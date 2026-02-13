import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class SheetPage extends StatelessWidget {
  const SheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakSheet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bottom sheet with optional drag handle and title. Theme via YakSheetThemeData.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Use YakSheet.show(context, child: ...) or build YakSheet as content for showModalBottomSheet.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Text(
              'Simple sheet',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              variant: YakButtonVariant.primary,
              text: 'Open simple sheet',
              onPressed: () {
                YakSheet.show(
                  context,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Sheet content goes here. Drag handle at top by default.',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Sheet with title',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              variant: YakButtonVariant.secondary,
              text: 'Open sheet with title',
              onPressed: () {
                YakSheet.show(
                  context,
                  title: Text(
                    'Confirm action',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: YakColor.primitive.gray.gray800,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Do you want to proceed?'),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Confirm'),
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
              'Sheet without drag handle',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              variant: YakButtonVariant.ghost,
              text: 'Open sheet (no handle)',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) => YakSheet(
                    showDragHandle: false,
                    borderRadius: 24,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text('This sheet has no drag handle.'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'As widget in custom modal',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            YakButton(
              variant: YakButtonVariant.primary,
              text: 'Custom modal + YakSheet',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) => YakSheet(
                    title: Text(
                      'Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: YakColor.primitive.gray.gray800,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Share'),
                          onTap: () => Navigator.pop(context),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: YakColor.primitive.danger.danger500,
                          ),
                          title: Text(
                            'Delete',
                            style: TextStyle(
                              color: YakColor.primitive.danger.danger500,
                            ),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
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
