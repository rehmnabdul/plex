import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';

/// Searchable single-select field. Not a replacement for
/// [PlexFormFieldAutoComplete] or [PlexFormFieldDropdown].
class PlexLookup<T> extends StatefulWidget {
  const PlexLookup({
    super.key,
    required this.items,
    required this.labelOf,
    this.value,
    this.onChanged,
    this.hint = 'Search',
    this.label,
    this.enabled = true,
    this.subtitleOf,
  });

  final List<T> items;
  final String Function(T item) labelOf;
  final String Function(T item)? subtitleOf;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String hint;
  final String? label;
  final bool enabled;

  @override
  State<PlexLookup<T>> createState() => _PlexLookupState<T>();
}

class _PlexLookupState<T> extends State<PlexLookup<T>> {
  Future<void> _openPicker() async {
    if (!widget.enabled) return;
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final bool compact = MediaQuery.sizeOf(context).width < 640;
    final Widget panel = _PlexLookupPanel<T>(
      items: widget.items,
      labelOf: widget.labelOf,
      subtitleOf: widget.subtitleOf,
      value: widget.value,
      hint: widget.hint,
      onChanged: widget.onChanged,
    );

    if (compact) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        backgroundColor: colors.surfaceCard,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SizedBox(
              height:
                  (MediaQuery.sizeOf(context).height * 0.6).clamp(280.0, 520.0),
              child: panel,
            ),
          );
        },
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: colors.surfaceCard,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PlexRadius.lg),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
              child: SizedBox(height: 480, child: panel),
            ),
          ),
        );
      },
    );
  }

  void _clear() {
    if (!widget.enabled) return;
    widget.onChanged?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final T? value = widget.value;
    final bool hasValue = value != null;
    final String display = hasValue ? widget.labelOf(value as T) : widget.hint;
    final BorderRadius radius = BorderRadius.circular(PlexRadius.md);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: colors.surfaceSunken,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color:
                  widget.enabled ? colors.borderDefault : colors.borderSubtle,
            ),
          ),
          child: InkWell(
            key: const Key('plex-lookup-field'),
            onTap: widget.enabled ? _openPicker : null,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PlexDim.small,
                vertical: PlexDim.small,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          const SizedBox(height: PlexDim.mini),
                        ],
                        Text(
                          display,
                          style: TextStyle(
                            color: !widget.enabled
                                ? colors.textDisabled
                                : hasValue
                                    ? colors.textPrimary
                                    : colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasValue)
                    IconButton(
                      tooltip: 'Clear',
                      visualDensity: VisualDensity.compact,
                      iconSize: PlexFontSize.large,
                      color: colors.textMuted,
                      onPressed: widget.enabled ? _clear : null,
                      icon: const Icon(Icons.close),
                    ),
                  Icon(
                    Icons.search,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PlexLookupPanel<T> extends StatefulWidget {
  const _PlexLookupPanel({
    required this.items,
    required this.labelOf,
    required this.subtitleOf,
    required this.value,
    required this.hint,
    required this.onChanged,
  });

  final List<T> items;
  final String Function(T item) labelOf;
  final String Function(T item)? subtitleOf;
  final T? value;
  final String hint;
  final ValueChanged<T?>? onChanged;

  @override
  State<_PlexLookupPanel<T>> createState() => _PlexLookupPanelState<T>();
}

class _PlexLookupPanelState<T> extends State<_PlexLookupPanel<T>> {
  late final TextEditingController _query;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _query = TextEditingController();
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<T> _filtered() {
    final String query = _filter.trim().toLowerCase();
    if (query.isEmpty) return widget.items;
    return widget.items.where((T item) {
      if (widget.labelOf(item).toLowerCase().contains(query)) return true;
      final String? subtitle = widget.subtitleOf?.call(item);
      return subtitle != null && subtitle.toLowerCase().contains(query);
    }).toList();
  }

  InputDecoration _searchDecoration(PlexColorTokens colors) {
    final BorderRadius radius = BorderRadius.circular(PlexRadius.md);
    return InputDecoration(
      filled: true,
      fillColor: colors.surfaceSunken,
      hintText: widget.hint,
      hintStyle: TextStyle(color: colors.textMuted),
      prefixIcon: Icon(Icons.search, color: colors.textMuted),
      isDense: true,
      border: OutlineInputBorder(
        gapPadding: PlexDim.smallest,
        borderRadius: radius,
      ),
      enabledBorder: OutlineInputBorder(
        gapPadding: PlexDim.smallest,
        borderRadius: radius,
        borderSide: BorderSide(color: colors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: PlexDim.smallest,
        borderRadius: radius,
        borderSide: BorderSide(color: colors.borderFocus, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final List<T> visible = _filtered();

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PlexDim.medium,
        PlexDim.small,
        PlexDim.medium,
        PlexDim.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('plex-lookup-search'),
            controller: _query,
            autofocus: true,
            onChanged: (String value) => setState(() => _filter = value),
            style: TextStyle(color: colors.textPrimary),
            decoration: _searchDecoration(colors),
          ),
          const SizedBox(height: PlexDim.small),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      'No matches',
                      style: TextStyle(color: colors.textMuted),
                    ),
                  )
                : ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (BuildContext context, int index) {
                      final T item = visible[index];
                      final String label = widget.labelOf(item);
                      final String? subtitle = widget.subtitleOf?.call(item);
                      final bool selected = widget.value == item;
                      return ListTile(
                        key: Key('plex-lookup-item-$label'),
                        selected: selected,
                        selectedTileColor:
                            colors.brandPrimary.withValues(alpha: 0.12),
                        title: Text(
                          label,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        subtitle: subtitle == null
                            ? null
                            : Text(
                                subtitle,
                                style: TextStyle(color: colors.textSecondary),
                              ),
                        onTap: () {
                          widget.onChanged?.call(item);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
