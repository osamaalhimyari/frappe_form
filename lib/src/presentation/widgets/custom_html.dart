import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
  CustomHtml({
    super.key,
    super.anchorKey,
    super.data,
    super.onLinkTap,
    super.onAnchorTap,
    super.extensions = const [],
    super.onCssParseError,
    super.shrinkWrap = true,
    super.onlyRenderTheseTags,
    super.doNotRenderTheseTags,
    Map<String, Style>? styleMap,
    Style? style,
  }) : super(
          style: styleMap ?? (style == null ? {} : {'body': style, 'p': style}),
        );
}
