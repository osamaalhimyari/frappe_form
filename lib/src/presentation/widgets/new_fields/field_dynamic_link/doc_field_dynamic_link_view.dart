// ignore_for_file: overridden_fields, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';

class DocFieldDynamicLinkView extends DocFieldView {
  final List<String> docTypes;
  
  /// Callback to notify the parent/form that the DocType category has changed
  final void Function(String? doctype, String? option)? onDocTypeChanged;

  DocFieldDynamicLinkView({
    super.key,
    required super.field,
    required this.docTypes,
    this.onDocTypeChanged,
    CustomTextEditingController? controller,
    super.dependsOnController,
  }) : super(
          controller:
              controller ?? CustomTextEditingController(focusNode: FocusNode()),
        );

  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  @override
  void initController() {
    super.initController();
    // If there is an initial value in the field definition, set it to the controller
    if (controller.text.isEmpty && field.initial != null) {
      controller.text = field.initial.toString();
    }
  }

  @override
  State<DocFieldDynamicLinkView> createState() =>
      _DocFieldDynamicLinkViewState();
}

class _DocFieldDynamicLinkViewState
    extends DocFieldViewState<DocFieldDynamicLinkView> {
  
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

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
    // 1. Clean the list of DocTypes
    final uniqueDocTypes = widget.docTypes.toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───────── CATEGORY SELECTION (DocType) ─────────
        DropdownButtonFormField<String>(
          // Use controller.text as the source of truth for the dropdown
          value: controller.text.isEmpty ? null : controller.text,
          isExpanded: true,
          hint: const Text('Select Category'),
          items: uniqueDocTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: isReadOnly
              ? null
              : (value) {
                  setState(() {
                    // Update the controller so the form state knows which DocType is selected
                    controller.text = value ?? '';
                  });
                  
                  // Notify the outside world (the Parent) so the LinkField can refresh
                  if (widget.onDocTypeChanged != null) {
                    widget.onDocTypeChanged!(value,field.options);
                  }
                },
          decoration: InputDecoration(
            // Use field.label if provided, otherwise 'Link To'
            labelText: field.label.isNotEmpty ? field.label : 'Link To',
            prefixIcon: const Icon(Icons.category_outlined, size: 20),
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}