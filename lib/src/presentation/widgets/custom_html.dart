import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

extension HtmlStyle on TextStyle {
  Style get asHtmlStyle => Style(
    padding: HtmlPaddings.zero,
    margin: Margins.zero,
    fontSize: fontSize == null ? null : FontSize(fontSize!),
    fontWeight: fontWeight,
    color: color,
    textAlign: TextAlign.start,
    fontFamily: fontFamily,
  );
}

class CustomHtml extends Html {
  static OnTap defaultOnLinkTap = (url, attributes, element) {
    final Uri? uri = Uri.tryParse(url ?? '');
    if (uri != null) {
      launchUrl(uri);
    }
  };

  CustomHtml({
    super.key,
    super.anchorKey,
    super.data,
    OnTap? onLinkTap,
    super.onAnchorTap,
    super.extensions = const [],
    super.onCssParseError,
    super.shrinkWrap = true,
    super.onlyRenderTheseTags,
    super.doNotRenderTheseTags,
    Map<String, Style>? styleMap,
    Style? style,
  }) : super(
         onLinkTap: onLinkTap ?? defaultOnLinkTap,
         style: styleMap ?? (style == null ? {} : {'body': style, 'p': style}),
       );
}
