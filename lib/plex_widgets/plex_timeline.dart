import 'package:flutter/material.dart';

/// A single event in a [PlexTimeline].
class PlexTimelineEvent {
  const PlexTimelineEvent({
    required this.title,
    this.subtitle,
    this.timestamp,
    this.icon,
    this.color,
    this.child,
  });

  final String title;
  final String? subtitle;
  final String? timestamp;
  final Widget? icon;
  final Color? color;
  final Widget? child;
}

/// A vertical timeline widget displaying a list of events.
class PlexTimeline extends StatelessWidget {
  const PlexTimeline({
    super.key,
    required this.events,
    this.alternating = false,
    this.lineColor,
    this.dotRadius = 10.0,
  });

  final List<PlexTimelineEvent> events;
  final bool alternating;
  final Color? lineColor;
  final double dotRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final line = lineColor ?? colorScheme.outline.withValues(alpha: 0.5);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final event = events[index];
        final isLeft = !alternating || index.isEven;
        final content = Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _EventContent(event: event, theme: theme),
        );
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLeft)
                Expanded(child: content)
              else
                const SizedBox(width: 24),
              SizedBox(
                width: dotRadius * 2 + 16,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (index < events.length - 1)
                      Positioned(
                        top: dotRadius + 4,
                        bottom: -8,
                        left: dotRadius + 8 - 1,
                        child: Container(
                          width: 2,
                          color: line,
                        ),
                      ),
                    Container(
                      width: dotRadius * 2,
                      height: dotRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: event.color ?? colorScheme.primary,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLeft)
                Expanded(child: content)
              else
                const SizedBox(width: 24),
            ],
          ),
        );
      },
    );
  }
}

class _EventContent extends StatelessWidget {
  const _EventContent({
    required this.event,
    required this.theme,
  });

  final PlexTimelineEvent event;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (event.icon != null) ...[
              event.icon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                event.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (event.timestamp != null)
              Text(
                event.timestamp!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
        if (event.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            event.subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
        if (event.child != null) ...[
          const SizedBox(height: 8),
          event.child!,
        ],
      ],
    );
  }
}
