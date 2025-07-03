import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:frappe_form/src/entity/enumerator/feature_type.dart';
import 'package:frappe_form/src/entity/enumerator/geolocation_type.dart';
import 'package:frappe_form/src/entity/enumerator/geometry_property_type.dart';
import 'package:frappe_form/src/entity/enumerator/geometry_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doc_geolocation.g.dart';

@JsonSerializable()
@CopyWith()
class DocGeolocation {
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GeolocationType? type;
  @JsonKey(name: "features")
  final List<Feature>? features;

  DocGeolocation({this.type, this.features});

  factory DocGeolocation.fromLatLng({
    required double latitude,
    required double longitude,
  }) {
    return DocGeolocation(
      type: GeolocationType.featureCollection,
      features: [
        Feature(
          type: FeatureType.feature,
          // Setting a GeometryProperty is required so Frappe properly renders
          // the map, no matter the GeometryProperty is empty.
          properties: GeometryProperty(),
          geometry: Geometry(
            type: GeometryType.point,
            coordinates: [longitude, latitude],
          ),
        ),
      ],
    );
  }

  factory DocGeolocation.fromJson(Map<String, dynamic> json) {
    return _$DocGeolocationFromJson(json);
  }

  factory DocGeolocation.fromJsonString(String json) =>
      DocGeolocation.fromJson(jsonDecode(json));

  Map<String, dynamic> toJson() {
    return _$DocGeolocationToJson(this);
  }

  String toJsonString() => jsonEncode(toJson());

  @override
  String toString() => toJsonString();
}

@JsonSerializable()
@CopyWith()
class Feature {
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final FeatureType? type;
  @JsonKey(name: "properties")
  final GeometryProperty? properties;
  @JsonKey(name: "geometry")
  final Geometry? geometry;

  Feature({this.type, this.properties, this.geometry});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return _$FeatureFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FeatureToJson(this);
  }
}

@JsonSerializable()
@CopyWith()
class Geometry {
  @JsonKey(name: "type", unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final GeometryType? type;
  @JsonKey(name: "coordinates")
  final List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return _$GeometryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeometryToJson(this);
  }
}

@JsonSerializable()
@CopyWith()
class GeometryProperty {
  @JsonKey(
    name: "point_type",
    unknownEnumValue: JsonKey.nullForUndefinedEnumValue,
  )
  final GeometryPropertyType? pointType;
  @JsonKey(name: "radius")
  final double? radius;

  GeometryProperty({this.pointType, this.radius});

  factory GeometryProperty.fromJson(Map<String, dynamic> json) {
    return _$GeometryPropertyFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GeometryPropertyToJson(this);
  }
}
