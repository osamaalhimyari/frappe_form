// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_geolocation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [DocGeolocation] is to generate the code for a copyWith(...) function.
extension $DocGeolocationCopyWithExtension on DocGeolocation {
  DocGeolocation copyWith({GeolocationType? type, List<Feature>? features}) {
    return DocGeolocation(
      type: type ?? this.type,
      features:
          ((features?.isNotEmpty ?? false) ? features : null) ?? this.features,
    );
  }
}

/// This Extension on [Feature] is to generate the code for a copyWith(...) function.
extension $FeatureCopyWithExtension on Feature {
  Feature copyWith({
    FeatureType? type,
    GeometryProperty? properties,
    Geometry? geometry,
  }) {
    return Feature(
      type: type ?? this.type,
      properties: properties ?? this.properties,
      geometry: geometry ?? this.geometry,
    );
  }
}

/// This Extension on [Geometry] is to generate the code for a copyWith(...) function.
extension $GeometryCopyWithExtension on Geometry {
  Geometry copyWith({GeometryType? type, List<double>? coordinates}) {
    return Geometry(
      type: type ?? this.type,
      coordinates:
          ((coordinates?.isNotEmpty ?? false) ? coordinates : null) ??
          this.coordinates,
    );
  }
}

/// This Extension on [GeometryProperty] is to generate the code for a copyWith(...) function.
extension $GeometryPropertyCopyWithExtension on GeometryProperty {
  GeometryProperty copyWith({GeometryPropertyType? pointType, double? radius}) {
    return GeometryProperty(
      pointType: pointType ?? this.pointType,
      radius: radius ?? this.radius,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocGeolocation _$DocGeolocationFromJson(Map<String, dynamic> json) =>
    DocGeolocation(
      type: $enumDecodeNullable(
        _$GeolocationTypeEnumMap,
        json['type'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocGeolocationToJson(DocGeolocation instance) =>
    <String, dynamic>{
      'type': ?_$GeolocationTypeEnumMap[instance.type],
      'features': ?instance.features,
    };

const _$GeolocationTypeEnumMap = {
  GeolocationType.featureCollection: 'FeatureCollection',
};

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
  type: $enumDecodeNullable(
    _$FeatureTypeEnumMap,
    json['type'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  properties: json['properties'] == null
      ? null
      : GeometryProperty.fromJson(json['properties'] as Map<String, dynamic>),
  geometry: json['geometry'] == null
      ? null
      : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
  'type': ?_$FeatureTypeEnumMap[instance.type],
  'properties': ?instance.properties,
  'geometry': ?instance.geometry,
};

const _$FeatureTypeEnumMap = {FeatureType.feature: 'Feature'};

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
  type: $enumDecodeNullable(
    _$GeometryTypeEnumMap,
    json['type'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  coordinates: (json['coordinates'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
  'type': ?_$GeometryTypeEnumMap[instance.type],
  'coordinates': ?instance.coordinates,
};

const _$GeometryTypeEnumMap = {
  GeometryType.point: 'Point',
  GeometryType.lineString: 'LineString',
  GeometryType.polygon: 'Polygon',
};

GeometryProperty _$GeometryPropertyFromJson(Map<String, dynamic> json) =>
    GeometryProperty(
      pointType: $enumDecodeNullable(
        _$GeometryPropertyTypeEnumMap,
        json['point_type'],
        unknownValue: JsonKey.nullForUndefinedEnumValue,
      ),
      radius: (json['radius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GeometryPropertyToJson(GeometryProperty instance) =>
    <String, dynamic>{
      'point_type': ?_$GeometryPropertyTypeEnumMap[instance.pointType],
      'radius': ?instance.radius,
    };

const _$GeometryPropertyTypeEnumMap = {
  GeometryPropertyType.circle: 'circle',
  GeometryPropertyType.circleMarker: 'circlemarker',
};
