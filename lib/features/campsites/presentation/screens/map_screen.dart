import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/campsites_provider.dart';
import '../../domain/entities/campsite.dart';
import '../../../../core/utils/price_formatter.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campsitesAsync = ref.watch(campsitesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campsites Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: campsitesAsync.when(
        data: (campsites) => _buildMapAndListView(context, campsites),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading map',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  LatLng fixCoordinates(double rawLat, double rawLong) {
    // If values are absurdly large (like 32680.68), scale them down
    final lat = (rawLat.abs() > 90) ? rawLat / 1000 : rawLat;
    final long = (rawLong.abs() > 180) ? rawLong / 1000 : rawLong;
    
    // Clamp to valid ranges
    return LatLng(
      lat.clamp(-90, 90),
      long.clamp(-180, 180),
    );
  }

  Widget _buildMapAndListView(BuildContext context, List<Campsite> campsites) {
    // Fix coordinates for all campsites
    final validCampsites = campsites.where((c) {
      final fixedLocation = fixCoordinates(c.geoLocation.latitude, c.geoLocation.longitude);
      return fixedLocation.latitude >= -90 && fixedLocation.latitude <= 90 &&
             fixedLocation.longitude >= -180 && fixedLocation.longitude <= 180;
    }).toList();

    if (validCampsites.isEmpty) {
      return const Center(child: Text('No campsites with valid coordinates found'));
    }

    // Calculate bounds for the map to show all campsites
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (final campsite in validCampsites) {
      final fixedLocation = fixCoordinates(campsite.geoLocation.latitude, campsite.geoLocation.longitude);
      minLat = min(minLat, fixedLocation.latitude);
      maxLat = max(maxLat, fixedLocation.latitude);
      minLng = min(minLng, fixedLocation.longitude);
      maxLng = max(maxLng, fixedLocation.longitude);
    }

    // Center map on the middle of all campsites
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    
    // Calculate appropriate zoom level based on the spread of coordinates
    final latSpread = maxLat - minLat;
    final lngSpread = maxLng - minLng;
    final maxSpread = max(latSpread, lngSpread);
    
    // Adjust zoom level based on coordinate spread
    double zoomLevel = 8.0; // Default zoom
    if (maxSpread > 10) {
      zoomLevel = 4.0; // Very wide spread
    } else if (maxSpread > 5) {
      zoomLevel = 5.0; // Wide spread
    } else if (maxSpread > 2) {
      zoomLevel = 6.0; // Medium spread
    } else if (maxSpread > 1) {
      zoomLevel = 7.0; // Small spread
    }
    
    // Ensure we start with a wide view to see all markers
    zoomLevel = min(zoomLevel, 5.0);
    
    final initialCameraPosition = CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: zoomLevel,
    );
    
    // Debug: Print map center and zoom info
    print('Map center: ($centerLat, $centerLng), zoom: $zoomLevel, spread: $maxSpread');
    print('Valid campsites: ${validCampsites.length}/${campsites.length}');

    final markers = validCampsites.map((campsite) {
      final fixedLocation = fixCoordinates(campsite.geoLocation.latitude, campsite.geoLocation.longitude);
      
      // Debug: Print original and fixed coordinates
      print('Campsite ${campsite.id}: Original(${campsite.geoLocation.latitude}, ${campsite.geoLocation.longitude}) -> Fixed(${fixedLocation.latitude}, ${fixedLocation.longitude})');
      
      return Marker(
        markerId: MarkerId(campsite.id),
        position: fixedLocation,
        infoWindow: InfoWindow(
          title: campsite.label,
          snippet: '${campsite.country} • ${PriceFormatter.formatPricePerNight(campsite.pricePerNight, currency: '€')}',
        ),
      );
    }).toSet();

    return Column(
      children: [
        // Map Section (40% of screen height)
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              onTap: (LatLng position) {
                // Optional: Handle map tap
              },
            ),
          ),
        ),
        
        // List Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.list, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Campsites (${campsites.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Campsites List (60% of screen height)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final campsite = campsites[index];
              final fixedLocation = fixCoordinates(campsite.geoLocation.latitude, campsite.geoLocation.longitude);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    campsite.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(campsite.country),
                      Text(
                        'Lat: ${fixedLocation.latitude.toStringAsFixed(4)}, '
                        'Lng: ${fixedLocation.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        PriceFormatter.formatPricePerNight(campsite.pricePerNight, currency: '€'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (campsite.closeToWater)
                            const Icon(Icons.water, size: 16, color: Colors.blue),
                          if (campsite.campFireAllowed)
                            const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => context.push('/campsite/${campsite.id}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 