# Yak Merchant App Design Library

A Flutter design system library for **Yak Merchant App**, providing reusable UI components that follow consistent design guidelines and best practices.

## 📦 What This Library Contains

This library provides pre-built UI components for the Yak Merchant App:

### 🎯 Button Components
- **YakButton** - Unified button component with 5 variants:
  - `primary` - Main action button (gold background)
  - `secondary` - Outlined button for secondary actions
  - `ghost` - Transparent button for subtle actions
  - `icon` - Icon-only button (circular or square)
  - `floating` - Floating action button (FAB)
- **YakToggleButton** - Toggle switch button for on/off states

### 📝 Input Components
- **YakTextInput** - Text input field with label, error states, and validation
- **YakOtpInput** - OTP/PIN input with multiple digit boxes

All components support:
- ✅ Loading states
- ✅ Disabled states
- ✅ Error handling
- ✅ Customizable styling
- ✅ Consistent spacing and typography
- ✅ Accessible design

---

## 🚀 Installation

### For Projects in the Same Organization (Private Repo)

Since this is a private repository in the `yaksociety` organization, projects within the same organization can use it directly.

**Important:** Make sure you have:
- ✅ Access to the `yaksociety` organization on GitHub
- ✅ Read permissions for this repository
- ✅ SSH keys configured (for SSH method) or GitHub credentials (for HTTPS method)

Add this package to your Flutter project's `pubspec.yaml`:

#### Option 1: Using SSH (Recommended)

If you have SSH keys set up with GitHub:

```yaml
dependencies:
  yak_merchant_app_design_lib:
    git:
      url: git@github.com:yaksociety/yak-merchant-app-design-lib.git
      ref: main
```

#### Option 2: Using HTTPS with Personal Access Token

If you prefer HTTPS, you'll need a GitHub Personal Access Token:

1. Create a Personal Access Token in GitHub (Settings → Developer settings → Personal access tokens)
2. Add it to your `pubspec.yaml`:

```yaml
dependencies:
  yak_merchant_app_design_lib:
    git:
      url: https://YOUR_TOKEN@github.com/yaksociety/yak-merchant-app-design-lib.git
      ref: main
```

**Note:** For better security, use environment variables or store the token securely instead of hardcoding it.

#### Option 3: Using HTTPS (if already authenticated)

If you're already authenticated with GitHub CLI or Git credentials:

```yaml
dependencies:
  yak_merchant_app_design_lib:
    git:
      url: https://github.com/yaksociety/yak-merchant-app-design-lib.git
      ref: main
```

### After Adding the Dependency

Run:
```bash
flutter pub get
```

### Using a Specific Version

To use a specific version or tag:

```yaml
dependencies:
  yak_merchant_app_design_lib:
    git:
      url: git@github.com:yaksociety/yak-merchant-app-design-lib.git
      ref: v0.0.1  # Use a specific tag
```

Or use a specific commit:

```yaml
dependencies:
  yak_merchant_app_design_lib:
    git:
      url: git@github.com:yaksociety/yak-merchant-app-design-lib.git
      ref: abc123def456  # Use a specific commit hash
```

---

## 📖 How to Use

### Import the Library

```dart
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';
```

---

## 🎨 Component Usage

### 1. YakButton

The main button component with multiple variants.

#### Primary Button (Default)
```dart
YakButton(
  text: 'Continue',
  onPressed: () {
    // Handle button press
  },
)

// With icons
YakButton(
  text: 'Save',
  leftIcon: const Icon(Icons.check, size: 20),
  rightIcon: const Icon(Icons.arrow_forward, size: 20),
  onPressed: () {},
  variant: YakButtonVariant.primary,
)

// Loading state
YakButton(
  text: 'Loading',
  isLoading: true,
  onPressed: () {},
)
```

#### Secondary Button
```dart
YakButton(
  text: 'Cancel',
  onPressed: () {},
  variant: YakButtonVariant.secondary,
)
```

#### Ghost Button
```dart
YakButton(
  text: 'Skip',
  onPressed: () {},
  variant: YakButtonVariant.ghost,
)
```

#### Icon Button
```dart
// Circular icon button
YakButton(
  text: '',
  icon: Icons.favorite,
  variant: YakButtonVariant.icon,
  onPressed: () {},
)

// Square icon button
YakButton(
  text: '',
  icon: Icons.settings,
  variant: YakButtonVariant.icon,
  isCircularIcon: false,
  onPressed: () {},
)
```

#### Floating Action Button (FAB)
```dart
// Regular FAB
YakButton(
  text: '',
  icon: Icons.add,
  variant: YakButtonVariant.floating,
  onPressed: () {},
)

// Extended FAB with label
YakButton(
  text: 'Edit',
  icon: Icons.edit,
  variant: YakButtonVariant.floating,
  onPressed: () {},
)
```

### 2. YakToggleButton

Toggle button for switching between two states.

```dart
YakToggleButton(
  value: isEnabled,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
)
```

### 3. YakTextInput

Text input field with label, placeholder, and error handling.

```dart
// Basic text input
YakTextInput(
  label: 'Email',
  placeholder: 'Enter your email',
  onChanged: (value) {
    print('Input: $value');
  },
)

// With required indicator
YakTextInput(
  label: 'Password',
  isRequired: true,
  placeholder: 'Enter your password',
  obscureText: true,
  onChanged: (value) {
    print('Password: $value');
  },
)

// With error state
YakTextInput(
  label: 'Email',
  placeholder: 'Enter your email',
  errorMessage: 'Invalid email address',
  onChanged: (value) {
    // Handle input
  },
)

// With controller
final _controller = TextEditingController();

YakTextInput(
  label: 'Username',
  controller: _controller,
  placeholder: 'Enter username',
  onChanged: (value) {
    // Handle input
  },
)
```

### 4. YakOtpInput

OTP/PIN input with multiple digit boxes.

```dart
// Basic 6-digit OTP
YakOtpInput(
  length: 6,
  onChanged: (value) {
    print('OTP: $value');
  },
  onCompleted: (value) {
    print('Completed OTP: $value');
    // Verify OTP
  },
)

// 4-digit PIN with obscured text
YakOtpInput(
  length: 4,
  obscureText: true,
  onCompleted: (value) {
    // Handle PIN completion
  },
)

// Custom size and spacing
YakOtpInput(
  length: 6,
  boxSize: 56,
  spacing: 16,
  onCompleted: (value) {
    // Handle completion
  },
)
```

---

## 💡 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input
            YakTextInput(
              label: 'Email',
              isRequired: true,
              placeholder: 'Enter your email',
              controller: _emailController,
              errorMessage: _emailError,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  _emailError = null;
                });
              },
            ),
            
            SizedBox(height: 16),
            
            // Password input
            YakTextInput(
              label: 'Password',
              isRequired: true,
              placeholder: 'Enter your password',
              controller: _passwordController,
              obscureText: true,
              onChanged: (value) {},
            ),
            
            SizedBox(height: 24),
            
            // Login button
            YakButton(
              text: 'Login',
              isLoading: _isLoading,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                // Handle login
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _isLoading = false;
                  });
                });
              },
            ),
            
            SizedBox(height: 12),
            
            // Secondary button
            YakButton(
              text: 'Forgot Password?',
              variant: YakButtonVariant.ghost,
              onPressed: () {
                // Handle forgot password
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎨 Design System

The library follows these design principles:

- **Color Scheme**: Gold/Yellow (#F4C430) primary color with black text
- **Spacing**: 8px grid system with consistent padding
- **Typography**: Font size 16px with 0.15 letter spacing and 600 font weight
- **Accessibility**: Proper disabled states, touch targets, and visual feedback

---

## 📚 Examples

Check out the `example/` directory for complete working examples of all components.

To run the example app:
```bash
cd example
flutter run
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🐛 Issues

If you encounter any issues or have suggestions, please file them on the [issue tracker](https://github.com/yaksociety/yak-merchant-app-design-lib/issues).

## 📄 License

See [LICENSE](LICENSE) for details.
