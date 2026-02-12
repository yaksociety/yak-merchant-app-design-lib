import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

void main() {
  runApp(const ButtonExampleApp());
}

class ButtonExampleApp extends StatelessWidget {
  const ButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Components Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF4C430)),
        useMaterial3: true,
      ),
      home: const ButtonExamplePage(),
    );
  }
}

class ButtonExamplePage extends StatefulWidget {
  const ButtonExamplePage({super.key});

  @override
  State<ButtonExamplePage> createState() => _ButtonExamplePageState();
}

class _ButtonExamplePageState extends State<ButtonExamplePage> {
  bool toggleValue = false;
  bool isLoading = false;
  
  // Text input controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  // OTP input
  String _otpCode = '';

  // Select
  String? _selectedCountry;
  String? _selectedItem;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4C430),
        title: const Text(
          'Yak Design Library',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary Buttons Section
            _buildSection(
              'Primary Buttons',
              'Primary buttons are used for the primary action on a page. They are typically larger and more prominent than other buttons.',
              [
                YakButton(
                  text: 'Button',
                  variant: YakButtonVariant.primary,
                  onPressed: () => _showSnackBar('Primary button pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Button',
                  leftIcon: const Icon(Icons.check_circle, size: 20),
                  variant: YakButtonVariant.primary,
                  onPressed: () => _showSnackBar('Button with left icon pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Button',
                  rightIcon: const Icon(Icons.arrow_forward, size: 20),
                  variant: YakButtonVariant.primary,
                  onPressed: () => _showSnackBar('Button with right icon pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Button',
                  leftIcon: const Icon(Icons.check_circle, size: 20),
                  rightIcon: const Icon(Icons.arrow_forward, size: 20),
                  variant: YakButtonVariant.primary,
                  onPressed: () => _showSnackBar('Button with both icons pressed'),
                ),
                const SizedBox(height: 16),
                const YakButton(
                  text: 'Disabled',
                  variant: YakButtonVariant.primary,
                  onPressed: null,
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Loading',
                  variant: YakButtonVariant.primary,
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() => isLoading = true);
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() => isLoading = false);
                    if (mounted) _showSnackBar('Loading complete');
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Secondary Buttons Section
            _buildSection(
              'Secondary Buttons',
              'Secondary buttons are used for secondary actions or alternative options. They are usually smaller and less prominent.',
              [
                YakButton(
                  text: 'Button',
                  variant: YakButtonVariant.secondary,
                  onPressed: () => _showSnackBar('Secondary button pressed'),
                ),
                const SizedBox(height: 16),
                YakButton(
                  text: 'Button',
                  leftIcon: const Icon(Icons.edit, size: 20),
                  variant: YakButtonVariant.secondary,
                  onPressed: () => _showSnackBar('Secondary with icon pressed'),
                ),
                const SizedBox(height: 16),
                const YakButton(
                  text: 'Disabled',
                  variant: YakButtonVariant.secondary,
                  onPressed: null,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Ghost Buttons Section
            _buildSection(
              'Ghost Buttons',
              'Ghost buttons have a transparent background and no border. They are used to emphasize a secondary action or option.',
              [
                YakButton(
                  text: 'Button',
                  variant: YakButtonVariant.ghost,
                  onPressed: () => _showSnackBar('Ghost button pressed'),
                ),
                const SizedBox(height: 16),
                const YakButton(
                  text: 'Disabled',
                  variant: YakButtonVariant.ghost,
                  onPressed: null,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Icon Buttons Section
            _buildSection(
              'Icon Buttons',
              'Icon buttons use an icon to represent an action or function. They are often used in combination with text labels.',
              [
                Row(
                  children: [
                    YakButton(
                      text: '',
                      icon: Icons.favorite,
                      variant: YakButtonVariant.icon,
                      onPressed: () => _showSnackBar('Heart icon pressed'),
                    ),
                    const SizedBox(width: 16),
                    YakButton(
                      text: '',
                      icon: Icons.share,
                      variant: YakButtonVariant.icon,
                      onPressed: () => _showSnackBar('Share icon pressed'),
                    ),
                    const SizedBox(width: 16),
                    YakButton(
                      text: '',
                      icon: Icons.settings,
                      isCircularIcon: false,
                      variant: YakButtonVariant.icon,
                      onPressed: () => _showSnackBar('Settings icon pressed'),
                    ),
                    const SizedBox(width: 16),
                    YakButton(
                      text: '',
                      icon: Icons.delete,
                      variant: YakButtonVariant.icon,
                      onPressed: null,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Toggle Buttons Section
            _buildSection(
              'Toggle Buttons',
              'Toggle buttons are a checkbox in a more visual state. They are used to switch between two states or options.',
              [
                Row(
                  children: [
                    YakToggleButton(
                      value: toggleValue,
                      onChanged: (value) {
                        setState(() => toggleValue = value);
                        _showSnackBar('Toggle: ${value ? 'ON' : 'OFF'}');
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(
                      toggleValue ? 'Enabled' : 'Disabled',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Floating Action Buttons Section
            _buildSection(
              'Floating Action Buttons',
              'Floating Action Buttons (FABs) are circular buttons located in a fixed position on the screen. They are used for the primary action.',
              [
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
              ],
            ),

            const SizedBox(height: 32),

            // Button Placement Example
            _buildSection(
              'Button Placement Example',
              'The placement of buttons depends on their purpose and the context of the interface.',
              [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Slack Team',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Are you sure you want to leave this team? You\'ll need a new invite to join again.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          YakButton(
                            text: 'Cancel',
                            variant: YakButtonVariant.secondary,
                            onPressed: () => _showSnackBar('Cancelled'),
                          ),
                          const SizedBox(width: 12),
                          YakButton(
                            text: 'Continue',
                            variant: YakButtonVariant.primary,
                            onPressed: () => _showSnackBar('Confirmed'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Text Input Section
            _buildSection(
              'Text Input',
              'Text input fields with labels, placeholders, and error messages.',
              [
                YakTextInput(
                  label: 'label',
                  isRequired: true,
                  placeholder: 'placeholder',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    // Handle email input
                  },
                ),
                const SizedBox(height: 24),
                YakTextInput(
                  label: 'label',
                  isRequired: true,
                  placeholder: 'placeholder',
                  controller: _usernameController,
                  errorMessage: 'ชื่อผู้ใช้นี้ได้ลงทะเบียนร้านค้าแล้ว',
                  onChanged: (value) {
                    // Handle username input
                  },
                ),
                const SizedBox(height: 24),
                YakTextInput(
                  label: 'label',
                  placeholder: 'placeholder',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) {
                    // Handle phone input
                  },
                ),
                const SizedBox(height: 24),
                YakTextInput(
                  label: 'label',
                  isRequired: true,
                  placeholder: 'placeholder',
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: (value) {
                    // Handle password input
                  },
                ),
                const SizedBox(height: 24),
                YakTextInput(
                  placeholder: 'placeholder',
                  onChanged: (value) {
                    // Handle input without label
                  },
                ),
                const SizedBox(height: 24),
                YakTextArea(
                  label: 'label',
                  isRequired: true,
                  placeholder: 'placeholder',
                  controller: _addressController,
                  minLines: 4,
                  onChanged: (value) {
                    // Handle address input
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Select Section
            _buildSection(
              'Select',
              'Dropdown select with optional label, placeholder, and icon. Chevron is hidden when only 1 item.',
              [
                YakSelect<String>(
                  label: 'label',
                  isRequired: true,
                  placeholder: 'placeholder',
                  items: const [
                    YakSelectItem(value: 'item1', label: 'Item 1'),
                    YakSelectItem(value: 'item2', label: 'Item 2'),
                    YakSelectItem(value: 'item3', label: 'Item 3'),
                    YakSelectItem(value: 'item4', label: 'Item 4'),
                  ],
                  value: _selectedItem,
                  onChanged: (value) {
                    setState(() => _selectedItem = value);
                  },
                ),
                const SizedBox(height: 24),
                YakSelect<String>(
                  label: 'label',
                  placeholder: 'placeholder',
                  items: [
                    YakSelectItem(
                      value: 'th',
                      label: 'ไทย',
                      icon: Container(
                        width: 24,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFA51931),
                              Colors.white,
                              const Color(0xFF2D2A4A),
                              Colors.white,
                              const Color(0xFFA51931),
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                    YakSelectItem(
                      value: 'en',
                      label: 'English',
                      icon: Container(
                        width: 24,
                        height: 16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.blue,
                        ),
                        child: const Icon(Icons.flag, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                  value: _selectedCountry,
                  onChanged: (value) {
                    setState(() => _selectedCountry = value);
                  },
                ),
                const SizedBox(height: 24),
                YakSelect<String>(
                  label: 'Single item (no chevron)',
                  items: [
                    YakSelectItem(
                      value: 'only',
                      label: '+66',
                      icon: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFFA51931),
                              Colors.white,
                              const Color(0xFF2D2A4A),
                              Colors.white,
                              const Color(0xFFA51931),
                            ],
                            stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                  value: 'only',
                  onChanged: (_) {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            // OTP Input Section
            _buildSection(
              'OTP Input',
              'One-time password input with multiple digit boxes.',
              [
                YakOtpInput(
                  length: 6,
                  boxSize: 48,
                  spacing: 12,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (code) {
                    setState(() {
                      _otpCode = code;
                    });
                  },
                  onCompleted: (code) {
                    _showSnackBar('OTP completed: $code');
                  },
                ),
                const SizedBox(height: 16),
                if (_otpCode.isNotEmpty)
                  Text(
                    'Current code: $_otpCode',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                const SizedBox(height: 24),
                YakOtpInput(
                  length: 4,
                  boxSize: 56,
                  spacing: 16,
                  obscureText: true,
                  onChanged: (code) {
                    // Handle 4-digit OTP
                  },
                  onCompleted: (code) {
                    _showSnackBar('4-digit OTP completed: $code');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
