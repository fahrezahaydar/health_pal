import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entity/clinic_entity.dart';

class LocMapWidget extends StatefulWidget {
  const LocMapWidget({
    super.key,
    required this.clinics,
    this.userLat,
    this.userLng,
    this.selectedClinicId,
    this.onMarkerTap,
  });

  final List<ClinicEntity> clinics;
  final double? userLat;
  final double? userLng;
  final String? selectedClinicId;
  final void Function(ClinicEntity clinic)? onMarkerTap;

  @override
  State<LocMapWidget> createState() => _LocMapWidgetState();
}

class _LocMapWidgetState extends State<LocMapWidget> {
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _centerOnInitialPosition();
  }

  @override
  void didUpdateWidget(LocMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userLat != widget.userLat ||
        oldWidget.userLng != widget.userLng) {
      _animateTo(LatLng(widget.userLat!, widget.userLng!), 13.0);
    }
    if (oldWidget.selectedClinicId != widget.selectedClinicId &&
        widget.selectedClinicId != null) {
      final clinic = widget.clinics.where(
        (c) => c.id == widget.selectedClinicId,
      );
      if (clinic.isNotEmpty) {
        _animateTo(LatLng(clinic.first.latitude, clinic.first.longitude), 15.0);
      }
    }
  }

  void _centerOnInitialPosition() {
    final hasPosition = widget.userLat != null && widget.userLng != null;
    if (hasPosition) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(LatLng(widget.userLat!, widget.userLng!), 13.0);
      });
    }
  }

  void _animateTo(LatLng point, double zoom) {
    _mapController.move(point, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final hasPosition = widget.userLat != null && widget.userLng != null;
    final center = hasPosition
        ? LatLng(widget.userLat!, widget.userLng!)
        : (widget.clinics.isNotEmpty
              ? LatLng(
                  widget.clinics.first.latitude,
                  widget.clinics.first.longitude,
                )
              : const LatLng(-6.2088, 106.8456));

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13,
        onTap: (_, _) {},
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
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
            ...widget.clinics.map((c) {
              final isSelected = c.id == widget.selectedClinicId;
              return Marker(
                point: LatLng(c.latitude, c.longitude),
                child: GestureDetector(
                  onTap: () => widget.onMarkerTap?.call(c),
                  child: isSelected
                      ? Transform.scale(
                          scale: 1.3,
                          child: const Icon(
                            AppIcons.locationOnFilled,
                            color: AppTheme.blue,
                            size: 36,
                          ),
                        )
                      : const Icon(
                          AppIcons.locationOnFilled,
                          color: AppTheme.primary,
                          size: 32,
                        ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}
