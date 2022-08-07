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
  bool _showFilter = false;

  late LatLng kLocation;
  late CameraPosition originCamPosition;
  final Set<Marker> _markers = <Marker>{};
  List<FilterChipData> wildChips = [];
  List<FilterChipData> geschlechterChips = [];
  List<FilterChipData> ursacheChips = [];
  List<FilterChipData> verwendungChips = [];

  MapType _currentMapType = MapType.hybrid;
  Uint8List markerBytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    wildChips = widget.page.wildarten;
    geschlechterChips = widget.page.geschlechter;
    ursacheChips = widget.page.ursachen;
    verwendungChips = widget.page.verwendungen;
    initMap();
  }

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    if (path == null || width == null) return Uint8List(0);

    ByteData data = await rootBundle.load(path);
    ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void initMap() async {
    markerBytes = await getBytesFromAsset(path: 'assets/location-marker.png', width: 125);
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
          wildChips.where((e) => e.isSelected).map((e) => e.label).contains(k.wildart) &&
          geschlechterChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.geschlecht) &&
          ursacheChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.ursache) &&
          verwendungChips
              .where((e) => e.isSelected)
              .map((e) => e.label)
              .contains(k.verwendung)) {
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
                      icon: k.icon,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                    child: GoogleMap(
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
                  ),
                  // GO BACK BUTTON
                  Positioned(
                    top: size.height * 0.026,
                    left: size.width * 0.05,
                    child: Container(
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
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: size.width * 0.05),
                              child: Text('${_markers.length} Abschüsse'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ACTIVATE FILTER BUTTONS
                  Positioned(
                    top: size.height * 0.026,
                    right: size.width * 0.05,
                    child: MapFilterButton(
                      iconColor: _showFilter
                          ? Theme.of(context).primaryTextTheme.bodyMedium!.color!
                          : primaryColor,
                      color: _showFilter
                          ? Theme.of(context).scaffoldBackgroundColor
                          : rehwildFarbe,
                      onTap: () => setState(() {
                        _showFilter = !_showFilter;
                      }),
                      iconData: _showFilter
                          ? Icons.close
                          : widget.page.wildarten.length ==
                                      wildChips.where((e) => e.isSelected).length &&
                                  widget.page.geschlechter.length ==
                                      geschlechterChips
                                          .where((e) => e.isSelected)
                                          .length &&
                                  widget.page.verwendungen.length ==
                                      verwendungChips.where((e) => e.isSelected).length
                              ? Icons.filter_alt
                              : Icons.filter_alt_off_rounded,
                    ),
                  ),
                  _showFilter
                      ? Positioned(
                          top: size.height * 0.12,
                          right: size.width * 0.05,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MapFilterButton(
                                color: rehwildFarbe,
                                title: 'Wildarten',
                                onTap: () async {
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
                              ),
                              const SizedBox(height: 12),
                              MapFilterButton(
                                color: protokollFarbe,
                                title: 'Geschlechter',
                                onTap: () async {
                                  await showMaterialModalBottomSheet(
                                      context: context,
                                      shape: modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: 'Geschlechter',
                                          chips: geschlechterChips,
                                        );
                                      });
                                  rebuildMarkers();
                                  if (mounted) setState(() {});
                                  _goToOrigin();
                                },
                              ),
                              const SizedBox(height: 12),
                              MapFilterButton(
                                color: hegeabschussFarbe,
                                title: 'Ursachen',
                                onTap: () async {
                                  await showMaterialModalBottomSheet(
                                      context: context,
                                      shape: modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: 'Ursachen',
                                          chips: ursacheChips,
                                        );
                                      });
                                  rebuildMarkers();
                                  if (mounted) setState(() {});
                                  _goToOrigin();
                                },
                              ),
                              const SizedBox(height: 12),
                              MapFilterButton(
                                color: nichtBekanntFarbe,
                                title: 'Verwendungen',
                                onTap: () async {
                                  await showMaterialModalBottomSheet(
                                      context: context,
                                      shape: modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: 'Verwendungen',
                                          chips: verwendungChips,
                                        );
                                      });
                                  rebuildMarkers();
                                  if (mounted) setState(() {});
                                  _goToOrigin();
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  // TOGGLE MAP TYPE BUTTON
                  Positioned(
                    top: size.height * 0.026,
                    right: size.width * 0.225,
                    child: Container(
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
              label: const Text(
                'Anfangsposition',
              ),
              icon: const Icon(Icons.restore_rounded),
            ),
    );
  }

  Future<void> _goToOrigin() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(originCamPosition));
  }
}

class MapFilterButton extends StatelessWidget {
  VoidCallback? onTap;
  String title;
  Color color;
  IconData iconData;
  Color iconColor;
  Color textColor;

  MapFilterButton({
    Key? key,
    required this.onTap,
    this.title = "",
    this.color = rehwildFarbe,
    this.iconData = Icons.filter_alt,
    this.iconColor = primaryColor,
    this.textColor = primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 14,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          color: color,
        ),
        duration: const Duration(milliseconds: 250),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: iconColor,
            ),
            Text(
              title,
              style: TextStyle(color: textColor),
            )
          ],
        ),
      ),
    );
  }
}
