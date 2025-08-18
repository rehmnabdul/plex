import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Slots for AppBar layout - used by the CustomMultiChildLayout
/// to identify and position each component of the AppBar
enum _AppBarSlot {
  /// The leading widget (typically a back button or drawer hamburger)
  leading,
  
  /// The title widget displayed in the center
  title,
  
  /// The actions displayed at the right side
  actions,
}

/// A customizable AppBar replacement with familiar defaults.
///
/// Can be used anywhere an `AppBar` is expected since it implements
/// `PreferredSizeWidget`.
class PlexAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlexAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.toolbarHeight,
    this.leadingWidth,
    this.centerTitle,
    this.titleSpacing,
    this.iconTheme,
    this.actionsIconTheme,
    this.systemOverlayStyle,
    this.primary = true,
  });

  // Leading and navigation
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? leadingWidth;

  // Title and actions
  final Widget? title;
  final List<Widget>? actions;
  final bool? centerTitle;
  final double? titleSpacing;

  // Layout
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;
  final bool primary;

  // Visuals
  final double? elevation;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final SystemUiOverlayStyle? systemOverlayStyle;

  @override
  Size get preferredSize => Size.fromHeight(
        (toolbarHeight ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppBarTheme appBarTheme = theme.appBarTheme;

    final Color? effectiveBg = backgroundColor ?? appBarTheme.backgroundColor;
    final Color? effectiveFg = foregroundColor ?? appBarTheme.foregroundColor;
    final double effectiveElevation = elevation ?? appBarTheme.elevation ?? 0.0;
    final ShapeBorder? effectiveShape = shape ?? appBarTheme.shape;
    final Color? effectiveShadow = shadowColor ?? appBarTheme.shadowColor;
    final Color? effectiveSurfaceTint = surfaceTintColor ?? appBarTheme.surfaceTintColor;
    final IconThemeData? effectiveIconTheme = iconTheme ?? appBarTheme.iconTheme;
    final IconThemeData? effectiveActionsIconTheme = actionsIconTheme ?? appBarTheme.actionsIconTheme;
    final double effectiveToolbarHeight = toolbarHeight ?? appBarTheme.toolbarHeight ?? kToolbarHeight;
    final double effectiveTitleSpacing = titleSpacing ?? NavigationToolbar.kMiddleSpacing;
    final bool effectiveCenterTitle = centerTitle ?? appBarTheme.centerTitle ?? false;
    final SystemUiOverlayStyle? effectiveOverlay = systemOverlayStyle ?? appBarTheme.systemOverlayStyle;

    final Widget? leadingWidget = _buildLeading(context);
    final Widget? constrainedLeading = leadingWidget == null || leadingWidth == null ? leadingWidget : SizedBox(width: leadingWidth, child: Align(alignment: Alignment.centerLeft, child: leadingWidget));

    // Create a title text style that respects theme and foreground color
    final TextStyle titleTextStyle = (theme.textTheme.titleLarge ?? const TextStyle())
        .copyWith(color: effectiveFg);
    
    // Wrap the title with appropriate text styling if it's not null
    final Widget? styledTitle = title != null
        ? DefaultTextStyle(
            style: titleTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            child: title!,
          )
        : null;
    
    // Build the toolbar with appropriate icon theming
    final Widget toolbar = IconTheme.merge(
      data: effectiveIconTheme ?? const IconThemeData(),
      child: SizedBox(
        height: effectiveToolbarHeight,
        child: effectiveCenterTitle
            ? _buildCenteredToolbar(
                leading: constrainedLeading,
                title: styledTitle,
                actions: actions,
                actionsIconTheme: effectiveActionsIconTheme,
              )
            : NavigationToolbar(
                leading: constrainedLeading,
                middle: styledTitle == null
                    ? null
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: styledTitle,
                      ),
                trailing: actions == null || actions!.isEmpty
                    ? null
                    : IconTheme.merge(
                        data: effectiveActionsIconTheme ?? const IconThemeData(),
                        child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
                      ),
                centerMiddle: false,
                middleSpacing: effectiveTitleSpacing,
              ),
      ),
    );

    final Widget bar = Material(
      color: effectiveBg,
      elevation: effectiveElevation,
      shadowColor: effectiveShadow,
      surfaceTintColor: effectiveSurfaceTint,
      shape: effectiveShape,
      child: SafeArea(
        top: primary,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (flexibleSpace != null)
              Positioned.fill(
                child: flexibleSpace!,
              ),
            toolbar,
            if (bottom != null) bottom!,
          ],
        ),
      ),
    );

    if (effectiveOverlay != null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(value: effectiveOverlay, child: bar);
    }
    return bar;
  }

  Widget _buildCenteredToolbar({
    required Widget? leading,
    required Widget? title,
    required List<Widget>? actions,
    required IconThemeData? actionsIconTheme,
  }) {
    // If no title, just use a standard row layout
    if (title == null) {
      return NavigationToolbar(
        leading: leading,
        middle: null,
        trailing: actions != null && actions.isNotEmpty
            ? IconTheme.merge(
                data: actionsIconTheme ?? const IconThemeData(),
                child: Row(mainAxisSize: MainAxisSize.min, children: actions),
              )
            : null,
        centerMiddle: false,
        middleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      );
    }
    
    // Calculate space needed for leading and actions
    final double symmetricInset = _estimateSymmetricInset(
      hasLeading: leading != null,
      actionsCount: actions?.length ?? 0,
    );
    
    // Create a list of children for the layout
    final List<Widget> layoutChildren = [];
    
    // Add leading widget if present
    if (leading != null) {
      layoutChildren.add(
        LayoutId(
          id: _AppBarSlot.leading,
          child: leading,
        ),
      );
    }
    
    // Always add title widget
    layoutChildren.add(
      LayoutId(
        id: _AppBarSlot.title,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: symmetricInset),
          child: title,
        ),
      ),
    );
    
    // Add actions if present
    if (actions != null && actions.isNotEmpty) {
      layoutChildren.add(
        LayoutId(
          id: _AppBarSlot.actions,
          child: IconTheme.merge(
            data: actionsIconTheme ?? const IconThemeData(),
            child: Row(mainAxisSize: MainAxisSize.min, children: actions),
          ),
        ),
      );
    }
    
    return CustomMultiChildLayout(
      delegate: _AppBarLayoutDelegate(
        hasLeading: leading != null,
        hasActions: actions != null && actions.isNotEmpty,
        titleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
        leadingWidth: leadingWidth,
      ),
      children: layoutChildren,
    );
  }

  static const double _kActionSlotExtent = 48.0;

  double _estimateSymmetricInset({required bool hasLeading, required int actionsCount}) {
    // Use a minimal padding to avoid hiding text unnecessarily
    final double left = hasLeading ? (leadingWidth ?? kToolbarHeight) * 0.5 : 0.0;
    final double right = actionsCount > 0 ? (_kActionSlotExtent * actionsCount) * 0.5 : 0.0;
    
    // Use a minimal inset to allow more text to be visible
    return (left > right ? left : right) * 0.5;
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (!automaticallyImplyLeading) return null;

    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop == true || Navigator.of(context).canPop();
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final bool hasDrawer = scaffold?.hasDrawer == true;

    if (hasDrawer) {
      return IconButton(
        icon: const Icon(Icons.menu),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        onPressed: () => Scaffold.of(context).openDrawer(),
      );
    }

    if (canPop) {
      return const BackButton();
    }

    return null;
  }
}

/// Custom layout delegate for the AppBar that provides precise control over
/// the positioning of the leading widget, title, and actions.
///
/// This allows for a properly centered title that doesn't overlap with
/// the leading or action widgets, while maintaining proper spacing.
class _AppBarLayoutDelegate extends MultiChildLayoutDelegate {
  /// Creates an AppBar layout delegate.
  ///
  /// The [hasLeading], [hasActions], and [titleSpacing] arguments must not be null.
  _AppBarLayoutDelegate({
    required this.hasLeading,
    required this.hasActions,
    required this.titleSpacing,
    this.leadingWidth,
  });

  /// Whether the AppBar has a leading widget.
  final bool hasLeading;
  
  /// Whether the AppBar has action widgets.
  final bool hasActions;
  
  /// Spacing around the title.
  final double titleSpacing;
  
  /// Width of the leading widget, if specified.
  final double? leadingWidth;

  @override
  void performLayout(Size size) {
    double leadingWidth = this.leadingWidth ?? kToolbarHeight;
    double actionsWidth = 0.0;
    
    // Layout leading widget (left side)
    if (hasLeading && hasChild(_AppBarSlot.leading)) {
      // Constrain the leading widget to its specified width and full height
      final Size leadingSize = layoutChild(
        _AppBarSlot.leading,
        BoxConstraints.tightFor(width: leadingWidth, height: size.height),
      );
      // Position with the specified spacing
      positionChild(_AppBarSlot.leading, Offset(titleSpacing, 0.0));
      // Update the effective leading width including spacing
      leadingWidth = leadingSize.width + titleSpacing;
    } else {
      leadingWidth = 0.0;
    }
    
    // Layout actions widget (right side)
    if (hasActions && hasChild(_AppBarSlot.actions)) {
      // Allow actions to take as much space as needed
      final Size actionsSize = layoutChild(
        _AppBarSlot.actions,
        BoxConstraints.loose(size),
      );
      // Position at the right edge
      positionChild(
        _AppBarSlot.actions,
        Offset(size.width - actionsSize.width, 0.0),
      );
      actionsWidth = actionsSize.width;
    }
    
    // Layout title widget (center)
    if (hasChild(_AppBarSlot.title)) {
      // Calculate the available width for the title
      // Use most of the available space, leaving only minimal margins for leading/actions
      final double minLeadingMargin = hasLeading ? 8.0 : 0.0;
      final double minActionsMargin = hasActions ? 8.0 : 0.0;
      
      // Reserve just enough space for leading and actions with minimal margins
      final double reservedLeadingWidth = leadingWidth > 0 ? leadingWidth + minLeadingMargin : 0.0;
      final double reservedActionsWidth = actionsWidth > 0 ? actionsWidth + minActionsMargin : 0.0;
      
      // Allow title to use most of the available space
      final double maxWidth = size.width - reservedLeadingWidth - reservedActionsWidth;
      
      // Layout the title with the calculated constraints
      final Size titleSize = layoutChild(
        _AppBarSlot.title,
        BoxConstraints.loose(Size(maxWidth, size.height)),
      );
      
      // Center the title horizontally and vertically
      final double titleX = (size.width - titleSize.width) / 2.0;
      final double titleY = (size.height - titleSize.height) / 2.0;
      
      // Ensure title doesn't overlap with leading or actions
      final double minX = leadingWidth;
      final double maxX = size.width - actionsWidth - titleSize.width;
      final double adjustedTitleX = titleX.clamp(minX, maxX);
      
      positionChild(_AppBarSlot.title, Offset(adjustedTitleX, titleY));
    }
  }

  @override
  bool shouldRelayout(_AppBarLayoutDelegate oldDelegate) {
    // Relayout if any of the layout-affecting properties have changed
    return oldDelegate.hasLeading != hasLeading ||
        oldDelegate.hasActions != hasActions ||
        oldDelegate.titleSpacing != titleSpacing ||
        oldDelegate.leadingWidth != leadingWidth;
  }
}
