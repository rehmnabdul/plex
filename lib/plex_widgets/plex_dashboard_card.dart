import 'package:flutter/material.dart';
import 'package:plex/plex_widgets/plex_card.dart';

/// A KPI dashboard card with optional trend indicator and sparkline.
class PlexDashboardCard extends StatelessWidget {
  const PlexDashboardCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.icon,
    this.chart,
    this.onTap,
    this.color,
  });

  final String title;
  final String value;
  final String? subtitle;
  final double? trend;
  final Widget? icon;
  final Widget? chart;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PlexCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trend != null) _TrendIndicator(trend: trend!),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (chart != null) ...[
            const SizedBox(height: 12),
            chart!,
          ],
        ],
      ),
    );
  }
}

class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({required this.trend});

  final double trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = trend >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${isPositive ? '+' : ''}${trend.toStringAsFixed(1)}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
