import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? _selectedItem;
  String? _selectedCountry;
  String? _selectedSingle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakSelect')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dropdown select with optional label and icons.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Chevron is hidden when only 1 item. Supports icon per item.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            YakSelect<String>(
              label: 'Select option',
              isRequired: true,
              placeholder: 'Choose an item',
              items: const [
                YakSelectItem(value: 'item1', label: 'Item 1'),
                YakSelectItem(value: 'item2', label: 'Item 2'),
                YakSelectItem(value: 'item3', label: 'Item 3'),
                YakSelectItem(value: 'item4', label: 'Item 4'),
              ],
              value: _selectedItem,
              onChanged: (v) => setState(() => _selectedItem = v),
            ),
            const SizedBox(height: 24),
            YakSelect<String>(
              label: 'Country / Language',
              placeholder: 'Select country',
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
              onChanged: (v) => setState(() => _selectedCountry = v),
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFA51931),
                          Colors.white,
                          Color(0xFF2D2A4A),
                          Colors.white,
                          Color(0xFFA51931),
                        ],
                        stops: [0.0, 0.2, 0.4, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
              value: _selectedSingle ?? 'only',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
