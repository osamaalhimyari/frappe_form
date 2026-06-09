import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// Top-level GeoJSON object type stored by a Geolocation field.
enum GeolocationType {
  /// A GeoJSON `FeatureCollection` holding one or more features.
  @JsonValue('FeatureCollection')
  featureCollection('FeatureCollection');

  /// The raw GeoJSON string value backing this enum entry.
  final String name;

  /// Creates a [GeolocationType] bound to its raw GeoJSON [name].
  const GeolocationType(this.name);

  /// Returns the [GeolocationType] whose [name] matches [name], or `null`.
  static GeolocationType? valueOf(String? name) =>
      GeolocationType.values.firstWhereOrNull((value) => value.name == name);
}
