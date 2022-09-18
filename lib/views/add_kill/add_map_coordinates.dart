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

class AddMapCoordsScreen extends StatefulWidget {
  final LatLng initCoords;
  const AddMapCoordsScreen({Key? key, required this.initCoords}) : super(key: key);

  @override
  State<AddMapCoordsScreen> createState() => _AddMapCoordsScreenState();
}

class _AddMapCoordsScreenState extends State<AddMapCoordsScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const double cameraZoom = 10;
  static const double cameraTilt = 0;
  static const double cameraBearing = 0;

  late CameraPosition _cameraPosition;
  late ValueNotifier<LatLng> _camPos;

  bool _showButtons = true;

  MapType _currentMapType = MapType.hybrid;

  @override
  void initState() {
    super.initState();
    _camPos = ValueNotifier(widget.initCoords);
    _cameraPosition = CameraPosition(
      target: _camPos.value,
      bearing: cameraBearing,
      tilt: cameraTilt,
      zoom: cameraZoom,
    );
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
      body: SafeArea(
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
                child: ValueListenableBuilder(
                  builder: (BuildContext context, LatLng newPos, Widget? child) {
                    Marker marker = Marker(
                        markerId: const MarkerId('marker'),
                        position: _cameraPosition.target);

                    return GoogleMap(
                      mapType: _currentMapType,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: _showButtons ? false : true,
                      initialCameraPosition: _cameraPosition,
                      markers: {marker},
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMove: (camPos) {
                        _cameraPosition = camPos;
                        _camPos.value = camPos.target;
                      },
                    );
                  },
                  valueListenable: _camPos,
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
                              offset: const Offset(0, 0), // changes position of shadow
                            ),
                          ],
                          color: Theme.of(context)
                              .scaffoldBackgroundColor, //.withOpacity(0.8),
                        ),
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            // TOGGLE MAP TYPE
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 14,
                              offset: const Offset(0, 0), // changes position of shadow
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(_camPos.value),
        backgroundColor: rehwildFarbe,
        foregroundColor: Colors.white,
        label: Text(dg.confirm),
        icon: const Icon(Icons.check_rounded),
      ),
    );
  }
}
