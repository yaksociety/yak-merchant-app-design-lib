import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  bool isLoading = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSection(String title, String description, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(description, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakButton')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Primary', 'Main action button.', [
              YakButton(text: 'Continue', onPressed: () => _showSnackBar('Primary pressed')),
              const SizedBox(height: 16),
              YakButton(
                text: 'With left icon',
                leftIcon: const Icon(Icons.check, size: 20),
                variant: YakButtonVariant.primary,
                onPressed: () => _showSnackBar('Left icon pressed'),
              ),
              const SizedBox(height: 16),
              YakButton(
                text: 'With right icon',
                rightIcon: const Icon(Icons.arrow_forward, size: 20),
                variant: YakButtonVariant.primary,
                onPressed: () => _showSnackBar('Right icon pressed'),
              ),
              const SizedBox(height: 16),
              YakButton(
                text: 'Loading',
                isLoading: isLoading,
                variant: YakButtonVariant.primary,
                onPressed: () async {
                  setState(() => isLoading = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) setState(() => isLoading = false);
                  if (mounted) _showSnackBar('Loading complete');
                },
              ),
              const SizedBox(height: 16),
              const YakButton(text: 'Disabled', onPressed: null),
            ]),
            const SizedBox(height: 32),
            _buildSection('Secondary', 'Outlined secondary button.', [
              YakButton(
                text: 'Cancel',
                variant: YakButtonVariant.secondary,
                onPressed: () => _showSnackBar('Secondary pressed'),
              ),
              const SizedBox(height: 16),
              const YakButton(text: 'Disabled', variant: YakButtonVariant.secondary, onPressed: null),
            ]),
            const SizedBox(height: 32),
            _buildSection('Ghost', 'Transparent button for subtle actions.', [
              YakButton(
                text: 'Skip',
                variant: YakButtonVariant.ghost,
                onPressed: () => _showSnackBar('Ghost pressed'),
              ),
              const SizedBox(height: 16),
              const YakButton(text: 'Disabled', variant: YakButtonVariant.ghost, onPressed: null),
            ]),
            const SizedBox(height: 32),
            _buildSection('Icon', 'Icon-only button (circular or square).', [
              Row(
                children: [
                  YakButton(
                    text: '',
                    icon: Icons.favorite,
                    variant: YakButtonVariant.icon,
                    onPressed: () => _showSnackBar('Heart pressed'),
                  ),
                  const SizedBox(width: 16),
                  YakButton(
                    text: '',
                    icon: Icons.share,
                    variant: YakButtonVariant.icon,
                    onPressed: () => _showSnackBar('Share pressed'),
                  ),
                  const SizedBox(width: 16),
                  YakButton(
                    text: '',
                    icon: Icons.settings,
                    isCircularIcon: false,
                    variant: YakButtonVariant.icon,
                    onPressed: () => _showSnackBar('Settings pressed'),
                  ),
                  const SizedBox(width: 16),
                  YakButton(text: '', icon: Icons.delete, variant: YakButtonVariant.icon, onPressed: null),
                ],
              ),
            ]),
            const SizedBox(height: 32),
            _buildSection('Floating (FAB)', 'Floating action button.', [
              Row(
                children: [
                  YakButton(
                    text: '',
                    icon: Icons.add,
                    variant: YakButtonVariant.floating,
                    onPressed: () => _showSnackBar('FAB pressed'),
                  ),
                  const SizedBox(width: 16),
                  YakButton(
                    text: 'Edit',
                    icon: Icons.edit,
                    variant: YakButtonVariant.floating,
                    onPressed: () => _showSnackBar('Extended FAB pressed'),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
