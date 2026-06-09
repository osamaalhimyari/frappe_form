import 'package:collection/collection.dart';

/// Comparison operators evaluated when resolving a field's `dependsOn` rule
/// against the current answer.
enum DocFieldDependsOnOperator {
  /// True if whether at least one answer has a value that is equal to the dependsOn answer.
  equals('=='),

  /// True if whether at least no answer has a value that is equal to the dependsOn answer.
  notEquals('!='),

  /// True if whether at least no answer has a value that is greater or equal to the dependsOn answer.
  greaterOrEquals('>='),

  /// True if whether at least no answer has a value that is less or equal to the dependsOn answer.
  lessOrEquals('<='),

  /// True if whether at least no answer has a value that is greater than the dependsOn answer.
  greaterThan('>'),

  /// True if whether at least no answer has a value that is less than the dependsOn answer.
  lessThan('<'),

  /// No comparison; the rule is always considered unmatched.
  none('');

  /// The operator symbol backing this enum entry.
  final String name;

  /// Creates a [DocFieldDependsOnOperator] bound to its symbol [name].
  const DocFieldDependsOnOperator(this.name);

  /// Returns the operator whose [name] matches [name], or `null` if none.
  static DocFieldDependsOnOperator? valueOf(String? name) =>
      DocFieldDependsOnOperator.values.firstWhereOrNull(
        (value) => value.name == name,
      );
}
