import 'package:collection/collection.dart';

enum DocFieldDependsOnArithmetic {
  sum('+'),
  subtract('-'),
  multiply('*'),
  divide('/');

  final String name;
  const DocFieldDependsOnArithmetic(this.name);

  static DocFieldDependsOnArithmetic? valueOf(String? name) =>
      DocFieldDependsOnArithmetic.values.firstWhereOrNull(
        (value) => value.name == name,
      );
}
