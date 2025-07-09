// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_geolocation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocGeolocationCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// DocGeolocation(...).copyWith(id: 12, name: "My name")
  /// ````
  DocGeolocation call({
    GeolocationType? type,
    List<Feature>? features,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocGeolocation.copyWith(...)`.
class _$DocGeolocationCWProxyImpl implements _$DocGeolocationCWProxy {
  const _$DocGeolocationCWProxyImpl(this._value);

  final DocGeolocation _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// DocGeolocation(...).copyWith(id: 12, name: "My name")
  /// ````
  DocGeolocation call({
    Object? type = const $CopyWithPlaceholder(),
    Object? features = const $CopyWithPlaceholder(),
  }) {
    return DocGeolocation(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as GeolocationType?,
      features: features == const $CopyWithPlaceholder()
          ? _value.features
          // ignore: cast_nullable_to_non_nullable
          : features as List<Feature>?,
    );
  }
}

extension $DocGeolocationCopyWith on DocGeolocation {
  /// Returns a callable class that can be used as follows: `instanceOfDocGeolocation.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$DocGeolocationCWProxy get copyWith => _$DocGeolocationCWProxyImpl(this);
}

abstract class _$FeatureCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Feature(...).copyWith(id: 12, name: "My name")
  /// ````
  Feature call({
    FeatureType? type,
    GeometryProperty? properties,
    Geometry? geometry,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeature.copyWith(...)`.
class _$FeatureCWProxyImpl implements _$FeatureCWProxy {
  const _$FeatureCWProxyImpl(this._value);

  final Feature _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Feature(...).copyWith(id: 12, name: "My name")
  /// ````
  Feature call({
    Object? type = const $CopyWithPlaceholder(),
    Object? properties = const $CopyWithPlaceholder(),
    Object? geometry = const $CopyWithPlaceholder(),
  }) {
    return Feature(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as FeatureType?,
      properties: properties == const $CopyWithPlaceholder()
          ? _value.properties
          // ignore: cast_nullable_to_non_nullable
          : properties as GeometryProperty?,
      geometry: geometry == const $CopyWithPlaceholder()
          ? _value.geometry
          // ignore: cast_nullable_to_non_nullable
          : geometry as Geometry?,
    );
  }
}

extension $FeatureCopyWith on Feature {
  /// Returns a callable class that can be used as follows: `instanceOfFeature.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$FeatureCWProxy get copyWith => _$FeatureCWProxyImpl(this);
}

abstract class _$GeometryCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Geometry(...).copyWith(id: 12, name: "My name")
  /// ````
  Geometry call({
    GeometryType? type,
    List<double>? coordinates,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGeometry.copyWith(...)`.
class _$GeometryCWProxyImpl implements _$GeometryCWProxy {
  const _$GeometryCWProxyImpl(this._value);

  final Geometry _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// Geometry(...).copyWith(id: 12, name: "My name")
  /// ````
  Geometry call({
    Object? type = const $CopyWithPlaceholder(),
    Object? coordinates = const $CopyWithPlaceholder(),
  }) {
    return Geometry(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as GeometryType?,
      coordinates: coordinates == const $CopyWithPlaceholder()
          ? _value.coordinates
          // ignore: cast_nullable_to_non_nullable
          : coordinates as List<double>?,
    );
  }
}

extension $GeometryCopyWith on Geometry {
  /// Returns a callable class that can be used as follows: `instanceOfGeometry.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GeometryCWProxy get copyWith => _$GeometryCWProxyImpl(this);
}

abstract class _$GeometryPropertyCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GeometryProperty(...).copyWith(id: 12, name: "My name")
  /// ````
  GeometryProperty call({
    GeometryPropertyType? pointType,
    double? radius,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGeometryProperty.copyWith(...)`.
class _$GeometryPropertyCWProxyImpl implements _$GeometryPropertyCWProxy {
  const _$GeometryPropertyCWProxyImpl(this._value);

  final GeometryProperty _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// GeometryProperty(...).copyWith(id: 12, name: "My name")
  /// ````
  GeometryProperty call({
    Object? pointType = const $CopyWithPlaceholder(),
    Object? radius = const $CopyWithPlaceholder(),
  }) {
    return GeometryProperty(
      pointType: pointType == const $CopyWithPlaceholder()
          ? _value.pointType
          // ignore: cast_nullable_to_non_nullable
          : pointType as GeometryPropertyType?,
      radius: radius == const $CopyWithPlaceholder()
          ? _value.radius
          // ignore: cast_nullable_to_non_nullable
          : radius as double?,
    );
  }
}

extension $GeometryPropertyCopyWith on GeometryProperty {
  /// Returns a callable class that can be used as follows: `instanceOfGeometryProperty.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$GeometryPropertyCWProxy get copyWith => _$GeometryPropertyCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocGeolocation _$DocGeolocationFromJson(Map<String, dynamic> json) =>
    DocGeolocation(
      type: $enumDecodeNullable(_$GeolocationTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DocGeolocationToJson(DocGeolocation instance) =>
    <String, dynamic>{
      if (_$GeolocationTypeEnumMap[instance.type] case final value?)
        'type': value,
      if (instance.features case final value?) 'features': value,
    };

const _$GeolocationTypeEnumMap = {
  GeolocationType.featureCollection: 'FeatureCollection',
};

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      type: $enumDecodeNullable(_$FeatureTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      properties: json['properties'] == null
          ? null
          : GeometryProperty.fromJson(
              json['properties'] as Map<String, dynamic>),
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      if (_$FeatureTypeEnumMap[instance.type] case final value?) 'type': value,
      if (instance.properties case final value?) 'properties': value,
      if (instance.geometry case final value?) 'geometry': value,
    };

const _$FeatureTypeEnumMap = {
  FeatureType.feature: 'Feature',
};

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      type: $enumDecodeNullable(_$GeometryTypeEnumMap, json['type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      if (_$GeometryTypeEnumMap[instance.type] case final value?) 'type': value,
      if (instance.coordinates case final value?) 'coordinates': value,
    };

const _$GeometryTypeEnumMap = {
  GeometryType.point: 'Point',
  GeometryType.lineString: 'LineString',
  GeometryType.polygon: 'Polygon',
};

GeometryProperty _$GeometryPropertyFromJson(Map<String, dynamic> json) =>
    GeometryProperty(
      pointType: $enumDecodeNullable(
          _$GeometryPropertyTypeEnumMap, json['point_type'],
          unknownValue: JsonKey.nullForUndefinedEnumValue),
      radius: (json['radius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GeometryPropertyToJson(GeometryProperty instance) =>
    <String, dynamic>{
      if (_$GeometryPropertyTypeEnumMap[instance.pointType] case final value?)
        'point_type': value,
      if (instance.radius case final value?) 'radius': value,
    };

const _$GeometryPropertyTypeEnumMap = {
  GeometryPropertyType.circle: 'circle',
  GeometryPropertyType.circleMarker: 'circlemarker',
};
