import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/utils/utils.dart';

class MapScreen extends StatefulWidget {
  final KillEntry kill;
  const MapScreen({Key? key, required this.kill}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const double cameraZoom = 15;
  static const double cameraTilt = 0;
  static const double cameraBearing = 0;

  bool _isLoading = true;
  bool _showButtons = true;

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
    //var bytes = await getBytesFromAsset(path: 'assets/location-marker.png', width: 125);

    if (!mounted) return;
    GameType gt =
        GameType.all.firstWhere((e) => e.wildart == widget.kill.wildart);
    _markers.add(
      Marker(
        markerId: MarkerId(widget.kill.key),
        position: kLocation,
        // icon: BitmapDescriptor.fromBytes(bytes),
        icon: BitmapDescriptor.defaultMarkerWithHue(gt.bitmapDescriptor),
        infoWindow: InfoWindow(
            title:
                '${GameType.translate(context, widget.kill.wildart)} (${GameType.translateGeschlecht(context, widget.kill.geschlecht)})',
            onTap: () => showAlertDialog(
                  title: '',
                  description: widget.kill.localizedToString(context),
                  yesOption: '',
                  noOption: 'Ok',
                  onYes: () {},
                  icon: widget.kill.icon,
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
    Size size = MediaQuery.of(context).size;
    final dg = S.of(context);
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.green,
            ))
          : SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Listener(
                      onPointerMove: (move) {
                        if (_showButtons) setState(() => _showButtons = false);
                      },
                      onPointerUp: (_) {
                        if (!_showButtons) setState(() => _showButtons = true);
                      },
                      child: GoogleMap(
                        mapType: _currentMapType,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: _showButtons ? false : true,
                        initialCameraPosition: kCamPosition,
                        markers: _markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          //createMarkerIcon();
                        },
                      ),
                    ),
                  ),
                  // BACK BUTTON
                  Positioned(
                    top: size.height * 0.026,
                    left: size.width * 0.05,
                    child: AnimatedSwitcher(
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      reverseDuration: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 100),
                      child: _showButtons
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 14,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor, //.withOpacity(0.8),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon:
                                          const Icon(Icons.arrow_back_rounded),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: size.width * 0.05),
                                      child: Text('#${widget.kill.nummer}'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.026,
                    right: size.width * 0.05,
                    child: AnimatedSwitcher(
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      reverseDuration: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 100),
                      child: _showButtons
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 14,
                                    offset: const Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: toggleMapType,
                                icon: const Icon(Icons.map_rounded),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _isLoading
          ? Container()
          : FloatingActionButton.extended(
              onPressed: _goToOrigin,
              backgroundColor: rehwildFarbe,
              foregroundColor: Colors.white,
              label: Text(dg.mapInitialPosition),
              icon: const Icon(Icons.restore_rounded),
            ),
    );
  }

  Future<void> _goToOrigin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(kCamPosition));
  }
}
