import 'dart:async';
import 'dart:convert';
import 'package:dash_bubble/dash_bubble.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/pages/login/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:http/http.dart' as http;
import '../../functions/functions.dart';
import '../../functions/notifications.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../NavigatorPages/notification.dart';
import '../loadingPage/loading.dart';
import '../login/landingpage.dart';
import '../navDrawer/nav_drawer.dart';
import '../vehicleInformations/docs_onprocess.dart';
import 'droplocation.dart';
import 'map_page.dart';

class RidePage extends StatefulWidget {
  const RidePage({Key? key}) : super(key: key);

  @override
  State<RidePage> createState() => _RidePageState();
}

final distanceBetween = [
  {'name': '0-2 km', 'value': '0.43496'},
  {'name': '0-5 km', 'value': '1.0874'},
  {'name': '0-7 km', 'value': '1.7088'}
];
int _choosenDistance = 1;
List choosenRide = [];
bool isOverLayPermission = false;

class _RidePageState extends State<RidePage> with WidgetsBindingObserver {
  late geolocator.LocationPermission permission;
  int gettingPerm = 0;
  String state = '';
  bool _isLoading = false;
  bool _selectDistance = false;
  bool makeOnline = false;
  bool _cancel = false;
  bool isBid = false;
  String rideType = 'normal';

  bool currentpage = true;
  TextEditingController bidText = TextEditingController();
  final platforms = const MethodChannel('flutter.app/awake');
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    DashBubble.instance.stopBubble();

    if (userDetails['vehicle_types'] != [] && userDetails['role'] != 'owner') {
      setState(() {
        vechiletypeslist = userDetails['driverVehicleType']['data'];
      });
    }
    getadminCurrentMessages();
    currentpage = true;
    getLocs();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isBackground = false;
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      DashBubble.instance.stopBubble();
      isBackground = true;
    }
  }

  @override
  void dispose() {
    time?.cancel();
    bidStream?.cancel();
    super.dispose();
  }

  navigateLogout() {
    if (ownermodule == '1') {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingPage()),
            (route) => false);
      });
    } else {
      ischeckownerordriver = 'driver';
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      });
    }
  }

//getting permission and current location
  getLocs() async {
    permission = await geolocator.GeolocatorPlatform.instance.checkPermission();
    serviceEnabled =
        await geolocator.GeolocatorPlatform.instance.isLocationServiceEnabled();

    if (permission == geolocator.LocationPermission.denied ||
        permission == geolocator.LocationPermission.deniedForever ||
        serviceEnabled == false) {
      gettingPerm++;

      if (gettingPerm > 1) {
        locationAllowed = false;
        if (userDetails['active'] == true) {
          var val = await driverStatus();
          if (val == 'logout') {
            navigateLogout();
          }
        }
        state = '3';
      } else {
        state = '2';
      }
      setState(() {
        _isLoading = false;
      });
    } else if (permission == geolocator.LocationPermission.whileInUse ||
        permission == geolocator.LocationPermission.always) {
      if (serviceEnabled == true) {
        if (center == null) {
          var locs = await geolocator.Geolocator.getLastKnownPosition();
          if (locs != null) {
            center = LatLng(locs.latitude, locs.longitude);
            heading = locs.heading;
          } else {
            var loc = await geolocator.Geolocator.getCurrentPosition(
                desiredAccuracy: geolocator.LocationAccuracy.low);
            center = LatLng(double.parse(loc.latitude.toString()),
                double.parse(loc.longitude.toString()));
            heading = loc.heading;
          }
        }
        if (mounted) {
          setState(() {});
        }
      }

      if (makeOnline == true && userDetails['active'] == false) {
        var val = await driverStatus();
        if (val == 'logout') {
          navigateLogout();
        }
      }
      makeOnline = false;
      if (mounted) {
        setState(() {
          locationAllowed = true;
          state = '3';
          _isLoading = false;
        });
      }
    }
  }

  dynamic time;
  dynamic bidStream;
  List rideBck = [];
  timer() {
    bidStream = FirebaseDatabase.instance
        .ref()
        .child('bid-meta/${choosenRide[0]["request_id"]}')
        // .child(
        //     'bid-meta/${choosenRide[0]["request_id"]}/drivers/driver_${userDetails["id"]}')
        .onChildRemoved
        .handleError((onError) {
      bidStream?.cancel();
    }).listen((event) {
      if (driverReq.isEmpty) {
        getUserDetails();
      }
    });
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (waitingList.isNotEmpty) {
        valueNotifierTimer.incrementNotifier();
      } else {
        timer.cancel();
        bidStream?.cancel();
        bidStream = null;
        time = null;
      }
    });
  }

  getLocationPermission() async {
    if (permission == geolocator.LocationPermission.denied ||
        permission == geolocator.LocationPermission.deniedForever) {
      if (permission != geolocator.LocationPermission.deniedForever) {
        if (platform == TargetPlatform.android) {
          await perm.Permission.location.request();
          await perm.Permission.locationAlways.request();
        } else {
          await [perm.Permission.location].request();
        }
      }
      if (serviceEnabled == false) {
        await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocator.LocationAccuracy.low);
        // await location.requestService();
      }
    } else if (serviceEnabled == false) {
      await geolocator.Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.low);
      // await location.requestService();
    }
    setState(() {
      _isLoading = true;
    });
    getLocs();
  }

  popFunction() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      child: Material(
          child: (state != '1' && state != '2')
              ? ValueListenableBuilder(
                  valueListenable: valueNotifierHome.value,
                  builder: (context, value, child) {
                    if (time == null &&
                        waitingList.isNotEmpty &&
                        choosenRide.isNotEmpty) {
                      timer();
                    }
                    if (driverReq.isNotEmpty && currentpage == true) {
                      currentpage = false;
                      choosenRide.clear();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Maps()),
                              (route) => false);
                        }
                      });
                    }
                    if (isGeneral == true) {
                      isGeneral = false;
                      if (lastNotification != latestNotification) {
                        lastNotification = latestNotification;
                        pref.setString('lastNotification', latestNotification);
                        latestNotification = '';
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationPage()));
                        });
                      }
                    }
                    if (userDetails['approve'] == false && driverReq.isEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DocsProcess()),
                            (route) => false);
                      });
                    }

                    return Directionality(
                      textDirection: (languageDirection == 'rtl')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: Scaffold(
                        drawer: const NavDrawer(),
                        body: Stack(
                          children: [
                            Container(
                              height: media.height * 1,
                              width: media.width * 1,
                              padding: EdgeInsets.fromLTRB(
                                  media.width * 0.05,
                                  media.width * 0.05 +
                                      MediaQuery.of(context).padding.top,
                                  media.width * 0.05,
                                  media.width * 0.05),
                              color: page,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: media.width * 0.1,
                                        width: media.width * 0.1,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: textColor
                                                      .withOpacity(0.2),
                                                  spreadRadius: 2)
                                            ],
                                            color: page,
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.01)),
                                        child: StatefulBuilder(
                                            builder: (context, setState) {
                                          return InkWell(
                                              onTap: () async {
                                                Scaffold.of(context)
                                                    .openDrawer();
                                              },
                                              child: Icon(
                                                Icons.menu,
                                                size: media.width * 0.05,
                                                color: textColor,
                                              ));
                                        }),
                                      ),
                                      (userDetails['low_balance'] == false) &&
                                              (userDetails['role'] ==
                                                      'driver' &&
                                                  (userDetails[
                                                              'vehicle_type_id'] !=
                                                          null ||
                                                      userDetails[
                                                              'vehicle_types']
                                                          .isNotEmpty))
                                          ? Container(
                                              alignment: Alignment.center,
                                              child: InkWell(
                                                  onTap: () async {
                                                    if (((userDetails[
                                                                    'vehicle_type_id'] !=
                                                                null) ||
                                                            (userDetails[
                                                                    'vehicle_types'] !=
                                                                [])) &&
                                                        userDetails['role'] ==
                                                            'driver') {
                                                      if (userDetails[
                                                              'active'] ==
                                                          false) {
                                                        if (pref.getBool(
                                                                    'isOverlaypermission') !=
                                                                false &&
                                                            Theme.of(context)
                                                                    .platform ==
                                                                TargetPlatform
                                                                    .android) {
                                                          if (await DashBubble
                                                                  .instance
                                                                  .hasOverlayPermission() ==
                                                              false) {
                                                            setState(() {
                                                              isOverLayPermission =
                                                                  true;
                                                            });
                                                          }
                                                        }
                                                      }
                                                      if (locationAllowed ==
                                                              true &&
                                                          serviceEnabled ==
                                                              true) {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        var val =
                                                            await driverStatus();
                                                        if (val == 'logout') {
                                                          navigateLogout();
                                                        }
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      } else if (locationAllowed ==
                                                              true &&
                                                          serviceEnabled ==
                                                              false) {
                                                        await geolocator
                                                                .Geolocator
                                                            .getCurrentPosition(
                                                                desiredAccuracy:
                                                                    geolocator
                                                                        .LocationAccuracy
                                                                        .low);
                                                        if (await geolocator
                                                            .GeolocatorPlatform
                                                            .instance
                                                            .isLocationServiceEnabled()) {
                                                          serviceEnabled = true;
                                                          setState(() {
                                                            _isLoading = true;
                                                          });

                                                          var val =
                                                              await driverStatus();
                                                          if (val == 'logout') {
                                                            navigateLogout();
                                                          }
                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        }
                                                      } else {
                                                        if (serviceEnabled ==
                                                            true) {
                                                          setState(() {
                                                            makeOnline = true;
                                                          });
                                                        } else {
                                                          await geolocator
                                                                  .Geolocator
                                                              .getCurrentPosition(
                                                                  desiredAccuracy:
                                                                      geolocator
                                                                          .LocationAccuracy
                                                                          .low);
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          await getLocs();
                                                          if (serviceEnabled ==
                                                              true) {
                                                            setState(() {
                                                              makeOnline = true;
                                                            });
                                                          }
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            media.width * 0.01,
                                                        right:
                                                            media.width * 0.01),
                                                    height: media.width * 0.08,
                                                    width: media.width * 0.267,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              media.width *
                                                                  0.04),
                                                      color: (userDetails[
                                                                  'active'] ==
                                                              false)
                                                          ? const Color(
                                                                  0xff707070)
                                                              .withOpacity(0.6)
                                                          : const Color(
                                                              0xff00E688),
                                                    ),
                                                    child:
                                                        (userDetails[
                                                                    'active'] ==
                                                                false)
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets.all(
                                                                        media.width *
                                                                            0.01),
                                                                    height: media
                                                                            .width *
                                                                        0.07,
                                                                    width: media
                                                                            .width *
                                                                        0.07,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color:
                                                                            onlineOfflineText),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/offline.png',
                                                                      color: const Color(
                                                                          0xff707070),
                                                                    ),
                                                                  ),
                                                                  MyText(
                                                                    text: languages[
                                                                            choosenLanguage]
                                                                        [
                                                                        'text_on_duty'],
                                                                    size: media
                                                                            .width *
                                                                        twelve,
                                                                    color: (isDarkTheme ==
                                                                            true)
                                                                        ? textColor.withOpacity(
                                                                            0.7)
                                                                        : const Color(
                                                                            0xff555555),
                                                                  ),
                                                                  Container(),
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(),
                                                                  MyText(
                                                                    text: languages[
                                                                            choosenLanguage]
                                                                        [
                                                                        'text_off_duty'],
                                                                    size: media
                                                                            .width *
                                                                        twelve,
                                                                    color:
                                                                        textColor,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.all(
                                                                        media.width *
                                                                            0.01),
                                                                    height: media
                                                                            .width *
                                                                        0.07,
                                                                    width: media
                                                                            .width *
                                                                        0.07,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color:
                                                                            onlineOfflineText),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/offline.png',
                                                                      color: const Color(
                                                                          0xff00E688),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                  )),
                                            )
                                          : Container(),
                                      (userDetails['enable_bidding'] == true)
                                          ? InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _choosenDistance =
                                                      choosenDistance;
                                                  _selectDistance = true;
                                                });
                                              },
                                              child: Text(
                                                distanceBetween[choosenDistance]
                                                        ['name']
                                                    .toString(),
                                                style: GoogleFonts.notoSans(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    fontWeight: FontWeight.w600,
                                                    color: buttonColor),
                                                textDirection:
                                                    TextDirection.ltr,
                                              ))
                                          : Container()
                                    ],
                                  ),
                                  SizedBox(
                                    height: media.width * 0.05,
                                  ),
                                  (userDetails['active'] == true)
                                      ? SizedBox(
                                          height: media.width * 0.05,
                                        )
                                      : Container(),
                                  userDetails['active'] == true &&
                                          rideList.isNotEmpty &&
                                          driverReq.isEmpty

                                      //bidding
                                      ? Expanded(
                                          child: SingleChildScrollView(
                                              child: Column(
                                            children: rideList
                                                .asMap()
                                                .map((key, value) {
                                                  // ignore: prefer_typing_uninitialized_variables
                                                  List stops = [];
                                                  if (rideList[key]
                                                          ['trip_stops'] !=
                                                      'null') {
                                                    stops = jsonDecode(
                                                        rideList[key]
                                                            ['trip_stops']);
                                                  }

                                                  return MapEntry(
                                                    key,
                                                    InkWell(
                                                      onTap: () {
                                                        if (value[
                                                                'is_out_station'] ==
                                                            true) {
                                                          choosenRide.clear();
                                                          bidText.text = '';
                                                          rideType =
                                                              'outStation';
                                                          setState(() {
                                                            isBid = true;
                                                          });

                                                          choosenRide.add(
                                                              rideList[key]);
                                                          choosenRide[0]
                                                              ['km'] = rideList[
                                                                      key]
                                                                  ['distance']
                                                              .toString();

                                                          if (choosenRide[0][
                                                                  'trip_stops'] !=
                                                              'null') {
                                                            tripStops = stops;
                                                          } else {
                                                            tripStops.clear();
                                                          }
                                                        } else {
                                                          choosenRide.clear();
                                                          addressList.clear();
                                                          tripStops.clear();
                                                          bidText.text = '';
                                                          if (rideList[key][
                                                                  'trip_stops'] !=
                                                              'null') {
                                                            tripStops = jsonDecode(
                                                                rideList[key][
                                                                    'trip_stops']);
                                                          }

                                                          addressList.add(
                                                              AddressList(
                                                                  id: '1',
                                                                  type:
                                                                      'pickup',
                                                                  address: rideList[
                                                                          key][
                                                                      'pick_address'],
                                                                  latlng: LatLng(
                                                                      rideList[key]
                                                                          [
                                                                          'pick_lat'],
                                                                      rideList[key]
                                                                          [
                                                                          'pick_lng']),
                                                                  name: rideList[
                                                                          key][
                                                                      'pickup_poc_name'],
                                                                  // pickup: true,
                                                                  number: rideList[
                                                                          key][
                                                                      'pickup_poc_mobile'],
                                                                  instructions:
                                                                      rideList[key]
                                                                          ['pickup_poc_instruction']));
                                                          if (tripStops
                                                              .isNotEmpty) {
                                                            for (var i = 0;
                                                                i <
                                                                    tripStops
                                                                        .length;
                                                                i++) {
                                                              addressList.add(
                                                                  AddressList(
                                                                      id: (i + 2)
                                                                          .toString(),
                                                                      type:
                                                                          'drop',
                                                                      // pickup: false,
                                                                      address: tripStops[i]
                                                                          [
                                                                          'address'],
                                                                      latlng: LatLng(
                                                                          tripStops[i]
                                                                              [
                                                                              'latitude'],
                                                                          tripStops[i]
                                                                              [
                                                                              'longitude']),
                                                                      name: tripStops[i]
                                                                          [
                                                                          'poc_name'],
                                                                      number: tripStops[i]
                                                                          [
                                                                          'poc_mobile'],
                                                                      instructions:
                                                                          tripStops[i]
                                                                              ['poc_instruction']));
                                                            }
                                                          } else {
                                                            addressList.add(
                                                                AddressList(
                                                                    id: '2',
                                                                    type:
                                                                        'drop',
                                                                    // pickup: false,
                                                                    address:
                                                                        rideList[key]
                                                                            [
                                                                            'drop_address'],
                                                                    latlng: LatLng(
                                                                        rideList[key]
                                                                            [
                                                                            'drop_lat'],
                                                                        rideList[key]
                                                                            [
                                                                            'drop_lng']),
                                                                    name: rideList[key]
                                                                        [
                                                                        'drop_poc_name'],
                                                                    number: rideList[
                                                                            key]
                                                                        [
                                                                        'drop_poc_mobile'],
                                                                    instructions:
                                                                        rideList[key]
                                                                            ['drop_poc_instruction']));
                                                          }

                                                          choosenRide.add(
                                                              rideList[key]);
                                                          choosenRide[0]
                                                              ['km'] = rideList[
                                                                      key]
                                                                  ['distance']
                                                              .toString();

                                                          if (choosenRide[0][
                                                                  'trip_stops'] !=
                                                              'null') {
                                                            tripStops = stops;
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const Maps()));
                                                          } else {
                                                            tripStops.clear();
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const Maps()));
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            media.width * 0.02),
                                                        margin: EdgeInsets.only(
                                                            left: media.width *
                                                                0.01,
                                                            right: media.width *
                                                                0.01,
                                                            top: media.width *
                                                                0.01,
                                                            bottom: (key ==
                                                                    rideList.length -
                                                                        1)
                                                                ? media.width *
                                                                    0.15
                                                                : media.width *
                                                                    0.04),
                                                        width:
                                                            media.width * 0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: isDarkTheme
                                                                    ? Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5)
                                                                    : page,
                                                                // borderRadius:
                                                                //     BorderRadius
                                                                //         .circular(
                                                                //             10),
                                                                boxShadow: [
                                                              BoxShadow(
                                                                  blurRadius:
                                                                      2.0,
                                                                  spreadRadius:
                                                                      2.0,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2))
                                                            ]),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.025,
                                                            ),
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: const Color(
                                                                          0xff9C9C9A)
                                                                      .withOpacity(
                                                                          0.23)),
                                                              padding: EdgeInsets
                                                                  .all(media
                                                                          .width *
                                                                      0.05),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  MyText(
                                                                    text: rideList[
                                                                            key]
                                                                        [
                                                                        'request_no'],
                                                                    size: media
                                                                            .width *
                                                                        fourteen,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w600,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                  InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          choosenRide
                                                                              .clear();
                                                                          bidText.text =
                                                                              '';
                                                                          choosenRide
                                                                              .add(rideList[key]);
                                                                          _cancel =
                                                                              true;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          MyText(
                                                                            text:
                                                                                languages[choosenLanguage]['text_skip_ride'],
                                                                            size:
                                                                                media.width * twelve,
                                                                            fontweight:
                                                                                FontWeight.w600,
                                                                            maxLines:
                                                                                1,
                                                                            color:
                                                                                verifyDeclined,
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                media.width * 0.015,
                                                                          ),
                                                                          Icon(
                                                                            Icons.cancel_outlined,
                                                                            size:
                                                                                media.width * 0.04,
                                                                            color:
                                                                                verifyDeclined,
                                                                          )
                                                                        ],
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                                  media.width *
                                                                      0.02,
                                                            ),
                                                            if (value[
                                                                    'is_out_station'] ==
                                                                true)
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  MyText(
                                                                    text: rideList[
                                                                            key]
                                                                        [
                                                                        'trip_start_time'],
                                                                    size: media
                                                                            .width *
                                                                        twelve,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .w600,
                                                                    maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                  if (rideList[
                                                                              key]
                                                                          [
                                                                          'return_time'] !=
                                                                      null)
                                                                    MyText(
                                                                      text:
                                                                          'To',
                                                                      size: media
                                                                              .width *
                                                                          twelve,
                                                                      fontweight:
                                                                          FontWeight
                                                                              .w600,
                                                                      maxLines:
                                                                          1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                    ),
                                                                  (rideList[key]
                                                                              [
                                                                              'return_time'] !=
                                                                          null)
                                                                      ? MyText(
                                                                          text: rideList[key]
                                                                              [
                                                                              'return_time'],
                                                                          size: media.width *
                                                                              twelve,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                          maxLines:
                                                                              1,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .all(media
                                                                          .width *
                                                                      0.025),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: media
                                                                              .width *
                                                                          0.02),
                                                              width:
                                                                  media.width *
                                                                      0.9,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                color: const Color(
                                                                    0xffE4E4E3),
                                                              )),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        height: media.width *
                                                                            0.12,
                                                                        width: media.width *
                                                                            0.12,
                                                                        decoration: BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            image: DecorationImage(image: NetworkImage(rideList[key]['user_img']), fit: BoxFit.cover)),
                                                                      ),
                                                                      SizedBox(
                                                                        width: media.width *
                                                                            0.05,
                                                                      ),
                                                                      Expanded(
                                                                          child:
                                                                              MyText(
                                                                        text: rideList[key]
                                                                            [
                                                                            'user_name'],
                                                                        size: media.width *
                                                                            fourteen,
                                                                        fontweight:
                                                                            FontWeight.w600,
                                                                        maxLines:
                                                                            1,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      )),
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            media.width *
                                                                                0.04,
                                                                            media.width *
                                                                                0.02,
                                                                            media.width *
                                                                                0.04,
                                                                            media.width *
                                                                                0.02),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(media.width *
                                                                                0.05),
                                                                            color:
                                                                                const Color(0xff5BDD0A).withOpacity(0.24)),
                                                                        child:
                                                                            MyText(
                                                                          text: (value['is_out_station'] == true)
                                                                              ? languages[choosenLanguage]['text_outstation']
                                                                              : languages[choosenLanguage]['text_bid_ride'],
                                                                          size: media.width *
                                                                              twelve,
                                                                          fontweight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.05,
                                                                  ),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.8,
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              media.width * 0.05,
                                                                          width:
                                                                              media.width * 0.05,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              color: online.withOpacity(0.4)),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                media.width * 0.025,
                                                                            width:
                                                                                media.width * 0.025,
                                                                            decoration:
                                                                                BoxDecoration(shape: BoxShape.circle, color: online),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              media.width * 0.03,
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                MyText(text: rideList[key]['pick_address'], size: media.width * twelve)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.8,
                                                                    child: (stops
                                                                            .isEmpty)
                                                                        ? Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: media.width * 0.02,
                                                                              ),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.location_on,
                                                                                    color: const Color(0xFFFF0000),
                                                                                    size: media.width * 0.06,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: media.width * 0.03,
                                                                                  ),
                                                                                  Expanded(child: MyText(text: rideList[key]['drop_address'], size: media.width * twelve)),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Column(
                                                                            children: stops
                                                                                .asMap()
                                                                                .map((key, value) {
                                                                                  return MapEntry(
                                                                                    key,
                                                                                    Column(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: media.width * 0.02,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            (key == stops.length - 1)
                                                                                                ? Icon(
                                                                                                    Icons.location_on,
                                                                                                    color: const Color(0xFFFF0000),
                                                                                                    size: media.width * 0.06,
                                                                                                  )
                                                                                                : Container(
                                                                                                    height: media.width * 0.06,
                                                                                                    width: media.width * 0.06,
                                                                                                    alignment: Alignment.center,
                                                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red.withOpacity(0.1)),
                                                                                                    child: MyText(
                                                                                                      text: (key + 1).toString(),
                                                                                                      size: media.width * twelve,
                                                                                                      maxLines: 1,
                                                                                                      color: verifyDeclined,
                                                                                                    ),
                                                                                                  ),
                                                                                            SizedBox(
                                                                                              width: media.width * 0.03,
                                                                                            ),
                                                                                            Expanded(child: MyText(text: stops[key]['address'], size: media.width * twelve))
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                })
                                                                                .values
                                                                                .toList(),
                                                                          ),
                                                                  ),
                                                                  if (rideList[
                                                                              key]
                                                                          [
                                                                          'goods'] !=
                                                                      'null')
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              media.width * 0.025,
                                                                        ),
                                                                        MyText(
                                                                          text: languages[choosenLanguage]
                                                                              [
                                                                              'text_goods_type'],
                                                                          size: media.width *
                                                                              fourteen,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              media.width * 0.025,
                                                                        ),
                                                                        SizedBox(
                                                                            width: media.width *
                                                                                0.65,
                                                                            child:
                                                                                MyText(
                                                                              text: rideList[key]['goods'],
                                                                              size: media.width * twelve,
                                                                              maxLines: 2,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                  SizedBox(
                                                                    height: media
                                                                            .width *
                                                                        0.025,
                                                                  ),
                                                                  SizedBox(
                                                                    width: media
                                                                            .width *
                                                                        0.8,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        MyText(
                                                                            text:
                                                                                '${rideList[key]['distance'].toString()} km',
                                                                            size: media.width *
                                                                                sixteen,
                                                                            fontweight:
                                                                                FontWeight.w600),
                                                                        MyText(
                                                                          text:
                                                                              '${rideList[key]['currency']} ${rideList[key]['price']}',
                                                                          size: media.width *
                                                                              sixteen,
                                                                          fontweight:
                                                                              FontWeight.w600,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  if (value[
                                                                              'is_out_station'] ==
                                                                          true &&
                                                                      rideList[key]
                                                                              [
                                                                              'drivers'] !=
                                                                          null &&
                                                                      rideList[key]['drivers']
                                                                              [
                                                                              'driver_${userDetails['id']}'] !=
                                                                          null)
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child: MyText(
                                                                              maxLines: 1,
                                                                              text: '${languages[choosenLanguage]['text_my_bid_amount']}',
                                                                              size: media.width * sixteen,
                                                                              fontweight: FontWeight.w600),
                                                                        ),
                                                                        MyText(
                                                                            text:
                                                                                '${rideList[key]['currency']} ${rideList[key]['drivers']['driver_${userDetails['id']}']['price'].toString()}',
                                                                            size: media.width *
                                                                                sixteen,
                                                                            fontweight:
                                                                                FontWeight.w600),
                                                                      ],
                                                                    )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                                .values
                                                .toList(),
                                          )),
                                        )
                                      : (userDetails['active'] == false)
                                          ? Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: media.width * 0.7,
                                                    height: media.width * 0.7,
                                                    child: Image.asset(
                                                      'assets/images/offline_image.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.05,
                                                  ),
                                                  SizedBox(
                                                      width: media.width * 0.9,
                                                      child: MyText(
                                                        text: languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_you_are_offduty'],
                                                        size: media.width *
                                                            sixteen,
                                                        fontweight:
                                                            FontWeight.w600,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ))
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: media.width * 0.7,
                                                    height: media.width * 0.7,
                                                    child: Image.asset(
                                                      'assets/images/no_ride.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: media.width * 0.05,
                                                  ),
                                                  SizedBox(
                                                    width: media.width * 0.9,
                                                    child: Text(
                                                      languages[choosenLanguage]
                                                          [
                                                          'text_no_ride_in_area'],
                                                      style: GoogleFonts
                                                          .notoSans(
                                                              fontSize:
                                                                  media.width *
                                                                      sixteen,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: textColor),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                  (userDetails.isNotEmpty &&
                                          userDetails['low_balance'] == true)
                                      ?
                                      //low balance
                                      Container(
                                          decoration: BoxDecoration(
                                              color: buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: media.width * 0.9,
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          child: Text(
                                            userDetails['owner_id'] != null
                                                ? languages[choosenLanguage]
                                                    ['text_fleet_diver_low_bal']
                                                : languages[choosenLanguage]
                                                    ['text_low_balance'],
                                            style: GoogleFonts.notoSans(
                                              fontSize: media.width * fourteen,
                                              color: (isDarkTheme)
                                                  ? Colors.black
                                                  : textColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Container(),
                                  (userDetails['role'] == 'driver' &&
                                          (userDetails['vehicle_type_id'] ==
                                                  null &&
                                              userDetails['vehicle_types']
                                                  .isEmpty) &&
                                          userDetails['low_balance'] == false)
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: buttonColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: media.width * 0.9,
                                          padding: EdgeInsets.all(
                                              media.width * 0.025),
                                          child: MyText(
                                            text: languages[choosenLanguage]
                                                ['text_no_fleet_assigned'],
                                            size: media.width * fourteen,
                                            color: (isDarkTheme)
                                                ? Colors.black
                                                : textColor,
                                            fontweight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                          ))
                                      : Container()
                                ],
                              ),
                            ),

                            (driverReq.isEmpty &&
                                    userDetails['role'] != 'owner' &&
                                    userDetails['transport_type'] !=
                                        'delivery' &&
                                    userDetails['active'] == true &&
                                    userDetails[
                                            'show_instant_ride_feature_on_mobile_app'] ==
                                        '1')
                                ? Positioned(
                                    bottom: media.width * 0.05,
                                    left: media.width * 0.05,
                                    right: media.width * 0.05,
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            addressList.clear();
                                            var val = await geoCoding(
                                                center.latitude,
                                                center.longitude);
                                            setState(() {
                                              if (addressList
                                                  .where((element) =>
                                                      element.type == 'pickup')
                                                  .isNotEmpty) {
                                                var add = addressList
                                                    .firstWhere((element) =>
                                                        element.type ==
                                                        'pickup');
                                                add.address = val;
                                                add.latlng = LatLng(
                                                    center.latitude,
                                                    center.longitude);
                                              } else {
                                                addressList.add(AddressList(
                                                    id: '1',
                                                    type: 'pickup',
                                                    address: val,
                                                    latlng: LatLng(
                                                        center.latitude,
                                                        center.longitude)));
                                              }
                                            });
                                            if (addressList.isNotEmpty) {
                                              // ignore: use_build_context_synchronously
                                              Navigator.push(
                                                  // ignore: use_build_context_synchronously
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DropLocation()));
                                            }
                                          },
                                          child: Container(
                                            height: media.width * 0.12,
                                            padding: EdgeInsets.all(
                                                media.width * 0.03),
                                            decoration: BoxDecoration(
                                                color: (isDarkTheme)
                                                    ? buttonColor
                                                    : Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        media.width * 0.02)),
                                            child: MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_instant_ride'],
                                              size: media.width * sixteen,
                                              fontweight: FontWeight.w600,
                                              color: (isDarkTheme)
                                                  ? Colors.black
                                                  : buttonColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ))
                                : Container(),

                            //logout popup
                            (logout == true)
                                ? Positioned(
                                    top: 0,
                                    child: Container(
                                      height: media.height * 1,
                                      width: media.width * 1,
                                      color:
                                          Colors.transparent.withOpacity(0.6),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: media.width * 0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                    height: media.height * 0.1,
                                                    width: media.width * 0.1,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: page),
                                                    child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            logout = false;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: textColor,
                                                        ))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                media.width * 0.05),
                                            width: media.width * 0.9,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: page),
                                            child: Column(
                                              children: [
                                                Text(
                                                  languages[choosenLanguage]
                                                      ['text_confirmlogout'],
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.notoSans(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.05,
                                                ),
                                                Button(
                                                    onTap: () async {
                                                      setState(() {
                                                        _isLoading = true;
                                                        logout = false;
                                                      });
                                                      var result =
                                                          await userLogout();
                                                      if (result == 'success') {
                                                        setState(() {
                                                          navigateLogout();
                                                          userDetails.clear();
                                                        });
                                                      } else {
                                                        setState(() {
                                                          logout = true;
                                                        });
                                                      }
                                                    },
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_confirm'])
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                : Container(),

                            (isBid == true)
                                ? Positioned(
                                    child: InkWell(
                                      onTap: () {
                                        choosenRide.clear();
                                        isBid = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: media.height * 1,
                                        width: media.width * 1,
                                        color: Colors.black.withOpacity(0.3),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                width: media.width * 1,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: page,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 2,
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          spreadRadius: 2)
                                                    ]),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              media.width *
                                                                  0.05,
                                                              media.width *
                                                                  0.02,
                                                              media.width *
                                                                  0.05,
                                                              media.width *
                                                                  0.05),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.15,
                                                                width: media
                                                                        .width *
                                                                    0.15,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    image: DecorationImage(
                                                                        image: NetworkImage(choosenRide[0]
                                                                            [
                                                                            'user_img']),
                                                                        fit: BoxFit
                                                                            .cover)),
                                                              ),
                                                              SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.05),
                                                              Expanded(
                                                                child: SizedBox(
                                                                  height: media
                                                                          .width *
                                                                      0.2,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Text(
                                                                        choosenRide[0]
                                                                            [
                                                                            'user_name'],
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: GoogleFonts.notoSans(
                                                                            fontSize: media.width *
                                                                                eighteen,
                                                                            color:
                                                                                textColor),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              MyText(
                                                                text:
                                                                    '${choosenRide[0]['km']} km',
                                                                // maxLines: 1,
                                                                size: media
                                                                        .width *
                                                                    sixteen,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: online
                                                                        .withOpacity(
                                                                            0.2)),
                                                                child:
                                                                    Container(
                                                                  height: media
                                                                          .width *
                                                                      0.025,
                                                                  width: media
                                                                          .width *
                                                                      0.025,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color:
                                                                          online),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                              Expanded(
                                                                child: MyText(
                                                                  text: choosenRide[
                                                                          0][
                                                                      'pick_address'],
                                                                  // maxLines: 1,
                                                                  size: media
                                                                          .width *
                                                                      twelve,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.03,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                color: const Color(
                                                                    0xFFFF0000),
                                                                size: media
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                              ),
                                                              Expanded(
                                                                child: MyText(
                                                                  text: choosenRide[
                                                                          choosenRide.length -
                                                                              1]
                                                                      [
                                                                      'drop_address'],
                                                                  // maxLines: 1,
                                                                  size: media
                                                                          .width *
                                                                      twelve,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          SizedBox(
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (bidText
                                                                            .text
                                                                            .isNotEmpty &&
                                                                        ((bidText.text.contains('.'))
                                                                                ? (double.parse(bidText.text) - double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))
                                                                                : (int.parse(bidText.text) - int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))) >
                                                                            0) {
                                                                      setState(
                                                                          () {
                                                                        bidText
                                                                            .text = (bidText
                                                                                .text.isEmpty)
                                                                            ? (choosenRide[0]['price'].toString().contains('.'))
                                                                                ? (double.parse(choosenRide[0]['price'].toString()) - ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toStringAsFixed(2)
                                                                                : (int.parse(choosenRide[0]['price'].toString()) - ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toString()
                                                                            : (bidText.text.toString().contains('.'))
                                                                                ? (double.parse(bidText.text.toString()) - ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toStringAsFixed(2)
                                                                                : (int.parse(bidText.text.toString()) - ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toString();
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: media
                                                                            .width *
                                                                        0.2,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        color: (bidText.text.isNotEmpty && ((bidText.text.contains('.')) ? (double.parse(bidText.text) - double.parse(userDetails['bidding_amount_increase_or_decrease'].toString())) : (int.parse(bidText.text) - int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))) > 0) ? buttonColor : borderLines,
                                                                        // buttonColor,
                                                                        borderRadius: BorderRadius.circular(media.width * 0.04)),
                                                                    padding: EdgeInsets.all(
                                                                        media.width *
                                                                            0.025),
                                                                    child: Text(
                                                                      // '-10',
                                                                      (userDetails['bidding_amount_increase_or_decrease']
                                                                              .toString()
                                                                              .contains('.'))
                                                                          ? '-${double.parse(userDetails['bidding_amount_increase_or_decrease'].toString())}'
                                                                          : '-${int.parse(userDetails['bidding_amount_increase_or_decrease'].toString())}',
                                                                      style: GoogleFonts.notoSans(
                                                                          fontSize: media.width *
                                                                              fourteen,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              page),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.5,
                                                                  child:
                                                                      TextField(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    controller:
                                                                        bidText,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText: (choosenRide
                                                                              .isNotEmpty)
                                                                          ? choosenRide[0]['price']
                                                                              .toString()
                                                                          : '',
                                                                      hintStyle: GoogleFonts.notoSans(
                                                                          fontSize: media.width *
                                                                              sixteen,
                                                                          color:
                                                                              textColor),
                                                                      border: UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: hintColor)),
                                                                    ),
                                                                    style: GoogleFonts.notoSans(
                                                                        fontSize:
                                                                            media.width *
                                                                                sixteen,
                                                                        color:
                                                                            textColor),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      bidText
                                                                          .text = (bidText
                                                                              .text
                                                                              .isEmpty)
                                                                          ? (choosenRide[0]['price'].toString().contains('.'))
                                                                              ? (double.parse(choosenRide[0]['price'].toString()) + ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toStringAsFixed(2)
                                                                              : (int.parse(choosenRide[0]['price'].toString()) + ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toString()
                                                                          : (bidText.text.toString().contains('.'))
                                                                              ? (double.parse(bidText.text.toString()) + ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toStringAsFixed(2)
                                                                              : (int.parse(bidText.text.toString()) + ((userDetails['bidding_amount_increase_or_decrease'].toString().contains('.')) ? double.parse(userDetails['bidding_amount_increase_or_decrease'].toString()) : int.parse(userDetails['bidding_amount_increase_or_decrease'].toString()))).toString();
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: media
                                                                            .width *
                                                                        0.2,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            buttonColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(media.width *
                                                                                0.04)),
                                                                    padding: EdgeInsets.all(
                                                                        media.width *
                                                                            0.025),
                                                                    child: Text(
                                                                      // '+10',
                                                                      (userDetails['bidding_amount_increase_or_decrease']
                                                                              .toString()
                                                                              .contains('.'))
                                                                          ? '+${double.parse(userDetails['bidding_amount_increase_or_decrease'].toString())}'
                                                                          : '+${int.parse(userDetails['bidding_amount_increase_or_decrease'].toString())}',
                                                                      style: GoogleFonts.notoSans(
                                                                          fontSize: media.width *
                                                                              fourteen,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              page),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.9,
                                                              child: Button(
                                                                  onTap:
                                                                      () async {
                                                                    if (bidText
                                                                            .text
                                                                            .isNotEmpty ||
                                                                        choosenRide[0]['price'] !=
                                                                            null) {
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            true;
                                                                      });
                                                                      try {
                                                                        await FirebaseDatabase
                                                                            .instance
                                                                            .ref()
                                                                            .child('bid-meta/${choosenRide[0]["request_id"]}/drivers/driver_${userDetails["id"]}')
                                                                            .update({
                                                                          'driver_id':
                                                                              userDetails['id'],
                                                                          'price': bidText.text.isNotEmpty
                                                                              ? bidText.text
                                                                              : choosenRide[0]['price'].toString(),
                                                                          'driver_name':
                                                                              userDetails['name'],
                                                                          'driver_img':
                                                                              userDetails['profile_picture'],
                                                                          'bid_time':
                                                                              ServerValue.timestamp,
                                                                          'is_rejected':
                                                                              'none',
                                                                          'vehicle_make':
                                                                              userDetails['car_make_name'],
                                                                          'vehicle_model':
                                                                              userDetails['car_model_name'],
                                                                          'lat':
                                                                              center.latitude,
                                                                          'lng':
                                                                              center.longitude
                                                                        });
                                                                        setState(
                                                                            () {
                                                                          // isAvailable =
                                                                          //     false;
                                                                        });
                                                                        // FirebaseDatabase.instance.ref().child('drivers/driver_${userDetails['id']}').update({
                                                                        //   'is_available': false
                                                                        // });
                                                                        isBid =
                                                                            false;
                                                                        setState(
                                                                            () {});
                                                                      } catch (e) {
                                                                        debugPrint(
                                                                            e.toString());
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        _isLoading =
                                                                            false;
                                                                      });
                                                                    }
                                                                  },
                                                                  text: languages[
                                                                          choosenLanguage]
                                                                      [
                                                                      'text_bid']))
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),

                            //waiting for ride to accept by customer
                            if (waitingList.isNotEmpty && rideType == 'normal')
                              Positioned(
                                  child: ValueListenableBuilder(
                                      valueListenable: valueNotifierTimer.value,
                                      builder: (context, value, child) {
                                        var val = DateTime.now()
                                            .difference(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    waitingList[0]['drivers'][
                                                            'driver_${userDetails["id"]}']
                                                        ['bid_time']))
                                            .inSeconds;
                                        if (int.parse(val.toString()) >=
                                            (int.parse(userDetails[
                                                        'maximum_time_for_find_drivers_for_bitting_ride']
                                                    .toString()) +
                                                5)) {
                                          FirebaseDatabase.instance
                                              .ref()
                                              .child(
                                                  'bid-meta/${waitingList[0]["request_id"]}/drivers/driver_${userDetails["id"]}')
                                              .update(
                                                  {"is_rejected": 'by_driver'});
                                        }
                                        return Container(
                                          height: media.height * 1,
                                          width: media.width * 1,
                                          color: Colors.transparent
                                              .withOpacity(0.6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(),
                                              ),
                                              if (waitingList.isNotEmpty)
                                                Container(
                                                  width: media.width * 1,
                                                  decoration: BoxDecoration(
                                                      color: page,
                                                      //  borderRadius: BorderRadius.only(topRight:Radius.circular(10), topLeft: Radius.circular(10)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 2.0,
                                                            spreadRadius: 2.0,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2))
                                                      ]),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: (media.width *
                                                                1 /
                                                                (int.parse(userDetails[
                                                                            'maximum_time_for_find_drivers_for_bitting_ride']
                                                                        .toString()) +
                                                                    5)) *
                                                            ((int.parse(userDetails[
                                                                            'maximum_time_for_find_drivers_for_bitting_ride']
                                                                        .toString()) +
                                                                    5) -
                                                                double.parse(val
                                                                    .toString())),
                                                        height: 5,
                                                        color: buttonColor,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            media.width * 0.05,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _cancel =
                                                                        true;
                                                                  });
                                                                },
                                                                child: MyText(
                                                                  text: languages[
                                                                          choosenLanguage]
                                                                      [
                                                                      'text_cancel'],
                                                                  // maxLines: 1,
                                                                  size: media
                                                                          .width *
                                                                      fourteen,
                                                                  color:
                                                                      verifyDeclined,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.03,
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.7,
                                                              child: Text(
                                                                languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_waiting_for_user'],
                                                                style: GoogleFonts.notoSans(
                                                                    fontSize: media
                                                                            .width *
                                                                        sixteen,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        textColor),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                          Container(
                                                            padding: EdgeInsets
                                                                .all(media
                                                                        .width *
                                                                    0.05),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Container(
                                                                          height:
                                                                              media.width * 0.1,
                                                                          width:
                                                                              media.width * 0.1,
                                                                          decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(image: NetworkImage(waitingList[0]['user_img']), fit: BoxFit.cover)),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              media.width * 0.05,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              media.width * 0.1,
                                                                          child:
                                                                              Text(
                                                                            waitingList[0]['user_name'],
                                                                            style: GoogleFonts.notoSans(
                                                                                fontSize: media.width * fourteen,
                                                                                color: textColor,
                                                                                fontWeight: FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      width: media
                                                                              .width *
                                                                          0.025,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  height: media.width * 0.05,
                                                                                  width: media.width * 0.05,
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: online.withOpacity(0.2)),
                                                                                  child: Container(
                                                                                    height: media.width * 0.025,
                                                                                    width: media.width * 0.025,
                                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: online),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: media.width * 0.06,
                                                                                ),
                                                                                Expanded(
                                                                                  child: MyText(
                                                                                    text: waitingList[0]['pick_address'],
                                                                                    // maxLines: 1,
                                                                                    size: media.width * twelve,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: media.width * 0.02,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.location_on,
                                                                                  color: const Color(0xFFFF0000),
                                                                                  size: media.width * 0.06,
                                                                                ),
                                                                                SizedBox(
                                                                                  width: media.width * 0.05,
                                                                                ),
                                                                                Expanded(
                                                                                  child: MyText(
                                                                                    text: waitingList[0]['drop_address'],
                                                                                    // maxLines: 1,
                                                                                    size: media.width * twelve,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: media
                                                                          .width *
                                                                      0.025,
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.9,
                                                                  child: Text(
                                                                    '${waitingList[0]['currency']} ${waitingList[0]['drivers']['driver_${userDetails["id"]}']['price']}',
                                                                    style: GoogleFonts.notoSans(
                                                                        fontSize:
                                                                            media.width *
                                                                                sixteen,
                                                                        color:
                                                                            textColor,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        );
                                      })),
                            if (_cancel == true)
                              Positioned(
                                  child: Container(
                                height: media.height * 1,
                                width: media.width * 1,
                                color: Colors.transparent.withOpacity(0.2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: media.width * 0.9,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                              height: media.height * 0.1,
                                              width: media.width * 0.1,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: page),
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _cancel = false;
                                                    });
                                                  },
                                                  child: Icon(
                                                      Icons.cancel_outlined,
                                                      color: textColor))),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.all(media.width * 0.05),
                                      width: media.width * 0.9,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: page),
                                      child: Column(
                                        children: [
                                          Text(
                                            languages[choosenLanguage]
                                                ['text_cancel_confirmation'],
                                            // 'yyygghjhgjhgjhghgh',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.notoSans(
                                                fontSize: media.width * sixteen,
                                                color: textColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Button(
                                              onTap: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                try {
                                                  await FirebaseDatabase
                                                      .instance
                                                      .ref()
                                                      .child(
                                                          'bid-meta/${choosenRide[0]["request_id"]}/drivers/driver_${userDetails["id"]}')
                                                      .update({
                                                    'driver_id':
                                                        userDetails['id'],
                                                    'price': choosenRide[0]
                                                            ["price"]
                                                        .toString(),
                                                    'driver_name':
                                                        userDetails['name'],
                                                    'driver_img': userDetails[
                                                        'profile_picture'],
                                                    'bid_time':
                                                        ServerValue.timestamp,
                                                    'is_rejected': 'by_driver'
                                                  });

                                                  // Navigator.pop(context);
                                                } catch (e) {
                                                  debugPrint(e.toString());
                                                }
                                                setState(() {
                                                  _cancel = false;
                                                  _isLoading = false;
                                                });
                                              },
                                              text: languages[choosenLanguage]
                                                  ['text_confirm'])
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),

                            //select distance
                            (_selectDistance == true)
                                ? Positioned(
                                    top: 0,
                                    child: Container(
                                      height: media.height * 1,
                                      width: media.width * 1,
                                      color:
                                          Colors.transparent.withOpacity(0.6),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: media.width * 0.9,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                    height: media.height * 0.1,
                                                    width: media.width * 0.1,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: borderLines
                                                                .withOpacity(
                                                                    0.5)),
                                                        shape: BoxShape.circle,
                                                        color: page),
                                                    child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectDistance =
                                                                false;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.cancel_outlined,
                                                          color: textColor,
                                                        ))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                media.width * 0.05),
                                            width: media.width * 0.9,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: borderLines
                                                        .withOpacity(0.5)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: page),
                                            child: Column(
                                              children: [
                                                Text(
                                                  languages[choosenLanguage]
                                                      ['text_distance_between'],
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.notoSans(
                                                      fontSize:
                                                          media.width * sixteen,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.05,
                                                ),
                                                Column(
                                                  children: distanceBetween
                                                      .asMap()
                                                      .map((i, value) {
                                                        return MapEntry(
                                                          i,
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                _choosenDistance =
                                                                    i;
                                                              });
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: media
                                                                          .height *
                                                                      0.05,
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          color:
                                                                              textColor,
                                                                          width:
                                                                              1.2)),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: (_choosenDistance ==
                                                                          i)
                                                                      ? Container(
                                                                          height:
                                                                              media.width * 0.03,
                                                                          width:
                                                                              media.width * 0.03,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color:
                                                                                textColor,
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                ),
                                                                SizedBox(
                                                                  width: media
                                                                          .width *
                                                                      0.05,
                                                                ),
                                                                Text(
                                                                  distanceBetween[
                                                                              i]
                                                                          [
                                                                          'name']
                                                                      .toString(),
                                                                  style: GoogleFonts.notoSans(
                                                                      fontSize:
                                                                          media.width *
                                                                              sixteen,
                                                                      color:
                                                                          textColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      })
                                                      .values
                                                      .toList(),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.025,
                                                ),
                                                Button(
                                                    onTap: () async {
                                                      setState(() {
                                                        choosenDistance =
                                                            _choosenDistance;
                                                        _selectDistance = false;
                                                        pref.setString(
                                                            'choosenDistance',
                                                            choosenDistance
                                                                .toString());

                                                        rideStart?.cancel();
                                                        rideStart = null;
                                                        rideRequest();
                                                      });
                                                    },
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_confirm'])
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),

                            (updateAvailable == true)
                                ? Positioned(
                                    top: 0,
                                    child: Container(
                                      height: media.height * 1,
                                      width: media.width * 1,
                                      color:
                                          Colors.transparent.withOpacity(0.6),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: media.width * 0.9,
                                              padding: EdgeInsets.all(
                                                  media.width * 0.05),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: page,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                      width: media.width * 0.8,
                                                      child: Text(
                                                        languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_update_available'],
                                                        style: GoogleFonts
                                                            .notoSans(
                                                                fontSize: media
                                                                        .width *
                                                                    sixteen,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      )),
                                                  SizedBox(
                                                    height: media.width * 0.05,
                                                  ),
                                                  Button(
                                                      onTap: () async {
                                                        if (platform ==
                                                            TargetPlatform
                                                                .android) {
                                                          openBrowser(
                                                              'https://play.google.com/store/apps/details?id=${package.packageName}');
                                                        } else {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          var response = await http
                                                              .get(Uri.parse(
                                                                  'http://itunes.apple.com/lookup?bundleId=${package.packageName}'));
                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            openBrowser(jsonDecode(
                                                                        response
                                                                            .body)[
                                                                    'results'][0]
                                                                [
                                                                'trackViewUrl']);
                                                          }

                                                          setState(() {
                                                            _isLoading = false;
                                                          });
                                                        }
                                                      },
                                                      text: 'Update')
                                                ],
                                              ))
                                        ],
                                      ),
                                    ))
                                : Container(),

                            (isOverLayPermission &&
                                    Theme.of(context).platform ==
                                        TargetPlatform.android)
                                ? Positioned(
                                    child: Container(
                                    height: media.height * 1,
                                    width: media.width * 1,
                                    color: Colors.black.withOpacity(0.2),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // height: media.width * 0.5,
                                          width: media.width * 0.9,
                                          padding: EdgeInsets.all(
                                              media.width * 0.05),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: borderLines
                                                    .withOpacity(0.5)),
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.05),
                                            color: page,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MyText(
                                                text:
                                                    "Please Allow Overlay Permisson for Appear on the Other Apps",
                                                size: media.width * sixteen,
                                                textAlign: TextAlign.center,
                                                fontweight: FontWeight.bold,
                                              ),
                                              SizedBox(
                                                height: media.width * 0.05,
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isOverLayPermission =
                                                            false;
                                                      });
                                                      pref.setBool(
                                                          'isOverlaypermission',
                                                          isOverLayPermission);
                                                    },
                                                    child: SizedBox(
                                                      width: media.width * 0.3,
                                                      child: MyText(
                                                        text: languages[
                                                                choosenLanguage]
                                                            ['text_decline'],
                                                        size: media.width *
                                                            sixteen,
                                                        color: verifyDeclined,
                                                        fontweight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isOverLayPermission =
                                                              false;
                                                        });
                                                        DashBubble.instance
                                                            .requestOverlayPermission();
                                                      },
                                                      child: MyText(
                                                        text: languages[
                                                                choosenLanguage]
                                                            [
                                                            'text_open_settings'],
                                                        textAlign:
                                                            TextAlign.end,
                                                        size: media.width *
                                                            sixteen,
                                                        color: online,
                                                        fontweight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                : Container(),

                            //loader
                            (_isLoading == true)
                                ? const Positioned(top: 0, child: Loading())
                                : Container(),
                          ],
                        ),
                      ),
                    );
                  })
              : (state == '1')
                  ? Container(
                      padding: EdgeInsets.all(media.width * 0.05),
                      width: media.width * 0.6,
                      height: media.width * 0.3,
                      decoration: BoxDecoration(
                          color: page,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            languages[choosenLanguage]['text_enable_location'],
                            style: GoogleFonts.notoSans(
                                fontSize: media.width * sixteen,
                                color: textColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  state = '';
                                });
                                getLocs();
                              },
                              child: Text(
                                languages[choosenLanguage]['text_ok'],
                                style: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: media.width * twenty,
                                    color: buttonColor),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : (state == '2')
                      ? Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: media.height * 0.31,
                                width: media.width * 0.8,
                                child: Image.asset(
                                  'assets/images/allow_location_permission.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Text(
                                languages[choosenLanguage]['text_trustedtaxi'],
                                style: GoogleFonts.notoSans(
                                    fontSize: media.width * eighteen,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: media.width * 0.025,
                              ),
                              Text(
                                languages[choosenLanguage]
                                    ['text_allowpermission1'],
                                style: GoogleFonts.notoSans(
                                  fontSize: media.width * fourteen,
                                ),
                              ),
                              Text(
                                languages[choosenLanguage]
                                    ['text_allowpermission2'],
                                style: GoogleFonts.notoSans(
                                  fontSize: media.width * fourteen,
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.05,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(media.width * 0.05,
                                    0, media.width * 0.05, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: media.width * 0.075,
                                        child: const Icon(
                                            Icons.location_on_outlined)),
                                    SizedBox(
                                      width: media.width * 0.025,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.8,
                                      child: Text(
                                        languages[choosenLanguage]
                                            ['text_loc_permission'],
                                        style: GoogleFonts.notoSans(
                                            fontSize: media.width * fourteen,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: media.width * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(media.width * 0.05,
                                    0, media.width * 0.05, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: media.width * 0.075,
                                        child: const Icon(
                                            Icons.location_on_outlined)),
                                    SizedBox(
                                      width: media.width * 0.025,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.8,
                                      child: Text(
                                        languages[choosenLanguage]
                                            ['text_background_permission'],
                                        style: GoogleFonts.notoSans(
                                            fontSize: media.width * fourteen,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(media.width * 0.05),
                                  child: Button(
                                      onTap: () async {
                                        getLocationPermission();
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_continue']))
                            ],
                          ),
                        )
                      : Container()),
    );
  }
}
