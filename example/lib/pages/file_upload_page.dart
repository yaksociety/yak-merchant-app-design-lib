import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

/// Example page demonstrating [YakFileUpload] in a real-case flow:
/// pick file → simulated upload (progress) → success or failure → change/remove/retry.
class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  YakFileUploadItem? _file;
  Timer? _uploadTimer;
  YakFileUploadItem? _fileDoc;
  Timer? _uploadTimerDoc;
  late final List<YakFileUploadSource> _uploadSources = _buildUploadSources();

  @override
  void dispose() {
    _uploadTimer?.cancel();
    _uploadTimerDoc?.cancel();
    super.dispose();
  }

  /// Build platform-specific upload sources: camera + gallery only on iOS/Android.
  /// On macOS/Windows/Linux we show only "Choose file" (camera can crash on desktop).
  List<YakFileUploadSource> _buildUploadSources() {
    final list = <YakFileUploadSource>[];
    final isDesktop = defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;
    if (!isDesktop) {
      list.add(
        YakFileUploadSource(
          label: 'Take a photo',
          icon: Icons.camera_alt_rounded,
          onSelected: _takePhoto,
        ),
      );
      list.add(
        YakFileUploadSource(
          label: 'Import from library',
          icon: Icons.photo_library_rounded,
          onSelected: _pickFromGallery,
        ),
      );
    }
    list.add(
      YakFileUploadSource(
        label: 'Choose file',
        icon: Icons.folder_open_rounded,
        onSelected: _chooseFile,
      ),
    );
    return list;
  }

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.camera);
      if (xFile == null || !mounted) return;
      await _startUploadFromXFile(xFile);
    } catch (e) {
      if (!mounted) return;
      _showError('Camera not available: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile == null || !mounted) return;
      await _startUploadFromXFile(xFile);
    } catch (e) {
      if (!mounted) return;
      _showError('Photo library not available: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _startUploadFromXFile(XFile xFile) async {
    final name = xFile.name;
    final size = await xFile.length();
    if (!mounted) return;
    setState(() {
      _file = YakFileUploadItem(
        name: name,
        sizeBytes: size,
        status: YakFileUploadStatus.uploading,
        progress: 0,
      );
    });
    _simulateUpload(name, size);
    await _loadThumbnailFromXFile(xFile);
  }

  /// Loads image bytes from [xFile] and updates [_file] to show thumbnail.
  Future<void> _loadThumbnailFromXFile(XFile xFile) async {
    try {
      final bytes = await xFile.readAsBytes();
      if (!mounted || _file == null) return;
      setState(() {
        _file = _file!.copyWith(thumbnail: MemoryImage(bytes));
      });
    } catch (_) {
      // Ignore thumbnail load failure
    }
  }

  static bool _isImageFileName(String name) {
    final lower = name.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }

  Future<void> _chooseFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'svg', 'pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty || !mounted) return;

    final platformFile = result.files.single;
    final name = platformFile.name;
    final size = platformFile.size;
    final bytes = platformFile.bytes;
    final thumbnail = (bytes != null && _isImageFileName(name))
        ? MemoryImage(bytes)
        : null;

    setState(() {
      _file = YakFileUploadItem(
        name: name,
        sizeBytes: size,
        status: YakFileUploadStatus.uploading,
        progress: 0,
        thumbnail: thumbnail,
      );
    });

    _simulateUpload(name, size);
  }

  /// Single entry point for "pick and upload" when no custom sources are used.
  Future<void> _pickAndUpload() async {
    await _chooseFile();
  }

  void _simulateUpload(String name, int size) {
    _uploadTimer?.cancel();
    const duration = Duration(milliseconds: 400);
    const steps = 25;
    var step = 0;

    _uploadTimer = Timer.periodic(duration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      step++;
      final progress = (step / steps).clamp(0.0, 1.0);
      setState(() {
        _file = _file!.copyWith(progress: progress);
      });
      if (step >= steps) {
        timer.cancel();
        _uploadTimer = null;
        if (!mounted) return;
        // Simulate 10% failure for demo
        final failed = DateTime.now().millisecond % 10 == 0;
        setState(() {
          _file = _file!.copyWith(
            status: failed ? YakFileUploadStatus.failed : YakFileUploadStatus.success,
            progress: null,
            errorMessage: failed ? 'Upload failed. Please try again.' : null,
          );
        });
      }
    });
  }

  void _cancelUpload() {
    _uploadTimer?.cancel();
    _uploadTimer = null;
    setState(() => _file = null);
  }

  void _retry() {
    if (_file == null) return;
    final name = _file!.name;
    final size = _file!.sizeBytes;
    setState(() {
      _file = _file!.copyWith(
        status: YakFileUploadStatus.uploading,
        progress: 0,
      );
    });
    _simulateUpload(name, size);
  }

  void _remove() {
    setState(() => _file = null);
  }

  void _changeFile() {
    _uploadTimer?.cancel();
    _uploadTimer = null;
    if (_uploadSources.isNotEmpty) {
      _showUploadSourcesSheet();
    } else {
      _chooseFile();
    }
  }

  // --- Document upload example (configurable: label + horizontal + instructions) ---

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );
    if (result == null || result.files.isEmpty || !mounted) return;
    final pf = result.files.single;
    final name = pf.name;
    final size = pf.size;
    final thumbnail = (pf.bytes != null && _isImageFileName(name))
        ? MemoryImage(pf.bytes!)
        : null;
    setState(() {
      _fileDoc = YakFileUploadItem(
        name: name,
        sizeBytes: size,
        status: YakFileUploadStatus.uploading,
        progress: 0,
        thumbnail: thumbnail,
      );
    });
    _simulateUploadDoc(name, size);
  }

  void _simulateUploadDoc(String name, int size) {
    _uploadTimerDoc?.cancel();
    const duration = Duration(milliseconds: 400);
    const steps = 25;
    var step = 0;
    _uploadTimerDoc = Timer.periodic(duration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      step++;
      final progress = (step / steps).clamp(0.0, 1.0);
      setState(() {
        _fileDoc = _fileDoc!.copyWith(progress: progress);
      });
      if (step >= steps) {
        timer.cancel();
        _uploadTimerDoc = null;
        if (!mounted) return;
        setState(() {
          _fileDoc = _fileDoc!.copyWith(
            status: YakFileUploadStatus.success,
            progress: null,
          );
        });
      }
    });
  }

  void _cancelUploadDoc() {
    _uploadTimerDoc?.cancel();
    _uploadTimerDoc = null;
    setState(() => _fileDoc = null);
  }

  void _removeDoc() => setState(() => _fileDoc = null);

  void _changeDoc() {
    _uploadTimerDoc?.cancel();
    _uploadTimerDoc = null;
    _pickDocument();
  }

  void _showUploadSourcesSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _uploadSources
                .map((source) => ListTile(
                      leading: source.icon != null
                          ? Icon(source.icon)
                          : null,
                      title: Text(source.label),
                      onTap: () {
                        Navigator.of(context).pop();
                        source.onSelected();
                      },
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakFileUpload')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'File upload with drag-and-drop and choose file',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Pick a file to see uploading → success/failed states. Supports cancel, retry, change, and remove.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            YakFileUpload(
              value: _file,
              acceptedTypes: const ['jpg', 'png', 'svg'],
              enabled: true,
              uploadSources: _uploadSources,
              callbacks: YakFileUploadCallbacks(
                onPickRequested: _pickAndUpload,
                onCancelUpload: _cancelUpload,
                onRetry: _retry,
                onRemove: _remove,
                onChangeRequested: _changeFile,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Example: Configurable (label, horizontal, instructions)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Label above, horizontal drop zone, max size hint, and instructions below. Tap to pick a file.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            YakFileUpload(
              value: _fileDoc,
              label: 'Professional license in Thailand',
              isRequired: true,
              hintText: 'Attach image or file for upload',
              maxFileSizeLabel: 'max 2 MB',
              acceptedTypes: const ['jpg', 'png', 'pdf'],
              dropZoneLayout: YakFileUploadDropZoneLayout.horizontal,
              changeButtonLabel: 'Change',
              instructions: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please attach a copy of the professional license in Thailand.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _bullet('Ensure all information is complete and clear.'),
                  _bullet(
                    'Legal entities with foreign directors holding more than 49% must attach a certificate of business operation for foreigners.',
                  ),
                  _bullet(
                    'The document must state that it permits operating a business related to selling food or beverages.',
                  ),
                ],
              ),
              callbacks: YakFileUploadCallbacks(
                onPickRequested: _pickDocument,
                onCancelUpload: _cancelUploadDoc,
                onRemove: _removeDoc,
                onChangeRequested: _changeDoc,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Disabled state',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const YakFileUpload(
              value: null,
              acceptedTypes: ['JPG', 'PNG', 'SVG'],
              enabled: false,
              callbacks: YakFileUploadCallbacks(),
            ),
            const SizedBox(height: 32),
            const Text(
              'State demos (no real picker)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _StateDemoSection(
              onSelectState: (item) => setState(() => _file = item),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small demo that lets you switch between uploading / success / failed
/// without using the real file picker.
class _StateDemoSection extends StatelessWidget {
  const _StateDemoSection({required this.onSelectState});

  final void Function(YakFileUploadItem?) onSelectState;

  static const int _demoSize = 500 * 1024; // 500 kb

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _DemoButton(
              label: 'Uploading 25%',
              onPressed: () => onSelectState(YakFileUploadItem(
                name: 'Yak.pdf',
                sizeBytes: _demoSize,
                status: YakFileUploadStatus.uploading,
                progress: 0.25,
              )),
            ),
            _DemoButton(
              label: 'Success',
              onPressed: () => onSelectState(YakFileUploadItem(
                name: 'Yak.pdf',
                sizeBytes: _demoSize,
                status: YakFileUploadStatus.success,
              )),
            ),
            _DemoButton(
              label: 'Failed',
              onPressed: () => onSelectState(YakFileUploadItem(
                name: 'Yak.pdf',
                sizeBytes: _demoSize,
                status: YakFileUploadStatus.failed,
                errorMessage: 'Upload failed.',
              )),
            ),
            _DemoButton(
              label: 'Clear',
              onPressed: () => onSelectState(null),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _bullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
