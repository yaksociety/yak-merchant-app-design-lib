import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakAlert')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Banner alert at the top of the screen. Use YakAlert.show() to display as overlay.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Types: info, warning, error, success. Optional action link and dismiss (X).',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Error (e.g. login failed)',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              text: 'Show error alert',
              variant: YakButtonVariant.primary,
              onPressed: () {
                YakAlert.show(
                  context,
                  title: 'Login failed',
                  message:
                      'Identity verification with the service provider is incomplete. Please restart the login process.',
                  type: YakAlertType.error,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Info with action link',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              text: 'Show info + Show More',
              variant: YakButtonVariant.secondary,
              onPressed: () {
                YakAlert.show(
                  context,
                  title: 'Some kind of alert!',
                  message:
                      'This is an alert message that will be placed inside the body of this alert box, be that a success or info message.',
                  type: YakAlertType.info,
                  actionLabel: 'Show More',
                  onAction: () {},
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Warning',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              text: 'Show warning alert',
              variant: YakButtonVariant.secondary,
              onPressed: () {
                YakAlert.show(
                  context,
                  title: 'Some kind of alert!',
                  message:
                      'This is a warning. Please review before continuing.',
                  type: YakAlertType.warning,
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Success with auto-dismiss',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              text: 'Show success (3s)',
              variant: YakButtonVariant.primary,
              onPressed: () {
                YakAlert.show(
                  context,
                  title: 'Saved',
                  message: 'Your changes have been saved successfully.',
                  type: YakAlertType.success,
                  duration: const Duration(seconds: 3),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Inline YakAlert',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakAlert(
              title: 'Information',
              message:
                  'You can also place YakAlert inline in your layout instead of using show().',
              type: YakAlertType.info,
              actionLabel: 'Show More',
              onAction: () {},
              onDismiss: () {},
            ),
          ],
        ),
      ),
    );
  }
}
