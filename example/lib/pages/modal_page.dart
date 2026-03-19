import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class ModalPage extends StatefulWidget {
  const ModalPage({super.key});

  @override
  State<ModalPage> createState() => _ModalPageState();
}

class _ModalPageState extends State<ModalPage> {
  bool _subscribeGuides = false;
  bool _subscribeResources = true;
  bool _subscribeAcademy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakModal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'YakModal is a container only.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You provide all content (title, description, actions) yourself via the `child`.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Basic modal',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              text: 'Open basic modal',
              variant: YakButtonVariant.primary,
              onPressed: () {
                YakModal.show(
                  context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Photo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: YakModal.gap),
                      Text(
                        'Add a photo to your profile.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: YakModal.gap),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: YakColor.primitive.neutral.neutral200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Icon(Icons.image, size: 48)),
                      ),
                      const SizedBox(height: YakModal.gap),
                      Row(
                        children: [
                          Expanded(
                            child: YakButton(
                              text: 'Cancel',
                              variant: YakButtonVariant.secondary,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: YakModal.gap),
                          Expanded(
                            child: YakButton(
                              text: 'Continue',
                              variant: YakButtonVariant.primary,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Custom content (checkboxes)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              text: 'Open subscribe modal',
              variant: YakButtonVariant.secondary,
              onPressed: () {
                YakModal.show(
                  context,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Subscribe',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: YakModal.gap),
                      Text(
                        'Choose what you want to receive.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: YakModal.gap),
                      _ModalCheckboxRow(
                        label: 'Guides',
                        value: _subscribeGuides,
                        onChanged: (v) => setState(() => _subscribeGuides = v),
                      ),
                      const SizedBox(height: 12),
                      _ModalCheckboxRow(
                        label: 'Resources',
                        value: _subscribeResources,
                        onChanged: (v) =>
                            setState(() => _subscribeResources = v),
                      ),
                      const SizedBox(height: 12),
                      _ModalCheckboxRow(
                        label: 'Academy',
                        value: _subscribeAcademy,
                        onChanged: (v) => setState(() => _subscribeAcademy = v),
                      ),
                      const SizedBox(height: YakModal.gap),
                      YakButton(
                        text: 'Done',
                        variant: YakButtonVariant.primary,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalCheckboxRow extends StatelessWidget {
  const _ModalCheckboxRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
          ],
        ),
      ),
    );
  }
}
