import 'package:collection/collection.dart';

/// Logical connectors used to chain `dependsOn` conditions together.
enum DocFieldDependsOnCondition {
  /// Logical AND (`&&`): every linked condition must hold.
  and('&&'),

  /// Logical OR (`||`): any linked condition may hold.
  or('||');

  /// The connector symbol backing this enum entry.
  final String name;

  /// Creates a [DocFieldDependsOnCondition] bound to its symbol [name].
  const DocFieldDependsOnCondition(this.name);

  /// Returns the connector whose [name] matches [name], or `null` if none.
  static DocFieldDependsOnCondition? valueOf(String? name) =>
      DocFieldDependsOnCondition.values.firstWhereOrNull(
        (value) => value.name == name,
      );
}
