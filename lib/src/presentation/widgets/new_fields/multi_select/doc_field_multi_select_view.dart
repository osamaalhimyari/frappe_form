// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';

class DocFieldMultiSelectView extends DocFieldView {
  DocFieldMultiSelectView({
    super.key,
    CustomValueController<String>? controller,
    required super.field,
    super.dependsOnController,
  }) : super(
         controller:
             controller ??
             CustomValueController<String>(focusNode: FocusNode()),
       );

  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;

  @override
  void initController() {
    super.initController();
    // Initialize with empty string if null
    controller.value ??= field.initial?.toString() ?? '';
  }

  @override
  State<DocFieldMultiSelectView> createState() =>
      DocFieldMultiSelectViewState();
}

class DocFieldMultiSelectViewState<SF extends DocFieldMultiSelectView>
    extends DocFieldViewState<SF> {
  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;

  /// All available options (populated from field options)
  List<String> _allItems = [];

  /// Filtered options for the search dropdown
  List<String> _filteredItems = [];

  /// Text controller for the search input
  final TextEditingController _searchController = TextEditingController();

  /// Helper to get selected items as a List from the controller's string
  List<String> get _selectedItems {
    if (controller.value.isEmpty) return [];
    return (controller.value ?? '').split(',').map((e) => e.trim()).toList();
  }

  @override
  void initState() {
    super.initState();

    // Populate options from the field definition (adjust based on your Frappe logic)
    if (widget.field.options is List) {
      _allItems = (widget.field.options as List)
          .map((e) => e.toString())
          .toList();
    } else {
      final String? rawOptions = widget.field.options;

      if (rawOptions != null && rawOptions.isNotEmpty) {
        setState(() {
          // Splits "Option 1, Option 3" into ["Option 1", "Option 3"]
          _allItems = rawOptions
              .split(',')
              .map((e) => e.trim()) // Removes extra spaces
              .where((e) => e.isNotEmpty) // Removes empty entries
              .toList();
        });
      }
    }

    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = [];
      } else {
        _filteredItems = _allItems
            .where(
              (e) =>
                  e.toLowerCase().contains(query) &&
                  !_selectedItems.contains(e),
            ) // Don't show already selected
            .toList();
      }
    });
  }

  void _toggleItem(String value) {
    List<String> current = List.from(_selectedItems);

    if (current.contains(value)) {
      current.remove(value);
    } else {
      current.add(value);
    }

    setState(() {
      // Update the actual form controller
      controller.value = current.join(', ');
      _searchController.clear();
      _filteredItems = [];
    });
  }

  @override
  Widget? buildTitleView(BuildContext context) {
    if (field.title.isEmpty) return null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(field.title, style: theme.textTheme.titleSmall),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Selected chips
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _selectedItems
              .map(
                (item) => Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  onDeleted: () => _toggleItem(item),
                  deleteIcon: const Icon(Icons.close, size: 14),
                ),
              )
              .toList(),
        ),

        if (_selectedItems.isNotEmpty) const SizedBox(height: 8),

        /// Input field
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Type to search...',
            prefixIcon: const Icon(Icons.search, size: 20),
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),

        /// Suggestions Dropdown
        if (_filteredItems.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _filteredItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(item),
                  dense: true,
                  onTap: () => _toggleItem(item),
                );
              },
            ),
          ),
      ],
    );
  }
}