// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DocFieldColorView extends DocFieldView {
  DocFieldColorView({
    super.key,
    CustomValueController<String>? controller,
    required super.field,
    super.dependsOnController,
  }) : super(
          controller: controller ??
              CustomValueController<String>(focusNode: FocusNode()),
        );

  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;

  @override
  void initController() {
    super.initController();
    // 1. Initialize controller value from field initial if empty
    // Standard Frappe hex format is #RRGGBB
    if (controller.value.isEmpty && field.initial != null) {
      controller.value = field.initial.toString();
    }
    
    // Default to white if still empty to avoid parsing errors
    if (controller.value.isEmpty) {
      controller.value = '#FFFFFF';
    }
  }

  @override
  State<DocFieldColorView> createState() => DocFieldColorViewState();
}

class DocFieldColorViewState<SF extends DocFieldColorView> extends DocFieldViewState<SF> {
  late Color _currentColor;

  @override
  CustomValueController<String> get controller =>
      super.controller as CustomValueController<String>;

  @override
  void initState() {
    super.initState();
    // Initialize the local Color object from the controller's string
    _currentColor = _parseHexColor(controller.value??'#FFFFFF');
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
    return Row(
      children: [
        // ───────── COLOR PREVIEW BOX ─────────
        GestureDetector(
          onTap: _openColorPicker,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(255~/0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Icon(
              Icons.colorize, 
              color: _currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ───────── READ-ONLY HEX DISPLAY ─────────
        Expanded(
          child: TextFormField(
            readOnly: true,
            // Create a temporary controller for the display or use the value directly
            // onChanged: (value) => controller.value = value,
            controller: TextEditingController(text: controller.value),
            decoration: const InputDecoration(
              hintText: '#FFFFFF',
              // labelText: controller.value, // Shows the hex code
            
              labelStyle: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onTap: _openColorPicker,
          ),
        ),
      ],
    );
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: _currentColor,
            onColorChanged: (color) {
              setState(() {
                _currentColor = color;
                // Update the Form Controller with Hex String
                controller.value = _toHex(color);
              });
            },
            enableAlpha: false, // Frappe doesn't usually use Alpha in standard Color fields
            displayThumbColor: true,
            paletteType: PaletteType.hsvWithHue,
            labelTypes: const [ColorLabelType.hex],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ───────── HELPERS ─────────

  Color _parseHexColor(String hexString) {
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return Colors.white; // Fallback
    }
  }

  String _toHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
  }
}