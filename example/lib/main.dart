// ignore_for_file: constant_pattern_never_matches_value_type

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:example/attachment_utils.dart';
import 'package:example/doc_form_samples.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_field_editor/json_field_editor.dart';

void main() {
  runApp(const MyApp());
}

var transactions = [
  {
    "label": "Groups",
    "items": ["BOM", "Product Bundle", "Item Alternative"],
  },
  {
    "label": "Pricing",
    "items": ["Item Price", "Pricing Rule"],
  },
  {
    "label": "Sell",
    "items": ["Quotation", "Sales Order", "Delivery Note", "Sales Invoice"],
  },
  {
    "label": "Buy",
    "items": [
      "Material Request",
      "Supplier Quotation",
      "Request for Quotation",
      "Purchase Order",
      "Purchase Receipt",
      "Purchase Invoice",
    ],
  },
  {
    "label": "Manufacture",
    "items": ["Production Plan", "Work Order", "Item Manufacturer"],
  },
  {
    "label": "Traceability",
    "items": ["Serial No", "Batch"],
  },
  {
    "label": "Stock Movement",
    "items": ["Stock Entry", "Stock Reconciliation"],
  },
];
StreamController<
  ({ThemeData? theme, InputDecorationTheme? inputDecorationTheme})
>
themeStream =
    StreamController<
      ({ThemeData? theme, InputDecorationTheme? inputDecorationTheme})
    >.broadcast();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<
      ({ThemeData? theme, InputDecorationTheme? inputDecorationTheme})
    >(
      stream: themeStream.stream,
      initialData: null,
      builder: (context, snapshot) {
        final theme =
            snapshot.data?.theme ??
            (View.of(context).platformDispatcher.platformBrightness ==
                    Brightness.light
                ? ThemeData.light()
                : ThemeData.dark());
        return MaterialApp(
          title: 'Frappe Doc Form Demo',
          scrollBehavior: const CustomScrollBehavior(),
          theme: theme.copyWith(
            inputDecorationTheme: snapshot.data?.inputDecorationTheme,
          ),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<({String name, Locale? value})> locales = [
    (name: 'System default', value: null),
    (name: 'English', value: Locale('en', 'US')),
    (name: 'Spanish', value: Locale('es', 'ES')),
    (name: 'French', value: Locale('fr', 'FR')),
  ];
  final List<({String name, String value})> forms = [
    (name: 'Supported Fields Test', value: DocFormSamples.fieldTest),
    // (name: 'Table Test', value: DocFormSampRles.tableTest),
  ];
  final List<({String name, InputDecorationTheme? value})>
  inputDecorationThemes = [
    (name: 'Default', value: null),
    (
      name: 'Outline',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(),
      ),
    ),
    (
      name: 'Outline Stretched Rounded',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),
    ),
    (
      name: 'Outline Stretched Rounded Filled',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        filled: true,
      ),
    ),
    (
      name: 'Outline Stretched Rounded Filled No Borders',
      value: const InputDecorationTheme(
        contentPadding: EdgeInsets.only(left: 16, top: 12, bottom: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
          borderSide: BorderSide(style: BorderStyle.none, width: 0),
        ),
        isDense: true,
        alignLabelWithHint: true,
        filled: true,
      ),
    ),
  ];
  final List<({String name, ThemeData? value})> themes = [
    (name: 'System Default', value: null),
    (name: 'Light', value: ThemeData.light()),
    (name: 'Dark', value: ThemeData.dark()),
  ];

  static bool isValidJson(String? jsonString) {
    if (jsonString == null) {
      return false;
    }
    try {
      json.decode(jsonString);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  Locale? selectedLocale;
  String selectedForm = DocFormSamples.fieldTest;
  InputDecorationTheme? selectedInputDecorationTheme;
  final extraLocalizations = [DocFormFrLocalization()];
  ThemeData theme = ThemeData();
  ThemeData? selectedTheme;
  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Frappe Doc Form Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  label: Text('Select a Form sample'),
                ),
                initialValue: selectedForm,
                items: forms
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.value,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedForm = value;
                  }
                },
              ),
              const SizedBox(height: 8.0),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String? nameError;
                      String? jsonError;
                      final nameController = JsonTextFieldController();
                      final jsonController = JsonTextFieldController();
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: StatefulBuilder(
                            builder: (context, dialogSetState) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Add a Form from JSON',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Form Name',
                                    errorText: nameError,
                                    contentPadding: EdgeInsets.only(
                                      left: 16,
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(28),
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                        0.6,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: JsonField(
                                        controller: jsonController,
                                        isFormatting: true,
                                        showErrorMessage: true,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                          labelText: 'Form JSON',
                                          errorText: jsonError,
                                          contentPadding: EdgeInsets.only(
                                            left: 16,
                                            top: 12,
                                            bottom: 12,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(28),
                                            ),
                                          ),
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => jsonController
                                            .formatJson(sortJson: true),
                                        child: const Text('Format JSON'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          nameError = jsonError = null;
                                          if (nameController.text.isEmpty) {
                                            nameError = 'Name is required';
                                          }
                                          if (nameError == null &&
                                              forms.any(
                                                (item) =>
                                                    item.name ==
                                                    nameController.text,
                                              )) {
                                            nameError =
                                                'A Form with this name already exists';
                                          }
                                          if (jsonController.text.isEmpty) {
                                            jsonError = 'JSON is required';
                                          }
                                          if (jsonError == null &&
                                              !isValidJson(
                                                jsonController.text,
                                              )) {
                                            jsonError = 'Invalid JSON';
                                          }
                                          if (jsonError == null &&
                                              forms.any(
                                                (item) =>
                                                    item.value ==
                                                    jsonController.text,
                                              )) {
                                            jsonError =
                                                'A Form with this JSON already exists';
                                          }
                                          if (nameError != null ||
                                              jsonError != null) {
                                            dialogSetState(() {});
                                            return;
                                          }
                                          forms.add((
                                            name: nameController.text,
                                            value: jsonController.text,
                                          ));
                                          selectedForm = jsonController.text;
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              theme.colorScheme.primary,
                                          foregroundColor:
                                              theme.colorScheme.onPrimary,
                                        ),
                                        child: const Text('Add'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add a Form from JSON'),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<Locale?>(
                decoration: const InputDecoration(
                  label: Text('Select the Form locale'),
                ),
                initialValue: selectedLocale,
                items: locales
                    .map(
                      (e) => DropdownMenuItem<Locale>(
                        value: e.value,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedLocale = value;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<InputDecorationTheme?>(
                decoration: const InputDecoration(
                  label: Text('Select input decoration theme'),
                ),
                initialValue: selectedInputDecorationTheme,
                items: inputDecorationThemes
                    .map(
                      (e) => DropdownMenuItem<InputDecorationTheme>(
                        value: e.value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.78,
                          child: Text(e.name),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  themeStream.add((
                    theme: selectedTheme,
                    inputDecorationTheme: selectedInputDecorationTheme = value,
                  ));
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<ThemeData?>(
                decoration: const InputDecoration(
                  label: Text('Select app theme'),
                ),
                initialValue: selectedTheme,
                items: themes
                    .map(
                      (e) => DropdownMenuItem<ThemeData>(
                        value: e.value,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.78,
                          child: Text(e.name),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  themeStream.add((
                    theme: selectedTheme = value,
                    inputDecorationTheme: selectedInputDecorationTheme,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        extendedPadding: const EdgeInsets.symmetric(horizontal: 32.0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocFormPage(
                form: form,
                locale: selectedLocale,
                localizations: extraLocalizations,
              ),
            ),
          );
        },
        label: const Text('Open Form'),
      ),
    );
  }

  DocForm get form => DocForm.fromJsonString(selectedForm);
}

class DocFormPage extends StatefulWidget {
  final DocForm form;
  final Locale? locale;
  final List<DocFormBaseLocalization>? localizations;
  const DocFormPage({
    super.key,
    required this.form,
    this.locale,
    this.localizations,
  });

  @override
  State createState() => DocFormPageState();
}

class DocFormPageState extends State<DocFormPage> {
  bool loading = true;
  ThemeData theme = ThemeData();

  @override
  void initState() {
    super.initState();
    // widget.form.fields.add(
    //   DocField(
    //     fieldName: "heatmap_chart",
    //     fieldType: "Heatmap",
    //     label: "Heatmap Chart",
    //     name: "Stock Movement",
    //   ),
    // );

    // int index = (widget.form.fieldsOrder).indexWhere(
    //   (element) => element == "dashboard_tab",
    // );
    // (widget.form.fieldsOrder).insert(index + 1, "heatmap_chart");

    // //  if (widget.form.dashboard!.transactions.isNotEmpty){

    // widget.form.fields.insert(
    //   0,
    //   DocField.fromJson({
    //     "fieldname": "dash_connections",
    //     "label": "Connections",
    //     "fieldtype": "Connections",
    //   }),
    // );
    // (widget.form.fieldsOrder).insert(index + 2, "dash_connections");
    //  }

    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() => loading = false),
    );
  }
//  Future<List<Map<String, dynamic>>> _filterLinkData(
//     List<Map<String, dynamic>> data,
//     String pattern,
//   ) async {
//     if (pattern.isEmpty) return data;
//     final lowerPattern = pattern.toLowerCase();
//     return data.where((e) {
//       final value = e['value']?.toString().toLowerCase() ?? '';
//       final description = e['description']?.toString().toLowerCase() ?? '';
//       return value.contains(lowerPattern) || description.contains(lowerPattern);
//     }).toList();
//   }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return DocFormView(
      key: ValueKey(loading),
      form: widget.form,
      onAttachmentLoaded: onAttachmentLoaded,
      locale: widget.locale,
      localizations: widget.localizations,
      baseUrl: "https://img.freepik.com/", // Set your base URL here
      fetchSuggestions: (pattern, options)async =>  [
                          'Apple',
                          'Banana',
                          'Cherry',
                          'Date',
                          'Elderberry',
                          'Fig',
                          'Grape',
                        ]
                        .map(
                          (e) => {'value': e, 'description': '$e description'},
                        )
                        .toList(),
      controller: DocFormController(
        onBuildFieldView: (field, children, onAttachmentLoaded) async {
          switch (field.type) {
            case FieldType.heatmap:
              return HeatMapView(field: field, activityData: []);
            case FieldType.connections:
              return ConnectionsView(
                transactions: transactions
                    .map((e) => Transaction.fromMap(e))
                    .toList(),
                onTap: (String link) {},
              );
               case FieldType.dynamicLink:
            //ToDo: Implement dynamic link docTypes data
            return DocFieldDynamicLinkView(
              field: field,
              fetchLinkData: (pattern, doctype) async {
                // return await SearchData.searchlink(
                //   SearchLinkRequest(doctype: doctype, txt: pattern),
                // );
                return [
                         'lion',
                          'tiger',
                          'leopard',
                          'cheetah',
                          'panther',
                          'jaguar',
                          'cougar',
                        ]
                        .map(
                          (e) => {'value': e, 'description': '$e description'},
                        )
                        .toList();
              },
              docTypes: const ["Item", "Customer", "Selling"],
            );

            default:
              return null;
          }
        },
      ),

      isLoading: loading,
      onSubmit: onSubmit,
      onCancel: onCancel,
      onResponse: onResponse,
    );
  }

  Future<Attachment?> onAttachmentLoaded() async {
    return AttachmentUtils.pickAttachment(context);
  }

  Future<bool> onSubmit() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text('Are you sure you want to submit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
          ],
        ),
      ) ??
      false;

  Future<bool> onCancel() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text('Are you sure you want to cancel?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
          ],
        ),
      ) ??
      false;

  void onResponse(Map<String, dynamic> formResponse) async {
    String json = jsonEncode(formResponse);
    var prettyString = const JsonEncoder.withIndent('  ').convert(formResponse);
    debugPrint('''
      ========================================================================
      $prettyString
      ========================================================================
      ''');
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Form Response',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: JsonField(
                      controller: JsonTextFieldController()..text = json,
                      isFormatting: true,
                      showErrorMessage: true,
                      doInitFormatting: true,
                      readOnly: true,
                      showCursor: true,
                      enableInteractiveSelection: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 16,
                          top: 12,
                          bottom: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                        ),
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// French localizations
class DocFormFrLocalization extends DocFormBaseLocalization {
  DocFormFrLocalization() : super(Locale('fr', 'FR'));

  @override
  String get btnSubmit => 'Soumettre';
  @override
  String get btnUpload => 'Télécharger';
  @override
  String get btnChange => 'Changement';
  @override
  String get btnRemove => 'Retirer';
  @override
  String get textOtherOption => 'Autre option';
  @override
  String get textDate => 'Date';
  @override
  String get textTime => 'Temps';
  @override
  String get textLatitude => 'Latitude';
  @override
  String get textLongitude => 'Longitude';
  @override
  String get textPhone => 'Téléphone';
  @override
  String get textSearchPhoneCountryCode => 'Nom du pays ou code de composition';
  @override
  String get exceptionNoEmptyField => 'Ce champ est obligatoire.';
  @override
  String get exceptionValueMustBeAPositiveIntegerNumber =>
      'La valeur doit être un nombre entier positif.';
  @override
  String get exceptionValueMustBeAPositiveNumber =>
      'La valeur doit être un nombre positif.';
  @override
  String get exceptionValueMustBeANumber => 'La valeur doit être un numéro.';
  @override
  String get exceptionInvalidUrl => 'Invalid url.';
  @override
  String get exceptionInvalidPhoneNumber => 'Numéro de téléphone non valide.';
  @override
  String exceptionValueOutOfRange(dynamic minValue, dynamic maxValue) =>
      'La valeur doit être comprise entre $minValue et $maxValue.';
  @override
  String exceptionTextLength(dynamic minLength, dynamic maxLength) =>
      'Le texte doit contenir au moins des caractères $minLength et au maximum $maxLength.';
  @override
  String exceptionTextMaxLength(dynamic maxLength) =>
      'Le texte doit contenir au maximum des caractères $maxLength.';
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  static const _webScrollPhysics = BouncingScrollPhysics(
    parent: RangeMaintainingScrollPhysics(),
  );

  const CustomScrollBehavior() : super();

  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      kIsWeb ? _webScrollPhysics : super.getScrollPhysics(context);
}
