import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// Extra geometry rendering hints used by Leaflet-style Geolocation drawings.
enum GeometryPropertyType {
  /// A circle defined by a center point and a radius.
  @JsonValue('circle')
  circle('circle'),

  /// A circle marker whose radius is fixed in screen pixels.
  @JsonValue('circlemarker')
  circleMarker('circlemarker');

  /// The raw GeoJSON property string backing this enum entry.
  final String name;

  /// Creates a [GeometryPropertyType] bound to its raw [name].
  const GeometryPropertyType(this.name);

  /// Returns the [GeometryPropertyType] whose [name] matches [name], or `null`.
  static GeometryPropertyType? valueOf(String? name) => GeometryPropertyType
      .values
      .firstWhereOrNull((value) => value.name == name);
}
