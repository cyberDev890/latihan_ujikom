
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent_plus/android_intent.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String locationMessage = "Belum mendapatkan Lat dan Long";
  String addressMessage = "Mencari lokasi";
  TextEditingController textEditingController = TextEditingController();

  Position _myPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0.0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);

  Future<void> _determinePosition() async {
    bool serviceEnabeled;
    LocationPermission locationPermission;

    serviceEnabeled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabeled) {
      return Future.error("Location service belum aktif");
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied)
        return Future.error("Location Permission ditolak");
    }

    if (locationPermission == LocationPermission.deniedForever)
      return Future.error(
          "Location permission ditolak, gagal request permissions");

    Position myPosition = await Geolocator.getCurrentPosition();
    setState(() => _myPosition = myPosition);
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service belum aktif");
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied)
        return Future.error("Location Permission ditolak");
    }

    if (locationPermission == LocationPermission.deniedForever)
      return Future.error(
          "Location permission ditolak,  gagal request permissions");

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      addressMessage =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_myPosition.toString()),
            SizedBox(height: 20),
            Text(locationMessage),
            SizedBox(height: 20),
            Text(addressMessage),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Lokasi Tujuan",
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  final intent = AndroidIntent(
                      action: "action_view",
                      data: Uri.encodeFull(
                          "google.navigation:q=${textEditingController.text}&avoid=tf"),
                      package: "com.google.android.apps.maps");
                  intent.launch();
                },
                child: Text("Cari Alamat"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: _determinePosition,
        onPressed: () async {
          Position position = await _getGeoLocationPosition();
          setState(() {
            locationMessage = "${position.latitude} ${position.longitude}";
          });
          getAddressFromLatLong(position);
        },
        child: Icon(Icons.location_on),
      ),
    );
  }
}
