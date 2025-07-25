// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_rules.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RenderRulesCWProxy {
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// RenderRules(...).copyWith(id: 12, name: "My name")
  /// ````
  RenderRules call({
    String? type,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRenderRules.copyWith(...)`.
class _$RenderRulesCWProxyImpl implements _$RenderRulesCWProxy {
  const _$RenderRulesCWProxyImpl(this._value);

  final RenderRules _value;

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored.
  ///
  /// Usage
  /// ```dart
  /// RenderRules(...).copyWith(id: 12, name: "My name")
  /// ````
  RenderRules call({
    Object? type = const $CopyWithPlaceholder(),
  }) {
    return RenderRules(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
    );
  }
}

extension $RenderRulesCopyWith on RenderRules {
  /// Returns a callable class that can be used as follows: `instanceOfRenderRules.copyWith(...)`.
  // ignore: library_private_types_in_public_api
  _$RenderRulesCWProxy get copyWith => _$RenderRulesCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenderRules _$RenderRulesFromJson(Map<String, dynamic> json) => RenderRules(
      type: json['type'] as String?,
    );

Map<String, dynamic> _$RenderRulesToJson(RenderRules instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
    };
