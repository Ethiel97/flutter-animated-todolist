import 'package:flutter/material.dart';

class HealthSummary extends StatelessWidget {
  const HealthSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _StatItem(
          icon: "🚶‍♂️", // or use 🏃 if preferred
          value: "4.7K",
          label: "steps",
          color: Colors.blue,
        ),
        SizedBox(width: 16),
        _StatItem(
          icon: "🌙",
          value: "6.37",
          label: "hours",
          color: Colors.purple,
        ),
        SizedBox(width: 16),
        _StatItem(
          icon: "🏃‍♂️",
          value: "36",
          label: "mins",
          color: Colors.green,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(width: 4),
        Text.rich(
          textAlign: TextAlign.start,
          TextSpan(
            children: [
              TextSpan(
                text: "$value ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              TextSpan(
                text: label,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
