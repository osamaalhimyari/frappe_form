// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [Attachment] is to generate the code for a copyWith(...) function.
extension $AttachmentCopyWithExtension on Attachment {
  Attachment copyWith({
    String? mediaType,
    String? path,
    String? url,
    String? base64,
  }) {
    return Attachment(
      mediaType: mediaType ?? this.mediaType,
      path: path ?? this.path,
      url: url ?? this.url,
      base64: base64 ?? this.base64,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) => Attachment(
  mediaType: json['mediaType'] as String?,
  path: json['path'] as String?,
  url: json['url'] as String?,
  base64: json['base64'] as String?,
);

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'mediaType': ?instance.mediaType,
      'path': ?instance.path,
      'url': ?instance.url,
      'base64': ?instance.base64,
    };
