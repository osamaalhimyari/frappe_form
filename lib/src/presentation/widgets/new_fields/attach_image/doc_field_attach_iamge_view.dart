// ignore_for_file: overridden_fields

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DocFieldAttachIamgeView extends DocFieldView {
  final Future<Attachment?> Function()? onAttachmentLoaded;
  final String baseUrl;

  DocFieldAttachIamgeView({
    super.key,
    CustomValueController<Attachment>? controller,
    required super.field,
    required this.onAttachmentLoaded,
    required this.baseUrl,
    super.dependsOnController,
  }) : super(
          controller: controller ??
              CustomValueController<Attachment>(focusNode: FocusNode()),
        );

  @override
  CustomValueController<Attachment> get controller =>
      super.controller as CustomValueController<Attachment>;

  @override
  void initController() {
    super.initController();
    
    // Transform the initial string URL from Frappe into an Attachment object
    if (controller.value == null && field.initial != null && field.initial.toString().isNotEmpty) {
      final initialUrl = field.initial.toString();
      controller.value = Attachment(
        url: initialUrl,
        path: initialUrl,
        mediaType: _getMediaType(initialUrl),
      );
    }
  }

  String _getMediaType(String url) {
    final lower = url.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg'; // default
  }

  @override
  State<DocFieldAttachIamgeView> createState() => DocFieldAttachIamgeViewState();
}

class DocFieldAttachIamgeViewState<SF extends DocFieldAttachIamgeView>
    extends DocFieldViewState<SF> {
  bool isLoading = false;

  @override
  CustomValueController<Attachment> get controller =>
      super.controller as CustomValueController<Attachment>;

  Attachment? get value => controller.value;
  set value(Attachment? val) => controller.value = val;

  /// Combines relative Frappe paths with the baseUrl
  String? _buildSafeImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) return null;
    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) return rawUrl;
    
    try {
      final baseUri = Uri.parse(widget.baseUrl);
      return baseUri.resolve(rawUrl).toString();
    } catch (e) {
      return rawUrl;
    }
  }

  @override
  Widget? buildTitleView(BuildContext context) {
    if (field.title.isEmpty) return null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(field.title, style: theme.textTheme.titleSmall),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    final imageUrl = _buildSafeImageUrl(value?.url ?? value?.path) ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───────── IMAGE PREVIEW AREA ─────────
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: value == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildImageWidget(imageUrl),
                    ),
                  ),
                ),
        ),

        // ───────── ACTION BUTTONS ─────────
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isReadOnly || isLoading ? null : _onBtnUpload,
                icon: isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(value == null ? Icons.upload_file : Icons.refresh),
                label: Text(
                  value == null
                      ? DocFormLocalization.instance.localization.btnUpload
                      : DocFormLocalization.instance.localization.btnChange,
                ),
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: isReadOnly || isLoading ? null : _onBtnRemove,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.error,
                ),
                icon: const Icon(Icons.delete_outline),
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    // Check if it's a local file first (for newly picked images)
    if (!kIsWeb && value!.path.isNotEmpty && File((value!.path??'')).existsSync()) {
      return Image.file(
        File(value!.path??''),
        height: 200,
        fit: BoxFit.cover,
      );
    }

    // If it's an image from the server
    if (value?.isImage ?? true) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
          height: 200,
          color: theme.dividerColor.withAlpha(255~/0.1),
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 200,
          color: theme.dividerColor.withAlpha(255~/0.1),
          child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      );
    }

    // Fallback for non-image files
    return Container(
      height: 100,
      width: double.infinity,
      color: theme.dividerColor.withAlpha(255~/0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 48),
          Text((value?.url??'').split('/').last),
        ],
      ),
    );
  }

  Future<void> _onBtnUpload() async {
    setState(() => isLoading = true);
    try {
      final temp = await widget.onAttachmentLoaded?.call();
      if (temp != null) {
        setState(() => value = temp);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _onBtnRemove() async {
    setState(() => value = null);
  }
}