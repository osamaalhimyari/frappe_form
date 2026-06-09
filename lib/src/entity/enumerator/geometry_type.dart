import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

/// The GeoJSON geometry shapes supported by Geolocation fields.
enum GeometryType {
  /// A single coordinate point.
  @JsonValue('Point')
  point('Point'),

  /// A connected sequence of points forming a line.
  @JsonValue('LineString')
  lineString('LineString'),

  /// A closed shape bounded by a ring of points.
  @JsonValue('Polygon')
  polygon('Polygon');

  /// The raw GeoJSON string value backing this enum entry.
  final String name;

  /// Creates a [GeometryType] bound to its raw GeoJSON [name].
  const GeometryType(this.name);

  /// Returns the [GeometryType] whose [name] matches [name], or `null`.
  static GeometryType? valueOf(String? name) =>
      GeometryType.values.firstWhereOrNull((value) => value.name == name);
}
