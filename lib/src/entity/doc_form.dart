import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/entity/doc_type.dart';
import 'package:frappe_form/src/entity/enumerator/doc_type_type.dart';
import 'package:frappe_form/src/logic/utils/param_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_form.g.dart';

@JsonSerializable()
@CopyWith()
class DocForm extends DocType {
  @JsonKey(name: "fields")
  final List<DocField> fields;
  @JsonKey(name: "field_order")
  final List<String> fieldsOrder;

  DocForm({
    super.name,
    super.creation,
    super.modified,
    super.modifiedBy,
    super.owner,
    super.idx,
    super.module,
    super.sortField,
    super.sortOrder,
    super.readOnly,
    super.maxAttachments,
    super.isSubmittable,
    super.showTitleFieldInLink,
    super.translatedDocType,
    super.allowAutoRepeat,
    super.docType,
    super.docStatus,
    super.description,
    List<DocField>? fields,
    List<String>? fieldsOrder,
  })  : fields = fields ?? [],
        fieldsOrder = fieldsOrder ?? [];

  Map<String, dynamic> toAnswerMap() => {
        ParamUtils.owner: owner,
        ParamUtils.docStatus: docStatus,
        ParamUtils.idx: idx,
        ParamUtils.docType: name,
      };

  void sortFields() {
    for (int i = 0; i < fieldsOrder.length; ++i) {
      final String fieldName = fieldsOrder[i];
      for (int j = i; j < fields.length; ++j) {
        if (fields[j].fieldName == fieldName) {
          final tempField = fields[i];
          fields[i] = fields[j];
          fields[j] = tempField;
          break;
        }
      }
    }
  }

  factory DocForm.fromJson(Map<String, dynamic> json) =>
      _$DocFormFromJson(json);

  factory DocForm.fromJsonString(String json) =>
      DocForm.fromJson(jsonDecode(json));

  @override
  Map<String, dynamic> toJson() {
    return _$DocFormToJson(this);
  }
}
