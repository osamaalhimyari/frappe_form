import 'dart:convert';

class NonStandardFieldnames {
  NonStandardFieldnames({
    this.contact,
    this.blogger,
    this.accessLog,
    this.activityLog,
    this.energyPointLog,
    this.routeHistory,
    this.userPermission,
    this.documentFollow,
    this.communication,
    this.toDo,
    this.tokenCache,
    Map<String, String>? raw,
  }) : raw = raw ?? const {};

  factory NonStandardFieldnames.fromMap(Map<String, dynamic> data) {
    return NonStandardFieldnames(
      contact: data['Contact'] as String?,
      blogger: data['Blogger'] as String?,
      accessLog: data['Access Log'] as String?,
      activityLog: data['Activity Log'] as String?,
      energyPointLog: data['Energy Point Log'] as String?,
      routeHistory: data['Route History'] as String?,
      userPermission: data['User Permission'] as String?,
      documentFollow: data['Document Follow'] as String?,
      communication: data['Communication'] as String?,
      toDo: data['ToDo'] as String?,
      tokenCache: data['Token Cache'] as String?,
      // Keep the full doctype→fieldname map so callers can resolve
      // arbitrary connected doctypes (e.g. ERPNext's BOM → `item`),
      // not just the handful of typed getters above.
      raw: {
        for (final entry in data.entries)
          if (entry.value is String) entry.key: entry.value as String,
      },
    );
  }

  /// Untyped lookup for connected doctypes whose link field deviates
  /// from `dashboard.fieldname`. Empty when the parent dashboard had
  /// no `non_standard_fieldnames` block.
  final Map<String, String> raw;

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [NonStandardFieldnames].
  factory NonStandardFieldnames.fromJson(String data) {
    return NonStandardFieldnames.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }
  String? contact;
  String? blogger;
  String? accessLog;
  String? activityLog;
  String? energyPointLog;
  String? routeHistory;
  String? userPermission;
  String? documentFollow;
  String? communication;
  String? toDo;
  String? tokenCache;

  Map<String, dynamic> toMap() => {
        'Contact': contact,
        'Blogger': blogger,
        'Access Log': accessLog,
        'Activity Log': activityLog,
        'Energy Point Log': energyPointLog,
        'Route History': routeHistory,
        'User Permission': userPermission,
        'Document Follow': documentFollow,
        'Communication': communication,
        'ToDo': toDo,
        'Token Cache': tokenCache,
      };

  /// `dart:convert`
  ///
  /// Converts [NonStandardFieldnames] to a JSON string.
  String toJson() => json.encode(toMap());
}
