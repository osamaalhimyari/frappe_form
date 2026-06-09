import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// Identifies whether a Frappe metadata record describes a [DocType] container
/// or a single [DocField] within one.
enum DocTypeType {
  /// A full document type definition (a form/table in Frappe).
  @JsonValue('DocType')
  docType('DocType'),

  /// A single field belonging to a [DocType].
  @JsonValue('DocField')
  docField('DocField');

  /// The raw Frappe string value backing this enum entry.
  final String name;

  /// Creates a [DocTypeType] bound to its raw Frappe [name].
  const DocTypeType(this.name);

  /// Returns the [DocTypeType] whose [name] matches [name], or `null` if none.
  static DocTypeType? valueOf(String? name) =>
      DocTypeType.values.firstWhereOrNull((value) => value.name == name);
}
