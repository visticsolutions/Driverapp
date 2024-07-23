import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/landingpage.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import 'adddriver.dart';

class DriverList extends StatefulWidget {
  const DriverList({Key? key}) : super(key: key);

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  bool _isLoading = false;
  String isclickmenu = '';
  dynamic _shimmer;

  @override
  void initState() {
    _shimmer = AnimationController.unbounded(vsync: MyTickerProvider())
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
    // setState(() {
    getdriverdata();
    // });
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

  getdriverdata() async {
    if (fleetdriverList.isEmpty) {
      for (var i = 0; i < 10; i++) {
        fleetdriverList.add({});
      }
    }
    var val = await fleetDriverDetails();
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  driverdeletepopup(media, driverid) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: page,
            content: SizedBox(
              width: media.width * 0.8,
              // color: page,
              child: MyText(
                text: languages[choosenLanguage]['text_delete_confirmation'],
                size: media.width * sixteen,
                fontweight: FontWeight.bold,
              ),
            ),
            actions: [
              Button(
                  width: media.width * 0.2,
                  height: media.width * 0.09,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: languages[choosenLanguage]['text_no']),
              Button(
                  width: media.width * 0.2,
                  height: media.width * 0.09,
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _isLoading = true;
                    });
                    var val = await deletefleetdriver(driverid);
                    if (val == 'logout') {
                      navigateLogout();
                    }

                    getdriverdata();
                  },
                  text: languages[choosenLanguage]['text_yes']),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: Directionality(
            textDirection: (languageDirection == 'rtl')
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Stack(children: [
              Container(
                  padding: EdgeInsets.fromLTRB(
                      media.width * 0.05,
                      MediaQuery.of(context).padding.top + media.width * 0.05,
                      media.width * 0.05,
                      0),
                  height: media.height * 1,
                  width: media.width * 1,
                  color: (isDarkTheme && fleetdriverList.isEmpty)
                      ? Colors.black
                      : page,
                  //history details
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.only(bottom: media.width * 0.05),
                            width: media.width * 0.9,
                            alignment: Alignment.center,
                            child: MyText(
                              text: languages[choosenLanguage]
                                  ['text_manage_drivers'],
                              size: media.width * sixteen,
                              fontweight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: textColor,
                                  )))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: fleetdriverList.isNotEmpty
                              ? Column(
                                  children: [
                                    for (var i = 0;
                                        i < fleetdriverList.length;
                                        i++)
                                      (fleetdriverList[i].isEmpty)
                                          ? AnimatedBuilder(
                                              animation: _shimmer,
                                              builder: (context, widget) {
                                                return ShaderMask(
                                                    blendMode:
                                                        BlendMode.srcATop,
                                                    shaderCallback: (bounds) {
                                                      return LinearGradient(
                                                              colors:
                                                                  shaderColor,
                                                              stops:
                                                                  shaderStops,
                                                              begin:
                                                                  shaderBegin,
                                                              end: shaderEnd,
                                                              tileMode: TileMode
                                                                  .clamp,
                                                              transform: SlidingGradientTransform(
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
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.15,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.15,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
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
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.2,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.2,
                                                                color: hintColor
                                                                    .withOpacity(
                                                                        0.5),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                media.width *
                                                                    0.02,
                                                          ),
                                                          const MySeparator(),
                                                          // Container(
                                                          //   height: 1,
                                                          //   width: media.width * 0.8,
                                                          //   color: hintColor,
                                                          // ),
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
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: hintColor
                                                                        .withOpacity(
                                                                            0.5)),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
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
                                                            height:
                                                                media.width *
                                                                    0.03,
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
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: hintColor
                                                                        .withOpacity(
                                                                            0.5)),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
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
                                                      // height: media.width * 0.3,
                                                      width: media.width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: page,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: hintColor,
                                                            offset: const Offset(
                                                                0.0,
                                                                1.0), //(x,y)
                                                            blurRadius: 5.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(children: [
                                                        Expanded(
                                                            flex: 35,
                                                            child: Container(
                                                              // height:
                                                              //     media.width * 0.3,
                                                              padding: EdgeInsets.only(
                                                                  left: media
                                                                          .width *
                                                                      0.01,
                                                                  right: media
                                                                          .width *
                                                                      0.01),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: page,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            10)),
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
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    height: media
                                                                            .width *
                                                                        0.24,
                                                                    width: media
                                                                            .width *
                                                                        0.24,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: NetworkImage(
                                                                            fleetdriverList[i]['profile_picture'].toString(),
                                                                          ),
                                                                          fit: BoxFit.cover),
                                                                      borderRadius: const BorderRadius
                                                                          .all(
                                                                          Radius.circular(
                                                                              10)),
                                                                    ),
                                                                  ),
                                                                  MyText(
                                                                    text: fleetdriverList[i]
                                                                            [
                                                                            'name']
                                                                        .toString(),
                                                                    maxLines: 1,
                                                                    size: media
                                                                            .width *
                                                                        sixteen,
                                                                    fontweight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                        Expanded(
                                                            flex: 65,
                                                            child: Container(
                                                                padding: EdgeInsets.only(
                                                                    left: media
                                                                            .width *
                                                                        0.05,
                                                                    right: media
                                                                            .width *
                                                                        0.03),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    MyText(
                                                                      text: fleetdriverList[i]
                                                                              [
                                                                              'mobile']
                                                                          .toString(),
                                                                      size: media
                                                                              .width *
                                                                          fourteen,
                                                                    ),
                                                                    if (fleetdriverList[i]['car_number']
                                                                            .toString() ==
                                                                        'null')
                                                                      Container(
                                                                          height: media.width *
                                                                              0.1,
                                                                          width: media.width *
                                                                              0.2,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image: DecorationImage(
                                                                                image: const AssetImage('assets/images/disablecar.png'),
                                                                                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
                                                                                fit: BoxFit.contain),
                                                                          )),

                                                                    // ignore: unnecessary_null_comparison
                                                                    fleetdriverList[i]['car_number'].toString() ==
                                                                            'null'
                                                                        ? fleetdriverList[i]['approve'] ==
                                                                                false
                                                                            ? Container(
                                                                                // width:
                                                                                //     media.width * 0.4,
                                                                                alignment: Alignment.center,
                                                                                padding: EdgeInsets.all(media.width * 0.01),
                                                                                decoration: BoxDecoration(
                                                                                  // border: Border.all(
                                                                                  //     color: Colors.yellow,
                                                                                  //     width: 2),
                                                                                  color: buttonColor,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: MyText(
                                                                                  text: languages[choosenLanguage]['text_waiting_approval'],
                                                                                  size: media.width * fourteen,
                                                                                  color: (isDarkTheme) ? Colors.black : buttonText,
                                                                                ),
                                                                              )
                                                                            : MyText(
                                                                                text: languages[choosenLanguage]['text_fleet_not_assigned'],
                                                                                size: media.width * fourteen,
                                                                                color: textColor,
                                                                                fontweight: FontWeight.bold,
                                                                              )
                                                                        : MyText(
                                                                            text:
                                                                                fleetdriverList[i]['car_number'].toString(),
                                                                            size:
                                                                                media.width * fourteen,
                                                                            fontweight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    fleetdriverList[i]['car_make_name'].toString() ==
                                                                            'null'
                                                                        ? Container()
                                                                        : MyText(
                                                                            text:
                                                                                '${fleetdriverList[i]['car_make_name']},${fleetdriverList[i]['car_model_name']}',
                                                                            size:
                                                                                media.width * fourteen,
                                                                          ),
                                                                    if (fleetdriverList[i]
                                                                            [
                                                                            'vehicle_type_icon'] !=
                                                                        null)
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                              height: media.width * 0.1,
                                                                              width: media.width * 0.2,
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                      fleetdriverList[i]['vehicle_type_icon'].toString(),
                                                                                    ),
                                                                                    fit: BoxFit.contain),
                                                                              )),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showModalBottomSheet(
                                                                                  context: context,
                                                                                  builder: (builder) {
                                                                                    return DeletePopup(
                                                                                      onTap: () async {
                                                                                        Navigator.pop(context);
                                                                                        setState(() {
                                                                                          _isLoading = true;
                                                                                        });
                                                                                        var val = await deletefleetdriver(fleetdriverList[i]['id']);
                                                                                        if (val == 'logout') {
                                                                                          navigateLogout();
                                                                                        }

                                                                                        getdriverdata();
                                                                                      },
                                                                                    );
                                                                                  });
                                                                              // driverdeletepopup(media, fleetdriverList[i]['id']);
                                                                            },
                                                                            child:
                                                                                MyText(
                                                                              text: languages[choosenLanguage]['text_delete_driver'],
                                                                              size: media.width * twelve,
                                                                              color: inputFieldSeparator,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    if (fleetdriverList[i]
                                                                            [
                                                                            'vehicle_type_icon'] ==
                                                                        null)
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              // driverdeletepopup(media, fleetdriverList[i]['id']);
                                                                              showModalBottomSheet(
                                                                                  context: context,
                                                                                  builder: (builder) {
                                                                                    return DeletePopup(
                                                                                      onTap: () async {
                                                                                        Navigator.pop(context);
                                                                                        setState(() {
                                                                                          _isLoading = true;
                                                                                        });
                                                                                        var val = await deletefleetdriver(fleetdriverList[i]['id']);
                                                                                        if (val == 'logout') {
                                                                                          navigateLogout();
                                                                                        }

                                                                                        getdriverdata();
                                                                                      },
                                                                                    );
                                                                                  });
                                                                            },
                                                                            child:
                                                                                MyText(
                                                                              text: languages[choosenLanguage]['text_delete_driver'],
                                                                              size: media.width * twelve,
                                                                              color: inputFieldSeparator,
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ))),
                                                      ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    SizedBox(
                                      height: media.width * 0.02,
                                    ),
                                  ],
                                )
                              : (_isLoading == false)
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      Container(
                        padding: EdgeInsets.all(media.width * 0.05),
                        child: Button(
                            onTap: () async {
                              var nav = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AddDriver()));
                              if (nav != null) {
                                if (nav) {
                                  await getdriverdata();
                                }
                              }
                            },
                            text: languages[choosenLanguage]
                                ['text_add_driver']),
                      ),
                    ],
                  )),
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),
            ])));
  }
}

class DeletePopup extends StatefulWidget {
  final dynamic onTap;
  const DeletePopup({super.key, required this.onTap});

  @override
  State<DeletePopup> createState() => _DeletePopupState();
}

class _DeletePopupState extends State<DeletePopup> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: page,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(media.width * 0.04),
              topRight: Radius.circular(media.width * 0.04))),
      padding: EdgeInsets.all(media.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: media.width * 0.9,
            child: MyText(
              text: languages[choosenLanguage]['text_delete_confirmation'],
              size: media.width * sixteen,
              fontweight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: media.width * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Button(
                  width: media.width * 0.4,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: 'No'),
              Button(
                  width: media.width * 0.4, onTap: widget.onTap, text: 'Yes'),
            ],
          ),
        ],
      ),
    );
  }
}
