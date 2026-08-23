import 'package:flutter/material.dart';
import 'package:plex/plex_scanner.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_utils/plex_routing.dart';
import 'package:plex/plex_widgets/plex_mobile_list.dart';

export 'package:plex/plex_widgets/plex_mobile_list.dart'
    show PlexMobileList, PlexMobileTallyItem;

/// Shop-floor tally: [PlexMobileList] plus scan / typed-code increment.
///
/// Qty stays with the parent. A scan or typed submit finds a line via
/// [matchCode] (or [id] / [barcode]) then calls [onIncrement] and [onScanMatch].
class PlexMobileTally extends StatefulWidget {
  const PlexMobileTally({
    super.key,
    required this.items,
    this.onIncrement,
    this.onDecrement,
    this.onTap,
    this.onScanMatch,
    this.enableScanner = true,
    this.matchCode,
  });

  final List<PlexMobileTallyItem> items;
  final ValueChanged<PlexMobileTallyItem>? onIncrement;
  final ValueChanged<PlexMobileTallyItem>? onDecrement;
  final ValueChanged<PlexMobileTallyItem>? onTap;

  /// Fired after a scan or typed submit increments a matched line.
  final ValueChanged<PlexMobileTallyItem>? onScanMatch;

  /// When false, the Scan button does not push [PlexScanner].
  final bool enableScanner;

  /// Override default match (`code == item.id || code == item.barcode`).
  final bool Function(PlexMobileTallyItem item, String code)? matchCode;

  @override
  State<PlexMobileTally> createState() => _PlexMobileTallyState();
}

class _PlexMobileTallyState extends State<PlexMobileTally> {
  static const double _kTapMin = 40;

  final TextEditingController _codeController = TextEditingController();
  bool _noMatch = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  bool _matches(PlexMobileTallyItem item, String code) {
    final bool Function(PlexMobileTallyItem, String)? custom = widget.matchCode;
    if (custom != null) {
      return custom(item, code);
    }
    return code == item.id || code == item.barcode;
  }

  PlexMobileTallyItem? _findMatch(String code) {
    for (final PlexMobileTallyItem item in widget.items) {
      if (_matches(item, code)) {
        return item;
      }
    }
    return null;
  }

  void _applyCode(String raw) {
    final String code = raw.trim();
    final PlexMobileTallyItem? item =
        code.isEmpty ? null : _findMatch(code);
    setState(() {
      _noMatch = item == null;
    });
    if (item == null) {
      return;
    }
    _codeController.clear();
    widget.onIncrement?.call(item);
    widget.onScanMatch?.call(item);
  }

  void _submitTyped() {
    _applyCode(_codeController.text);
  }

  Future<void> _openScanner() async {
    if (!widget.enableScanner) {
      return;
    }
    final dynamic result = await Plex.to(() => const PlexScanner());
    if (!mounted) {
      return;
    }
    if (result is String) {
      _applyCode(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final BorderRadius radius = BorderRadius.circular(PlexRadius.md);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              height: _kTapMin,
              child: FilledButton(
                key: const Key('plex-mobile-tally-scan'),
                onPressed: widget.enableScanner ? _openScanner : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.brandPrimary,
                  foregroundColor: colors.textInverse,
                  disabledBackgroundColor: colors.surfaceSunken,
                  disabledForegroundColor: colors.textMuted,
                  minimumSize: const Size(_kTapMin, _kTapMin),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PlexDim.smallMedium,
                  ),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: radius),
                ),
                child: const Text('Scan'),
              ),
            ),
            const SizedBox(width: PlexDim.small),
            Expanded(
              child: SizedBox(
                height: _kTapMin,
                child: TextField(
                  key: const Key('plex-mobile-tally-code'),
                  controller: _codeController,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: PlexFontSize.body,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitTyped(),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: colors.surfaceSunken,
                    hintText: 'Code',
                    hintStyle: TextStyle(
                      color: colors.textMuted,
                      fontSize: PlexFontSize.body,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: PlexDim.smallMedium,
                      vertical: PlexDim.small,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: radius,
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: radius,
                      borderSide: BorderSide(color: colors.borderDefault),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: radius,
                      borderSide: BorderSide(color: colors.borderFocus),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: PlexDim.small),
            SizedBox(
              height: _kTapMin,
              child: FilledButton.tonal(
                key: const Key('plex-mobile-tally-submit'),
                onPressed: _submitTyped,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.surfaceSunken,
                  foregroundColor: colors.textPrimary,
                  minimumSize: const Size(_kTapMin, _kTapMin),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PlexDim.smallMedium,
                  ),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: radius),
                ),
                child: const Text('Go'),
              ),
            ),
          ],
        ),
        if (_noMatch) ...[
          const SizedBox(height: PlexDim.small),
          Text(
            'No match',
            key: const Key('plex-mobile-tally-nomatch'),
            style: TextStyle(
              color: colors.textMuted,
              fontSize: PlexFontSize.caption,
            ),
          ),
        ],
        const SizedBox(height: PlexDim.small),
        PlexMobileList(
          items: widget.items,
          onIncrement: widget.onIncrement,
          onDecrement: widget.onDecrement,
          onTap: widget.onTap,
        ),
      ],
    );
  }
}
