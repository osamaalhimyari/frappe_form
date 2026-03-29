class DocFormSamples {
 

  static const fieldTest =
   r'''
{
    "actions": [],
    "allow_rename": 1,
    "creation": "2025-07-04 10:00:57.319696",
    "custom": 1,
    "description": "FieldTest description sample",
    "doctype": "DocType",
    "engine": "InnoDB",
    "field_order": [
  "dashboard_tab",
  "details",
  "heatmap",           
  "inventory_section", 
  "shelf_life_in_days"

    ],
    "fields": [
    {
    "fieldname": "link_type",
    "fieldtype": "Link",
    "label": "Link Target Type",
    "options": "DocType"
},
{
    "fieldname": "link_name",
    "fieldtype": "Dynamic Link",
    "label": "Link Record",
    "options": "link_type" 
}
    ],
    "index_web_pages_for_search": 1,
    "links": [],
    "modified": "2025-10-10 03:57:48.220332",
    "modified_by": "user@mail.com",
    "module": "Culinary Forms",
    "name": "FieldTest",
    "owner": "user@mail.com",

    "sort_field": "modified",
    "sort_order": "DESC",
    "states": []
  }
  ''';


/**
 * 
 * 
 * ,
       {
            "fieldname": "heatmap",
            "label": "Stock Movement",
            "fieldtype": "Heatmap"
        }
      {
        "fieldname": "Barcode",
        "fieldtype": "Barcode",
        "label": "Barcode"
        ,"default": "123456789012"
      }
 {
        "fieldname": "Color",
        "fieldtype": "Color",
        "label": "Color",
        "default": "#FF0000"
      },
  {
        "fieldname": "Table MultiSelect",
        "fieldtype": "Table MultiSelect",
        "label": "Table MultiSelect",
        "options": "Option 1, Option 3"
      },
    {
        "fieldname": "Small Text",
        "fieldtype": "Small Text",
        "label": "Small Text"
      },
      {
        "fieldname": "Signature",
        "fieldtype": "Signature",
        "label": "Signature"
      }


 */

}
