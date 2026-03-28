
// ignore_for_file: use_build_context_synchronously, overridden_fields

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
// import 'package:get/get.dart';
import 'package:signature/signature.dart';

class DocFieldSignatureView extends DocFieldView {
  DocFieldSignatureView({
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
    controller.value ??= '${field.initial}';
  }

  @override
  State<DocFieldSignatureView> createState() => DocFieldSignatureViewState();
}

class DocFieldSignatureViewState<SF extends DocFieldSignatureView>
    extends DocFieldViewState<SF> {
  late SignatureController _signatureController;
  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;
  /// Get value from controller if it exists (for initial loading or persistence)
  String? get frappeSignatureValue =>
      controller.value.isEmpty ? null : controller.value;

  @override
  void initState() {
    super.initState();

    _signatureController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    _signatureController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
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
        // ───────── SIGNATURE PAD ─────────
        Container(
          height: 160,
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Signature(
            controller: _signatureController,
            backgroundColor: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        // ───────── ACTIONS ─────────
        Row(
          children: [
            TextButton.icon(
              icon: const Icon(Icons.clear),
              label: const Text('Clear'),
              onPressed: () {
                _signatureController.clear();
                // Update the controller so the Map is updated
                controller.value = ''; 
                setState(() {});
              },
            ),

            const Spacer(),

            TextButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Save'),
              onPressed: _exportSignature,
            ),
          ],
        ),

        // ───────── PREVIEW ─────────
        if (frappeSignatureValue != null) ...[
          const SizedBox(height: 8),
          const Text('Saved Signature Preview:', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
            ),
            child: Image.memory(
              base64Decode(frappeSignatureValue!.split(',').last),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ],
    );
  }

  // ───────── EXPORT TO FRAPPE FORMAT ─────────

  Future<void> _exportSignature() async {
    if (_signatureController.isEmpty) return;

    final Uint8List? bytes = await _signatureController.toPngBytes();
    if (bytes == null) return;

    final base64 = base64Encode(bytes);

    setState(() {
      // THIS UPDATES THE CONTROLLER IN YOUR FormManager Registry
      controller.value = 'data:image/png;base64,$base64';
    });
    
 ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Signature saved')),    );
  }
}