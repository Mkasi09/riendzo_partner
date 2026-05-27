import 'package:flutter/material.dart';
import 'package:riendzo_partner/theme/app_theme.dart';

class DriverHeader extends StatelessWidget {
  const DriverHeader({
    super.key,
    required this.isOnline,
    required this.onOnlineChanged,
  });

  final bool isOnline;
  final ValueChanged<bool> onOnlineChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.ink,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.directions_car, color: Colors.white),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riendzo Partner',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              Text(
                'Driver console',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                color: isOnline ? const Color(0xFF0F9F6E) : AppTheme.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
            Switch(value: isOnline, onChanged: onOnlineChanged),
          ],
        ),
      ],
    );
  }
}
