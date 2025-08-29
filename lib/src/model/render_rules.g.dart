// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'render_rules.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

/// This Extension on [RenderRules] is to generate the code for a copyWith(...) function.
extension $RenderRulesCopyWithExtension on RenderRules {
  RenderRules copyWith({String? type}) {
    return RenderRules(type: type ?? this.type);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RenderRules _$RenderRulesFromJson(Map<String, dynamic> json) =>
    RenderRules(type: json['type'] as String?);

Map<String, dynamic> _$RenderRulesToJson(RenderRules instance) =>
    <String, dynamic>{'type': ?instance.type};
