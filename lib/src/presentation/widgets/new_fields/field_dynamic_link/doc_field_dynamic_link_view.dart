// ignore_for_file: overridden_fields, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:frappe_form/src/model/new_models/message.dart';

class DocFieldDynamicLinkView extends DocFieldView {
  /// Predefined DocTypes to choose from
  final List<String> docTypes;

  /// Function to fetch records for the selected DocType
  final Future<List<Map<String, dynamic>>> Function(String doctype, String txt) fetchLinkData;

  DocFieldDynamicLinkView({
    super.key,
    required super.field,
    required this.fetchLinkData,
    required this.docTypes,
    CustomTextEditingController? controller,
    super.dependsOnController,
  }) : super(
          controller: controller ??
              CustomTextEditingController(focusNode: FocusNode()),
        );

  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  @override
  void initController() {
    super.initController();
    // Initialize ID from field initial value if controller is empty
    if (controller.text.isEmpty && field.initial != null) {
      controller.text = field.initial.toString();
    }
  }

  @override
  State<DocFieldDynamicLinkView> createState() => _DocFieldDynamicLinkViewState();
}

class _DocFieldDynamicLinkViewState
    extends DocFieldViewState<DocFieldDynamicLinkView> {
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  /// The Label/Search input controller
  final TextEditingController _displayController = TextEditingController();
  
  String? _selectedDocType;
  List<Message> _linkData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // On load, the display shows whatever ID is currently in the controller
    _displayController.text = controller.text;
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  // ───────── DATA LOGIC ─────────

  Future<void> _loadLinkData() async {
    if (_selectedDocType == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await widget.fetchLinkData(_selectedDocType!, '');
      setState(() {
        _linkData = data.map((e) => Message.fromMap(e)).toList();
      });
      
      if (mounted) {
        _showLinkSelectionModal();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectLink(Message item) {
    setState(() {
      // 1. Update form ID (Value)
      controller.text = item.value ?? '';
      // 2. Update display text (Label)
      _displayController.text = item.label ?? item.value ?? '';
    });
  }

  // ───────── UI BUILDERS ─────────

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
        /// 1. DocType Selection Dropdown
        DropdownButtonFormField<String>(
          initialValue: _selectedDocType,
          items: widget.docTypes
              .map((docType) => DropdownMenuItem(
                    value: docType,
                    child: Text(docType, style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: isReadOnly ? null : (value) {
            setState(() {
              _selectedDocType = value;
              // Clear previous selection when DocType changes
              controller.clear();
              _displayController.clear();
            });
          },
          decoration: const InputDecoration(
            labelText: 'Select Category',
            prefixIcon: Icon(Icons.category_outlined, size: 20),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),

        const SizedBox(height: 12),

        /// 2. Record Selection Field
        TextFormField(
          controller: _displayController,
          readOnly: true, // Only allow selection via Tap
          enabled: _selectedDocType != null && !isReadOnly,
          onTap: _loadLinkData,
          decoration: InputDecoration(
            labelText: 'Select Record',
            hintText: _selectedDocType == null ? 'Select category first' : 'Tap to search...',
            prefixIcon: const Icon(Icons.link, size: 20),
            border: const OutlineInputBorder(),
            suffixIcon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_displayController.text.isNotEmpty && !isReadOnly
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _displayController.clear();
                          controller.clear();
                        },
                      )
                    : const Icon(Icons.arrow_drop_down)),
          ),
        ),
      ],
    );
  }

  void _showLinkSelectionModal() {
    if (_linkData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No records found for this category')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select $_selectedDocType',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _linkData.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _linkData[index];
                return ListTile(
                  title: Text(item.label ?? ''),
                  subtitle: item.label != item.value ? Text(item.value ?? '') : null,
                  onTap: () {
                    _selectLink(item);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}