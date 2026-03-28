import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:frappe_form/src/model/new_models/message.dart';

/// ======================================================
/// Dynamic Link Field with selectable DocTypes
/// ======================================================
class FrappeDynamicLinkField extends DocFieldTextFieldView {
  /// Predefined DocTypes to choose from
  final List<String> docTypes;

  /// Function to fetch records for the selected DocType
  final Future<List<Map<String, dynamic>>> Function(String doctype, String txt)
  fetchLinkData;
  @override
  final CustomTextEditingController  controller ;

  FrappeDynamicLinkField({
    super.key,
    required super.field,
    required this.fetchLinkData,
    required this.docTypes, required this.controller,
  });

  @override
  State<FrappeDynamicLinkField> createState() => _FrappeDynamicLinkFieldState();
}

class _FrappeDynamicLinkFieldState
    extends DocFieldTextFieldViewState<FrappeDynamicLinkField> {

  String? _selectedDocType;
  List<Message> _linkData = [];
  List<Message> _filteredData = [];
  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  // }

  Future<void> _loadLinkData() async {
    if (_selectedDocType == null || _selectedDocType!.isEmpty) {
      setState(() {
        _linkData = [];
        _filteredData = [];
        widget.controller.clear();
      });
      return;
    }

    setState(() => isLoading = true);
    try {
      final data = await widget.fetchLinkData(_selectedDocType!, '');
      setState(() {
        _linkData = data.map((e) => Message.fromMap(e)).toList();
        _filteredData = _linkData;
        widget.controller.clear();
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterLinks(String pattern) {
    setState(() {
      if (pattern.isEmpty) {
        _filteredData = _linkData;
      } else {
        final lower = pattern.toLowerCase();
        _filteredData = _linkData
            .where(
              (e) =>
                  (e.label?.toLowerCase().contains(lower) ?? false) ||
                  (e.value?.toLowerCase().contains(lower) ?? false),
            )
            .toList();
      }
    });
  }

  void _selectLink(Message item) {
    widget.controller.text = item.label ?? item.value ?? '';
    controller.text = widget.controller.text; // sync with DocField
    setState(() {});
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// --- DocType dropdown ---
        DropdownButtonFormField<String>(
          initialValue: _selectedDocType,
          items: widget.docTypes
              .map(
                (docType) =>
                    DropdownMenuItem(value: docType, child: Text(docType)),
              )
              .toList(),
          onChanged: (value) {
            if (value != _selectedDocType) {
              setState(() {
                _selectedDocType = value;
              });
              _loadLinkData();
            }
          },
          decoration: const InputDecoration(
            labelText: 'Select DocType',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),

        /// --- Link selection ---
        TextField(
          controller: widget.controller,
          decoration: const InputDecoration(
            labelText: 'Select Record',
            border: OutlineInputBorder(),
          ),
          readOnly: _linkData.isEmpty,
          onChanged: _filterLinks,
          onTap: _linkData.isNotEmpty
              ? () => _showLinkSelection(context)
              : null,
        ),
      ],
    );
  }

  void _showLinkSelection(BuildContext context) {
    if (_filteredData.isEmpty) return;

    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: _filteredData.length,
        itemBuilder: (context, index) {
          final item = _filteredData[index];
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
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
