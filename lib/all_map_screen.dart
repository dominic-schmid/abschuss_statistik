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
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'models/filter_chip_data.dart';
import 'models/kill_page.dart';
import 'widgets/chip_selector_modal.dart';

class AllMapScreen extends StatefulWidget {
  final KillPage page;
  const AllMapScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<AllMapScreen> createState() => _AllMapScreenState();
}

class _AllMapScreenState extends State<AllMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const double cameraZoom = 12.75;
  static const double cameraTilt = 0;
  static const double cameraBearing = 0;

  bool _isLoading = true;

  late LatLng kLocation;
  late CameraPosition originCamPosition;
  final Set<Marker> _markers = <Marker>{};
  MapType _currentMapType = MapType.hybrid;
  Uint8List markerBytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    wildChips = widget.page.wildarten;
    initMap();
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

  void initMap() async {
    markerBytes =
        await getBytesFromAsset(path: 'assets/location-marker.png', width: 125);
    rebuildMarkers();
    setState(() => _isLoading = false);
  }

  rebuildMarkers() {
    _markers.clear();
    double avgLat = 0;
    double avgLon = 0;
    int markerCount = 0;

    for (KillEntry k in widget.page.kills) {
      if (k.gpsLat != null &&
          k.gpsLon != null &&
          wildChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.wildart)) {
        avgLat += k.gpsLat!;
        avgLon += k.gpsLon!;
        markerCount++;

        _markers.add(
          Marker(
            markerId: MarkerId(k.key),
            position: LatLng(k.gpsLat!, k.gpsLon!),
            //icon: BitmapDescriptor.fromBytes(markerBytes),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                KillEntry.getMarkerHueFromWildart(k.wildart)),
            infoWindow: InfoWindow(
                title: '${k.wildart} (${k.geschlecht})',
                onTap: () => showAlertDialog(
                      title: '',
                      description: k.toString(),
                      yesOption: '',
                      noOption: 'Ok',
                      onYes: () {},
                      icon: Icons.info,
                      context: context,
                    ),
                snippet:
                    '${DateFormat('dd.MM.yy').format(k.datetime)} ${DateFormat('kk:mm').format(k.datetime)}'),
          ),
        );
      }
    }

    if (_markers.isNotEmpty) {
      originCamPosition = CameraPosition(
        target: LatLng(avgLat / markerCount, avgLon / markerCount),
        bearing: cameraBearing,
        tilt: cameraTilt,
        zoom: cameraZoom,
      );
    }
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

  List<FilterChipData> wildChips = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          ChartAppBar(title: Text('${_markers.length} Abschüsse'), actions: [
        IconButton(
            onPressed: toggleMapType, icon: const Icon(Icons.map_rounded)),
        IconButton(
          onPressed: () async {
            await showMaterialModalBottomSheet(
                context: context,
                shape: modalShape,
                builder: (BuildContext context) {
                  return ChipSelectorModal(
                    title: 'Wildarten',
                    chips: wildChips,
                  );
                });
            rebuildMarkers();
            if (mounted) setState(() {});
            _goToOrigin();
          },
          icon: widget.page.wildarten.length ==
                  wildChips.where((e) => e.isSelected).length
              ? Icon(Icons.filter_alt)
              : Icon(Icons.filter_alt_off_rounded),
        )
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
              initialCameraPosition: originCamPosition,
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
              label: const Text('Anfangsposition'),
              icon: const Icon(Icons.restore_rounded),
            ),
    );
  }

  Future<void> _goToOrigin() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(originCamPosition));
  }
}
