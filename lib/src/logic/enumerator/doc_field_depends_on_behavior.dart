import 'package:collection/collection.dart';

/// Controls how multiple `dependsOn` criteria combine when deciding whether a
/// field should be shown or enabled.
enum DocFieldDependsOnBehavior {
  /// Enable the question when all the dependsOn criteria are satisfied.
  all,

  /// Enable the question when any of the dependsOn criteria are satisfied.
  any;

  /// The behavior applied when none is explicitly configured.
  static const defaultValue = any;

  /// Whether this behavior uses "any" (logical OR) combination.
  bool get isAny => this == any;

  /// The seed value to fold criteria results into: `true` for [all], `false`
  /// for [any].
  bool init() => this == all;

  /// Folds [newValue] into the running [currentValue] using OR for [any] and
  /// AND for [all].
  bool check(bool currentValue, bool newValue) =>
      isAny ? currentValue || newValue : currentValue && newValue;

  /// Returns the behavior whose name matches [name], or `null` if none.
  static DocFieldDependsOnBehavior? valueOf(String? name) =>
      DocFieldDependsOnBehavior.values.firstWhereOrNull(
        (value) => value.name == name,
      );
}
