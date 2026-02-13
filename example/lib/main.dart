import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

import 'pages/alert_page.dart';
import 'pages/button_page.dart';
import 'pages/card_page.dart';
import 'pages/indicator_page.dart';
import 'pages/modal_page.dart';
import 'pages/otp_input_page.dart';
import 'pages/select_page.dart';
import 'pages/sheet_page.dart';
import 'pages/text_area_page.dart';
import 'pages/text_input_page.dart';
import 'pages/toggle_button_page.dart';

void main() {
  runApp(const YakDesignExampleApp());
}

class YakDesignExampleApp extends StatelessWidget {
  const YakDesignExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yak Design Library Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: YakColor.primitive.primary.primary500),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/button': (_) => const ButtonPage(),
        '/toggle': (_) => const ToggleButtonPage(),
        '/text-input': (_) => const TextInputPage(),
        '/text-area': (_) => const TextAreaPage(),
        '/select': (_) => const SelectPage(),
        '/otp-input': (_) => const OtpInputPage(),
        '/indicator': (_) => const IndicatorPage(),
        '/card': (_) => const CardPage(),
        '/sheet': (_) => const SheetPage(),
        '/modal': (_) => const ModalPage(),
        '/alert': (_) => const AlertPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('YakButton', 'Primary, secondary, ghost, icon, FAB', Icons.smart_button, '/button'),
      _NavItem('YakToggleButton', 'On/off toggle switch', Icons.toggle_on, '/toggle'),
      _NavItem('YakTextInput', 'Single-line text input', Icons.text_fields, '/text-input'),
      _NavItem('YakTextArea', 'Multi-line text area', Icons.notes, '/text-area'),
      _NavItem('YakSelect', 'Dropdown select', Icons.arrow_drop_down_circle, '/select'),
      _NavItem('YakOtpInput', 'OTP / PIN digit boxes', Icons.pin, '/otp-input'),
      _NavItem('YakIndicator', 'Progress bar with rounded ends & animation', Icons.trending_up, '/indicator'),
      _NavItem('YakCard', 'Card with image/overlay, globally themed', Icons.credit_card, '/card'),
      _NavItem('YakSheet', 'Bottom sheet with drag handle & title', Icons.call_made, '/sheet'),
      _NavItem('YakModal', 'Dialog with icon, title, description, custom child', Icons.dashboard_customize, '/modal'),
      _NavItem('YakAlert', 'Top-of-screen alert (info, warning, error, success)', Icons.warning_amber_rounded, '/alert'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yak Design Library'),
        backgroundColor: YakColor.primitive.primary.primary500,
        foregroundColor: YakColor.primitive.gray.gray900,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(item.icon),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, item.route),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _NavItem(this.title, this.subtitle, this.icon, this.route);
}
