import 'package:flutter/material.dart';
import 'package:frappe_form2/frappe_form.dart';

/// Renders a "junction" child-table field — one whose child doctype is
/// a single [FieldType.link] — as a checklist instead of a row-by-row
/// grid editor.
///
/// This mirrors Frappe Desk's RoleEditor: on the User doctype the
/// `roles` table (child doctype `Has Role`, whose only field is the
/// `role` Link to `Role`) is shown as a list of checkboxes — one per
/// available target record — rather than a grid of "Add Row" cards.
///
/// The selected child rows are kept on [controller], so they survive a
/// tab switch (which disposes and rebuilds the [State]) and so the form
/// controller can read them back when generating the save payload.
class DocFieldTableCheckListView extends DocFieldView {
  /// The child doctype's single Link field — e.g. `role` for the
  /// `Has Role` child table. Its [DocField.fieldName] is the key written
  /// into every emitted row map; its [DocField.options] is the doctype
  /// whose records become the checkboxes.
  final DocField linkField;

  /// The same suggestion fetcher the rest of the form uses — called
  /// once with an empty pattern to load every selectable option.
  final Future<List<Map<String, dynamic>>> Function(String, DocField)?
  fetchSuggestions;

  DocFieldTableCheckListView({
    super.key,
    required super.field,
    required this.linkField,
    this.fetchSuggestions,
    super.dependsOnController,
  }) : super(controller: CustomValueController<List<Map<String, dynamic>>>());

  @override
  CustomValueController<List<Map<String, dynamic>>> get controller =>
      super.controller as CustomValueController<List<Map<String, dynamic>>>;

  /// The child-table rows as they should be persisted: the original row
  /// maps for pre-existing selections (so `name` / audit columns ride
  /// along untouched) and a minimal `{<linkField>: value}` map for the
  /// newly-checked ones.
  List<Map<String, dynamic>> get rows =>
      List<Map<String, dynamic>>.from(controller.value ?? const []);

  @override
  void initController() {
    super.initController();
    // Seed once, from the constructor — NOT from the State's initState,
    // which re-runs every time a tab switch disposes and rebuilds the
    // State and would otherwise discard the user's edits.
    if (controller.value == null) {
      final initial = field.initial;
      final seeded = <Map<String, dynamic>>[];
      if (initial is List) {
        for (final row in initial) {
          if (row is Map) seeded.add(Map<String, dynamic>.from(row));
        }
      }
      controller.value = seeded;
    }
  }

  @override
  State<DocFieldTableCheckListView> createState() =>
      DocFieldTableCheckListViewState();
}

class DocFieldTableCheckListViewState
    extends DocFieldViewState<DocFieldTableCheckListView> {
  @override
  CustomValueController<List<Map<String, dynamic>>> get controller =>
      super.controller as CustomValueController<List<Map<String, dynamic>>>;

  String? get _linkFieldName => widget.linkField.fieldName;

  bool _loading = true;
  String? _error;

  /// Selectable options as (value, label) pairs.
  List<({String value, String label})> _options = const [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOptions());
  }

  /// The currently-checked option values, read off the persisted rows.
  List<String> get _selectedValues {
    final key = _linkFieldName;
    if (key == null) return const [];
    return [
      for (final row in controller.value ?? const <Map<String, dynamic>>[])
        if (row[key] != null && row[key].toString().isNotEmpty)
          row[key].toString(),
    ];
  }

  Future<void> _loadOptions() async {
    final fetch = widget.fetchSuggestions;
    if (fetch == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final results = await fetch('', widget.linkField);
      final options = <({String value, String label})>[];
      final seen = <String>{};
      for (final row in results) {
        final value = (row['value'] ?? row['name'])?.toString() ?? '';
        if (value.isEmpty || !seen.add(value)) continue;
        final label = (row['label'] ?? row['description'] ?? value).toString();
        options.add((value: value, label: label.isEmpty ? value : label));
      }
      // A value that's already assigned but absent from the lookup
      // (e.g. a disabled role) must still appear so it can be unchecked.
      for (final value in _selectedValues) {
        if (seen.add(value)) options.add((value: value, label: value));
      }
      options.sort(
        (a, b) => a.label.toLowerCase().compareTo(b.label.toLowerCase()),
      );
      if (!mounted) return;
      setState(() {
        _options = options;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  void _toggle(String value, bool checked) {
    final key = _linkFieldName;
    if (key == null) return;
    final next = List<Map<String, dynamic>>.from(
      controller.value ?? const <Map<String, dynamic>>[],
    );
    if (checked) {
      if (!next.any((row) => row[key]?.toString() == value)) {
        next.add(<String, dynamic>{key: value});
      }
    } else {
      next.removeWhere((row) => row[key]?.toString() == value);
    }
    setState(() => controller.value = next);
  }

  @override
  Widget buildBody(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          _error!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      );
    }
    if (_options.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'No options available',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      );
    }
    final selected = _selectedValues.toSet();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final option in _options)
          CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: selected.contains(option.value),
            title: Text(option.label),
            onChanged: (checked) => _toggle(option.value, checked ?? false),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${selected.length} selected',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}
