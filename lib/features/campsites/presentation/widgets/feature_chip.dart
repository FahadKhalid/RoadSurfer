import 'package:flutter/material.dart';

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool compact;

  const FeatureChip({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: isActive 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive 
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 14 : 16,
            color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[600],
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: compact ? 12 : 14,
                color: isActive 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 