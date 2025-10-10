import 'package:flutter/foundation.dart';
import 'package:frappe_form/frappe_form.dart';

class DocFieldDependsOnBundle {
  final String fieldName;
  final FieldController controller;
  late final DocFieldDependsOnOperator operator;
  final dynamic expectedAnswer;
  final DocFieldDependsOnBundle? and;
  final DocFieldDependsOnBundle? or;
  final DocFieldDependsOnBundle? sum;
  final DocFieldDependsOnBundle? subtract;
  final DocFieldDependsOnBundle? multiply;
  final DocFieldDependsOnBundle? divide;
  final List<FieldController> dependencyControllers;

  DocFieldDependsOnBundle({
    required this.fieldName,
    required this.controller,
    required this.operator,
    required this.expectedAnswer,
    this.and,
    this.or,
    this.sum,
    this.subtract,
    this.multiply,
    this.divide,
  }) : dependencyControllers = [] {
    dependencyControllers.addAll(_gatherDependencyControllers());
  }

  bool check({
    num? parentSumControllerAnswer,
    num? parentSubtractControllerAnswer,
    num? parentMultiplyControllerAnswer,
    num? parentDivideControllerAnswer,
  }) {
    bool result = true;
    dynamic controllerAnswer;
    if (controller.rawValue is DocGeolocation) {
      controllerAnswer = (controller.rawValue as DocGeolocation).toJsonString();
    } else {
      // Any other possible controller value can be treated as dynamic
      controllerAnswer = controller.rawValue;
    }

    if (controllerAnswer == null && expectedAnswer == null) {
      return false;
    }

    num? controllerAnswerAsNum = NumUtils.tryParse(
      controllerAnswer?.toString(),
    );

    if (controllerAnswerAsNum != null) {
      controllerAnswerAsNum += parentSumControllerAnswer ?? 0;
      controllerAnswerAsNum = parentSubtractControllerAnswer == null
          ? controllerAnswerAsNum
          : (parentSubtractControllerAnswer - controllerAnswerAsNum);
      controllerAnswerAsNum *= parentMultiplyControllerAnswer ?? 1;
      controllerAnswerAsNum = parentDivideControllerAnswer == null
          ? controllerAnswerAsNum
          : (parentDivideControllerAnswer / controllerAnswerAsNum);
    }

    num? expectedValueAsNum = NumUtils.tryParse(expectedAnswer?.toString());

    result = switch (operator) {
      DocFieldDependsOnOperator.equals =>
        controllerAnswerAsNum != null && expectedValueAsNum != null
            ? controllerAnswerAsNum == expectedValueAsNum
            : controllerAnswer?.toString() == expectedAnswer?.toString(),
      DocFieldDependsOnOperator.notEquals =>
        controllerAnswerAsNum != null && expectedValueAsNum != null
            ? controllerAnswerAsNum != expectedValueAsNum
            : controllerAnswer?.toString() != expectedAnswer?.toString(),
      DocFieldDependsOnOperator.greaterThan =>
        controllerAnswerAsNum == null || expectedValueAsNum == null
            ? false
            : controllerAnswerAsNum > expectedValueAsNum,
      DocFieldDependsOnOperator.lessThan =>
        controllerAnswerAsNum == null || expectedValueAsNum == null
            ? false
            : controllerAnswerAsNum < expectedValueAsNum,
      DocFieldDependsOnOperator.greaterOrEquals =>
        controllerAnswerAsNum == null || expectedValueAsNum == null
            ? false
            : controllerAnswerAsNum >= expectedValueAsNum,
      DocFieldDependsOnOperator.lessOrEquals =>
        controllerAnswerAsNum == null || expectedValueAsNum == null
            ? false
            : controllerAnswerAsNum <= expectedValueAsNum,
      DocFieldDependsOnOperator.none => result,
    };
    if (and != null) {
      result = result && and!.check();
    }
    if (or != null) {
      result = result || or!.check();
    }
    if (sum != null) {
      result =
          result &&
          sum!.check(parentSumControllerAnswer: controllerAnswerAsNum);
    }
    if (subtract != null) {
      result =
          result &&
          subtract!.check(
            parentSubtractControllerAnswer: controllerAnswerAsNum,
          );
    }
    if (multiply != null) {
      result =
          result &&
          multiply!.check(
            parentMultiplyControllerAnswer: controllerAnswerAsNum,
          );
    }
    if (divide != null) {
      result =
          result &&
          divide!.check(parentDivideControllerAnswer: controllerAnswerAsNum);
    }
    return result;
  }

  void addListener(VoidCallback listener) {
    for (final controller in dependencyControllers) {
      controller.addListener(listener);
    }
  }

  void removeListener(VoidCallback listener) {
    for (final controller in dependencyControllers) {
      controller.removeListener(listener);
    }
  }

  List<FieldController> _gatherDependencyControllers() => [
    controller,
    ...?and?._gatherDependencyControllers(),
    ...?or?._gatherDependencyControllers(),
    ...?sum?._gatherDependencyControllers(),
    ...?subtract?._gatherDependencyControllers(),
    ...?multiply?._gatherDependencyControllers(),
    ...?divide?._gatherDependencyControllers(),
  ];

  DocFieldDependsOnBundle withCondition({
    required DocFieldDependsOnCondition condition,
    required DocFieldDependsOnBundle? value,
  }) {
    DocFieldDependsOnBundle? and = this.and;
    DocFieldDependsOnBundle? or = this.or;
    switch (condition) {
      case DocFieldDependsOnCondition.and:
        and = and?.withCondition(condition: condition, value: value) ?? value;
        break;
      case DocFieldDependsOnCondition.or:
        or = or?.withCondition(condition: condition, value: value) ?? value;
        break;
    }

    return DocFieldDependsOnBundle(
      fieldName: fieldName,
      controller: controller,
      operator: operator,
      expectedAnswer: expectedAnswer,
      and: and,
      or: or,
    );
  }

  DocFieldDependsOnBundle withArithmetic({
    required DocFieldDependsOnArithmetic arithmetic,
    required DocFieldDependsOnBundle? value,
  }) {
    DocFieldDependsOnBundle? sum = this.sum;
    DocFieldDependsOnBundle? subtract = this.subtract;
    DocFieldDependsOnBundle? multiply = this.multiply;
    DocFieldDependsOnBundle? divide = this.divide;
    switch (arithmetic) {
      case DocFieldDependsOnArithmetic.sum:
        sum =
            sum?.withArithmetic(arithmetic: arithmetic, value: value) ?? value;
        break;
      case DocFieldDependsOnArithmetic.subtract:
        subtract =
            subtract?.withArithmetic(arithmetic: arithmetic, value: value) ??
            value;
        break;
      case DocFieldDependsOnArithmetic.multiply:
        multiply =
            multiply?.withArithmetic(arithmetic: arithmetic, value: value) ??
            value;
        break;
      case DocFieldDependsOnArithmetic.divide:
        divide =
            divide?.withArithmetic(arithmetic: arithmetic, value: value) ??
            value;
        break;
    }

    return DocFieldDependsOnBundle(
      fieldName: fieldName,
      controller: controller,
      operator: operator,
      expectedAnswer: expectedAnswer,
      sum: sum,
      subtract: subtract,
      multiply: multiply,
      divide: divide,
    );
  }

  static DocFieldDependsOnBundle? fromExpression(
    String? expression,
    List<DocFieldBundle> itemBundles,
  ) {
    if (expression == null || expression.isEmpty) return null;
    try {
      final dependsOnParts = expression.split('eval:');
      if (dependsOnParts.length <= 1) return null;
      final evalExpression = dependsOnParts[1];
      return _analyzeExpression(evalExpression, itemBundles);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  static DocFieldDependsOnBundle? _analyzeExpression(
    String expression,
    List<DocFieldBundle> itemBundles,
  ) {
    DocFieldDependsOnBundle? field;
    for (final condition in DocFieldDependsOnCondition.values) {
      final conditionExpression = expression.split(condition.name);
      if (conditionExpression.length > 1) {
        DocFieldDependsOnBundle? field1;
        for (int i = 0; i < conditionExpression.length; ++i) {
          String conditionExpressionPart1 = conditionExpression[i].trim();
          field1 = _analyzeExpression(conditionExpressionPart1, itemBundles);
          if (i + 1 < conditionExpression.length) {
            ++i;
            String conditionExpressionPart2 = conditionExpression[i].trim();
            DocFieldDependsOnBundle? field2 = _analyzeExpression(
              conditionExpressionPart2,
              itemBundles,
            );
            if (field2 != null) {
              field1 =
                  field1?.withCondition(condition: condition, value: field2) ??
                  field2;
            }
          }
          if (field == null) {
            field = field1;
          } else {
            field = field.withCondition(condition: condition, value: field1);
          }
        }
      }
    }

    for (final arithmetic in DocFieldDependsOnArithmetic.values) {
      final arithmeticExpression = expression.split(arithmetic.name);
      if (arithmeticExpression.length > 1) {
        DocFieldDependsOnBundle? field1;
        for (int i = 0; i < arithmeticExpression.length; ++i) {
          String arithmeticExpressionPart1 = arithmeticExpression[i].trim();
          field1 = _analyzeExpression(arithmeticExpressionPart1, itemBundles);
          if (i + 1 < arithmeticExpression.length) {
            ++i;
            String conditionExpressionPart2 = arithmeticExpression[i].trim();
            DocFieldDependsOnBundle? field2 = _analyzeExpression(
              conditionExpressionPart2,
              itemBundles,
            );
            if (field2 != null) {
              field1 =
                  field1?.withArithmetic(
                    arithmetic: arithmetic,
                    value: field2,
                  ) ??
                  field2;
            }
          }
          if (field == null) {
            field = field1;
          } else {
            field = field.withArithmetic(arithmetic: arithmetic, value: field1);
          }
        }
      }
    }

    return field ??= _fromSimpleExpression(expression, itemBundles);
  }

  static DocFieldDependsOnBundle? _fromSimpleExpression(
    String? expression,
    List<DocFieldBundle> itemBundles,
  ) {
    if (expression == null || expression.isEmpty) return null;
    for (final operator in DocFieldDependsOnOperator.values) {
      final operatorParts = expression.split(operator.name);
      if (operatorParts.length == 2) {
        final fieldName = operatorParts[0].trim().replaceAll('doc.', '');
        if (fieldName.isEmpty) return null;
        String expectedAnswer = operatorParts[1]
            .trim()
            .replaceAll('\'', '')
            .replaceAll('"', '');
        if (expectedAnswer.isEmpty) return null;
        final itemBundle = _findBundle(fieldName, itemBundles);
        return itemBundle == null
            ? null
            : DocFieldDependsOnBundle(
                fieldName: fieldName,
                controller: itemBundle.controller,
                operator: operator,
                expectedAnswer: expectedAnswer,
              );
      }
    }
    final fieldName = expression.trim().replaceAll('doc.', '');
    final itemBundle = _findBundle(fieldName, itemBundles);
    return itemBundle == null
        ? null
        : DocFieldDependsOnBundle(
            fieldName: fieldName,
            controller: itemBundle.controller,
            operator: DocFieldDependsOnOperator.none,
            expectedAnswer: null,
          );
  }

  static DocFieldBundle? _findBundle(
    String fieldName,
    List<DocFieldBundle> itemBundles,
  ) {
    for (final item in itemBundles) {
      if (item.field.fieldName == fieldName) {
        return item;
      }
      DocFieldBundle? result = _findBundle(fieldName, [
        ...item.children,
        ...item.view.childrenBundles,
      ]);
      if (result != null) return result;
    }
    return null;
  }
}
