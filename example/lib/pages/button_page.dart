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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSection(
    String title,
    String description,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
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
              YakButton(
                text: 'Continue',
                onPressed: () => _showSnackBar('Primary pressed'),
              ),
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
                text: 'Leading & trailing icon',
                leadingIcon: Icons.add,
                trailingIcon: Icons.arrow_forward,
                variant: YakButtonVariant.primary,
                onPressed: () => _showSnackBar('Icons pressed'),
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
              const YakButton(text: 'Disabled', disabled: true),
            ]),
            const SizedBox(height: 32),
            _buildSection('Secondary', 'Outlined secondary button.', [
              YakButton(
                text: 'Cancel',
                variant: YakButtonVariant.secondary,
                onPressed: () => _showSnackBar('Secondary pressed'),
              ),
              const SizedBox(height: 16),
              YakButton(
                text: 'Full width (start aligned)',
                variant: YakButtonVariant.secondary,
                width: double.infinity,
                contentAlignment: YakButtonContentAlignment.start,
                onPressed: () => _showSnackBar('Start aligned pressed'),
              ),
              const SizedBox(height: 16),
              const YakButton(
                text: 'Disabled',
                variant: YakButtonVariant.secondary,
                disabled: true,
              ),
            ]),
            const SizedBox(height: 32),
            _buildSection(
              'Label & required (field-style)',
              'Custom label with red asterisk when required. Style like a select/location field.',
              [
                YakButton(
                  label: 'ที่ตั้งร้านค้า',
                  isRequired: true,
                  text: '99/2 ซอยสุขุมวิท 26 ถนนสุขุมวิท แขวงคลอง...',
                  variant: YakButtonVariant.secondary,
                  leftIcon: Icon(
                    Icons.location_on,
                    color: YakColor.semantic.background.primaryMain,
                    size: 22,
                  ),
                  rightIcon: Icon(
                    Icons.chevron_right,
                    color: YakColor.semantic.textAndIcons.baseSecond,
                    size: 22,
                  ),
                  width: double.infinity,
                  onPressed: () => _showSnackBar('Select location pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  label: 'จังหวัด',
                  isRequired: true,
                  text: 'กรุงเทพมหานคร',
                  variant: YakButtonVariant.secondary,
                  rightIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: YakColor.semantic.textAndIcons.baseSecond,
                    size: 24,
                  ),
                  width: double.infinity,
                  onPressed: () => _showSnackBar('Select province pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  label: 'อำเภอ/เขต',
                  isRequired: true,
                  text: 'เลือกอำเภอ/เขต',
                  variant: YakButtonVariant.secondary,
                  width: double.infinity,
                  rightIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: YakColor.semantic.textAndIcons.baseSecond,
                    size: 24,
                  ),
                  disabled: true,
                ),
                const SizedBox(height: 16),
                YakButton(
                  label: 'Optional field',
                  isRequired: false,
                  text: 'Choose an option',
                  variant: YakButtonVariant.secondary,
                  width: double.infinity,
                  leftIcon: Icon(
                    Icons.tune,
                    color: YakColor.semantic.textAndIcons.baseSecond,
                    size: 22,
                  ),
                  rightIcon: Icon(
                    Icons.chevron_right,
                    color: YakColor.semantic.textAndIcons.baseSecond,
                    size: 22,
                  ),
                  onPressed: () => _showSnackBar('Optional pressed'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection('Ghost', 'Transparent button for subtle actions.', [
              YakButton(
                text: 'Skip',
                variant: YakButtonVariant.ghost,
                onPressed: () => _showSnackBar('Ghost pressed'),
              ),
              const SizedBox(height: 16),
              const YakButton(
                text: 'Disabled',
                variant: YakButtonVariant.ghost,
                disabled: true,
              ),
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
                  YakButton(
                    text: '',
                    icon: Icons.delete,
                    variant: YakButtonVariant.icon,
                    disabled: true,
                  ),
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
            const SizedBox(height: 32),
            _buildSection(
              'Custom stroke & rounded',
              'Custom border and border radius.',
              [
                YakButton(
                  text: 'Primary with stroke',
                  variant: YakButtonVariant.primary,
                  stroke: BorderSide(color: Colors.black87, width: 2),
                  borderRadius: 12,
                  onPressed: () => _showSnackBar('Stroke pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Pill shape',
                  variant: YakButtonVariant.secondary,
                  borderRadius: 999,
                  onPressed: () => _showSnackBar('Pill pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Rounded ghost',
                  variant: YakButtonVariant.ghost,
                  borderRadius: 20,
                  stroke: BorderSide(color: const Color(0xFFF4C430), width: 1),
                  onPressed: () => _showSnackBar('Rounded ghost pressed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
