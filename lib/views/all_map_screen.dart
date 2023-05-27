import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jagdstatistik/generated/l10n.dart';
import 'package:jagdstatistik/models/constants/game_type.dart';
import 'package:jagdstatistik/models/kill_entry.dart';
import 'package:jagdstatistik/providers/pref_provider.dart';
import 'package:jagdstatistik/utils/constants.dart';
import 'package:jagdstatistik/utils/utils.dart';
import 'package:jagdstatistik/widgets/kill_list_entry.dart';
import 'package:provider/provider.dart';

import '../models/filter_chip_data.dart';
import '../models/kill_page.dart';
import '../widgets/chip_selector_modal.dart';

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
  bool _showButtons = true;

  late LatLng kLocation;
  late CameraPosition originCamPosition;
  final Set<Marker> _markers = <Marker>{};
  List<FilterChipData> wildChips = [];
  List<FilterChipData> geschlechterChips = [];
  List<FilterChipData> ursacheChips = [];
  List<FilterChipData> verwendungChips = [];

  MapType _currentMapType = MapType.hybrid;
  Uint8List markerBytes = Uint8List(0);

  ValueNotifier<KillEntry?> selectedKill = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    wildChips = widget.page.wildarten;
    geschlechterChips = widget.page.geschlechter;
    ursacheChips = widget.page.ursachen;
    verwendungChips = widget.page.verwendungen;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initMap();
    });
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
              .contains(k.wildart) &&
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

        if (!mounted) return;
        GameType gt = GameType.all.firstWhere((e) => e.wildart == k.wildart);
        _markers.add(
          Marker(
            markerId: MarkerId(k.key),
            position: LatLng(k.gpsLat!, k.gpsLon!),
            icon: BitmapDescriptor.defaultMarkerWithHue(gt.bitmapDescriptor),
            onTap: () => selectedKill.value = k,
            // infoWindow: InfoWindow(
            //     title:
            //         '${GameType.translate(context, k.wildart)} (${GameType.translateGeschlecht(context, k.geschlecht)})',
            //     onTap: () => showAlertDialog(
            //           title: '',
            //           description: k.localizedToString(context),
            //           yesOption: '',
            //           noOption: 'Ok',
            //           onYes: () {},
            //           icon: k.icon,
            //           context: context,
            //         ),
            //     snippet:
            //         '${DateFormat('dd.MM.yy').format(k.datetime)} ${DateFormat('kk:mm').format(k.datetime)}'),
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
    } else if (widget.page.kills.isNotEmpty &&
        widget.page.kills
            .where(
                (element) => element.gpsLat != null && element.gpsLat != null)
            .isNotEmpty) {
      var kill = widget.page.kills
          .where((element) => element.gpsLat != null && element.gpsLat != null)
          .first;

      originCamPosition = CameraPosition(
        target: LatLng(kill.gpsLat!, kill.gpsLon!),
        bearing: cameraBearing,
        tilt: cameraTilt,
        zoom: cameraZoom,
      );
    } else {
      // Fallback default position: Bolzano
      originCamPosition = const CameraPosition(
        target: Constants.bolzanoCoords,
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
    final showPerson = Provider.of<PrefProvider>(context).showPerson;

    final dg = S.of(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                        if (_showButtons || _showFilter) {
                          setState(() {
                            _showButtons = false;
                            _showFilter = false;
                          });
                        }
                      },
                      onPointerUp: (_) {
                        if (!_showButtons) setState(() => _showButtons = true);
                      },
                      child: GoogleMap(
                        mapType: _currentMapType,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: _showButtons ? false : true,
                        initialCameraPosition: originCamPosition,
                        markers: _markers,
                        onTap: (_) => selectedKill.value = null,
                        // onCameraMoveStarted: () {
                        //   if (_showButtons) setState(() => _showButtons = false);
                        // },
                        // onCameraMove: (pos) {

                        //   if (_showButtons || _showFilter) {
                        //     setState(() {
                        //       _showButtons = false;
                        //       _showFilter = false;
                        //     });
                        //   }
                        // },
                        // onCameraIdle: () {
                        //   if (!_showButtons) setState(() => _showButtons = true);
                        // },
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedSwitcher(
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 225),
                        child: _showFilter
                            ? Container(color: Colors.black.withOpacity(0.8))
                            : const SizedBox(),
                      ),
                    ),
                  ),
                  // GO BACK BUTTON
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
                                      child: Text(dg.xKill_s(_markers.length)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),

                  // ACTIVATE FILTER BUTTONS
                  Positioned(
                    top: size.height * 0.026,
                    right: size.width * 0.05,
                    child: AnimatedSwitcher(
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      reverseDuration: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 100),
                      child: _showButtons
                          ? MapFilterButton(
                              iconColor: _showFilter
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color!
                                  : primaryColor,
                              color: _showFilter
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : rehwildFarbe,
                              onTap: () {
                                setState(() {
                                  _showFilter = !_showFilter;
                                });
                              },
                              iconData: _showFilter
                                  ? Icons.close
                                  : widget.page.wildarten.length ==
                                              wildChips
                                                  .where((e) => e.isSelected)
                                                  .length &&
                                          widget.page.geschlechter.length ==
                                              geschlechterChips
                                                  .where((e) => e.isSelected)
                                                  .length &&
                                          widget.page.verwendungen.length ==
                                              verwendungChips
                                                  .where((e) => e.isSelected)
                                                  .length
                                      ? Icons.filter_alt
                                      : Icons.filter_alt_off_rounded,
                            )
                          : const SizedBox(),
                    ),
                  ),
                  _showFilter && _showButtons
                      ? Positioned(
                          top: size.height * 0.12,
                          right: size.width * 0.05,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MapFilterButton(
                                color: rehwildFarbe,
                                title: dg.gameTypes,
                                onTap: () async {
                                  await showModalBottomSheet(
                                      showDragHandle: true,
                                      context: context,
                                      shape: Constants.modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: dg.gameTypes,
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
                                title: dg.sexes,
                                onTap: () async {
                                  await showModalBottomSheet(
                                      showDragHandle: true,
                                      context: context,
                                      shape: Constants.modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: dg.sexes,
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
                                title: dg.causes,
                                onTap: () async {
                                  await showModalBottomSheet(
                                      showDragHandle: true,
                                      context: context,
                                      shape: Constants.modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: dg.causes,
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
                                title: dg.usages,
                                onTap: () async {
                                  await showModalBottomSheet(
                                      showDragHandle: true,
                                      context: context,
                                      shape: Constants.modalShape,
                                      builder: (BuildContext context) {
                                        return ChipSelectorModal(
                                          title: dg.usages,
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
      // floatingActionButton: _isLoading
      //     ? Container()
      //     : FloatingActionButton.extended(
      //         onPressed: _goToOrigin,
      //         backgroundColor: rehwildFarbe,
      //         foregroundColor: Colors.white,
      //         label: Text(dg.mapInitialPosition),
      //         icon: const Icon(Icons.restore_rounded),
      //       ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: selectedKill,
        builder: (context, KillEntry? kill, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isLoading
                ? Container()
                : kill == null
                    ? FloatingActionButton.extended(
                        onPressed: _goToOrigin,
                        backgroundColor: rehwildFarbe,
                        foregroundColor: Colors.white,
                        label: Text(dg.mapInitialPosition),
                        icon: const Icon(Icons.restore_rounded),
                      )
                    : KillListEntry(
                        kill: kill,
                        showPerson: showPerson,
                        backgroundOpacity: 0.9,
                        showMap: false,
                      ),
          );
        },
      ),
    );
  }

  Future<void> _goToOrigin() async {
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(originCamPosition));
  }
}

class MapFilterButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final Color color;
  final IconData iconData;
  final Color iconColor;
  final Color textColor;

  const MapFilterButton({
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
