import 'package:frappe_form2/frappe_form2.dart';
import 'package:flutter/material.dart';

// 1. Global cache for data
final Map<String, List<DocFieldBundle>> _tableCache = {};
// 2. Global tracker for initialization status so it survives tab switches
final Set<String> _initializedKeys = {};

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

  // Cache key is the field's unique name
  String get _cacheKey => field.fieldName ?? field.label ?? 'table';

  List<DocFieldBundle> get _bundles =>
      _tableCache.putIfAbsent(_cacheKey, () => []);

  @override
  void initState() {
    super.initState();
    initFormController();
    scrollController = ScrollController();
    itemCountNotifier.value = _bundles.length;

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

  Future<void> _loadInitialRows() async {
    // Check global set instead of local boolean
    if (_initializedKeys.contains(_cacheKey)) {
      // Already initialized in a previous tab visit,
      // don't reload from field.initial even if _bundles is empty.
      return;
    }

    // Mark as initialized globally
    _initializedKeys.add(_cacheKey);

    final defaultData = field.initial;

    if (defaultData is List && defaultData.isNotEmpty) {
      final List<DocFieldBundle> newBundles = [];

      for (final rowData in defaultData) {
        if (rowData is Map<String, dynamic>) {
          final rowBundles = await _buildRowBundles(rowData);
          newBundles.addAll(rowBundles);
        }
      }

      if (newBundles.isNotEmpty && mounted) {
        setState(() {
          _bundles.addAll(newBundles);
          itemCountNotifier.value = _bundles.length;
        });
      }
    }
  }

  Future<List<DocFieldBundle>> _buildRowBundles(
    Map<String, dynamic> rowData,
  ) async {
    if (field.childForm == null) return [];

    final DocForm mergedChildForm = _buildMergedChildForm(
      field.childForm!,
      rowData,
    );

    final List<DocFieldBundle> builtBundles = await docFormController
        .buildFormFields(
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

  DocForm _buildMergedChildForm(
    DocForm childForm,
    Map<String, dynamic> rowData,
  ) {
    final List<DocField> mergedFields = childForm.fields.map((docField) {
      final String? fieldName = docField.fieldName;
      if (fieldName != null && rowData.containsKey(fieldName)) {
        return docField.copyWith(initial: rowData[fieldName]);
      }
      return docField.copyWith();
    }).toList();

    return childForm.copyWith(fields: mergedFields);
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  Widget gridItemView(BuildContext context, int index, double width) {
    // Safety check for async removals
    if (index >= _bundles.length) return const SizedBox.shrink();

    final childView = _bundles[index].view;

    return SizedBox(
      key: ValueKey('row_${_cacheKey}_${_bundles[index].hashCode}'),
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
          Positioned(right: 0, top: 0, child: removeButton(index)),
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
            _bundles.length,
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
        if (_bundles.isNotEmpty) ...[getGridView(context), totalCountIndicator],
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
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
        ),
        label: const Text("Add Row"),
        icon: const Icon(Icons.add, size: 18),
      ),
    ),
  );

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> onRemove(int index) async {
    if (index >= 0 && index < _bundles.length) {
      setState(() {
        _bundles.removeAt(index);
        itemCountNotifier.value = _bundles.length;
      });
      final int value = (int.tryParse(controller.text) ?? 0) - 1;
      controller.text = '${value > 0 ? value : ''}';
    }
  }

  Future<void> onAdd() async {
    if (field.childForm == null) return;

    final List<DocFieldBundle> builtBundles = await docFormController
        .buildFormFields(
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

    if (rowBundles.isNotEmpty && mounted) {
      setState(() {
        _bundles.addAll(rowBundles);
        itemCountNotifier.value = _bundles.length;
      });
      controller.text = '${(int.tryParse(controller.text) ?? 0) + 1}';
    }
  }
}
