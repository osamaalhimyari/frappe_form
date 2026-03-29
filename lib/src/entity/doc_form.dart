import 'dart:convert';
import 'package:adeptannotations/adeptannotations.dart';
import 'package:flutter/foundation.dart';
import 'package:frappe_form/src/entity/doc_field.dart';
import 'package:frappe_form/src/entity/doc_type.dart';
import 'package:frappe_form/src/entity/enumerator/doc_type_type.dart';
import 'package:frappe_form/src/logic/utils/param_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import '../model/new_models/dashboard.dart';

part 'doc_form.g.dart';

@JsonSerializable()
@CopyWith()
class DocForm extends DocType {
  @JsonKey(name: '__dashboard')
  final Dashboard? dashboard;

  @JsonKey(name: '__js') // Map from Frappe's __js key
  final String? jsContent;

  @JsonKey(name: 'fields')
  final List<DocField> fields;
  
  @JsonKey(name: 'field_order')
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
    this.dashboard, 
    this.jsContent, // Added to constructor
  }) : fields = fields ?? [],
       fieldsOrder = fieldsOrder ?? [];

  /// Utility to extract dynamic link options (like for opportunity_from) 
  /// directly from the form's javascript content.
  List<String> getDynamicLinkOptions(String fieldName) {
    final code = jsContent;
    if (code == null || code.isEmpty) return [];

    final pattern = RegExp(
      'set_query\\s*\\(\\s*["\']$fieldName["\']' 
      '[\\s\\S]*?'                               
      '["\']in["\']\\s*,\\s*\\['                 
      '([^\\]]+)'                                
      '\\]',                                      
      caseSensitive: false,
    );

    final match = pattern.firstMatch(code);
    final rawCapture = match?.group(1);

    if (rawCapture == null) return [];

    return rawCapture
        .split(',')
        .map((item) => item.trim())
        .map((item) => item.replaceAll(RegExp("['\"]"), "")) 
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toAnswerMap() => {
    if (owner != null) ParamUtils.owner: owner,
    if (docStatus != null) ParamUtils.docStatus: docStatus,
    if (idx != null) ParamUtils.idx: idx,
    if (name != null) ParamUtils.docType: name,
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

  static DocForm? fromJsonObject(Object? json) {
    if (json != null) {
      try {
        if (json is String) {
          return DocForm.fromJsonString(json.toString());
        }
        if (json is Map) {
          return DocForm.fromJson(json as Map<String, dynamic>);
        }
        if (json is DocForm) {
          return json;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return _$DocFormToJson(this);
  }
}