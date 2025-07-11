class DocFormSamples {
  static const fieldTest = r'''
{
    "actions": [],
    "allow_rename": 1,
    "creation": "2025-07-04 10:00:57.319696",
    "custom": 1,
    "doctype": "DocType",
    "engine": "InnoDB",
    "field_order": [
      "tab_texts",
      "section_multiline_texts",
      "column_break_ofje",
      "heading",
      "data",
      "int",
      "float",
      "currency",
      "percent",
      "password",
      "phone",
      "column_break_vswc",
      "text",
      "small_text",
      "long_text",
      "markdown",
      "text_editor",
      "tab_dates",
      "dates_section",
      "date",
      "time",
      "date_time",
      "dropdown_tab",
      "section_break_cwwe",
      "autocomplete",
      "select",
      "check_liked_option_3",
      "tab_4_tab",
      "section_break_viat",
      "attach",
      "attach_image",
      "miscellaneous",
      "section_break_omsq",
      "rating",
      "check",
      "geolocation",
      "custom_fields_tab",
      "photos_gallery_section",
      "photo_1",
      "photo_2",
      "photo_3",
      "photo_4",
      "photo_5",
      "photo_6",
      "place",
      "location",
      "place_data",
      "section_break_moic",
      "video",
      "tab_table",
      "ingredients_and_quantities_section",
      "recipe_evaluation_ingredients",
      "media_uploads_section",
      "media"
    ],
    "fields": [
      {
        "fieldname": "tab_texts",
        "fieldtype": "Tab Break",
        "label": "Texts"
      },
      {
        "description": "A section with multiple type of \ntexts",
        "fieldname": "section_multiline_texts",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "column_break_ofje",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "heading",
        "fieldtype": "Heading",
        "label": "Heading"
      },
      {
        "fieldname": "data",
        "fieldtype": "Data",
        "label": "Data"
      },
      {
        "fieldname": "int",
        "fieldtype": "Int",
        "label": "Int"
      },
      {
        "fieldname": "float",
        "fieldtype": "Float",
        "label": "Float",
        "precision": "3"
      },
      {
        "fieldname": "currency",
        "fieldtype": "Currency",
        "label": "Currency",
        "precision": "2"
      },
      {
        "fieldname": "percent",
        "fieldtype": "Percent",
        "label": "Percent"
      },
      {
        "fieldname": "password",
        "fieldtype": "Password",
        "label": "Password"
      },
      {
        "fieldname": "phone",
        "fieldtype": "Phone",
        "label": "Phone"
      },
      {
        "fieldname": "column_break_vswc",
        "fieldtype": "Column Break"
      },
      {
        "fieldname": "text",
        "fieldtype": "Text",
        "label": "Text"
      },
      {
        "fieldname": "small_text",
        "fieldtype": "Small Text",
        "label": "Small text"
      },
      {
        "fieldname": "long_text",
        "fieldtype": "Long Text",
        "label": "Long text"
      },
      {
        "fieldname": "markdown",
        "fieldtype": "Markdown Editor",
        "label": "Markdown"
      },
      {
        "fieldname": "text_editor",
        "fieldtype": "Text Editor",
        "label": "Text editor"
      },
      {
        "fieldname": "tab_dates",
        "fieldtype": "Tab Break",
        "label": "Dates"
      },
      {
        "description": "A section with multiple type of dates",
        "fieldname": "dates_section",
        "fieldtype": "Section Break"
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
        "fieldname": "date_time",
        "fieldtype": "Datetime",
        "label": "Date time"
      },
      {
        "fieldname": "dropdown_tab",
        "fieldtype": "Tab Break",
        "label": "Dropdown"
      },
      {
        "description": "A section with multiple dropdowns",
        "fieldname": "section_break_cwwe",
        "fieldtype": "Section Break"
      },
      {
        "description": "Start typing \"Autocomplete\"",
        "fieldname": "autocomplete",
        "fieldtype": "Autocomplete",
        "label": "Autocomplete",
        "options": "Autocomplete 1\nAutocomplete 2\nAutocomplete 3"
      },
      {
        "description": "Select Option 3 to test dependency eval",
        "fieldname": "select",
        "fieldtype": "Select",
        "label": "Select",
        "options": "\nOption 1\nOption 2\nOption 3"
      },
      {
        "default": "0",
        "depends_on": "eval:doc.select=='Option 3'",
        "fieldname": "check_liked_option_3",
        "fieldtype": "Check",
        "label": "Liked option 3?"
      },
      {
        "fieldname": "tab_4_tab",
        "fieldtype": "Tab Break",
        "label": "Attach"
      },
      {
        "description": "A section with multiple attachs",
        "fieldname": "section_break_viat",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "attach",
        "fieldtype": "Attach",
        "label": "Attach"
      },
      {
        "fieldname": "attach_image",
        "fieldtype": "Attach Image",
        "label": "Attach image"
      },
      {
        "fieldname": "miscellaneous",
        "fieldtype": "Tab Break",
        "label": "Miscellaneous"
      },
      {
        "description": "A section with miscellaneous fields",
        "fieldname": "section_break_omsq",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "rating",
        "fieldtype": "Rating",
        "label": "Rating"
      },
      {
        "default": "0",
        "fieldname": "check",
        "fieldtype": "Check",
        "label": "Check"
      },
      {
        "fieldname": "geolocation",
        "fieldtype": "Geolocation",
        "label": "Geolocation"
      },
      {
        "fieldname": "custom_fields_tab",
        "fieldtype": "Tab Break",
        "label": "Custom fields"
      },
      {
        "fieldname": "photos_gallery_section",
        "fieldtype": "Section Break",
        "label": "Photos Gallery",
        "options": "{\n    \"type\": \"GALLERY\"\n}"
      },
      {
        "fieldname": "photo_1",
        "fieldtype": "Attach Image",
        "label": "Photo 1"
      },
      {
        "fieldname": "photo_2",
        "fieldtype": "Attach Image",
        "label": "Photo 2"
      },
      {
        "fieldname": "photo_3",
        "fieldtype": "Attach Image",
        "label": "Photo 3"
      },
      {
        "fieldname": "photo_4",
        "fieldtype": "Attach Image",
        "label": "Photo 4"
      },
      {
        "fieldname": "photo_5",
        "fieldtype": "Attach Image",
        "label": "Photo 5"
      },
      {
        "fieldname": "photo_6",
        "fieldtype": "Attach Image",
        "label": "Photo 6"
      },
      {
        "fieldname": "place",
        "fieldtype": "Section Break",
        "label": "Place",
        "options": "{\n    \"type\": \"PLACE\"\n}"
      },
      {
        "fieldname": "location",
        "fieldtype": "Geolocation",
        "label": "Location"
      },
      {
        "fieldname": "place_data",
        "fieldtype": "Long Text",
        "label": "Place Data"
      },
      {
        "fieldname": "section_break_moic",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "video",
        "fieldtype": "Attach",
        "label": "Video",
        "options": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 30000\n}"
      },
      {
        "fieldname": "tab_table",
        "fieldtype": "Tab Break",
        "label": "Table"
      },
      {
        "description": "<strong>Take photo of Recipe/Formula</strong>",
        "fieldname": "ingredients_and_quantities_section",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "recipe_evaluation_ingredients",
        "fieldtype": "Table",
        "label": "Recipe Evaluation Ingredients",
        "options": "Recipe Evaluation Ingredients",
        "child_table": {
          "actions": [],
          "allow_rename": 1,
          "creation": "2025-06-26 13:04:50.708296",
          "doctype": "DocType",
          "editable_grid": 1,
          "engine": "InnoDB",
          "field_order": [
            "ingredient",
            "quantity",
            "photo"
          ],
          "fields": [
            {
              "fieldname": "ingredient",
              "fieldtype": "Data",
              "in_list_view": 1,
              "label": "Ingredient"
            },
            {
              "fieldname": "quantity",
              "fieldtype": "Data",
              "in_list_view": 1,
              "label": "Quantity"
            },
            {
              "fieldname": "photo",
              "fieldtype": "Attach Image",
              "label": "Photo"
            }
          ],
          "index_web_pages_for_search": 1,
          "istable": 1,
          "links": [],
          "modified": "2025-06-26 13:11:20.657458",
          "modified_by": "Administrator",
          "module": "Culinary Forms",
          "name": "Recipe Evaluation Ingredients",
          "owner": "Administrator",
          "permissions": [],
          "sort_field": "modified",
          "sort_order": "DESC",
          "states": []
        }
      },
      {
        "description": "<strong>Share photos or videos of the cooking process to bring your recipe to life</strong>",
        "fieldname": "media_uploads_section",
        "fieldtype": "Section Break"
      },
      {
        "fieldname": "media",
        "fieldtype": "Table",
        "label": "Media",
        "options": "Recipe Evaluation Media Uploads",
        "child_table": {
          "actions": [],
          "allow_rename": 1,
          "creation": "2025-06-26 13:33:15.367902",
          "doctype": "DocType",
          "editable_grid": 1,
          "engine": "InnoDB",
          "field_order": [
            "section_break_mtto",
            "photo",
            "video"
          ],
          "fields": [
            {
              "fieldname": "photo",
              "fieldtype": "Attach Image",
              "label": "Photo"
            },
            {
              "fieldname": "video",
              "fieldtype": "Attach",
              "label": "Video",
              "options": "{\n    \"type\": \"VIDEO\", \n    \"maxDuration\": 60000\n}"
            },
            {
              "fieldname": "section_break_mtto",
              "fieldtype": "Section Break",
              "options": "{\n\"type\": \"GALLERY\"\n}"
            }
          ],
          "index_web_pages_for_search": 1,
          "istable": 1,
          "links": [],
          "modified": "2025-07-10 16:14:36.937022",
          "modified_by": "Administrator",
          "module": "Culinary Forms",
          "name": "Recipe Evaluation Media Uploads",
          "owner": "Administrator",
          "permissions": [],
          "sort_field": "modified",
          "sort_order": "DESC",
          "states": []
        }
      }
    ],
    "index_web_pages_for_search": 1,
    "links": [],
    "modified": "2025-07-10 07:45:09.999743",
    "modified_by": "user@mail.com",
    "module": "Culinary Forms",
    "name": "FieldTest",
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

  static const tableTest = r'''
{
  "actions": [],
  "allow_rename": 1,
  "creation": "2025-07-10 04:25:02.166743",
  "custom": 1,
  "doctype": "DocType",
  "engine": "InnoDB",
  "field_order": [
    "ingredients_and_quantities_section",
    "recipe_evaluation_ingredients"
  ],
  "fields": [
    {
      "description": "<strong>Take photo of Recipe/Formula</strong>",
      "fieldname": "ingredients_and_quantities_section",
      "fieldtype": "Section Break"
    },
    {
      "fieldname": "recipe_evaluation_ingredients",
      "fieldtype": "Table",
      "label": "Recipe Evaluation Ingredients",
      "options": "Recipe Evaluation Ingredients",
      "child_table": {
        "actions": [],
        "allow_rename": 1,
        "creation": "2025-06-26 13:04:50.708296",
        "doctype": "DocType",
        "editable_grid": 1,
        "engine": "InnoDB",
        "field_order": [
          "ingredient",
          "quantity",
          "photo"
        ],
        "fields": [
          {
            "fieldname": "ingredient",
            "fieldtype": "Data",
            "in_list_view": 1,
            "label": "Ingredient"
          },
          {
            "fieldname": "quantity",
            "fieldtype": "Data",
            "in_list_view": 1,
            "label": "Quantity"
          },
          {
            "fieldname": "photo",
            "fieldtype": "Attach Image",
            "label": "Photo"
          }
        ],
        "index_web_pages_for_search": 1,
        "istable": 1,
        "links": [],
        "modified": "2025-06-26 13:11:20.657458",
        "modified_by": "Administrator",
        "module": "Culinary Forms",
        "name": "Recipe Evaluation Ingredients",
        "owner": "Administrator",
        "permissions": [],
        "sort_field": "modified",
        "sort_order": "DESC",
        "states": []
      }
    }
  ],
  "index_web_pages_for_search": 1,
  "links": [],
  "modified": "2025-07-10 07:49:47.507216",
  "modified_by": "user@mail.com",
  "module": "Culinary Forms",
  "name": "TableTest",
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
}
