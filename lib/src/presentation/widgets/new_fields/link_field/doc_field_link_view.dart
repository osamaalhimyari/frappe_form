// ignore_for_file: library_private_types_in_public_api, overridden_fields

import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:frappe_form/src/model/new_models/message.dart';

class DocFieldLinkView extends DocFieldView {
  // final Function(LinkFieldValue?)? onChanged;
  final Future<List<Map<String, dynamic>>> Function(String) fetchSuggestions;
  final Map<String, dynamic>? parentDoc;
  final bool enabled;
  final bool gridLayout;
  final bool showDividers;

  DocFieldLinkView({
    super.key,
    required super.field,
    // this.onChanged,
    required this.fetchSuggestions,
    this.parentDoc,
    this.enabled = true,
    this.gridLayout = false,
    this.showDividers = false,
    CustomTextEditingController? controller,
    super.dependsOnController,
  }) : super(
          controller: controller ?? 
              CustomTextEditingController(focusNode: FocusNode()),
        );

  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  @override
  void initController() {
    super.initController();
    // Initialize the ID value from field metadata if controller is empty
    if (controller.text.isEmpty && field.initial != null) {
      controller.text = field.initial.toString();
    }
  }

  @override
  _DocFieldLinkViewState createState() => _DocFieldLinkViewState();
}

class _DocFieldLinkViewState extends DocFieldViewState<DocFieldLinkView> {
  // Use the controller from the parent widget
  @override
  CustomTextEditingController get controller =>
      super.controller as CustomTextEditingController;

  // Internal controller for the Search UI (Label)
  final TextEditingController _displayController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<Message> _fullData = [];
  List<Message> _filteredData = [];
  bool _isLoading = false;
  bool hasFetched = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    
    // Set display text to match initial ID
    _displayController.text = controller.text;

    _focusNode.addListener(_onFocusChange);
    _displayController.addListener(_onTextChanged);

    _updateVisibility();
    _loadInitialData();
  }

  @override
  void didUpdateWidget(covariant DocFieldLinkView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.parentDoc != oldWidget.parentDoc) {
      _updateVisibility();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _displayController.removeListener(_onTextChanged);
    _displayController.dispose();
    _removeOverlay();
    super.dispose();
  }

  // --- Suggestion Logic ---

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showSuggestionsOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _onTextChanged() {
    if (_focusNode.hasFocus) {
      _filterSuggestions(_displayController.text);
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _filterSuggestions(String pattern) {
    if (pattern.isEmpty) {
      _filteredData = _fullData;
    } else {
      final query = pattern.toLowerCase();
      _filteredData = _fullData.where((item) {
        return (item.label?.toLowerCase().contains(query) ?? false) ||
               (item.value?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
  }

  // --- Overlay Management ---

  void _showSuggestionsOverlay() {
    _removeOverlay();
    _filterSuggestions(_displayController.text);
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: theme.cardColor,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildSuggestionsList(),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // --- UI Components ---

  Widget _buildSuggestionsList() {
    if (_isLoading) {
      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
    }
    if (_filteredData.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No results', textAlign: TextAlign.center));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: _filteredData.length,
      // ignore: unnecessary_underscores
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _filteredData[index];
        return ListTile(
          title: Text(item.label ?? ''),
          subtitle: item.label != item.value ? Text(item.value ?? '') : null,
          onTap: () => _selectItem(item),
        );
      },
    );
  }

  void _selectItem(Message item) {
    setState(() {
      controller.text = item.value ?? ''; // Save ID to form
      _displayController.text = item.label ?? item.value ?? ''; // Show Label in UI
    });

    // if (widget.onChanged != null) {
    //   widget.onChanged!(LinkFieldValue(value: item.value, label: item.label, description: item.description));
    // }
    
    _focusNode.unfocus();
    _removeOverlay();
  }

  // --- Visibility & Data ---

  void _updateVisibility() {
    final dependsOn = widget.field.visibilityDependsOn;
    if (dependsOn == null) {
      _isVisible = widget.field.hidden != 1;
    } else if (widget.parentDoc != null) {
      // Basic Eval implementation
      final val = widget.parentDoc![dependsOn.replaceFirst('eval:', '')];
      _isVisible = val != null && val.toString().isNotEmpty;
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await widget.fetchSuggestions('');
      _fullData = data.map((e) => Message.fromMap(e)).toList();
      hasFetched = true;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget? buildTitleView(BuildContext context) {
    if (field.title.isEmpty || !_isVisible) return null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(field.title, style: theme.textTheme.titleSmall),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _displayController,
        focusNode: _focusNode,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(Icons.link),
          border: const OutlineInputBorder(),
          suffixIcon: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)))
            : (_displayController.text.isNotEmpty && !isReadOnly
                ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                    _displayController.clear();
                    controller.clear();
                    // if (widget.onChanged != null) widget.onChanged!(null);
                  })
                : const Icon(Icons.arrow_drop_down)),
        ),
      ),
    );
  }
}

class LinkFieldValue {
  final String? description;
  final String? value;
  final String? label;
  LinkFieldValue({this.description, this.value, this.label});
}