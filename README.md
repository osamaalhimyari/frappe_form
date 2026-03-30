
# Frappe Form Updated package

A Flutter package for rendering Frappe Forms.

This package takes care of building the UI of a **Frappe Form**, handle behavior and validations and finally generates the **Response** from the user answers.

## Supported DocType form fields
So far this package supports the following [Field Types](https://docs.frappe.io/erpnext/v14/user/manual/en/customize-erpnext/articles/field-types#field-types)
| Field Type | Supported |  
| ------ | ------ |  
| Tab Break | :white_check_mark: |
| Column Break | :white_check_mark: |
| Section Break | :white_check_mark: |
| Data | :white_check_mark: |
| Text | :white_check_mark: |
| Small Text | :white_check_mark: |
| Long Text | :white_check_mark: |
| Text Editor | :white_check_mark: |
| Markdown Editor | :white_check_mark: |
| Select | :white_check_mark: |
| RadioGroup | :white_check_mark: _(This is not a Frappe default supported field, this is a custom field that is based on a `Select` field having a custom property `render_rules` with a JSON definition like: `"{\n \"type\": \"RADIO_GROUP\"\n}"`, this will make the `Select` to be rendered as a `RadioGroup`, check the demo. Use the `render_rules` custom property to override any field rendering)_ |
| Geolocation | :white_check_mark: |
| Autocomplete | :white_check_mark: |
| Phone | :white_check_mark: |
| Attach | :white_check_mark: |
| Attach Image | :white_check_mark: |
| Password | :white_check_mark: |
| Check | :white_check_mark: |
| Date | :white_check_mark: |
| Time | :white_check_mark: |
| Datetime | :white_check_mark: |
| Int | :white_check_mark: |
| Float | :white_check_mark: |
| Percent | :white_check_mark: |
| Currency | :white_check_mark: |
| Rating | :white_check_mark: |
| Heading | :white_check_mark: |
| Table | :white_check_mark: _(relies on having a `child_table` property that contains the JSON DocType definition of the referenced DocType)_ |
| HTML | :white_check_mark: _(With support for link tap behavior by using the [url_launcher](https://pub.dev/packages/url_launcher) plugin)_ |  
| Link | :white_check_mark: |  
| Dynamic Link | :white_check_mark: |  
| Barcode |:white_check_mark:|  
| Signature | :white_check_mark: |  
| Table MultiSelect | :white_check_mark: |  
| Color | :white_check_mark: |  
| Image |:white_check_mark: |  
| Button | :ballot_box_with_check: |  
| Code | :ballot_box_with_check: |  
| Read Only | :ballot_box_with_check: |  
| Duration | :ballot_box_with_check: |  
| HTML Editor | :ballot_box_with_check: |  
| Icon | :ballot_box_with_check: |  
| JSON | :ballot_box_with_check: |  

## Supported extra features
1. **Mandatory Depends On (JS)** expressions for validations
2. **Read Only Depends On (JS)** expressions for validations
3. **Display Depends On (JS)** expressions for validations
4. Required fields
5. Read only fields
6. Description
7. Default value


## How to use
Just add a `DocFormView` widget to your widget tree and you will have your Frappe Form UI.

```dart


final Map<String, List<Map<String, String>>> mockDocTypeData = {
      "Fruit": [
        {"value": "Apple", "description": "Red Crunchy"},
        {"value": "Banana", "description": "Yellow Sweet"},
        {"value": "Cherry", "description": "Small Red"},
      ],
      "Animal": [
        {"value": "Lion", "description": "King of Jungle"},
        {"value": "Tiger", "description": "Striped Hunter"},
        {"value": "Elephant", "description": "Trunk Giant"},
      ],
      "Job": [
        {"value": "Doctor", "description": "Medical Professional"},
        {"value": "Engineer", "description": "Technical Builder"},
      ],
    };
    // The fetchSuggestions implementation
    Future<List<Map<String, String>>> fetchLinkSuggestions({
      required String doctype, // e.g., "Fruit"
      required String query, // e.g., "ap"
    }) async {
      print("============================: '$query' and options: '$doctype'");

      // 1. Simulate Network Latency
      await Future.delayed(Duration(milliseconds: 200));

      // 2. Find the "DocType" list
      final List<Map<String, String>>? sourceList = mockDocTypeData[doctype];

      if (sourceList == null) return [];

      // 3. Filter by 'value' (the primary link field)
      return sourceList.where((item) {
        final String name = item['value']?.toLowerCase() ?? "";
        return name.contains(query.toLowerCase());
      }).toList();
    } //

    Future<List<Map<String, dynamic>>> _filterLinkData(
      List<Map<String, dynamic>> data,
      String pattern,
    ) async {
      if (pattern.isEmpty) return data;
      final lowerPattern = pattern.toLowerCase();
      return data.where((e) {
        final value = e['value']?.toString().toLowerCase() ?? '';
        final description = e['description']?.toString().toLowerCase() ?? '';
        return value.contains(lowerPattern) ||
            description.contains(lowerPattern);
      }).toList();
    }
    
  DocFormView(
      key: ValueKey(loading),
      form: widget.form,
      onAttachmentLoaded: onAttachmentLoaded,
      locale: widget.locale,
      localizations: widget.localizations,
      baseUrl: "https://img.freepik.com/", // Set your base URL here
      fetchSuggestions: (pattern, doctype) async {
        List<Map<String, dynamic>> rawData = [];

        try {
          final localMatches = await _filterLinkData(rawData, pattern);
          if (localMatches.isNotEmpty) return localMatches;
          print(
            'Fetching new suggestions for pattern: "$pattern" and docType: "$doctype"==========',
          );
          rawData = await fetchLinkSuggestions(
            doctype: doctype ?? "none",
            query: pattern,
          );

          return rawData;
        } catch (e) {
          return [];
        }
      }, // (pattern, options)async {
      // return   fetchLinkSuggestions(doctype:"Animal", query: pattern);
      // },
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

            default:
              return null;
          }
        },
      ),

      isLoading: loading,
      onSubmit: onSubmit,
      onCancel: onCancel,
      onResponse: onResponse,
      getDoctypesForDynamicLink: (String fieldName) async {
        var list = widget.form.getDynamicLinkOptions(fieldName);
        if (list.isEmpty) {
          list = ["Job", "Fruit", "Animal"];
        }
        return list;
      },
    );
 
```

## DocFormView
1. **`DocForm form`**: `DocFormView` requires an object of type **DocForm** this is the definition of the Frappe Form and will be used to build the Form UI and generate the Questions and Answers.
2. **`Locale? locale`**: Optionally you can specify the language like "es" or "en" or "fr", etc. you want as a Locale object to use for validation messages and Submit button, by default the system language will be used.
3. **`List<DocFormBaseLocalization>? localizations`**: this is a list that allows you to add extra language translations to the Form UI, currently the package supports only English and Spanish, so you can add other Languages, you just need to create a class for each new Language you want to support and extend **DocFormBaseLocalization**.
4. **`DocFormBaseLocalization? defaultLocalization`**: Indicates what should be the fallback localization if the specified language or the system language is not supported, by default English is the fallback.
5. **`bool isLoading`**: use this to indicate there is an ongoing operation, for instance if you need to make an API request to load your **DocForm** you can set `isLoading = true` so the `DocFormView` will show a Shimmer loading effect view.
6. **`Future<Attachment?> Function()? onAttachmentLoaded`**: To make this package simpler and compatible with all Flutter supported platforms, the feature to load an attachment is delegated to the App, so you have to handle this logic by implementing this function and returning an instance of `Attachment`.
7. **`List<Widget>? actions`**: To add custom actions to the AppBar.
8. **`Future<bool> Function()? onSubmit`**: Callback when the user wants to submit Form. Return true to proceed with the submission, false otherwise.
9. **`Future<bool> Function()? onCancel`**: Callback when the user wants to cancel the submission of the Form. Return true to allow the cancellation, false otherwise.
10. **`ValueChanged<Map<String, dynamic>>? onResponse`**: Get the FormResponse after user taps on Submit button and all Form fields has been processed.
11. **`DocFormController? controller`**: This is the controller to be used for questions and response generation within the `DocFormView`, the purpose of this controller here is to allow you to use an instance of an extension of `DocFormController` so you can override the behavior and widgets.

## Some extra notes
1. This widget will use the app Theme to build, so if you want to change colors, InputDecorations, etc, you just have to change it in your app Theme. Also all the package widgets are public and exposed so you could override it if necessary.
2. The `DocFormView` implementation takes care of validations depending on each `DocField` definition.
3. Check the example project which shows all the features in action.

## Demo
### [Try example demo app here](https://luis901101.github.io/frappe_form)
