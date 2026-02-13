import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class ModalPage extends StatelessWidget {
  const ModalPage({super.key});

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
              'Centered modal with optional icon, title, description. Add any content via child.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Use YakModal.show() or build YakModal as dialog content. Cancel + Continue buttons optional.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Text('Simple modal (title + child)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakButton(
              text: 'Open simple modal',
              variant: YakButtonVariant.primary,
              onPressed: () {
                YakModal.show(
                  context,
                  title: 'Photo',
                  description: 'Add a photo to your profile.',
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: YakColor.primitive.neutral.neutral200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.image, size: 48)),
                  ),
                  primaryLabel: 'Continue',
                  cancelLabel: 'Cancel',
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('With header icon (info)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakButton(
              text: 'Open modal with info icon',
              variant: YakButtonVariant.secondary,
              onPressed: () {
                YakModal.show(
                  context,
                  headerIconType: YakModalIconType.info,
                  title: 'Label',
                  description: 'Add a note or choose an option below.',
                  child: const Text('Put any widgets here: inputs, checkboxes, toggles.'),
                  primaryLabel: 'Continue',
                  cancelLabel: 'Cancel',
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('Success & error icons', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                YakButton(
                  text: 'Success icon',
                  variant: YakButtonVariant.secondary,
                  onPressed: () {
                    YakModal.show(
                      context,
                      headerIconType: YakModalIconType.success,
                      title: 'Done',
                      description: 'Your changes have been saved.',
                      child: const SizedBox.shrink(),
                      primaryLabel: 'OK',
                    );
                  },
                ),
                const SizedBox(height: 12),
                YakButton(
                  text: 'Error (red primary)',
                  variant: YakButtonVariant.secondary,
                  onPressed: () {
                    YakModal.show(
                      context,
                      headerIconType: YakModalIconType.error,
                      title: 'Error',
                      description: 'Something went wrong.',
                      child: const SizedBox.shrink(),
                      primaryLabel: 'Continue',
                      primaryIsDanger: true,
                      cancelLabel: 'Cancel',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Custom content (checkboxes)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakButton(
              text: 'Subscribe modal',
              variant: YakButtonVariant.primary,
              onPressed: () {
                YakModal.show(
                  context,
                  headerIconType: YakModalIconType.info,
                  title: 'Subscribe',
                  description: 'Choose what you want to receive.',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        title: const Text('Guides'),
                        value: false,
                        onChanged: (_) {},
                      ),
                      CheckboxListTile(
                        title: const Text('Resources'),
                        value: true,
                        onChanged: (_) {},
                      ),
                      CheckboxListTile(
                        title: const Text('Academy'),
                        value: false,
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  primaryLabel: 'Continue',
                  cancelLabel: 'Cancel',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
