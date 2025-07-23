import 'package:flutter/foundation.dart';
import 'package:frappe_form/frappe_form.dart';

class DocFormController {
  /// Allows to override the function to generate individual field answer,
  /// either to generate a new [DocFieldAnswer] or modify the generated one
  Future<DocFieldAnswer?> Function(
    DocFieldBundle fieldBundle,
    dynamic fieldValue,
  )? onGenerateFieldAnswer;

  /// Allows customizing the logic that maps [DocField] objects into
  /// [DocFieldView] widgets.
  ///
  /// [dependsOnController] needs to be passed to the returned [DocFieldView]
  /// otherwise the dependsOn functionality for that DocField will not work.
  /// assuming that form item has dependsOn values
  Future<DocFieldView?> Function(
    DocField field,
    Future<Attachment?> Function()? onAttachmentLoaded,
  )? onBuildFieldView;

  final DocFieldGroupController docFieldGroupController;
  DocFormController({
    this.docFieldGroupController = const DocFieldGroupController(),
    this.onGenerateFieldAnswer,
    this.onBuildFieldView,
  });

  Future<List<DocFieldBundle>> buildFormFields(
    DocForm form, {
    Future<Attachment?> Function()? onAttachmentLoaded,
  }) async {
    List<DocFieldBundle> fieldBundles = [];
    try {
      List<DocField> fieldGroups = docFieldGroupController.generateGroups(form);
      fieldBundles = await buildFormFieldBundles(
        fields: fieldGroups,
        onAttachmentLoaded: onAttachmentLoaded,
      );
      handleDependsOnLogic(fieldBundles: fieldBundles);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return fieldBundles;
  }

  void handleDependsOnLogic({required List<DocFieldBundle> fieldBundles}) {
    for (final fieldBundle in fieldBundles) {
      handleDependsOnLogicRecursively(
          fieldBundle: fieldBundle, fieldBundles: fieldBundles);
    }
  }

  void handleDependsOnLogicRecursively(
      {required DocFieldBundle fieldBundle,
      required List<DocFieldBundle> fieldBundles}) {
    fieldBundle.view.dependsOnController.requiredDependsOn =
        DocFieldDependsOnBundle.fromExpression(
            fieldBundle.field.requiredDependsOn, fieldBundles);
    fieldBundle.view.dependsOnController.readOnlyDependsOn =
        DocFieldDependsOnBundle.fromExpression(
            fieldBundle.field.readOnlyDependsOn, fieldBundles);
    fieldBundle.view.dependsOnController.visibilityDependsOn =
        DocFieldDependsOnBundle.fromExpression(
            fieldBundle.field.visibilityDependsOn, fieldBundles);
    for (final fieldChild in fieldBundle.children) {
      handleDependsOnLogicRecursively(
          fieldBundle: fieldChild, fieldBundles: fieldBundles);
    }
    for (final fieldChild in fieldBundle.view.childrenBundles) {
      handleDependsOnLogicRecursively(
          fieldBundle: fieldChild, fieldBundles: fieldBundles);
    }
  }

  Future<List<DocFieldBundle>> buildFormFieldBundles({
    required List<DocField> fields,
    required Future<Attachment?> Function()? onAttachmentLoaded,
    String? groupId,
    List<DocFieldBundle>? alreadyBuiltFieldBundles,
  }) async {
    List<DocFieldBundle> fieldBundles = [];
    try {
      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];

        final fieldBundle = await buildFormFieldBundle(
          field: field,
          onAttachmentLoaded: onAttachmentLoaded,
          groupId: groupId,
          alreadyBuiltItemBundles: [
            ...(alreadyBuiltFieldBundles ?? []),
            ...fieldBundles,
          ],
        );
        if (fieldBundle != null) {
          fieldBundles.add(fieldBundle);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return fieldBundles;
  }

  Future<DocFieldBundle?> buildFormFieldBundle({
    required DocField field,
    Future<Attachment?> Function()? onAttachmentLoaded,
    String? groupId,
    List<DocFieldBundle>? alreadyBuiltItemBundles,
  }) async {
    DocFieldView? fieldView;
    List<DocFieldBundle>? children;
    final fieldType = field.type;

    final groupIdForChildren =
        '${groupId != null ? "$groupId/" : ""}${field.fieldName}';

    children = await buildFormFieldBundles(
      fields: field.children,
      onAttachmentLoaded: onAttachmentLoaded,
      groupId: groupIdForChildren,
      alreadyBuiltFieldBundles: alreadyBuiltItemBundles,
    );

    fieldView = await onBuildFieldView?.call(
      field,
      onAttachmentLoaded,
    );

    if (fieldView == null) {
      switch (fieldType) {
        case FieldType.data:
          fieldView = DocFieldDataView(
            field: field,
          );
          break;
        case FieldType.text:
          fieldView = DocFieldTextView(
            field: field,
          );
          break;
        case FieldType.smallText:
          fieldView = DocFieldSmallTextView(
            field: field,
          );
          break;
        case FieldType.longText:
          fieldView = DocFieldLongTextView(
            field: field,
          );
          break;
        case FieldType.textEditor:
          fieldView = DocFieldTextEditorView(
            field: field,
          );
          break;
        case FieldType.markdownEditor:
          fieldView = DocFieldMarkdownEditorView(
            field: field,
          );
          break;
        case FieldType.int:
          fieldView = DocFieldIntView(
            field: field,
          );
          break;
        case FieldType.float:
          fieldView = DocFieldFloatView(
            field: field,
          );
          break;
        case FieldType.percent:
          fieldView = DocFieldPercentView(
            field: field,
          );
          break;
        case FieldType.currency:
          fieldView = DocFieldCurrencyView(
            field: field,
          );
          break;
        case FieldType.check:
          fieldView = DocFieldCheckView(
            field: field,
          );
          break;
        case FieldType.select:
          fieldView = DocFieldSelectView(
            field: field,
          );
          break;
        case FieldType.autocomplete:
          fieldView = DocFieldAutocompleteView(
            field: field,
          );
          break;
        case FieldType.phone:
          fieldView = DocFieldPhoneView(
            field: field,
          );
          break;
        case FieldType.password:
          fieldView = DocFieldPasswordView(
            field: field,
          );
          break;
        case FieldType.geolocation:
          fieldView = DocFieldGeolocationView(
            field: field,
          );
          break;
        case FieldType.date:
        case FieldType.time:
        case FieldType.dateTime:
          fieldView = DocFieldDateTimeView(
            field: field,
            type: DateTimeType.fromFieldType(fieldType),
          );
          break;
        case FieldType.attach:
        case FieldType.attachImage:
          fieldView = DocFieldAttachmentView(
            field: field,
            onAttachmentLoaded: onAttachmentLoaded,
          );
          break;
        case FieldType.heading:
          fieldView = DocFieldHeadingView(
            field: field,
          );
          break;
        case FieldType.tabBreak:
          fieldView = DocFieldTabView(
            field: field,
            children: children.map((itemBundle) => itemBundle.view).toList(),
          );
          break;
        case FieldType.columnBreak:
          fieldView = DocFieldColumnView(
            field: field,
            children: children.map((itemBundle) => itemBundle.view).toList(),
          );
          break;
        case FieldType.sectionBreak:
          List<DocFieldView> finalChildrenViews = [];
          List<DocFieldView> childrenViews =
              children.map((itemBundle) => itemBundle.view).toList();
          // This logic is to group consecutive check views so they can be displayed as a list with some padding.
          for (int i = 0; i < childrenViews.length; i++) {
            DocFieldView fieldView = childrenViews[i];
            if (fieldView is DocFieldCheckView) {
              List<DocFieldView> checkListView = [];
              checkListView.add(fieldView);
              while (++i < childrenViews.length) {
                if ((fieldView = childrenViews[i]) is DocFieldCheckView) {
                  checkListView.add(fieldView);
                } else {
                  finalChildrenViews.add(
                    DocFieldCheckListView(
                      field: DocField.dummy(),
                      children: checkListView,
                    ),
                  );
                  i--;
                  break;
                }
              }
            } else {
              finalChildrenViews.add(fieldView);
            }
          }
          fieldView = DocFieldSectionView(
            field: field,
            children: finalChildrenViews,
          );
          break;
        case FieldType.rating:
          fieldView = DocFieldRatingView(
            field: field,
          );
          break;
        case FieldType.table:
          fieldView = DocFieldTableView(
            field: field,
          );
          break;
        //TODO: pending implementation
        case FieldType.link:
        case FieldType.dynamicLink:
        case FieldType.barcode:
        case FieldType.button:
        case FieldType.code:
        case FieldType.color:
        case FieldType.html:
        case FieldType.image:
        case FieldType.readOnly:
        case FieldType.signature:
        case FieldType.tableMultiSelect:
        case FieldType.duration:
        case FieldType.htmlEditor:
        case FieldType.icon:
        case FieldType.json:
        case FieldType.unknown:
          break;
        // case FieldType.quantity:
        //   itemView = DocFieldQuantityView(
        //     item: item,
        //   );
        //   break;
        // case FieldType.boolean:
        //   fieldView = DocFieldBooleanView(
        //     field: field,
        //   );
        //   break;
        // case FieldType.checkOpen:
        //   fieldView = DocFieldCheckOpenView(
        //     field: field,
        //   );
        //   break;
        // case FieldType.radioOpen:
        //   fieldView = DocFieldRadioOpenView(
        //     field: field,
        //   );
        //   break;
        // case FieldType.selectOpen:
        //   fieldView = DocFieldSelectOpenView(
        //     field: field,
        //   );
        //   break;
        // case FieldType.url:
        //   fieldView = DocFieldUrlView(
        //     field: field,
        //   );
        //   break;
      }
    }

    return fieldView != null
        ? DocFieldBundle(
            field: field,
            view: fieldView,
            children: children,
            controller: fieldView.controller,
            groupId: groupId,
          )
        : null;
  }

  Future<Map<String, dynamic>> generateResponse({
    required DocForm form,
    required List<DocFieldBundle> itemBundles,
  }) async {
    List<DocFieldAnswer> fieldAnswers = await generateFieldAnswers(
      fieldBundles: itemBundles,
    );

    Map<String, dynamic> response = form.toAnswerMap();

    for (final fieldAnswer in fieldAnswers) {
      response.addAll(fieldAnswer.toAnswerMap());
    }

    return response;
  }

  Future<List<DocFieldAnswer>> generateFieldAnswers({
    required List<DocFieldBundle> fieldBundles,
  }) async {
    List<DocFieldAnswer> fieldAnswers = [];
    for (final fieldBundle in fieldBundles) {
      if (fieldBundle.field.type == FieldType.table) {
        final tableFieldAnswer = await generateTableFieldAnswer(
          fieldBundle: fieldBundle,
        );
        if (tableFieldAnswer != null) {
          fieldAnswers.add(tableFieldAnswer);
        }
      } else {
        final fieldAnswer = await generateFieldAnswer(fieldBundle);
        if (fieldAnswer != null) {
          fieldAnswers.add(fieldAnswer);
        }
        fieldAnswers.addAll(
          await generateFieldAnswers(fieldBundles: fieldBundle.children),
        );
      }
    }

    return fieldAnswers;
  }

  Future<DocFieldAnswer?> generateTableFieldAnswer({
    required DocFieldBundle fieldBundle,
  }) async {
    if (fieldBundle.field.type != FieldType.table) {
      return generateFieldAnswer(fieldBundle);
    }
    List<List<DocFieldAnswer>> fieldAnswersLists = [];
    for (final fieldBundle in fieldBundle.view.childrenBundles) {
      List<DocFieldAnswer> fieldAnswers = await generateFieldAnswers(
        fieldBundles: [fieldBundle],
      );
      if (fieldAnswers.isNotEmpty) {
        fieldAnswersLists.add(fieldAnswers);
      }
    }

    return DocFieldAnswer(
      type: fieldBundle.field.type,
      name: fieldBundle.field.fieldName,
      value: fieldAnswersLists,
    );
  }

  Future<DocFieldAnswer?> generateFieldAnswer(
    DocFieldBundle fieldBundle,
  ) async {
    final fieldType = fieldBundle.field.type;

    dynamic fieldValue = switch (fieldType) {
      // Excluding these types as they are not part of the response
      FieldType.tabBreak ||
      FieldType.columnBreak ||
      FieldType.sectionBreak =>
        null,
      FieldType.data ||
      FieldType.text ||
      FieldType.smallText ||
      FieldType.longText ||
      FieldType.textEditor ||
      FieldType.markdownEditor ||
      FieldType.select ||
      FieldType.geolocation ||
      FieldType.autocomplete ||
      FieldType.phone ||
      FieldType.attach ||
      FieldType.attachImage ||
      FieldType.password =>
        fieldBundle.controller.rawValue?.toString(),
      FieldType.check => fieldBundle.controller.rawValue?.toString().asInt,
      FieldType.date =>
        (fieldBundle.controller.rawValue as DateTime?)?.toJsonDate(),
      FieldType.time =>
        (fieldBundle.controller.rawValue as DateTime?)?.toJsonTime(),
      FieldType.dateTime =>
        (fieldBundle.controller.rawValue as DateTime?)?.toJsonDateTime(),
      FieldType.int => fieldBundle.controller.rawValue?.toString().asInt,
      FieldType.float ||
      FieldType.percent ||
      FieldType.currency ||
      FieldType.rating =>
        fieldBundle.controller.rawValue?.toString().asDouble,
      FieldType.heading => null,
      //TODO: pending implementation
      FieldType.link => null,
      FieldType.dynamicLink => null,
      FieldType.table => null,
      FieldType.barcode => null,
      FieldType.button => null,
      FieldType.code => null,
      FieldType.color => null,
      FieldType.html => null,
      FieldType.image => null,
      FieldType.readOnly => null,
      FieldType.signature => null,
      FieldType.tableMultiSelect => null,
      FieldType.duration => null,
      FieldType.htmlEditor => null,
      FieldType.icon => null,
      FieldType.json => null,
      FieldType.unknown => null,
    };

    DocFieldAnswer fieldAnswer =
        await onGenerateFieldAnswer?.call(fieldBundle, fieldValue) ??
            DocFieldAnswer(
              type: fieldType,
              name: fieldBundle.field.fieldName,
              value: fieldValue,
            );

    return fieldAnswer;
  }
}
