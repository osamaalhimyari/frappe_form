// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:barcode_widget/barcode_widget.dart';

class DocFieldBarcodeView extends DocFieldView {
  DocFieldBarcodeView({
    super.key,
    CustomTextEditingController? controller,
    required super.field,
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
    // Initialize with field initial value if controller is empty
    if (controller.text.isEmpty && field.initial != null) {
      controller.text = field.initial.toString();
    }
  }

  @override
  State<DocFieldBarcodeView> createState() => DocFieldBarcodeViewState();
}

class DocFieldBarcodeViewState<SF extends DocFieldBarcodeView>
    extends DocFieldViewState<SF> {
  
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  @override
  void initState() {
    super.initState();
    // Rebuild the UI (the barcode image) whenever the user types
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
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
    final String data = controller.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───────── TEXT INPUT ─────────
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter barcode data...',
            prefixIcon: const Icon(Icons.qr_code_scanner),
            border: const OutlineInputBorder(),
            suffixIcon: data.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.clear(),
                  )
                : null,
          ),
        ),

        const SizedBox(height: 12),

        // ───────── BARCODE PREVIEW ─────────
        Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: data.isEmpty
              ? Center(
                  child: Text(
                    'No data entered',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                )
              : BarcodeWidget(
                  barcode: _resolveBarcodeType(),
                  data: data,
                  drawText: true,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  errorBuilder: (context, error) => Center(
                    child: Text(
                      'Invalid format for ${_getBarcodeName()}',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  /// Helper to get the display name of the barcode type
  String _getBarcodeName() => field.options ?? 'CODE128';

  /// Maps the "options" string from Frappe to the Barcode logic
  Barcode _resolveBarcodeType() {
    switch (field.options?.toUpperCase()) {
      case 'EAN13':
        return Barcode.ean13();
      case 'EAN8':
        return Barcode.ean8();
      case 'QR':
      case 'QRCODE':
        return Barcode.qrCode();
      case 'CODE39':
        return Barcode.code39();
      case 'UPCA':
        return Barcode.upcA();
      default:
        return Barcode.code128(); // Most flexible default
    }
  }
}