import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdverband_scraper/models/kill_entry.dart';
import 'package:jagdverband_scraper/utils/utils.dart';
import 'package:jagdverband_scraper/widgets/chart_app_bar.dart';

class MapScreen extends StatefulWidget {
  final KillEntry kill;
  const MapScreen({Key? key, required this.kill}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const double cameraZoom = 14;
  static const double cameraTilt = 0;
  static const double cameraBearing = 0;

  bool _isLoading = true;

  late LatLng kLocation;
  late CameraPosition kCamPosition;
  final Set<Marker> _markers = <Marker>{};
  MapType _currentMapType = MapType.hybrid;

  @override
  void initState() {
    super.initState();
    createMarkerIcon();
    kLocation = LatLng(widget.kill.gpsLat!, widget.kill.gpsLon!);
    kCamPosition = CameraPosition(
      target: kLocation,
      bearing: cameraBearing,
      tilt: cameraTilt,
      zoom: cameraZoom,
    );
  }

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    if (path == null || width == null) return Uint8List(0);

    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void createMarkerIcon() async {
    var bytes =
        await getBytesFromAsset(path: 'assets/location-marker.png', width: 125);

    _markers.add(
      Marker(
        markerId: MarkerId(widget.kill.key),
        position: kLocation,
        icon: BitmapDescriptor.fromBytes(bytes),
        infoWindow: InfoWindow(
            title: '${widget.kill.wildart} (${widget.kill.geschlecht})',
            onTap: () => showAlertDialog(
                  title: '',
                  description: widget.kill.toString(),
                  yesOption: '',
                  noOption: 'Ok',
                  onYes: () {},
                  icon: Icons.info,
                  context: context,
                ),
            snippet:
                '${DateFormat('dd.MM.yy').format(widget.kill.datetime)} ${DateFormat('kk:mm').format(widget.kill.datetime)}'),
      ),
    );

    setState(() => _isLoading = false);
  }

  toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.hybrid
          ? MapType.normal
          : _currentMapType == MapType.normal
              ? MapType.terrain
              : MapType.hybrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChartAppBar(
          title: Text('Abschuss #${widget.kill.nummer}'),
          actions: [
            IconButton(
                onPressed: toggleMapType, icon: const Icon(Icons.map_rounded))
          ]),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : GoogleMap(
              mapType: _currentMapType,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: kCamPosition,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                //createMarkerIcon();
              },
            ),
      floatingActionButton: _isLoading
          ? Container()
          : FloatingActionButton.extended(
              onPressed: _goToOrigin,
              label: const Text('Zurück zum Abschuss'),
              icon: const Icon(Icons.restore_rounded),
            ),
    );
  }

  Future<void> _goToOrigin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kCamPosition));
  }
}
