import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

/// Created by luis901101 on 04/23/25.
class DocFieldColumnView extends DocFieldView {
  DocFieldColumnView({
    super.key,
    required super.field,
    super.children,
    super.dependsOnController,
  }) : super(controller: DummyController());

  @override
  State createState() => DocFieldColumnViewState();
}

class DocFieldColumnViewState extends DocFieldViewState<DocFieldColumnView> {
  @override
  Widget? buildTitleView(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children!.map((itemView) => itemView).toList(),
    );
  }
}
