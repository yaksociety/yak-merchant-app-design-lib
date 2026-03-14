import 'package:flutter/material.dart';
import 'package:yak_merchant_app_design_lib/yak_merchant_app_design_lib.dart';

class SearchInputPage extends StatefulWidget {
  const SearchInputPage({super.key});

  @override
  State<SearchInputPage> createState() => _SearchInputPageState();
}

class _SearchInputPageState extends State<SearchInputPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YakSearchInput')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search input with Text S/Regular.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Same behaviour as YakTextInput with label, placeholder, error, and focus states. Uses design tokens for typography and colors.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            YakSearchInput(
              label: 'Search',
              placeholder: 'Type to search...',
              controller: _searchController,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            YakSearchInput(
              label: 'Search (required)',
              isRequired: true,
              placeholder: 'Enter search term',
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            YakSearchInput(
              label: 'Search with error',
              placeholder: 'Search',
              errorMessage: 'Please enter at least 2 characters',
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            const YakSearchInput(
              label: 'Search (disabled)',
              placeholder: 'Disabled field',
              enabled: false,
            ),
            const SizedBox(height: 24),
            YakSearchInput(
              placeholder: 'Without label',
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
