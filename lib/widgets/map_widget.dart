import 'package:flutter/material.dart';
import 'package:my_task/models/place_location.dart';
import 'package:my_task/screens/map_screen.dart';
import 'package:my_task/services/location_service.dart';

class MapWidget extends StatelessWidget {
  const MapWidget(
      {super.key, required this.placeLocation, required this.setLocationFn});
  final PlaceLocation placeLocation;
  final Function(PlaceLocation placeLocation) setLocationFn;

  @override
  Widget build(BuildContext context) {
    String previewMapImagUrl = LocationService.GenerateMapUrlImage(
        placeLocation.latitude, placeLocation.longitude);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => MapScreen(
                initialLocation: placeLocation, setLocationFn: setLocationFn),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5),
        ),
        child: Center(
          child: previewMapImagUrl.isEmpty
              ? const Text('Tap untuk menambahkan lokasi')
              : Image.network(previewMapImagUrl),
        ),
      ),
    );
  }
}
