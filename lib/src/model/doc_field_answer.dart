import 'package:adeptannotations/adeptannotations.dart';
import 'package:frappe_form/src/entity/enumerator/field_type.dart';
import 'package:frappe_form/src/logic/utils/text_utils.dart';

part 'doc_field_answer.g.dart';

@CopyWith()
class DocFieldAnswer {
  final FieldType? type;
  final String? name;
  final dynamic value;

  DocFieldAnswer({required this.type, this.name, this.value});

  // List<Map<String, dynamic>> _toAnswerMap(List items) {
  //   if(items.isEmpty) return [];
  //   List<Map<String, dynamic>> mapList = [];
  //   for (var item in value as List) {
  //     final result = _toAnswerMap(item);
  //     if(result.isEmpty) continue;
  //     mapList.add(result);
  //   }
  //
  //   return {};
  // }

  Map<String, dynamic> toAnswerMap() {
    if (name.isEmpty || (value?.toString().isEmpty ?? true)) {
      return {};
    }
    dynamic valueParsed;
    if (value is List) {
      List<Map<String, dynamic>> mapList = [];
      for (var item in value as List) {
        if (item == null) continue;
        if (item is List<DocFieldAnswer>) {
          Map<String, dynamic> itemMap = {};
          for (final itemField in item) {
            final mapValue = itemField.toAnswerMap();
            if (mapValue.isEmpty) continue;
            itemMap.addAll(mapValue);
          }
          if (itemMap.isNotEmpty) {
            mapList.add(itemMap);
          }
        } else if (item is DocFieldAnswer) {
          final mapValue = item.toAnswerMap();
          if (mapValue.isEmpty) continue;
          mapList.add(mapValue);
        } else if (item is Map<String, dynamic>) {
          if (item.isEmpty) continue;
          mapList.add(item);
        }
      }
      if (mapList.isNotEmpty) {
        valueParsed = mapList;
      }
    } else {
      valueParsed = value;
    }
    if (valueParsed == null) return {};
    return {name!: valueParsed};
  }
}
