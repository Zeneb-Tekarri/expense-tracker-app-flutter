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
    return Padding(

      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, 
        vertical: 8.0
      ),

      child: TextField(
        controller: searchController,

        decoration: InputDecoration(
          hintText: 'Search transactions...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
        ),

        onChanged: onChanged,
      ),
    );  
  }
}