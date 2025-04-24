import 'package:flutter/material.dart';
import 'package:McDonalds/models/location_model.dart';
import 'package:McDonalds/services/storage_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _addressController = TextEditingController();
  bool _isLoading = false;
  Timer? _debounce;
  List<StoreLocation> _nearbyStores = [];
  Position? _currentPosition;
  GoogleMapController? _mapController;
  BitmapDescriptor? _storeIcon;

  @override
  void initState() {
    super.initState();
    _loadStoreIcon();
    _getCurrentLocation();
  }

  Future<void> _loadStoreIcon() async {
    _storeIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/icon/32_logo.png',
    );
    setState(() {}); // Actualizar los marcadores con el nuevo ícono
  }

  @override
  void dispose() {
    _addressController.dispose();
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  String _formatAddress(Placemark place) {
    final parts = <String>[];

    if (place.thoroughfare?.trim().isNotEmpty ?? false) {
      parts.add(place.thoroughfare!.trim());
    } else if (place.street?.trim().isNotEmpty ?? false) {
      parts.add(place.street!.trim());
    }

    if (place.subLocality?.trim().isNotEmpty ?? false) {
      parts.add(place.subLocality!.trim());
    }

    if (place.locality?.trim().isNotEmpty ?? false) {
      parts.add(place.locality!.trim());
    } else if (place.subAdministrativeArea?.trim().isNotEmpty ?? false) {
      parts.add(place.subAdministrativeArea!.trim());
    }

    if (place.administrativeArea?.trim().isNotEmpty ?? false) {
      parts.add(place.administrativeArea!.trim());
    }

    if (parts.isEmpty) {
      if (place.name?.trim().isNotEmpty ?? false) {
        parts.add(place.name!.trim());
      } else {
        return '';
      }
    }

    return parts.join(', ');
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);
      await _searchNearbyStores(position);

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty && mounted) {
        final address = _formatAddress(placemarks.first);
        _addressController.text = address;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al obtener la ubicación: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _searchNearbyStores(Position position) async {
    // TODO: Aquí se integraría la llamada a tu API
    // Por ahora usamos datos de ejemplo
    setState(() {
      _nearbyStores = [
        StoreLocation(
          name: 'McDonald\'s Centro',
          address: 'Av. Principal 123',
          latitude: position.latitude + 0.001,
          longitude: position.longitude + 0.001,
          additionalInfo: 'Abierto 24/7\nEstacionamiento disponible',
        ),
        StoreLocation(
          name: 'McDonald\'s Plaza Mayor',
          address: 'Plaza Mayor Local 45',
          latitude: position.latitude - 0.001,
          longitude: position.longitude - 0.001,
          additionalInfo: 'Horario: 7:00 AM - 11:00 PM\nArea de juegos',
        ),
      ];
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchAddress(query);
    });
  }

  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final position = Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );

        await _searchNearbyStores(position);
        setState(() => _currentPosition = position);

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(location.latitude, location.longitude)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al buscar la dirección: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showStoreInfo(StoreLocation store) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(store.address),
                if (store.additionalInfo != null) ...[
                  const SizedBox(height: 8),
                  Text(store.additionalInfo!),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveSelectedStore(store),
                    child: const Text('Seleccionar esta ubicación'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _saveSelectedStore(StoreLocation store) async {
    try {
      setState(() => _isLoading = true);
      await StorageService.saveLocation(
        LocationModel(
          address: store.address,
          type: 'store',
          savedAt: DateTime.now(),
          selectedStore: store,
        ),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la ubicación: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final mapSize = screenSize.width;
    final initialPosition =
        _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(19.4326, -99.1332); // CDMX como respaldo

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Buscador
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Buscar dirección...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 16),
                  // Botón de ubicación actual
                  ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Usar mi ubicación actual'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDA291C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Mapa cuadrado
            SizedBox(
              width: mapSize,
              height: mapSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 11,
                  ),
                  markers: Set<Marker>.from(
                    _nearbyStores.map(
                      (store) => Marker(
                        markerId: MarkerId(
                          store.name,
                        ), // Usar name en lugar de id
                        position: LatLng(store.latitude, store.longitude),
                        icon: _storeIcon ?? BitmapDescriptor.defaultMarker,
                        onTap: () => _showStoreInfo(store),
                      ),
                    ),
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
            // Lista de tiendas cercanas
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _nearbyStores.length,
                itemBuilder: (context, index) {
                  final store = _nearbyStores[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(store.name),
                      subtitle: Text(store.address),
                      onTap: () => _showStoreInfo(store),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
