import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakCard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Universal card: use [child] for any content. Theme via YakCardThemeData.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Set YakCardThemeData in ThemeData.extensions to customize all cards.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Text('Simple content', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakCard(
              onTap: () {},
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Card title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Text('Any content: text, lists, images. Compose with child.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('With border', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakCard(
              borderColor: YakColor.primitive.primary.primary500,
              borderWidth: 2,
              borderRadius: 16,
              child: const Center(child: Text('Bordered card')),
            ),
            const SizedBox(height: 24),
            const Text('Composed: gradient + overlay text', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakCard(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              height: 160,
              borderRadius: 16,
              borderWidth: 2,
              borderColor: YakColor.primitive.primary.primary500,
              clipBehavior: Clip.antiAlias,
              onTap: () {},
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          YakColor.primitive.primary.primary200,
                          YakColor.primitive.primary.primary500,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ready-to-eat food',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sell ready-to-eat menus delivered to customers',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            YakCard(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              height: 160,
              borderRadius: 12,
              clipBehavior: Clip.antiAlias,
              onTap: () {},
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          YakColor.primitive.success.success200,
                          YakColor.primitive.success.success600,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Products',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sell special products or handmade items',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('List-style content', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            YakCard(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Help'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
