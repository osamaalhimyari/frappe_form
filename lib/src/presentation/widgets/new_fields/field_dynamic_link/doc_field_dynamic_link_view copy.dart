// // ignore_for_file: overridden_fields, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:frappe_form/frappe_form.dart';

// class DocFieldDynamicLinkView extends DocFieldView {
//   final List<String> docTypes;

//   /// Callback signature: (DocType, SearchText)
//   final Future<List<Map<String, dynamic>>> Function(
//     String pattern,
//     String option,
//   )
//   fetchSuggestions;

//   DocFieldDynamicLinkView({
//     super.key,
//     required super.field,
//     required this.fetchSuggestions,
//     required this.docTypes,
//     CustomTextEditingController? controller,
//     super.dependsOnController,
//   }) : super(
//          controller:
//              controller ?? CustomTextEditingController(focusNode: FocusNode()),
//        );

//   @override
//   CustomTextEditingController get controller =>
//       super.controller as CustomTextEditingController;

//   @override
//   State<DocFieldDynamicLinkView> createState() =>
//       _DocFieldDynamicLinkViewState();
// }

// class _DocFieldDynamicLinkViewState
//     extends DocFieldViewState<DocFieldDynamicLinkView> {
//   @override
//   CustomTextEditingController get controller =>
//       super.controller as CustomTextEditingController;

//   String? _selectedDocType;

//   @override
//   Widget buildBody(BuildContext context) {
//     // 1. Clean the list of DocTypes
//     final uniqueDocTypes = widget.docTypes.toSet().toList();
//     Future<List<Map<String, dynamic>>> fetchsuggestions(String pattern) {
//       return widget.fetchSuggestions(pattern, _selectedDocType!);
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ───────── CATEGORY SELECTION (DocType) ─────────
//         DropdownButtonFormField<String>(
//           // Use 'value' to ensure the UI updates when 'setState' is called
//           value: _selectedDocType,
//           isExpanded: true,
//           hint: const Text('Select Category'),
//           items: uniqueDocTypes.map((type) {
//             return DropdownMenuItem(
//               value: type,
//               child: Text(type, style: const TextStyle(fontSize: 14)),
//             );
//           }).toList(),
//           onChanged: isReadOnly
//               ? null
//               : (value) {
//                   setState(() {
//                     _selectedDocType = value;
//                     // print(_selectedDocType! + "===================");
//                     controller.clear();
//                   });
//                 },
//           decoration: const InputDecoration(
//             labelText: 'Link To',
//             prefixIcon: Icon(Icons.category_outlined, size: 20),
//             border: OutlineInputBorder(),
//             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           ),
//         ),

//         const SizedBox(height: 12),

//         // ───────── RECORD SELECTION (Search) ─────────
//         if (_selectedDocType != null)
//           DocFieldLinkView(
//             key: Key('link_field_$_selectedDocType'),
//             field: field,
//             controller: controller,
//             fetchSuggestions: fetchsuggestions,
//           )
//         else
//           // Disabled placeholder if no category is picked
//           TextFormField(
//             enabled: false,
//             decoration: const InputDecoration(
//               labelText: 'Select Record',
//               hintText: 'Select category first',
//               border: OutlineInputBorder(),
//               prefixIcon: Icon(Icons.link_off, size: 20),
//             ),
//           ),
//       ],
//     );
//   }
// }
