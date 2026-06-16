import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../loc/domain/entity/clinic_entity.dart';

class LocMapWidget extends StatefulWidget {
  const LocMapWidget({
    super.key,
    required this.clinics,
    this.userLat,
    this.userLng,
    this.onMarkerTap,
    this.radiusKm = 10,
  });

  final List<ClinicEntity> clinics;
  final double? userLat;
  final double? userLng;
  final void Function(ClinicEntity clinic)? onMarkerTap;
  final double radiusKm;

  @override
  State<LocMapWidget> createState() => _LocMapWidgetState();
}

class _LocMapWidgetState extends State<LocMapWidget> {
  final _mapController = MapController();
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _animateToPosition();
  }

  @override
  void didUpdateWidget(LocMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userLat != widget.userLat ||
        oldWidget.userLng != widget.userLng) {
      _animateToPosition();
    }
  }

  void _animateToPosition() {
    if (_hasAnimated) return;
    _hasAnimated = true;
    final hasPosition =
        widget.userLat != null && widget.userLng != null;
    if (hasPosition) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(
          LatLng(widget.userLat!, widget.userLng!),
          13.0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPosition =
        widget.userLat != null && widget.userLng != null;
    final center = hasPosition
        ? LatLng(widget.userLat!, widget.userLng!)
        : (widget.clinics.isNotEmpty
            ? LatLng(
                widget.clinics.first.latitude,
                widget.clinics.first.longitude,
              )
            : const LatLng(-6.2088, 106.8456));

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: 13.0,
          onTap: (_, _) {},
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.healthpal.app',
          ),
          MarkerLayer(
            markers: [
              if (hasPosition)
                Marker(
                  point: center,
                  child: const Icon(
                    Icons.my_location,
                    color: AppTheme.blue,
                    size: 28,
                  ),
                ),
              ...widget.clinics.map((c) => Marker(
                    point: LatLng(c.latitude, c.longitude),
                    child: GestureDetector(
                      onTap: () => widget.onMarkerTap?.call(c),
                      child: const Icon(
                        Icons.local_hospital,
                        color: AppTheme.primary,
                        size: 32,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
