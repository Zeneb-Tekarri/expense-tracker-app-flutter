import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker_app/providers/transaction_provider.dart';
import 'package:expense_tracker_app/providers/search_filter_provider.dart';
import 'package:expense_tracker_app/screens/add_transaction_screen.dart';
import 'package:expense_tracker_app/widgets/transaction_list.dart';
import 'package:expense_tracker_app/widgets/transaction_search_bar.dart';
import 'package:expense_tracker_app/models/transaction_filter.dart';
import 'package:expense_tracker_app/widgets/transaction_filter_sheet.dart';
import 'package:expense_tracker_app/widgets/active_filter_chips.dart';


class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();// Controller for the search TextField

  // Helper function to get the date part of a DateTime object (ignoring time)
  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  @override
  void initState() {
    super.initState();
    // Load transactions when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  // Dispose the controller when the widget is disposed
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<TransactionProvider>().transactions;
    final searchFilterProvider = context.watch<SearchFilterProvider>();
    final filters = searchFilterProvider.filters;
    final searchLower = searchFilterProvider.searchQuery.toLowerCase().trim();
    final startDate = filters.startDate != null ? _dateOnly(filters.startDate!) : null;
    final endDate = filters.endDate != null ? _dateOnly(filters.endDate!) : null;

    // Filter transactions based on the search query and selected filters
    final filteredTransactions = transactions.where((transaction) {
      final transactionDate = _dateOnly(transaction.date);
      
      final matchesSearch = searchLower.isEmpty || transaction.title.toLowerCase().contains(searchLower) || transaction.category.toLowerCase().contains(searchLower);
      
      final matchesType = filters.type == null || transaction.type == filters.type;
      
      final matchesCategory = filters.category == null || transaction.category == filters.category;
      
      final matchesDateRange = startDate == null || endDate == null || (transactionDate.compareTo(startDate) >= 0 && transactionDate.compareTo(endDate) <= 0);
      
      return matchesSearch && matchesType && matchesCategory && matchesDateRange; 
    }).toList();

    // Sort newest transactions first
    filteredTransactions.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Transactions"),
      ),
      body: Column(
        children: [
          //Search bar and filter button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                //Search bar
                Expanded(
                  child: TransactionSearchBar(
                    searchController: _searchController,
                    searchQuery: searchFilterProvider.searchQuery,
                    onClear: () {
                      searchFilterProvider.clearSearchQuery();
                      _searchController.clear();
                    
                    },
                    onChanged: (value) {
                      searchFilterProvider.updateSearchQuery(value);
                    },
                  ),
                ),

                const SizedBox(width: 8),
            
                // Filter button
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    tooltip: 'Filter transactions',
                    // Show the filter sheet when the button is pressed
                    onPressed: () async {
                       final newFilters = await showModalBottomSheet<TransactionFilter>(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return TransactionFilterSheet(
                            initialFilter: filters,
                          );
                        },
                      );
                      // Update the state with the selected filters if they are not null
                      if (newFilters != null) {
                        searchFilterProvider.updateFilters(newFilters);
                      }              
                    }
                  ),
                ),
              ],
            ),
          ),

          // Display active filter chips if any filters are applied
          if (!filters.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ActiveFilterChips(
                filters: filters,
                onClearType: () {
                  searchFilterProvider.clearTypeFilter();
                },
                onClearCategory: () {
                  searchFilterProvider.clearCategoryFilter();
                },
                onClearDate: () {
                  searchFilterProvider.clearDateRangeFilter();
                },
              ),
            ),

          // Display the list of transactions, filtered based on the search query and selected filters
          Expanded(
            child: TransactionList(
              transactions: filteredTransactions,
              isSearching: searchFilterProvider.searchQuery.trim().isNotEmpty,
              hasActiveFilters: searchFilterProvider.hasActiveFilters,
            ),
          ),
        ],
      ),

      // Floating action button to navigate to the AddTransactionScreen
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const AddTransactionScreen())
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}