import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../assets/icons_assets.dart';
import '../until/global.dart';

class MapScreen extends StatefulWidget {
  static String routeName = "/map";
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor? customIconMarker;

  getIcons() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(12, 12)), IconsAssets.icDot)
        .then((d) {
      customIconMarker = d;
    });
  }

  Set<Marker> marker = {};

  CameraPosition kLake =
      const CameraPosition(target: LatLng(10.9501542, 106.6707032), zoom: 16);

  Future<void> goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(Global.latLngFromDB!));
    setState(() {
      _setMarker(Global.latLngFromDB!);
    });
  }

  void onMapCreate(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  void _setMarker(LatLng point) {
    setState(() {
      marker.add(Marker(
          markerId: MarkerId('Marker: ${Global.latLngFromDB!}'),
          icon: customIconMarker!,
          position: point));
    });
  }

  @override
  void initState() {
    super.initState();
    getIcons();
    goToTheLake();
    debugPrint(Global.latLngFromDB.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              //onCameraMoveStarted: goToTheLake,
              onCameraIdle: goToTheLake,
              onMapCreated: onMapCreate,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              markers: marker,
              initialCameraPosition: kLake,
              minMaxZoomPreference: const MinMaxZoomPreference(16, 24),
            ),
            backButton(),
            myLocationButton()
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(0, 1), blurRadius: 2)
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new),
        ));
  }

  Widget myLocationButton() {
    return Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 50),
            child: GestureDetector(
                onTap: () {
                  goToTheLake();
                },
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(children: <Widget>[
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(36),
                              topRight: Radius.circular(36),
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(0, 5),
                                  blurRadius: 5)
                            ],
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          )),
                      Positioned(
                          top: 10,
                          left: 10,
                          child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.asset(IconsAssets.icGPS))),
                    ])))));
  }
}
