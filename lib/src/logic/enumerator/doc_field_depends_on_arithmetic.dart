import 'package:collection/collection.dart';

/// Arithmetic operators usable inside a field's computed `dependsOn` expression.
enum DocFieldDependsOnArithmetic {
  /// Addition (`+`).
  sum('+'),

  /// Subtraction (`-`).
  subtract('-'),

  /// Multiplication (`*`).
  multiply('*'),

  /// Division (`/`).
  divide('/');

  /// The operator symbol backing this enum entry.
  final String name;

  /// Creates a [DocFieldDependsOnArithmetic] bound to its operator [name].
  const DocFieldDependsOnArithmetic(this.name);

  /// Returns the operator whose [name] matches [name], or `null` if none.
  static DocFieldDependsOnArithmetic? valueOf(String? name) =>
      DocFieldDependsOnArithmetic.values.firstWhereOrNull(
        (value) => value.name == name,
      );
}
