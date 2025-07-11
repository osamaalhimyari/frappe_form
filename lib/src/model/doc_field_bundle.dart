import 'package:frappe_form/src/logic/utils/text_utils.dart';
import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_view.dart';

class DocFieldBundle {
  /// Use it just to group views
  final String? groupId;
  final DocField field;
  final List<DocFieldBundle> children;
  final FieldController controller;
  final DocFieldView view;

  DocFieldBundle({
    this.groupId,
    required this.field,
    List<DocFieldBundle>? children,
    required this.controller,
    required this.view,
  }) : children = children ?? <DocFieldBundle>[];

  /// Returns linkId of the form [field] prefixed by its parent item
  /// link ids, showing a unique id for this form [field].
  String get uid =>
      groupId.isNotEmpty ? '$groupId/${field.fieldName}' : '${field.fieldName}';
}
