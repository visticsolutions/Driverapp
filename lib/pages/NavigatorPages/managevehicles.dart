import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/login.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/carinformation.dart';
import '../login/landingpage.dart';
import '../noInternet/nointernet.dart';
import 'assigndriver.dart';
import 'fleetdocuments.dart';

class ManageVehicles extends StatefulWidget {
  const ManageVehicles({Key? key}) : super(key: key);

  @override
  State<ManageVehicles> createState() => _ManageVehiclesState();
}

String fleetid = '';

class _ManageVehiclesState extends State<ManageVehicles> {
  dynamic _shimmer;
  bool _isLoading = false;
  String isclickmenu = '';

  @override
  void initState() {
    _shimmer = AnimationController.unbounded(vsync: MyTickerProvider())
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
    getvehicledata();
    super.initState();
  }

  @override
  void dispose() {
    _shimmer.dispose();
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

  getvehicledata() async {
    isclickmenu = '';
    if (vehicledata.isEmpty) {
      for (var i = 0; i < 10; i++) {
        vehicledata.add({});
      }
    }
    var val = await getVehicleInfo();
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return true;
      },
      child: Material(
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(
                    media.width * 0.05,
                    MediaQuery.of(context).padding.top + media.width * 0.05,
                    media.width * 0.05,
                    0),
                height: media.height * 1,
                width: media.width * 1,
                color:
                    (isDarkTheme && vehicledata.isEmpty) ? Colors.black : page,
                //history details
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: media.width * 0.05),
                          width: media.width * 0.9,
                          alignment: Alignment.center,
                          child: MyText(
                            text: languages[choosenLanguage]
                                ['text_manage_vehicle'],
                            size: media.width * sixteen,
                            fontweight: FontWeight.bold,
                          ),
                        ),
                        Positioned(
                            child: InkWell(
                                onTap: () {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                  // Navigator.popUntil(
                                  //     context, (route) => route is VehicleColor);
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: textColor)))
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: vehicledata.isNotEmpty
                            ? Column(
                                children: [
                                  for (var i = 0; i < vehicledata.length; i++)
                                    (vehicledata[i].isEmpty)
                                        ? AnimatedBuilder(
                                            animation: _shimmer,
                                            builder: (context, widget) {
                                              return ShaderMask(
                                                  blendMode: BlendMode.srcATop,
                                                  shaderCallback: (bounds) {
                                                    return LinearGradient(
                                                            colors: shaderColor,
                                                            stops: shaderStops,
                                                            begin: shaderBegin,
                                                            end: shaderEnd,
                                                            tileMode:
                                                                TileMode.clamp,
                                                            transform:
                                                                SlidingGradientTransform(
                                                                    slidePercent:
                                                                        _shimmer
                                                                            .value))
                                                        .createShader(bounds);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.all(
                                                        media.width * 0.03),
                                                    padding: EdgeInsets.all(
                                                        media.width * 0.03),
                                                    decoration: BoxDecoration(
                                                        color: page,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(media
                                                                        .width *
                                                                    0.02)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.15,
                                                              color: hintColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.15,
                                                              color: hintColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.2,
                                                              color: hintColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.2,
                                                              color: hintColor
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        const MySeparator(),
                                                        // Container(
                                                        //   height: 1,
                                                        //   width: media.width * 0.8,
                                                        //   color: hintColor,
                                                        // ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.02,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.05,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.05,
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: media.width *
                                                              0.03,
                                                        ),

                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.05,
                                                              width:
                                                                  media.width *
                                                                      0.05,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: hintColor
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.05,
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            })
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                right: media.width * 0.01,
                                                left: media.width * 0.01,
                                                bottom: media.width * 0.03),
                                            child: Stack(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isclickmenu = '';
                                                    });
                                                  },
                                                  child: Container(
                                                    height: media.width * 0.3,
                                                    width: media.width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      color: page,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: hintColor,
                                                          offset: const Offset(
                                                              0.0, 1.0), //(x,y)
                                                          blurRadius: 5.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 35,
                                                            child: Container(
                                                              height:
                                                                  media.width *
                                                                      0.3,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: page,
                                                                borderRadius: (languageDirection ==
                                                                        'rtl')
                                                                    ? const BorderRadius
                                                                        .only(
                                                                        topRight:
                                                                            Radius.circular(10),
                                                                        bottomRight:
                                                                            Radius.circular(10),
                                                                        topLeft:
                                                                            Radius.circular(60),
                                                                        bottomLeft:
                                                                            Radius.circular(60),
                                                                      )
                                                                    : const BorderRadius
                                                                        .only(
                                                                        topRight:
                                                                            Radius.circular(60),
                                                                        bottomRight:
                                                                            Radius.circular(60),
                                                                        topLeft:
                                                                            Radius.circular(10),
                                                                        bottomLeft:
                                                                            Radius.circular(10),
                                                                      ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color:
                                                                        hintColor,
                                                                    offset: const Offset(
                                                                        0.0,
                                                                        1.0), //(x,y)
                                                                    blurRadius:
                                                                        8.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 5,
                                                                      child:
                                                                          Container(
                                                                        width: media.width *
                                                                            0.2,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(
                                                                                vehicledata[i]['type_icon'].toString(),
                                                                              ),
                                                                              fit: BoxFit.contain),
                                                                          borderRadius: (languageDirection == 'rtl')
                                                                              ? const BorderRadius.only(
                                                                                  topLeft: Radius.circular(30),
                                                                                )
                                                                              : const BorderRadius.only(
                                                                                  topRight: Radius.circular(30),
                                                                                ),
                                                                        ),
                                                                      )),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child:
                                                                          MyText(
                                                                        text: vehicledata[i]['license_number']
                                                                            .toString(),
                                                                        size: media.width *
                                                                            fourteen,
                                                                      )),
                                                                  Expanded(
                                                                      flex: 3,
                                                                      child:
                                                                          MyText(
                                                                        text: vehicledata[i]['brand']
                                                                            .toString(),
                                                                        size: media.width *
                                                                            fourteen,
                                                                      )),
                                                                ],
                                                              ),
                                                            )),
                                                        Expanded(
                                                            flex: 57,
                                                            child: Stack(
                                                              children: [
                                                                vehicledata[i]['approve']
                                                                            .toString() ==
                                                                        '1'
                                                                    ? Center(
                                                                        child:
                                                                            Container(
                                                                          decoration: const BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(image: AssetImage('assets/images/approved.png'), opacity: 0.4, fit: BoxFit.contain)),
                                                                          height:
                                                                              media.width * 0.15,
                                                                          width:
                                                                              media.width * 0.15,
                                                                        ),
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Container(
                                                                              decoration: const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/images/wait.png'), opacity: 0.4, fit: BoxFit.contain)),
                                                                              height: media.width * 0.15,
                                                                              width: media.width * 0.15,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                Positioned(
                                                                    left: media
                                                                            .width *
                                                                        0.05,
                                                                    child:
                                                                        SizedBox(
                                                                      height: media
                                                                              .width *
                                                                          0.27,
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .spaceEvenly,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            vehicledata[i]['driverDetail'] != null
                                                                                ? MyText(text: vehicledata[i]['driverDetail']['data']['name'].toString(), size: media.width * fourteen, fontweight: FontWeight.bold)
                                                                                : Container(),
                                                                            vehicledata[i]['driverDetail'] != null
                                                                                ? MyText(
                                                                                    text: vehicledata[i]['driverDetail']['data']['mobile'].toString(),
                                                                                    size: media.width * fourteen,
                                                                                  )
                                                                                : Container(),
                                                                            MyText(
                                                                                text: vehicledata[i]['model'].toString(),
                                                                                size: media.width * fourteen,
                                                                                fontweight: FontWeight.bold),
                                                                            if (vehicledata[i]['driverDetail'] ==
                                                                                null)
                                                                              MyText(
                                                                                text: languages[choosenLanguage]['text_driver_not_assigned'],
                                                                                size: media.width * sixteen,
                                                                                fontweight: FontWeight.bold,
                                                                              ),
                                                                            if (vehicledata[i]['driverDetail'] == null &&
                                                                                vehicledata[i]['approve'].toString() == '0')
                                                                              Container(
                                                                                // width: media.width *
                                                                                //     0.4,
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.all(media.width * 0.01),
                                                                                decoration: BoxDecoration(
                                                                                  color: buttonColor,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: MyText(
                                                                                  text: languages[choosenLanguage]['text_waiting_approval'],
                                                                                  size: media.width * fourteen,
                                                                                  color: (isDarkTheme) ? Colors.black : buttonText,
                                                                                ),
                                                                              )
                                                                          ]),
                                                                    ))
                                                              ],
                                                            )),
                                                        Expanded(
                                                            flex: 8,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 5),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        if (isclickmenu ==
                                                                            i.toString()) {
                                                                          isclickmenu =
                                                                              '';
                                                                        } else {
                                                                          isclickmenu =
                                                                              i.toString();
                                                                        }
                                                                        fleetid =
                                                                            vehicledata[int.parse(isclickmenu)]['id'];
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .more_vert,
                                                                      color:
                                                                          textColor,
                                                                      size: 30,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                isclickmenu == i.toString()
                                                    ? Positioned(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              height:
                                                                  media.width *
                                                                      0.3,
                                                              width:
                                                                  media.width *
                                                                      0.3,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: page,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color:
                                                                        hintColor,
                                                                    offset: const Offset(
                                                                        0.0,
                                                                        1.0), //(x,y)
                                                                    blurRadius:
                                                                        5.0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  if (vehicledata[i]
                                                                              [
                                                                              'approve']
                                                                          .toString() !=
                                                                      '0')
                                                                    MenuClass(
                                                                      ontap:
                                                                          () async {
                                                                        var nav = await Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => AssignDriver(
                                                                                      fleetid: fleetid,
                                                                                      i: i,
                                                                                    )));
                                                                        if (nav !=
                                                                            null) {
                                                                          if (nav) {
                                                                            isclickmenu =
                                                                                '';
                                                                            getvehicledata();
                                                                          }
                                                                        }
                                                                      },
                                                                      text: languages[
                                                                              choosenLanguage]
                                                                          [
                                                                          'text_assign_driver'],
                                                                    ),
                                                                  MenuClass(
                                                                    ontap:
                                                                        () async {
                                                                      var nav = await Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => FleetDocuments(fleetid: fleetid)));
                                                                      if (nav !=
                                                                          null) {
                                                                        if (nav) {
                                                                          setState(
                                                                              () {
                                                                            isclickmenu =
                                                                                '';
                                                                          });
                                                                        }
                                                                      }
                                                                    },
                                                                    text: (vehicledata[i]['approve'].toString() !=
                                                                            '1')
                                                                        ? languages[choosenLanguage]
                                                                            [
                                                                            'text_upload_doc']
                                                                        : languages[choosenLanguage]
                                                                            [
                                                                            'text_edit_docs'],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            : (_isLoading == false)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: media.width * 0.3,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: media.width * 0.5,
                                        width: media.width * 0.5,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage((isDarkTheme)
                                                    ? 'assets/images/nodatafoundd.gif'
                                                    : 'assets/images/nodatafound.gif'),
                                                fit: BoxFit.contain)),
                                      ),
                                      SizedBox(
                                        height: media.width * 0.07,
                                      ),
                                      SizedBox(
                                        width: media.width * 0.8,
                                        child: MyText(
                                            text: languages[choosenLanguage]
                                                ['text_noDataFound'],
                                            textAlign: TextAlign.center,
                                            fontweight: FontWeight.w800,
                                            size: media.width * sixteen),
                                      ),
                                    ],
                                  )
                                : Container(),
                      ),
                    ),

                    //add vehicles
                    Container(
                      padding: EdgeInsets.all(media.width * 0.05),
                      child: Button(
                          onTap: () async {
                            myServiceId = userDetails['service_location_id'];
                            isowner = true;
                            var nav = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CarInformation(
                                          frompage: 3,
                                        )));
                            if (nav != null) {
                              if (nav) {
                                getvehicledata();
                              }
                            }
                          },
                          text: languages[choosenLanguage]['text_add_vehicle']),
                    ),
                  ],
                ),
              ),

              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),
              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          setState(() {
                            internetTrue();
                          });
                        },
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuClass extends StatelessWidget {
  final String text;
  final void Function() ontap;
  const MenuClass({Key? key, required this.text, required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Padding(
      padding:
          EdgeInsets.only(left: media.width * 0.03, top: media.width * 0.01),
      child: InkWell(
        onTap: ontap,
        child: SizedBox(
          width: media.width * 0.3,
          height: media.width * 0.08,
          child: MyText(
            text: text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            size: media.width * fourteen,
            fontweight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
