import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_task/models/place_location.dart';
import 'package:my_task/services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key, required this.initialLocation, required this.setLocationFn});
  final PlaceLocation initialLocation;
  final Function(PlaceLocation placeLocation) setLocationFn;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation = const LatLng(-6.1754, 106.8272);

  String _address = '';

  late GoogleMapController _googleMapController;

  Future getUserLocation() async {
    LocationData? locationData = await LocationService.getUserLocation();

    if (locationData != null) {
      setlocation(
        LatLng(locationData.latitude!, locationData.longitude!),
        moveCamera: true,
      );
    }
  }

  Future setlocation(LatLng position, {bool moveCamera = false}) async {
    String tempAddress = await LocationService.getPlaceAddress(
        position.latitude, position.longitude);

    await Future.delayed(
      const Duration(microseconds: 500),
    );

    if (moveCamera) {
      _googleMapController.moveCamera(CameraUpdate.newLatLng(position));
    }

    setState(() {
      _pickedLocation = position;
      _address = tempAddress;
    });
  }

  @override
  void initState() {
    if (widget.initialLocation.latitude == 0 &&
        widget.initialLocation.longitude == 0) {
      getUserLocation;
    } else {
      setlocation(
          LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          moveCamera: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_address),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('pickedLocation'),
                position: _pickedLocation,
              ),
            },
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController googleMapController) {
              _googleMapController = googleMapController;
            },
            onTap: setlocation,
          ),
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.setLocationFn(
                  PlaceLocation(
                      latitude: _pickedLocation.latitude,
                      longitude: _pickedLocation.longitude,
                      address: _address),
                );
                Navigator.of(context).pop();
              },
              child: const Text("Set Lokasi"),
            ),
          ),
        ],
      ),
    );
  }
}
