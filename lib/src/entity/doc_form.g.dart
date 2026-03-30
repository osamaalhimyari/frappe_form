// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_form.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [DocForm] is to generate the code for a copyWith(...) function.
extension $DocFormCopyWithExtension on DocForm {
  DocForm copyWith({
    String? name,
    DateTime? creation,
    DateTime? modified,
    String? modifiedBy,
    String? owner,
    int? idx,
    String? module,
    String? sortField,
    String? sortOrder,
    int? maxAttachments,
    int? isSubmittable,
    int? showTitleFieldInLink,
    int? translatedDocType,
    int? allowAutoRepeat,
    DocTypeType? docType,
    int? docStatus,
    String? description,
    Dashboard? dashboard,
    String? jsContent,
    List<DocField>? fields,
    List<String>? fieldsOrder,
  }) {
    return DocForm(
      name: name ?? this.name,
      creation: creation ?? this.creation,
      modified: modified ?? this.modified,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      owner: owner ?? this.owner,
      idx: idx ?? this.idx,
      module: module ?? this.module,
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
      maxAttachments: maxAttachments ?? this.maxAttachments,
      isSubmittable: isSubmittable ?? this.isSubmittable,
      showTitleFieldInLink: showTitleFieldInLink ?? this.showTitleFieldInLink,
      translatedDocType: translatedDocType ?? this.translatedDocType,
      allowAutoRepeat: allowAutoRepeat ?? this.allowAutoRepeat,
      docType: docType ?? this.docType,
      docStatus: docStatus ?? this.docStatus,
      description: description ?? this.description,
      dashboard: dashboard ?? this.dashboard,
      jsContent: jsContent ?? this.jsContent,
      fields: ((fields?.isNotEmpty ?? false) ? fields : null) ?? this.fields,
      fieldsOrder:
          ((fieldsOrder?.isNotEmpty ?? false) ? fieldsOrder : null) ??
          this.fieldsOrder,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocForm _$DocFormFromJson(Map<String, dynamic> json) => DocForm(
  name: json['name'] as String?,
  creation: json['creation'] == null
      ? null
      : DateTime.parse(json['creation'] as String),
  modified: json['modified'] == null
      ? null
      : DateTime.parse(json['modified'] as String),
  modifiedBy: json['modified_by'] as String?,
  owner: json['owner'] as String?,
  idx: (json['idx'] as num?)?.toInt(),
  module: json['module'] as String?,
  sortField: json['sort_field'] as String?,
  sortOrder: json['sort_order'] as String?,
  maxAttachments: (json['max_attachments'] as num?)?.toInt(),
  isSubmittable: (json['is_submittable'] as num?)?.toInt(),
  showTitleFieldInLink: (json['show_title_field_in_link'] as num?)?.toInt(),
  translatedDocType: (json['translated_doctype'] as num?)?.toInt(),
  allowAutoRepeat: (json['allow_auto_repeat'] as num?)?.toInt(),
  docType: $enumDecodeNullable(
    _$DocTypeTypeEnumMap,
    json['doctype'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  docStatus: (json['docstatus'] as num?)?.toInt(),
  description: json['description'] as String?,
  fields: (json['fields'] as List<dynamic>?)
      ?.map((e) => DocField.fromJson(e as Map<String, dynamic>))
      .toList(),
  fieldsOrder: (json['field_order'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  dashboard: json['__dashboard'] == null
      ? null
      : Dashboard.fromMap((json['__dashboard'] as Map).cast<String, dynamic>())
,
  jsContent: json['__js'] as String?,
);

Map<String, dynamic> _$DocFormToJson(DocForm instance) => <String, dynamic>{
  'name': ?instance.name,
  'creation': ?instance.creation?.toIso8601String(),
  'modified': ?instance.modified?.toIso8601String(),
  'modified_by': ?instance.modifiedBy,
  'owner': ?instance.owner,
  'idx': ?instance.idx,
  'module': ?instance.module,
  'sort_field': ?instance.sortField,
  'sort_order': ?instance.sortOrder,
  'max_attachments': ?instance.maxAttachments,
  'is_submittable': ?instance.isSubmittable,
  'show_title_field_in_link': ?instance.showTitleFieldInLink,
  'translated_doctype': ?instance.translatedDocType,
  'allow_auto_repeat': ?instance.allowAutoRepeat,
  'doctype': ?_$DocTypeTypeEnumMap[instance.docType],
  'docstatus': ?instance.docStatus,
  'description': ?instance.description,
  '__dashboard':instance.dashboard!=null? instance.dashboard!.toMap():{},
  '__js': ?instance.jsContent,
  'fields': instance.fields,
  'field_order': instance.fieldsOrder,
};

const _$DocTypeTypeEnumMap = {
  DocTypeType.docType: 'DocType',
  DocTypeType.docField: 'DocField',
};
