import 'package:frappe_form/src/presentation/widgets/doc_field_item/base/doc_field_text_field_view.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/src/presentation/utils/validation_utils.dart';

/// Created by luis901101 on 04/23/25.
class DocFieldIntView extends DocFieldTextFieldView {
  DocFieldIntView(
      {super.key,
      super.controller,
      required super.field,
      super.dependsOnController});

  @override
  State createState() => DocFieldIntViewState();
}

class DocFieldIntViewState<SF extends DocFieldIntView>
    extends DocFieldTextFieldViewState<SF> {
  @override
  void initState() {
    super.initState();
    controller.validations.addAll(
        [ValidationUtils.positiveNumberValidation(required: isRequired)]);
  }

  @override
  TextInputType? get keyboardType =>
      const TextInputType.numberWithOptions(signed: false, decimal: false);
  @override
  TextCapitalization? get textCapitalization => TextCapitalization.none;
}
