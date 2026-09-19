import 'package:flutter/material.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;
  const TransactionSearchBar({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onClear,
    required this.onChanged,
  });
 
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: searchController,
  
      decoration: InputDecoration(
        hintText: 'Search transactions...',
       
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2.0,
          ),
        ),
      ),
    
      onChanged: onChanged,
    );  
  }
}