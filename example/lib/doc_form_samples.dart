class DocFormSamples {
  static const fieldTest = r'''
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
					"doctype": "DocField",
					"name": "1uimps9dn8",
					"creation": "2013-03-07 18:50:30",
					"modified": "2025-11-25 13:52:06.641829",
					"modified_by": "Administrator",
					"owner": "Administrator",
					"docstatus": 0,
					"parent": "Opportunity",
					"parentfield": "fields",
					"parenttype": "DocType",
					"idx": 2,
					"fieldname": "opportunity_from",
					"label": "Opportunity From",
					"oldfieldname": "enquiry_from",
					"fieldtype": "Link",
					"oldfieldtype": "Select",
					"options": "DocType",
					"search_index": 0,
					"show_dashboard": 0,
					"hidden": 0,
					"set_only_once": 0,
					"allow_in_quick_entry": 0,
					"print_hide": 1,
					"report_hide": 0,
					"reqd": 1,
					"bold": 0,
					"in_global_search": 0,
					"collapsible": 0,
					"unique": 0,
					"no_copy": 0,
					"allow_on_submit": 0,
					"show_preview_popup": 0,
					"permlevel": 0,
					"ignore_user_permissions": 0,
					"columns": 0,
					"in_list_view": 1,
					"fetch_if_empty": 0,
					"in_filter": 0,
					"remember_last_selected_value": 0,
					"ignore_xss_filter": 0,
					"print_hide_if_no_value": 0,
					"allow_bulk_edit": 0,
					"in_standard_filter": 1,
					"in_preview": 0,
					"read_only": 0,
					"length": 0,
					"translatable": 0,
					"hide_border": 0,
					"hide_days": 0,
					"hide_seconds": 0,
					"non_negative": 0,
					"is_virtual": 0,
					"sort_options": 0,
					"show_on_timeline": 0,
					"make_attachment_public": 0,
					"linked_document_type": "Document",
					"fields": [],
					"permissions": [],
					"actions": [],
					"links": [],
					"states": [],
					"search_fields": [
						"module"
					],
					"is_custom_field": null
				},
				{
					"doctype": "DocField",
					"name": "1ui82ha1lk",
					"creation": "2013-03-07 18:50:30",
					"modified": "2025-11-25 13:52:06.641829",
					"modified_by": "Administrator",
					"owner": "Administrator",
					"docstatus": 0,
					"parent": "Opportunity",
					"parentfield": "fields",
					"parenttype": "DocType",
					"idx": 3,
					"fieldname": "party_name",
					"label": "Party",
					"oldfieldname": "customer",
					"fieldtype": "Dynamic Link",
					"oldfieldtype": "Link",
					"options": "opportunity_from",
					"search_index": 0,
					"show_dashboard": 0,
					"hidden": 0,
					"set_only_once": 0,
					"allow_in_quick_entry": 0,
					"print_hide": 1,
					"report_hide": 0,
					"reqd": 1,
					"bold": 1,
					"in_global_search": 0,
					"collapsible": 0,
					"unique": 0,
					"no_copy": 0,
					"allow_on_submit": 0,
					"show_preview_popup": 0,
					"permlevel": 0,
					"ignore_user_permissions": 0,
					"columns": 0,
					"in_list_view": 0,
					"fetch_if_empty": 0,
					"in_filter": 0,
					"remember_last_selected_value": 0,
					"ignore_xss_filter": 0,
					"print_hide_if_no_value": 0,
					"allow_bulk_edit": 0,
					"in_standard_filter": 1,
					"in_preview": 0,
					"read_only": 0,
					"length": 0,
					"translatable": 0,
					"hide_border": 0,
					"hide_days": 0,
					"hide_seconds": 0,
					"non_negative": 0,
					"is_virtual": 0,
					"sort_options": 0,
					"show_on_timeline": 0,
					"make_attachment_public": 0,
					"fields": [],
					"permissions": [],
					"actions": [],
					"links": [],
					"states": [],
					"search_fields": null,
					"is_custom_field": null,
					"linked_document_type": null
				}
    ],
    			"__js": "\n\n/* Adding apps/erpnext/erpnext/crm/doctype/opportunity/opportunity.js */\n\n// Copyright (c) 2015, Frappe Technologies Pvt. Ltd. and Contributors\n// License: GNU General Public License v3. See license.txt\nfrappe.provide(\"erpnext.crm\");\nerpnext.pre_sales.set_as_lost(\"Opportunity\");\nerpnext.sales_common.setup_selling_controller();\n\nfrappe.ui.form.on(\"Opportunity\", {\n\tsetup: function (frm) {\n\t\tfrm.custom_make_buttons = {\n\t\t\tQuotation: \"Quotation\",\n\t\t\t\"Supplier Quotation\": \"Supplier Quotation\",\n\t\t};\n\n\t\tfrm.set_query(\"opportunity_from\", function () {\n\t\t\treturn {\n\t\t\t\tfilters: {\n\t\t\t\t\tname: [\"in\", [\"Customer\", \"Lead\", \"Prospect\"]],\n\t\t\t\t},\n\t\t\t};\n\t\t});\n\n\t\tfrm.email_field = \"contact_email\";\n\t},\n\n\tvalidate: function (frm) {\n\t\tif (frm.doc.status == \"Lost\" && !frm.doc.lost_reasons.length) {\n\t\t\tfrm.trigger(\"set_as_lost_dialog\");\n\t\t\tfrappe.throw(__(\"Lost Reasons are required in case opportunity is Lost.\"));\n\t\t}\n\t},\n\n\tonload_post_render: function (frm) {\n\t\tfrm.get_field(\"items\").grid.set_multiple_add(\"item_code\", \"qty\");\n\t},\n\n\tparty_name: function (frm) {\n\t\tfrm.trigger(\"set_contact_link\");\n\n\t\tif (frm.doc.opportunity_from == \"Customer\") {\n\t\t\terpnext.utils.get_party_details(frm);\n\t\t} else if (frm.doc.opportunity_from == \"Lead\") {\n\t\t\terpnext.utils.map_current_doc({\n\t\t\t\tmethod: \"erpnext.crm.doctype.lead.lead.make_opportunity\",\n\t\t\t\tsource_name: frm.doc.party_name,\n\t\t\t\tfrm: frm,\n\t\t\t});\n\t\t}\n\t},\n\n\tstatus: function (frm) {\n\t\tif (frm.doc.status == \"Lost\") {\n\t\t\tfrm.trigger(\"set_as_lost_dialog\");\n\t\t}\n\t},\n\n\tcustomer_address: function (frm, cdt, cdn) {\n\t\terpnext.utils.get_address_display(frm, \"customer_address\", \"address_display\", false);\n\t},\n\n\tcontact_person: erpnext.utils.get_contact_details,\n\n\topportunity_from: function (frm) {\n\t\tfrm.trigger(\"setup_opportunity_from\");\n\n\t\tfrm.set_value(\"party_name\", \"\");\n\t},\n\n\tsetup_opportunity_from: function (frm) {\n\t\tfrm.trigger(\"setup_queries\");\n\t\tfrm.trigger(\"set_dynamic_field_label\");\n\t},\n\n\trefresh: function (frm) {\n\t\tvar doc = frm.doc;\n\t\tfrm.trigger(\"setup_opportunity_from\");\n\t\terpnext.toggle_naming_series();\n\n\t\tif (!frm.is_new() && doc.status !== \"Lost\") {\n\t\t\tif (doc.items) {\n\t\t\t\tfrm.add_custom_button(\n\t\t\t\t\t__(\"Supplier Quotation\"),\n\t\t\t\t\tfunction () {\n\t\t\t\t\t\tfrm.trigger(\"make_supplier_quotation\");\n\t\t\t\t\t},\n\t\t\t\t\t__(\"Create\")\n\t\t\t\t);\n\n\t\t\t\tfrm.add_custom_button(\n\t\t\t\t\t__(\"Request For Quotation\"),\n\t\t\t\t\tfunction () {\n\t\t\t\t\t\tfrm.trigger(\"make_request_for_quotation\");\n\t\t\t\t\t},\n\t\t\t\t\t__(\"Create\")\n\t\t\t\t);\n\t\t\t}\n\n\t\t\tif (frm.doc.opportunity_from != \"Customer\") {\n\t\t\t\tfrm.add_custom_button(\n\t\t\t\t\t__(\"Customer\"),\n\t\t\t\t\tfunction () {\n\t\t\t\t\t\tfrm.trigger(\"make_customer\");\n\t\t\t\t\t},\n\t\t\t\t\t__(\"Create\")\n\t\t\t\t);\n\t\t\t}\n\n\t\t\tfrm.add_custom_button(\n\t\t\t\t__(\"Quotation\"),\n\t\t\t\tfunction () {\n\t\t\t\t\tfrm.trigger(\"create_quotation\");\n\t\t\t\t},\n\t\t\t\t__(\"Create\")\n\t\t\t);\n\n\t\t\tlet company_currency = erpnext.get_currency(frm.doc.company);\n\t\t\tif (company_currency != frm.doc.currency) {\n\t\t\t\tfrm.add_custom_button(__(\"Fetch Latest Exchange Rate\"), function () {\n\t\t\t\t\tfrm.trigger(\"currency\");\n\t\t\t\t});\n\t\t\t}\n\t\t}\n\n\t\tif (!frm.doc.__islocal && frm.perm[0].write && frm.doc.docstatus == 0) {\n\t\t\tif (frm.doc.status === \"Open\") {\n\t\t\t\tfrm.add_custom_button(__(\"Close\"), function () {\n\t\t\t\t\tfrm.set_value(\"status\", \"Closed\");\n\t\t\t\t\tfrm.save();\n\t\t\t\t});\n\t\t\t} else {\n\t\t\t\tfrm.add_custom_button(__(\"Reopen\"), function () {\n\t\t\t\t\tfrm.set_value(\"lost_reasons\", []);\n\t\t\t\t\tfrm.set_value(\"status\", \"Open\");\n\t\t\t\t\tfrm.save();\n\t\t\t\t});\n\t\t\t}\n\t\t}\n\n\t\tif (!frm.is_new()) {\n\t\t\tfrappe.contacts.render_address_and_contact(frm);\n\t\t\t// frm.trigger('render_contact_day_html');\n\t\t} else {\n\t\t\tfrappe.contacts.clear_address_and_contact(frm);\n\t\t}\n\n\t\tif (frm.doc.opportunity_from && frm.doc.party_name) {\n\t\t\tfrm.trigger(\"set_contact_link\");\n\t\t}\n\t},\n\n\tset_contact_link: function (frm) {\n\t\tif (frm.doc.opportunity_from == \"Customer\" && frm.doc.party_name) {\n\t\t\tfrappe.dynamic_link = { doc: frm.doc, fieldname: \"party_name\", doctype: \"Customer\" };\n\t\t} else if (frm.doc.opportunity_from == \"Lead\" && frm.doc.party_name) {\n\t\t\tfrappe.dynamic_link = { doc: frm.doc, fieldname: \"party_name\", doctype: \"Lead\" };\n\t\t} else if (frm.doc.opportunity_from == \"Prospect\" && frm.doc.party_name) {\n\t\t\tfrappe.dynamic_link = { doc: frm.doc, fieldname: \"party_name\", doctype: \"Prospect\" };\n\t\t}\n\t},\n\n\tcurrency: function (frm) {\n\t\tlet company_currency = erpnext.get_currency(frm.doc.company);\n\t\tif (company_currency != frm.doc.currency) {\n\t\t\tfrappe.call({\n\t\t\t\tmethod: \"erpnext.setup.utils.get_exchange_rate\",\n\t\t\t\targs: {\n\t\t\t\t\tfrom_currency: frm.doc.currency,\n\t\t\t\t\tto_currency: company_currency,\n\t\t\t\t},\n\t\t\t\tcallback: function (r) {\n\t\t\t\t\tif (r.message) {\n\t\t\t\t\t\tfrm.set_value(\"conversion_rate\", flt(r.message));\n\t\t\t\t\t\tfrm.set_df_property(\n\t\t\t\t\t\t\t\"conversion_rate\",\n\t\t\t\t\t\t\t\"description\",\n\t\t\t\t\t\t\t\"1 \" + frm.doc.currency + \" = [?] \" + company_currency\n\t\t\t\t\t\t);\n\t\t\t\t\t}\n\t\t\t\t},\n\t\t\t});\n\t\t} else {\n\t\t\tfrm.set_value(\"conversion_rate\", 1.0);\n\t\t\tfrm.set_df_property(\"conversion_rate\", \"hidden\", 1);\n\t\t\tfrm.set_df_property(\"conversion_rate\", \"description\", \"\");\n\t\t}\n\n\t\tfrm.trigger(\"opportunity_amount\");\n\t\tfrm.trigger(\"set_dynamic_field_label\");\n\t},\n\n\topportunity_amount: function (frm) {\n\t\tfrm.set_value(\n\t\t\t\"base_opportunity_amount\",\n\t\t\tflt(frm.doc.opportunity_amount) * flt(frm.doc.conversion_rate)\n\t\t);\n\t},\n\n\tset_dynamic_field_label: function (frm) {\n\t\tif (frm.doc.opportunity_from) {\n\t\t\tfrm.set_df_property(\"party_name\", \"label\", frm.doc.opportunity_from);\n\t\t}\n\t\tfrm.trigger(\"change_grid_labels\");\n\t\tfrm.trigger(\"change_form_labels\");\n\t},\n\n\tmake_supplier_quotation: function (frm) {\n\t\tfrappe.model.open_mapped_doc({\n\t\t\tmethod: \"erpnext.crm.doctype.opportunity.opportunity.make_supplier_quotation\",\n\t\t\tfrm: frm,\n\t\t});\n\t},\n\n\tmake_request_for_quotation: function (frm) {\n\t\tfrappe.model.open_mapped_doc({\n\t\t\tmethod: \"erpnext.crm.doctype.opportunity.opportunity.make_request_for_quotation\",\n\t\t\tfrm: frm,\n\t\t});\n\t},\n\n\tchange_form_labels: function (frm) {\n\t\tlet company_currency = erpnext.get_currency(frm.doc.company);\n\t\tfrm.set_currency_labels([\"base_opportunity_amount\", \"base_total\"], company_currency);\n\t\tfrm.set_currency_labels([\"opportunity_amount\", \"total\"], frm.doc.currency);\n\n\t\t// toggle fields\n\t\tfrm.toggle_display(\n\t\t\t[\"conversion_rate\", \"base_opportunity_amount\", \"base_total\"],\n\t\t\tfrm.doc.currency != company_currency\n\t\t);\n\t},\n\n\tchange_grid_labels: function (frm) {\n\t\tlet company_currency = erpnext.get_currency(frm.doc.company);\n\t\tfrm.set_currency_labels([\"base_rate\", \"base_amount\"], company_currency, \"items\");\n\t\tfrm.set_currency_labels([\"rate\", \"amount\"], frm.doc.currency, \"items\");\n\n\t\tlet item_grid = frm.fields_dict.items.grid;\n\t\t$.each([\"base_rate\", \"base_amount\"], function (i, fname) {\n\t\t\tif (frappe.meta.get_docfield(item_grid.doctype, fname))\n\t\t\t\titem_grid.set_column_disp(fname, frm.doc.currency != company_currency);\n\t\t});\n\t\tfrm.refresh_fields();\n\t},\n\n\tcalculate_total: function (frm) {\n\t\tlet total = 0,\n\t\t\tbase_total = 0;\n\t\tfrm.doc.items.forEach((item) => {\n\t\t\ttotal += item.amount;\n\t\t\tbase_total += item.base_amount;\n\t\t});\n\n\t\tfrm.set_value({\n\t\t\ttotal: flt(total),\n\t\t\tbase_total: flt(base_total),\n\t\t});\n\t},\n});\nfrappe.ui.form.on(\"Opportunity Item\", {\n\tcalculate: function (frm, cdt, cdn) {\n\t\tlet row = frappe.get_doc(cdt, cdn);\n\t\tfrappe.model.set_value(cdt, cdn, \"amount\", flt(row.qty) * flt(row.rate));\n\t\tfrappe.model.set_value(cdt, cdn, \"base_rate\", flt(frm.doc.conversion_rate) * flt(row.rate));\n\t\tfrappe.model.set_value(cdt, cdn, \"base_amount\", flt(frm.doc.conversion_rate) * flt(row.amount));\n\t\tfrm.trigger(\"calculate_total\");\n\t},\n\tqty: function (frm, cdt, cdn) {\n\t\tfrm.trigger(\"calculate\", cdt, cdn);\n\t},\n\trate: function (frm, cdt, cdn) {\n\t\tfrm.trigger(\"calculate\", cdt, cdn);\n\t},\n});\n\n// TODO commonify this code\nerpnext.crm.Opportunity = class Opportunity extends frappe.ui.form.Controller {\n\tonload() {\n\t\tif (!this.frm.doc.status) {\n\t\t\tthis.frm.set_value(\"status\", \"Open\");\n\t\t}\n\t\tif (!this.frm.doc.company && frappe.defaults.get_user_default(\"Company\")) {\n\t\t\tthis.frm.set_value(\"company\", frappe.defaults.get_user_default(\"Company\"));\n\t\t}\n\t\tif (!this.frm.doc.currency) {\n\t\t\tthis.frm.set_value(\"currency\", frappe.defaults.get_user_default(\"Currency\"));\n\t\t}\n\n\t\tif (this.frm.is_new() && this.frm.doc.opportunity_type === undefined) {\n\t\t\tthis.frm.doc.opportunity_type = __(\"Sales\");\n\t\t}\n\t\tthis.setup_queries();\n\t}\n\n\trefresh() {\n\t\tthis.show_notes();\n\t\tthis.show_activities();\n\t}\n\n\tsetup_queries() {\n\t\tvar me = this;\n\n\t\tme.frm.set_query(\"customer_address\", erpnext.queries.address_query);\n\n\t\tthis.frm.set_query(\"item_code\", \"items\", function () {\n\t\t\treturn {\n\t\t\t\tquery: \"erpnext.controllers.queries.item_query\",\n\t\t\t\tfilters: { is_sales_item: 1 },\n\t\t\t};\n\t\t});\n\n\t\tme.frm.set_query(\"contact_person\", erpnext.queries[\"contact_query\"]);\n\n\t\tif (me.frm.doc.opportunity_from == \"Lead\") {\n\t\t\tme.frm.set_query(\"party_name\", erpnext.queries[\"lead\"]);\n\t\t} else if (me.frm.doc.opportunity_from == \"Customer\") {\n\t\t\tme.frm.set_query(\"party_name\", erpnext.queries[\"customer\"]);\n\t\t} else if (me.frm.doc.opportunity_from == \"Prospect\") {\n\t\t\tme.frm.set_query(\"party_name\", function () {\n\t\t\t\treturn {\n\t\t\t\t\tfilters: {\n\t\t\t\t\t\tcompany: me.frm.doc.company,\n\t\t\t\t\t},\n\t\t\t\t};\n\t\t\t});\n\t\t}\n\t}\n\n\tcreate_quotation() {\n\t\tfrappe.model.open_mapped_doc({\n\t\t\tmethod: \"erpnext.crm.doctype.opportunity.opportunity.make_quotation\",\n\t\t\tfrm: cur_frm,\n\t\t});\n\t}\n\n\tmake_customer() {\n\t\tfrappe.model.open_mapped_doc({\n\t\t\tmethod: \"erpnext.crm.doctype.opportunity.opportunity.make_customer\",\n\t\t\tfrm: cur_frm,\n\t\t});\n\t}\n\n\tshow_notes() {\n\t\tconst crm_notes = new erpnext.utils.CRMNotes({\n\t\t\tfrm: this.frm,\n\t\t\tnotes_wrapper: $(this.frm.fields_dict.notes_html.wrapper),\n\t\t});\n\t\tcrm_notes.refresh();\n\t}\n\n\tshow_activities() {\n\t\tconst crm_activities = new erpnext.utils.CRMActivities({\n\t\t\tfrm: this.frm,\n\t\t\topen_activities_wrapper: $(this.frm.fields_dict.open_activities_html.wrapper),\n\t\t\tall_activities_wrapper: $(this.frm.fields_dict.all_activities_html.wrapper),\n\t\t\tform_wrapper: $(this.frm.wrapper),\n\t\t});\n\t\tcrm_activities.refresh();\n\t}\n};\n\nextend_cscript(cur_frm.cscript, new erpnext.crm.Opportunity({ frm: cur_frm }));\n\ncur_frm.cscript.item_code = function (doc, cdt, cdn) {\n\tvar d = locals[cdt][cdn];\n\tif (d.item_code) {\n\t\treturn frappe.call({\n\t\t\tmethod: \"erpnext.crm.doctype.opportunity.opportunity.get_item_details\",\n\t\t\targs: { item_code: d.item_code },\n\t\t\tcallback: function (r, rt) {\n\t\t\t\tif (r.message) {\n\t\t\t\t\t$.each(r.message, function (k, v) {\n\t\t\t\t\t\tfrappe.model.set_value(cdt, cdn, k, v);\n\t\t\t\t\t});\n\t\t\t\t\trefresh_field(\"image_view\", d.name, \"items\");\n\t\t\t\t}\n\t\t\t},\n\t\t});\n\t}\n};\n\n\n//# sourceURL=opportunity__js",

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
