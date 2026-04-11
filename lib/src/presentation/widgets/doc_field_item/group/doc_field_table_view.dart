import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/material.dart';

class DocFieldTableView extends DocFieldView {
  final Future<List<Map<String, dynamic>>> Function(String, DocField)?
      fetchSuggestions;
  final String baseUrl;
  final Future<Attachment?> Function()? onAttachmentLoaded;

  DocFieldTableView({
    super.key,
    required super.field,
    super.children,
    super.childrenBundles,
    super.dependsOnController,
    this.fetchSuggestions,
    required this.baseUrl,
    this.onAttachmentLoaded,
  }) : super(controller: CustomTextEditingController());

  @override
  State createState() => DocFieldTableViewState();
}

class DocFieldTableViewState<SF extends DocFieldTableView>
    extends DocFieldViewState<SF> {
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  late final DocFormController docFormController;
  late final ScrollController scrollController;
  final itemCountNotifier = ValueNotifier<int>(0);
  double removeButtonOffset = 12.0;
  bool _hasLoadedInitialRows = false;

  @override
  void initState() {
    super.initState();
    initFormController();
    scrollController = ScrollController();
    itemCountNotifier.value = childrenBundles.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialRows();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void initFormController() {
    docFormController = DocFormController();
  }

  /// Load initial rows from field.defaultValue (the "default" array in JSON)
  Future<void> _loadInitialRows() async {
    if (_hasLoadedInitialRows) return;
    _hasLoadedInitialRows = true;

    // field.defaultValue maps to the "default" key in your JSON
    // which contains: [{uom: "Nos", conversion_factor: 1}, {uom: "Box", conversion_factor: 2}]
    final defaultData = field.initial;

    if (defaultData is List && defaultData.isNotEmpty) {
      // Create ONE separate independent form for EACH item in the default list
      for (final rowData in defaultData) {
        if (rowData is Map<String, dynamic>) {
          await _addRowWithData(Map<String, dynamic>.from(rowData));
        }
      }
    } else {
      // No default data → add one empty row
      await onAdd();
    }
  }

  /// Builds ONE row form with pre-filled data from [rowData]
  /// Each call is completely independent
  Future<void> _addRowWithData(Map<String, dynamic> rowData) async {
    if (field.childForm == null) return;

    // Create a fresh child form with initial values injected per field
    final DocForm mergedChildForm = _buildMergedChildForm(
      field.childForm!,
      rowData,
    );

    // Build this row's fields independently
    final List<DocFieldBundle> builtBundles =
        await docFormController.buildFormFields(
      mergedChildForm,
      fetchSuggestions: widget.fetchSuggestions != null
          ? (pattern, docField) =>
              widget.fetchSuggestions!(pattern, docField)
          : null,
      baseUrl: widget.baseUrl,
      onAttachmentLoaded: widget.onAttachmentLoaded,
    );

    // The first bundle is the parent wrapper; its children are the actual row fields
    final DocFieldBundle? parentBundle = builtBundles.firstOrNull;
    final List<DocFieldBundle> rowBundles = parentBundle?.children ?? [];

    if (rowBundles.isNotEmpty) {
      setState(() {
        childrenBundles.addAll(rowBundles);
        itemCountNotifier.value = childrenBundles.length;
      });
      controller.text =
          '${(int.tryParse(controller.text) ?? 0) + 1}';
    }
  }

  /// Creates a NEW [DocForm] instance where each field has its initial
  /// value set from [rowData].
  ///
  /// Example rowData: {uom: "Nos", conversion_factor: 1}
  /// This will set field "uom" initial → "Nos" and
  /// field "conversion_factor" initial → 1
  DocForm _buildMergedChildForm(
    DocForm childForm,
    Map<String, dynamic> rowData,
  ) {
    final List<DocField> mergedFields = childForm.fields.map((docField) {
      final String? fieldName = docField.fieldName;

      if (fieldName != null && rowData.containsKey(fieldName)) {
        // Inject the value from rowData as the initial value for this field
        return docField.copyWith(
          initial: rowData[fieldName],
        );
      }

      // No matching key in rowData → keep field as-is but still copy
      // to ensure each row gets its own independent field instance
      return docField.copyWith();
    }).toList();

    return childForm.copyWith(fields: mergedFields);
  }

  Widget gridItemView(BuildContext context, int index, double width) {
    if (index >= childrenBundles.length) return const SizedBox.shrink();

    final childView = childrenBundles[index].view;
    return SizedBox(
      width: width,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.only(
              top: removeButtonOffset,
              right: 4,
              left: 4,
              bottom: 4,
            ),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: childView,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: removeButton(index),
          ),
        ],
      ),
    );
  }

  Widget getGridView(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final bool isMobile = totalWidth < 600;
        final double itemWidth =
            isMobile ? totalWidth : totalWidth / 2;

        return Wrap(
          children: List.generate(
            childrenBundles.length,
            (index) => gridItemView(context, index, itemWidth),
          ),
        );
      },
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (childrenBundles.isEmpty)
          const Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(),
          )
        else ...[
          getGridView(context),
          totalCountIndicator,
        ],
        if (field.childForm != null) addButton,
      ],
    );
  }

  Widget get totalCountIndicator => Padding(
        padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
        child: ValueListenableBuilder<int>(
          valueListenable: itemCountNotifier,
          builder: (context, value, child) => Text(
            'Total Items: $value',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      );

  Widget removeButton(int index) => Material(
        shape: const CircleBorder(),
        color: theme.colorScheme.error,
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onRemove(index),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ),
      );

  Widget get addButton => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        child: Center(
          child: TextButton.icon(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              backgroundColor:
                  theme.colorScheme.primary.withOpacity(0.1),
            ),
            label: const Text("Add Row"),
            icon: const Icon(Icons.add, size: 18),
          ),
        ),
      );

  Future<void> onRemove(int index) async {
    if (index >= 0 && index < childrenBundles.length) {
      setState(() {
        childrenBundles.removeAt(index);
        itemCountNotifier.value = childrenBundles.length;
      });
      final int value = (int.tryParse(controller.text) ?? 0) - 1;
      controller.text = '${value > 0 ? value : ''}';
    }
  }

  /// Add a new empty row using the original child_table structure
  Future<void> onAdd() async {
    if (field.childForm == null) return;

    // Pass the original childForm with NO initial values → empty row
    final List<DocFieldBundle> builtBundles =
        await docFormController.buildFormFields(
      field.childForm!,
      fetchSuggestions: widget.fetchSuggestions != null
          ? (pattern, docField) =>
              widget.fetchSuggestions!(pattern, docField)
          : null,
      baseUrl: widget.baseUrl,
      onAttachmentLoaded: widget.onAttachmentLoaded,
    );

    final DocFieldBundle? parentBundle = builtBundles.firstOrNull;
    final List<DocFieldBundle> rowBundles = parentBundle?.children ?? [];

    if (rowBundles.isNotEmpty) {
      setState(() {
        childrenBundles.addAll(rowBundles);
        itemCountNotifier.value = childrenBundles.length;
      });
      controller.text =
          '${(int.tryParse(controller.text) ?? 0) + 1}';
    }
  }
}