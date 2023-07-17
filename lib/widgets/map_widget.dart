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
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Center(
            child: previewMapImagUrl.isEmpty
                ? const Text('Tap untuk menambahkan lokasi')
                : Stack(
                    children: [
                      Image.network(previewMapImagUrl),
                      Positioned(
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            setLocationFn(
                              PlaceLocation(latitude: 0.0, longitude: 0.0),
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
