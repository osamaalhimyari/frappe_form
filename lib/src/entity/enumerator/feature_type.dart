import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// Categorizes a GeoJSON entry as a single feature.
enum FeatureType {
  /// A single GeoJSON `Feature` object.
  @JsonValue('Feature')
  feature('Feature');

  /// The raw GeoJSON string value backing this enum entry.
  final String name;

  /// Creates a [FeatureType] bound to its raw GeoJSON [name].
  const FeatureType(this.name);

  /// Returns the [FeatureType] whose [name] matches [name], or `null` if none.
  static FeatureType? valueOf(String? name) =>
      FeatureType.values.firstWhereOrNull((value) => value.name == name);
}
