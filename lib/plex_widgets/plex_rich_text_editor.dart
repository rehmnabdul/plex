import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// Output format for [PlexRichTextEditor].
enum PlexRichTextFormat {
  html,
  markdown,
  delta,
}

/// A rich text editor wrapping flutter_quill's QuillEditor and QuillSimpleToolbar.
class PlexRichTextEditor extends StatefulWidget {
  const PlexRichTextEditor({
    super.key,
    this.initialValue,
    this.outputFormat = PlexRichTextFormat.html,
    this.onChanged,
    this.placeholder,
    this.readOnly = false,
    this.minHeight = 200.0,
  });

  final String? initialValue;
  final PlexRichTextFormat outputFormat;
  final void Function(String value)? onChanged;
  final String? placeholder;
  final bool readOnly;
  final double minHeight;

  @override
  State<PlexRichTextEditor> createState() => _PlexRichTextEditorState();
}

class _PlexRichTextEditorState extends State<PlexRichTextEditor> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _controller.addListener(_onDocumentChanged);
  }

  QuillController _createController() {
    Document document;
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      final s = widget.initialValue!.trim();
      if (s.startsWith('[') && s.endsWith(']')) {
        try {
          final json = jsonDecode(s) as List;
          document = Document.fromJson(json);
        } catch (_) {
          document = Document()..insert(0, '$s\n');
        }
      } else if (s.startsWith('<')) {
        try {
          final delta = HtmlToDelta().convert(s, transformTableAsEmbed: false);
          document = Document.fromDelta(delta);
        } catch (_) {
          document = Document()..insert(0, '$s\n');
        }
      } else {
        document = Document()..insert(0, '$s\n');
      }
    } else {
      document = Document();
    }
    return QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: widget.readOnly,
    );
  }

  void _onDocumentChanged() {
    widget.onChanged?.call(_getOutputValue());
  }

  String _getOutputValue() {
    switch (widget.outputFormat) {
      case PlexRichTextFormat.delta:
        return jsonEncode(_controller.document.toDelta().toJson());
      case PlexRichTextFormat.html:
      case PlexRichTextFormat.markdown:
        return _controller.document.toPlainText();
    }
  }

  @override
  void didUpdateWidget(covariant PlexRichTextEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.readOnly != widget.readOnly) {
      _controller.readOnly = widget.readOnly;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onDocumentChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(PlexDim.small),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.readOnly)
            QuillSimpleToolbar(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(
                showUndo: true,
                showRedo: true,
                showBoldButton: true,
                showItalicButton: true,
                showUnderLineButton: true,
                showStrikeThrough: true,
                showInlineCode: false,
                showColorButton: false,
                showBackgroundColorButton: false,
                showClearFormat: true,
                showAlignmentButtons: false,
                showHeaderStyle: false,
                showListNumbers: true,
                showListBullets: true,
                showListCheck: false,
                showCodeBlock: false,
                showQuote: true,
                showIndent: false,
                showLink: true,
                showSubscript: false,
                showSuperscript: false,
                showSearchButton: false,
                showFontFamily: false,
                showFontSize: false,
                showDividers: true,
                showSmallButton: false,
                embedButtons: [],
              ),
            ),
          SizedBox(
            height: widget.minHeight,
            child: QuillEditor.basic(
              controller: _controller,
              config: QuillEditorConfig(
                placeholder: widget.placeholder ?? 'Write something...',
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A form field wrapper for [PlexRichTextEditor] with [PlexFormFieldGeneric].
class PlexFormFieldRichText extends StatelessWidget {
  const PlexFormFieldRichText({
    super.key,
    this.properties = const PlexFormFieldGeneric.empty(),
    this.initialValue,
    this.outputFormat = PlexRichTextFormat.html,
    this.onChanged,
    this.placeholder,
    this.readOnly = false,
    this.minHeight = 200.0,
  });

  final PlexFormFieldGeneric properties;
  final String? initialValue;
  final PlexRichTextFormat outputFormat;
  final void Function(String value)? onChanged;
  final String? placeholder;
  final bool readOnly;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final editor = PlexRichTextEditor(
      initialValue: initialValue,
      outputFormat: outputFormat,
      onChanged: onChanged,
      placeholder: placeholder,
      readOnly: readOnly,
      minHeight: minHeight,
    );

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (properties.title != null) ...[
          Text(
            properties.title!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        editor,
        if (properties.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            properties.helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ],
    );

    if (properties.useMargin) {
      return Padding(
        padding: properties.margin,
        child: child,
      );
    }
    return child;
  }
}
