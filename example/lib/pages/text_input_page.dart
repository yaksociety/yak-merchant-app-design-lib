import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class TextInputPage extends StatefulWidget {
  const TextInputPage({super.key});

  @override
  State<TextInputPage> createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakTextInput')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Single-line text input with label, placeholder, and error.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Supports required indicator, error state, obscure text, and keyboard types.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            YakTextInput(
              label: 'Email',
              isRequired: true,
              placeholder: 'Enter your email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextInput(
              label: 'Username',
              isRequired: true,
              placeholder: 'Enter username',
              controller: _usernameController,
              errorMessage: 'This username is already taken',
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextInput(
              label: 'Phone',
              placeholder: 'Enter phone number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextInput(
              label: 'Password',
              isRequired: true,
              placeholder: 'Enter password',
              controller: _passwordController,
              obscureText: true,
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextInput(
              label: 'Label',
              placeholder: 'Input text',
              enabled: false,
              onChanged: (_) {},
            ),
            const SizedBox(height: 24),
            YakTextInput(
              placeholder: 'Without label',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
