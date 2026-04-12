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

  // 🔥 FIX: Local snapshot of bundles so parent rebuilds don't overwrite
  // user edits (removals/additions) when switching tabs.
  late List<DocFieldBundle> _localBundles;

  // Prevents duplicate loading on rebuild/scroll
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Snapshot the bundles ONCE from the widget at construction time.
    // All mutations (add/remove) happen on _localBundles only.
    _localBundles = List.from(widget.childrenBundles);

    initFormController();
    scrollController = ScrollController();
    itemCountNotifier.value = _localBundles.length;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialRows();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    itemCountNotifier.dispose();
    super.dispose();
  }

  void initFormController() {
    docFormController = DocFormController();
  }

  /// Idempotent initialization — runs exactly ONCE per State lifetime.
  /// Uses _localBundles so user removals are never overwritten.
  Future<void> _loadInitialRows() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // If bundles already exist (restored state or user edited), trust them.
    // Do NOT re-load from field.initial — user may have removed rows.
    if (_localBundles.isNotEmpty) {
      itemCountNotifier.value = _localBundles.length;
      return;
    }

    final defaultData = field.initial;

    if (defaultData is List && defaultData.isNotEmpty) {
      final List<DocFieldBundle> newBundles = [];

      for (final rowData in defaultData) {
        if (rowData is Map<String, dynamic>) {
          final rowBundles = await _buildRowBundles(rowData);
          newBundles.addAll(rowBundles);
        }
      }

      if (newBundles.isNotEmpty) {
        setState(() {
          _localBundles.clear();
          _localBundles.addAll(newBundles);
          itemCountNotifier.value = _localBundles.length;
        });
      }
    } else {
      await onAdd();
    }
  }

  /// Helper: Builds bundles for a single row from data
  Future<List<DocFieldBundle>> _buildRowBundles(
      Map<String, dynamic> rowData) async {
    if (field.childForm == null) return [];

    final DocForm mergedChildForm = _buildMergedChildForm(
      field.childForm!,
      rowData,
    );

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

    final DocFieldBundle? parentBundle = builtBundles.firstOrNull;
    return parentBundle?.children ?? [];
  }

  /// Merges child form schema with row data to set initial values
  DocForm _buildMergedChildForm(
    DocForm childForm,
    Map<String, dynamic> rowData,
  ) {
    final List<DocField> mergedFields = childForm.fields.map((docField) {
      final String? fieldName = docField.fieldName;

      if (fieldName != null && rowData.containsKey(fieldName)) {
        return docField.copyWith(
          initial: rowData[fieldName],
        );
      }

      return docField.copyWith();
    }).toList();

    return childForm.copyWith(fields: mergedFields);
  }

  Widget gridItemView(BuildContext context, int index, double width) {
    if (index >= _localBundles.length) return const SizedBox.shrink();

    final childView = _localBundles[index].view;

    // Unique key per row to prevent state reuse during scroll
    final Key rowKey = ValueKey('row_$index');

    return SizedBox(
      key: rowKey,
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
        final double itemWidth = isMobile ? totalWidth : totalWidth / 2;

        return Wrap(
          children: List.generate(
            _localBundles.length,
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
        if (_localBundles.isEmpty)
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
        color: Theme.of(context).colorScheme.error,
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
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
            label: const Text("Add Row"),
            icon: const Icon(Icons.add, size: 18),
          ),
        ),
      );

  Future<void> onRemove(int index) async {
    if (index >= 0 && index < _localBundles.length) {
      setState(() {
        _localBundles.removeAt(index);
        itemCountNotifier.value = _localBundles.length;
      });
      final int value = (int.tryParse(controller.text) ?? 0) - 1;
      controller.text = '${value > 0 ? value : ''}';
    }
  }

  /// Add a new empty row using the original child_table structure
  Future<void> onAdd() async {
    if (field.childForm == null) return;

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
        _localBundles.addAll(rowBundles);
        itemCountNotifier.value = _localBundles.length;
      });
      controller.text =
          '${(int.tryParse(controller.text) ?? 0) + 1}';
    }
  }
}