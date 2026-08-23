import 'package:flutter/material.dart';
import 'package:plex/plex_theme.dart';
import 'package:plex/plex_utils/plex_dimensions.dart';
import 'package:plex/plex_widgets/plex_badge.dart';
import 'package:plex/plex_widgets/plex_form_field_widgets.dart';

/// One page in a [PlexWizard].
class PlexWizardStep {
  const PlexWizardStep({
    required this.title,
    required this.child,
    this.subtitle,
    this.optional = false,
    this.validator,
  });

  final String title;
  final Widget child;
  final String? subtitle;
  final bool optional;
  final bool Function()? validator;
}

/// Rail orientation for [PlexWizard]. Default [horizontal] preserves the
/// original top numbered row.
enum PlexWizardAxis { horizontal, vertical }

/// Linear multi-step flow: numbered rail, step panel, Back / Next / Finish.
///
/// Opt-in widget — does not replace login, routing, or [PlexTabs].
/// Set [allowStepJump] to tap rail items and skip validators.
class PlexWizard extends StatefulWidget {
  const PlexWizard({
    super.key,
    required this.steps,
    this.onComplete,
    this.onStepChanged,
    this.axis = PlexWizardAxis.horizontal,
    this.allowStepJump = false,
  }) : assert(steps.length > 0, 'PlexWizard requires at least one step');

  final List<PlexWizardStep> steps;
  final VoidCallback? onComplete;
  final ValueChanged<int>? onStepChanged;
  final PlexWizardAxis axis;
  final bool allowStepJump;

  @override
  State<PlexWizard> createState() => _PlexWizardState();
}

class _PlexWizardState extends State<PlexWizard> {
  int _index = 0;

  bool get _isFirst => _index <= 0;

  bool get _isLast => _index >= widget.steps.length - 1;

  bool _passesValidator() {
    final bool Function()? validator = widget.steps[_index].validator;
    return validator == null || validator();
  }

  void _goBack() {
    if (_isFirst) return;
    setState(() => _index -= 1);
    widget.onStepChanged?.call(_index);
  }

  void _goForward() {
    if (!_passesValidator()) return;
    if (_isLast) {
      widget.onComplete?.call();
      return;
    }
    setState(() => _index += 1);
    widget.onStepChanged?.call(_index);
  }

  void _jumpTo(int index) {
    if (index < 0 || index >= widget.steps.length || index == _index) {
      return;
    }
    setState(() => _index = index);
    widget.onStepChanged?.call(_index);
  }

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final PlexWizardStep step = widget.steps[_index];
    final bool vertical = widget.axis == PlexWizardAxis.vertical;

    final Widget body = Padding(
      padding: const EdgeInsets.fromLTRB(
        PlexDim.mediumPlus,
        PlexDim.small,
        PlexDim.mediumPlus,
        PlexDim.medium,
      ),
      child: step.child,
    );

    return Material(
      color: colors.surfaceCard,
      elevation: PlexElevation.xs,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlexRadius.lg),
        side: BorderSide(color: colors.borderSubtle),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (vertical)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PlexWizardVerticalRail(
                  steps: widget.steps,
                  currentIndex: _index,
                  allowStepJump: widget.allowStepJump,
                  onStepTap: _jumpTo,
                ),
                Expanded(child: body),
              ],
            )
          else ...[
            _PlexWizardRail(
              steps: widget.steps,
              currentIndex: _index,
              allowStepJump: widget.allowStepJump,
              onStepTap: _jumpTo,
            ),
            body,
          ],
          _PlexWizardFooter(
            index: _index,
            count: widget.steps.length,
            isFirst: _isFirst,
            isLast: _isLast,
            onBack: _goBack,
            onForward: _goForward,
          ),
        ],
      ),
    );
  }
}

class _PlexWizardRail extends StatelessWidget {
  const _PlexWizardRail({
    required this.steps,
    required this.currentIndex,
    required this.allowStepJump,
    required this.onStepTap,
  });

  final List<PlexWizardStep> steps;
  final int currentIndex;
  final bool allowStepJump;
  final ValueChanged<int> onStepTap;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        PlexDim.mediumPlus,
        PlexDim.medium,
        PlexDim.mediumPlus,
        PlexDim.smallMedium,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13, left: 4, right: 4),
                  child: ColoredBox(
                    color: i <= currentIndex
                        ? colors.brandPrimary
                        : colors.borderSubtle,
                    child: const SizedBox(height: 2),
                  ),
                ),
              ),
            _PlexWizardRailTap(
              index: i,
              enabled: allowStepJump,
              onTap: onStepTap,
              child: _PlexWizardRailItem(
                step: steps[i],
                number: i + 1,
                completed: i < currentIndex,
                current: i == currentIndex,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlexWizardVerticalRail extends StatelessWidget {
  const _PlexWizardVerticalRail({
    required this.steps,
    required this.currentIndex,
    required this.allowStepJump,
    required this.onStepTap,
  });

  final List<PlexWizardStep> steps;
  final int currentIndex;
  final bool allowStepJump;
  final ValueChanged<int> onStepTap;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        PlexDim.mediumPlus,
        PlexDim.medium,
        PlexDim.smallMedium,
        PlexDim.medium,
      ),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: colors.borderSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: ColoredBox(
                  color: i <= currentIndex
                      ? colors.brandPrimary
                      : colors.borderSubtle,
                  child: const SizedBox(width: 2, height: PlexDim.medium),
                ),
              ),
            _PlexWizardRailTap(
              index: i,
              enabled: allowStepJump,
              onTap: onStepTap,
              child: _PlexWizardRailItem(
                step: steps[i],
                number: i + 1,
                completed: i < currentIndex,
                current: i == currentIndex,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlexWizardRailTap extends StatelessWidget {
  const _PlexWizardRailTap({
    required this.index,
    required this.enabled,
    required this.onTap,
    required this.child,
  });

  final int index;
  final bool enabled;
  final ValueChanged<int> onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget keyed = KeyedSubtree(
      key: Key('plex-wizard-step-$index'),
      child: child,
    );
    if (!enabled) return keyed;
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(PlexRadius.md),
      child: keyed,
    );
  }
}

class _PlexWizardRailItem extends StatelessWidget {
  const _PlexWizardRailItem({
    required this.step,
    required this.number,
    required this.completed,
    required this.current,
  });

  final PlexWizardStep step;
  final int number;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final Color titleColor =
        current || completed ? colors.textPrimary : colors.textMuted;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlexWizardBadge(
            number: number,
            completed: completed,
            current: current,
          ),
          const SizedBox(width: PlexDim.small),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: PlexFontSize.body,
                    fontWeight: current ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                if (step.subtitle != null) ...[
                  const SizedBox(height: PlexDim.mini),
                  Text(
                    step.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: PlexFontSize.small,
                    ),
                  ),
                ],
                if (step.optional) ...[
                  const SizedBox(height: PlexDim.mini),
                  const PlexBadge(label: 'Optional'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlexWizardBadge extends StatelessWidget {
  const _PlexWizardBadge({
    required this.number,
    required this.completed,
    required this.current,
  });

  final int number;
  final bool completed;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;
    final Color background;
    final Color foreground;
    if (completed || current) {
      background = colors.brandPrimary;
      foreground = colors.textInverse;
    } else {
      background = colors.surfaceSunken;
      foreground = colors.textMuted;
    }

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      child: completed
          ? Icon(Icons.check, size: 16, color: foreground)
          : Text(
              '$number',
              style: TextStyle(
                color: foreground,
                fontSize: PlexFontSize.caption,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
    );
  }
}

class _PlexWizardFooter extends StatelessWidget {
  const _PlexWizardFooter({
    required this.index,
    required this.count,
    required this.isFirst,
    required this.isLast,
    required this.onBack,
    required this.onForward,
  });

  final int index;
  final int count;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onForward;

  @override
  Widget build(BuildContext context) {
    final PlexColorTokens colors = PlexThemeData.of(context).colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PlexDim.mediumPlus,
        vertical: PlexDim.smallMedium,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderSubtle)),
      ),
      child: Row(
        children: [
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric(
              title: 'Back',
              enabled: !isFirst,
              useMargin: false,
              cornerRadius: PlexRadius.md,
            ),
            buttonType: PlexButtonType.outlined,
            size: PlexButtonSize.sm,
            buttonClick: onBack,
          ),
          Expanded(
            child: Text(
              'Step ${index + 1} of $count',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: PlexFontSize.caption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          PlexFormFieldButton(
            properties: PlexFormFieldGeneric(
              title: isLast ? 'Finish' : 'Next',
              useMargin: false,
              cornerRadius: PlexRadius.md,
            ),
            buttonType: PlexButtonType.filled,
            size: PlexButtonSize.sm,
            buttonClick: onForward,
          ),
        ],
      ),
    );
  }
}
