class DocFormSamples {
  static String get sampleStructure => r'''
{
    "actions": [],
    "allow_rename": 1,
    "creation": "2025-04-29 10:01:37.045763",
    "custom": 1,
    "doctype": "DocType",
    "engine": "InnoDB",
    "field_order": [
      "tab_1",
      "section_inputs",
      "column_break_pnys",
      "this_is_a_heading",
      "data",
      "phone",
      "autocomplete",
      "password",
      "select",
      "percent",
      "currency",
      "float",
      "integer",
      "rating",
      "column_break_bpxe",
      "text_editor",
      "text",
      "small_text",
      "long_text",
      "section_date_time_duration",
      "date",
      "time",
      "column_break_iwrx",
      "date1",
      "time1",
      "column_break_azix",
      "date2",
      "time2",
      "column_break_zomy",
      "date_and_time",
      "duration",
      "tab_2",
      "section_location",
      "geolocation",
      "section_attachments",
      "attach",
      "attach_image",
      "long_text_yrnz",
      "long_text_riio",
      "data2",
      "select_required"
    ],
    "fields": [
      {
        "fieldname": "tab_1",
        "fieldtype": "Tab Break",
        "label": "Tab 1"
      },
      {
        "fieldname": "section_inputs",
        "fieldtype": "Section Break",
        "label": "Section Inputs"
      },
      {
        "fieldname": "column_break_pnys",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "this_is_a_heading",
        "fieldtype": "Heading",
        "label": "This is a heading "
      },
      {
        "description": "Write something short like a name",
        "fieldname": "data",
        "fieldtype": "Data",
        "in_list_view": 1,
        "label": "Data",
        "length": 160,
        "reqd": 1
      },
      {
        "fieldname": "phone",
        "fieldtype": "Phone",
        "label": "Phone"
      },
      {
        "description": "Write something to autocomplete, like One, Two or Three",
        "fieldname": "autocomplete",
        "fieldtype": "Autocomplete",
        "label": "Autocomplete",
        "options": "One\nTwo\nThree",
        "reqd": 1
      },
      {
        "fieldname": "password",
        "fieldtype": "Password",
        "label": "Password"
      },
      {
        "default": "Select 2",
        "description": "Dropdown with default value = Select 2. If you choose Select 1, the Percent field will show up.",
        "fieldname": "select",
        "fieldtype": "Select",
        "label": "Select",
        "options": "Select 1\nSelect 2\nSelect 3",
        "reqd": 1
      },
      {
        "depends_on": "eval:doc.select=='Select 1'",
        "fieldname": "percent",
        "fieldtype": "Percent",
        "label": "Percent",
        "precision": "2"
      },
      {
        "fieldname": "currency",
        "fieldtype": "Currency",
        "label": "Currency",
        "precision": "4"
      },
      {
        "fieldname": "float",
        "fieldtype": "Float",
        "label": "Float",
        "precision": "5"
      },
      {
        "fieldname": "integer",
        "fieldtype": "Int",
        "label": "Integer"
      },
      {
        "fieldname": "rating",
        "fieldtype": "Rating",
        "label": "Rating"
      },
      {
        "fieldname": "column_break_bpxe",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "text_editor",
        "fieldtype": "Text Editor",
        "label": "Text Editor"
      },
      {
        "fieldname": "text",
        "fieldtype": "Text",
        "label": "Text"
      },
      {
        "fieldname": "small_text",
        "fieldtype": "Small Text",
        "label": "Small Text"
      },
      {
        "fieldname": "long_text",
        "fieldtype": "Long Text",
        "label": "Long Text"
      },
      {
        "fieldname": "section_date_time_duration",
        "fieldtype": "Section Break",
        "label": "Date, Time and Duration"
      },
      {
        "fieldname": "date",
        "fieldtype": "Date",
        "label": "Date"
      },
      {
        "fieldname": "time",
        "fieldtype": "Time",
        "label": "Time"
      },
      {
        "fieldname": "column_break_iwrx",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "date1",
        "fieldtype": "Date",
        "label": "Date1"
      },
      {
        "fieldname": "time1",
        "fieldtype": "Time",
        "label": "Time1"
      },
      {
        "fieldname": "column_break_azix",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "date2",
        "fieldtype": "Date",
        "label": "Date2"
      },
      {
        "fieldname": "time2",
        "fieldtype": "Time",
        "label": "Time2"
      },
      {
        "fieldname": "column_break_zomy",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "date_and_time",
        "fieldtype": "Datetime",
        "label": "Date and Time"
      },
      {
        "fieldname": "duration",
        "fieldtype": "Duration",
        "label": "Duration"
      },
      {
        "fieldname": "tab_2",
        "fieldtype": "Tab Break",
        "label": "Tab 2"
      },
      {
        "fieldname": "section_location",
        "fieldtype": "Section Break",
        "label": "Location"
      },
      {
        "default": "{\n  \"type\": \"FeatureCollection\",\n  \"features\": [\n    {\n      \"type\": \"Feature\",\n      \"properties\": {},\n      \"geometry\": { \"type\": \"Point\", \"coordinates\": [-9.208334, 38.757599] }\n    }\n  ]\n}",
        "fieldname": "geolocation",
        "fieldtype": "Geolocation",
        "label": "Geolocation"
      },
      {
        "fieldname": "section_attachments",
        "fieldtype": "Section Break",
        "label": "Attachments"
      },
      {
        "fieldname": "attach",
        "fieldtype": "Attach",
        "label": "Attach",
        "length": 10,
        "options": "image/jpeg\nvideo/mp4"
      },
      {
        "fieldname": "attach_image",
        "fieldtype": "Attach Image",
        "label": "Attach Image"
      },
      {
        "fieldname": "long_text_yrnz",
        "fieldtype": "Long Text"
      },
      {
        "fieldname": "long_text_riio",
        "fieldtype": "Long Text"
      },
      {
        "fieldname": "data2",
        "fieldtype": "Data",
        "label": "Required Data"
      },
      {
        "fieldname": "select_required",
        "fieldtype": "Select",
        "label": "Select required",
        "options": "S1\nS2\nS3",
        "reqd": 1
      }      
    ],
    "index_web_pages_for_search": 1,
    "links": [],
    "modified": "2025-05-20 16:19:56.735014",
    "modified_by": "user@mail.com",
    "module": "Culinary Forms",
    "name": "SampleStructure",
    "owner": "user@mail.com",
    "permissions": [
      {
        "create": 1,
        "delete": 1,
        "email": 1,
        "export": 1,
        "print": 1,
        "read": 1,
        "report": 1,
        "role": "System Manager",
        "share": 1,
        "write": 1
      }
    ],
    "sort_field": "modified",
    "sort_order": "DESC",
    "states": []
  }
  ''';

  static const tasteTester = r'''
{
  "actions": [],
  "autoname": "format:FORM-{YYYY}-{####}",
  "creation": "2025-04-21 15:33:05.551273",
  "doctype": "DocType",
  "engine": "InnoDB",
  "field_order": [
    "product",
    "project",
    "other_project",
    "price_paid",
    "column_break_fqyb",
    "purchased_at",
    "purchased_at_write_a_description",
    "purchased_at_location",
    "packaging_section",
    "photos_of_packaging",
    "packaging_notes",
    "column_break_guml",
    "ingredients",
    "flavor_evaluation_section",
    "flavor_appearance",
    "flavor_texture",
    "flavor_aroma",
    "total_flavor_experience",
    "column_break_hdfx",
    "taste_description",
    "taste_sweetness",
    "taste_sourness",
    "taste_saltiness",
    "taste_bitterness",
    "taste_umaminess",
    "after_taste",
    "section_break_mcld",
    "marketpalce_analysis",
    "video_review",
    "final_rating"
  ],
  "fields": [
    {
      "fieldname": "product",
      "fieldtype": "Data",
      "in_list_view": 1,
      "label": "Product",
      "reqd": 1
    },
    {
      "fieldname": "project",
      "fieldtype": "Autocomplete",
      "in_list_view": 1,
      "label": "Project",
      "options": "CWB\nLKK\nCDF\nOther",
      "reqd": 1
    },
    {
      "depends_on": "eval: doc.project == \"Other\"",
      "fieldname": "other_project",
      "fieldtype": "Text Editor",
      "label": "Other Project"
    },
    {
      "fieldname": "column_break_fqyb",
      "fieldtype": "Column Break"
    },
    {
      "fieldname": "price_paid",
      "fieldtype": "Float",
      "in_list_view": 1,
      "label": "Price Paid",
      "precision": "2"
    },
    {
      "default": "Write Text",
      "fieldname": "purchased_at",
      "fieldtype": "Select",
      "label": "Purchased at",
      "options": "Write Text\nSelect Location"
    },
    {
      "depends_on": "eval: doc.purchased_at == \"Write Text\"",
      "fieldname": "purchased_at_write_a_description",
      "fieldtype": "Text Editor",
      "label": "Purchased at (Write a description)"
    },
    {
      "depends_on": "eval: doc.purchased_at == \"Select Location\"",
      "fieldname": "purchased_at_location",
      "fieldtype": "Geolocation",
      "label": "Select Location"
    },
    {
      "fieldname": "packaging_section",
      "fieldtype": "Section Break",
      "label": "Packaging"
    },
    {
      "fieldname": "packaging_notes",
      "fieldtype": "Text Editor",
      "label": "Packaging Notes"
    },
    {
      "fieldname": "ingredients",
      "fieldtype": "Text Editor",
      "label": "Ingredients"
    },
    {
      "fieldname": "column_break_guml",
      "fieldtype": "Column Break"
    },
    {
      "fieldname": "column_break_hdfx",
      "fieldtype": "Column Break",
      "label": "Taste"
    },
    {
      "fieldname": "total_flavor_experience",
      "fieldtype": "Text Editor",
      "label": "Total Flavor Experience"
    },
    {
      "fieldname": "after_taste",
      "fieldtype": "Text Editor",
      "label": "After Taste"
    },
    {
      "fieldname": "section_break_mcld",
      "fieldtype": "Section Break"
    },
    {
      "description": "Would you buy it? If so why or why not? What would you change?",
      "fieldname": "marketpalce_analysis",
      "fieldtype": "Text Editor",
      "label": "Marketplace Analysis"
    },
    {
      "fieldname": "final_rating",
      "fieldtype": "Rating",
      "label": "Final Rating"
    },
    {
      "fieldname": "video_review",
      "fieldtype": "Attach Image",
      "label": "Video Review"
    },
    {
      "fieldname": "photos_of_packaging",
      "fieldtype": "Attach Image",
      "label": "Photos of Packaging"
    },
    {
      "fieldname": "taste_description",
      "fieldtype": "Text Editor",
      "label": "Taste Description"
    },
    {
      "default": "0",
      "fieldname": "taste_sweetness",
      "fieldtype": "Int",
      "label": "Sweetness"
    },
    {
      "default": "0",
      "fieldname": "taste_sourness",
      "fieldtype": "Int",
      "label": "Sourness"
    },
    {
      "default": "0",
      "fieldname": "taste_saltiness",
      "fieldtype": "Int",
      "label": "Saltiness"
    },
    {
      "default": "0",
      "fieldname": "taste_bitterness",
      "fieldtype": "Int",
      "label": "Bitterness"
    },
    {
      "default": "0",
      "fieldname": "taste_umaminess",
      "fieldtype": "Int",
      "label": "Umaminess"
    },
    {
      "fieldname": "flavor_appearance",
      "fieldtype": "Text Editor",
      "label": "Appearance"
    },
    {
      "fieldname": "flavor_texture",
      "fieldtype": "Text Editor",
      "label": "Texture"
    },
    {
      "fieldname": "flavor_aroma",
      "fieldtype": "Text Editor",
      "label": "Aroma"
    },
    {
      "fieldname": "flavor_evaluation_section",
      "fieldtype": "Section Break",
      "label": "Flavor Evaluation"
    }
  ],
  "grid_page_length": 50,
  "index_web_pages_for_search": 1,
  "links": [],
  "modified": "2025-05-22 23:02:24.457578",
  "modified_by": "Administrator",
  "module": "Culinary Forms",
  "name": "Taste Tester",
  "naming_rule": "Expression",
  "owner": "Administrator",
  "permissions": [
    {
      "create": 1,
      "delete": 1,
      "email": 1,
      "export": 1,
      "print": 1,
      "read": 1,
      "report": 1,
      "role": "Administrator",
      "share": 1,
      "write": 1
    },
    {
      "create": 1,
      "delete": 1,
      "email": 1,
      "export": 1,
      "print": 1,
      "read": 1,
      "report": 1,
      "role": "System Manager",
      "share": 1,
      "write": 1
    },
    {
      "create": 1,
      "email": 1,
      "export": 1,
      "print": 1,
      "report": 1,
      "role": "All",
      "share": 1,
      "write": 1
    }
  ],
  "row_format": "Dynamic",
  "sort_field": "modified",
  "sort_order": "DESC",
  "states": []
}
  ''';
}
