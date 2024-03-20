import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('map'),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: Center(
        child: Text(
          'This is the map Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// const LatLng currentLocation = LatLng(25.1193, 55.3773);

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: GoogleMap(
//           initialCameraPosition: CameraPosition(
//         target: currentLocation,
//       )),
//     );
//   }
// }
