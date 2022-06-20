import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelection;

  const MapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 37, longtitude: -122, address: ""),
      this.isSelection = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  void didChangeDependencies() {
    if (!widget.isSelection) {
      _pickedLocation = LatLng(
          widget.initialLocation.latitude, widget.initialLocation.longtitude);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          if (widget.isSelection)
            IconButton(
                onPressed: _pickedLocation == null
                    ? null
                    : () {
                        // 화면 pop하면서 값 전달.
                        Navigator.of(context).pop(_pickedLocation);
                      },
                icon: Icon(Icons.check))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            zoom: 17,
            target: LatLng(
              widget.initialLocation.latitude,
              widget.initialLocation.longtitude,
            )),
        onTap: widget.isSelection ? _selectLocation : null,
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('m1'), position: _pickedLocation!),
              },
      ),
    );
  }
}
