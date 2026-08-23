import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Compact interactive chip. Not a [PlexBadge].
class PlexTag extends StatelessWidget {
  const PlexTag({
    super.key,
    required this.label,
    this.onDeleted,
    this.selected = false,
    this.onTap,
    this.color,
  });

  final String label;
  final VoidCallback? onDeleted;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final Color accent =
        selected ? colors.brandPrimary : (color ?? colors.textSecondary);
    final Color background = selected
        ? colors.brandPrimary.withValues(alpha: 0.14)
        : (color?.withValues(alpha: 0.14) ?? colors.surfaceSunken);
    final Color foreground =
        selected ? colors.brandPrimary : (color ?? colors.textPrimary);
    final BorderRadius radius = BorderRadius.circular(PlexRadius.sm);

    return Material(
      key: Key('plex-tag-$label'),
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: accent.withValues(alpha: 0.45)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            PlexDim.small,
            PlexDim.smallest,
            onDeleted != null ? PlexDim.mini : PlexDim.small,
            PlexDim.smallest,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: PlexFontSize.caption,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: PlexDim.mini),
                InkResponse(
                  onTap: onDeleted,
                  radius: PlexDim.medium,
                  child: Icon(
                    Icons.close,
                    size: PlexFontSize.normal,
                    color: foreground,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrap of [PlexTag]s plus a field that appends unique trimmed tags on submit.
class PlexTagInput extends StatefulWidget {
  const PlexTagInput({
    super.key,
    required this.tags,
    this.onChanged,
    this.hint = 'Add tag',
    this.label,
  });

  final List<String> tags;
  final ValueChanged<List<String>>? onChanged;
  final String hint;
  final String? label;

  @override
  State<PlexTagInput> createState() => _PlexTagInputState();
}

class _PlexTagInputState extends State<PlexTagInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String raw) {
    final String tag = raw.trim();
    _controller.clear();
    if (tag.isEmpty) return;
    final bool exists = widget.tags.any(
      (String existing) => existing.toLowerCase() == tag.toLowerCase(),
    );
    if (exists) return;
    widget.onChanged?.call(List<String>.of(widget.tags)..add(tag));
  }

  void _remove(String tag) {
    final List<String> next = List<String>.of(widget.tags)..remove(tag);
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final BorderRadius radius = BorderRadius.circular(PlexRadius.md);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: PlexFontSize.small,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: PlexDim.smallest),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: PlexDim.small,
            vertical: PlexDim.small,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceSunken,
            borderRadius: radius,
            border: Border.all(color: colors.borderDefault),
          ),
          child: Wrap(
            spacing: PlexDim.small,
            runSpacing: PlexDim.small,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final String tag in widget.tags)
                PlexTag(
                  label: tag,
                  onDeleted: () => _remove(tag),
                ),
              SizedBox(
                width: 160,
                child: TextField(
                  key: const Key('plex-tag-input-field'),
                  controller: _controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: _submit,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: PlexFontSize.body,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hint,
                    hintStyle: TextStyle(color: colors.textMuted),
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: PlexDim.smallest,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
