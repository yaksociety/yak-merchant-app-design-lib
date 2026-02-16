import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? _selectedNormal;
  String? _selectedMinimal;
  String? _selectedCompact;
  String? _selectedCountry;
  String? _selectedSingle;

  Widget _section(String title, String subtitle, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

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
              'Dropdown select aligned with DropdownStyle (Android).',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Style variants: normal, minimal, compact. Label/required/error, check icon on selected.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            _section(
              'All style variants',
              'Normal (default), minimal, and compact — each with its own selection.',
              [
                YakSelect<String>(
                  label: 'Normal style',
                  style: YakSelectStyle.normal,
                  placeholder: 'Select an option',
                  items: const [
                    YakSelectItem(value: 'n1', label: 'Item 1'),
                    YakSelectItem(value: 'n2', label: 'Item 2'),
                    YakSelectItem(value: 'n3', label: 'Item 3'),
                  ],
                  value: _selectedNormal,
                  onChanged: (v) => setState(() => _selectedNormal = v),
                ),
                const SizedBox(height: 20),
                YakSelect<String>(
                  label: 'Minimal style',
                  style: YakSelectStyle.minimal,
                  placeholder: 'Select item',
                  items: const [
                    YakSelectItem(value: 'm1', label: 'Option A'),
                    YakSelectItem(value: 'm2', label: 'Option B'),
                    YakSelectItem(value: 'm3', label: 'Option C'),
                  ],
                  value: _selectedMinimal,
                  onChanged: (v) => setState(() => _selectedMinimal = v),
                ),
                const SizedBox(height: 20),
                YakSelect<String>(
                  label: 'Compact style',
                  style: YakSelectStyle.compact,
                  placeholder: 'Dropdown',
                  items: const [
                    YakSelectItem(value: 'c1', label: 'Choice 1'),
                    YakSelectItem(value: 'c2', label: 'Choice 2'),
                    YakSelectItem(value: 'c3', label: 'Choice 3'),
                  ],
                  value: _selectedCompact,
                  onChanged: (v) => setState(() => _selectedCompact = v),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'Required',
              'Label with red asterisk.',
              [
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
                  value: _selectedNormal,
                  onChanged: (v) => setState(() => _selectedNormal = v),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'With error',
              'Error message and danger-colored label/border.',
              [
                YakSelect<String>(
                  label: 'Province',
                  isRequired: true,
                  placeholder: 'Please select',
                  items: const [
                    YakSelectItem(value: 'x', label: 'Option X'),
                    YakSelectItem(value: 'y', label: 'Option Y'),
                  ],
                  value: null,
                  onChanged: (v) => setState(() => _selectedNormal = v),
                  errorMessage: 'This field is required',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'Disabled',
              'Grey background, no interaction.',
              [
                YakSelect<String>(
                  label: 'Disabled',
                  placeholder: 'Cannot select',
                  items: const [
                    YakSelectItem(value: 'only', label: 'Only option'),
                  ],
                  value: 'only',
                  onChanged: null,
                  enabled: false,
                ),
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'With icons',
              'Country / Language with flag icons.',
              [
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
              ],
            ),
            const SizedBox(height: 32),
            _section(
              'Single item (no chevron)',
              'One option only — chevron is hidden.',
              [
                YakSelect<String>(
                  label: 'Country code',
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
          ],
        ),
      ),
    );
  }
}
