import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/landingpage.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';

class AssignDriver extends StatefulWidget {
  final String? fleetid;
  final int? i;
  const AssignDriver({Key? key, required this.fleetid, required this.i})
      : super(key: key);

  @override
  State<AssignDriver> createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  String isassigndriver = '';
  int? driverid;
  bool _isLoadingassigndriver = true;
  bool _showToast = false;

  @override
  void initState() {
    setState(() {
      getdriverdata();
      isassigndriver = '';
    });
    super.initState();
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
    var val =
        await fleetDriverDetails(fleetid: widget.fleetid, isassigndriver: true);
    if (val == 'logout') {
      navigateLogout();
    }
    var val1 = await getVehicleInfo();
    if (val1 == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        // if (_isLoadingassigndriver == true) {
        //   showToast();
        // }
        _isLoadingassigndriver = false;
      });
    }
  }

  showToast() {
    setState(() {
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showToast = false;
      });
    });
  }

  String fleetid = '';

  //navigate
  pop() {
    Navigator.pop(context, true);
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
                                    Navigator.pop(context, true);
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
                          child: Column(
                            children: [
                              SizedBox(
                                height: media.width * 0.025,
                              ),
                              SizedBox(
                                height: media.width * 0.35,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: media.width * 0.01,
                                      left: media.width * 0.01,
                                      bottom: media.width * 0.03),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: media.width * 0.3,
                                        width: media.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                                  padding: EdgeInsets.all(
                                                      media.width * 0.01),
                                                  height: media.width * 0.3,
                                                  decoration: BoxDecoration(
                                                    color: page,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: hintColor,
                                                        offset: const Offset(
                                                            0.0, 1.0), //(x,y)
                                                        blurRadius: 8.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      (vehicledata[widget.i!][
                                                                  'driverDetail'] !=
                                                              null)
                                                          ? Container(
                                                              height:
                                                                  media.width *
                                                                      0.20,
                                                              width:
                                                                  media.width *
                                                                      0.20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                        image:
                                                                            NetworkImage(
                                                                          vehicledata[widget.i!]['driverDetail']['data']['profile_picture']
                                                                              .toString(),
                                                                        ),
                                                                        fit: BoxFit
                                                                            .fill),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .all(
                                                                        Radius.circular(
                                                                            10)),
                                                              ),
                                                            )
                                                          : Container(),
                                                      (vehicledata[widget.i!][
                                                                  'driverDetail'] !=
                                                              null)
                                                          ? MyText(
                                                              text: vehicledata[
                                                                              widget.i!]
                                                                          [
                                                                          'driverDetail']
                                                                      [
                                                                      'data']['name']
                                                                  .toString(),
                                                              size:
                                                                  media.width *
                                                                      sixteen,
                                                              fontweight:
                                                                  FontWeight
                                                                      .bold,
                                                            )
                                                          : MyText(
                                                              text: languages[
                                                                      choosenLanguage]
                                                                  [
                                                                  'text_no_driver'],
                                                              size:
                                                                  media.width *
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
                                                        left:
                                                            media.width * 0.05,
                                                        right:
                                                            media.width * 0.03),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (vehicledata[
                                                                    widget.i!][
                                                                'driverDetail'] !=
                                                            null)
                                                          MyText(
                                                            text: vehicledata[widget
                                                                            .i!]
                                                                        [
                                                                        'driverDetail']
                                                                    [
                                                                    'data']['mobile']
                                                                .toString(),
                                                            size: media.width *
                                                                fourteen,
                                                          ),
                                                        MyText(
                                                          text: vehicledata[
                                                                      widget.i!]
                                                                  [
                                                                  'license_number']
                                                              .toString(),
                                                          size: media.width *
                                                              fourteen,
                                                        ),
                                                        MyText(
                                                          text:
                                                              '${vehicledata[widget.i!]['brand']},${vehicledata[widget.i!]['model']}',
                                                          size: media.width *
                                                              fourteen,
                                                        ),
                                                        Container(
                                                            height:
                                                                media.width *
                                                                    0.1,
                                                            width: media.width *
                                                                0.2,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                      image:
                                                                          NetworkImage(
                                                                        vehicledata[widget.i!]['type_icon']
                                                                            .toString(),
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover),
                                                            )),
                                                      ],
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: media.width * 0.01,
                                    left: media.width * 0.01,
                                    bottom: media.width * 0.03),
                                child: MyText(
                                  text: languages[choosenLanguage]
                                      ['text_assign_new_driver'],
                                  size: media.width * eighteen,
                                  fontweight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: fleetdriverList.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var i = 0;
                                              i < fleetdriverList.length;
                                              i++)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: media.width * 0.01,
                                                  left: media.width * 0.01,
                                                  bottom: media.width * 0.03),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isassigndriver =
                                                            i.toString();
                                                        driverid = fleetdriverList[
                                                                int.parse(
                                                                    isassigndriver)]
                                                            ['id'];
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
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              flex: 35,
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .all(media
                                                                            .width *
                                                                        0.02),
                                                                // height: media
                                                                //         .width *
                                                                //     0.3,
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
                                                                          0.20,
                                                                      width: media
                                                                              .width *
                                                                          0.20,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        image: DecorationImage(
                                                                            image: NetworkImage(
                                                                              fleetdriverList[i]['profile_picture'].toString(),
                                                                            ),
                                                                            fit: BoxFit.fill),
                                                                        borderRadius: const BorderRadius
                                                                            .all(
                                                                            Radius.circular(10)),
                                                                      ),
                                                                    ),
                                                                    MyText(
                                                                      text: fleetdriverList[i]
                                                                              [
                                                                              'name']
                                                                          .toString(),
                                                                      maxLines:
                                                                          1,
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
                                                              flex: 45,
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
                                                                        text: fleetdriverList[i]['mobile']
                                                                            .toString(),
                                                                        size: media.width *
                                                                            fourteen,
                                                                      ),
                                                                      // ignore: unnecessary_null_comparison
                                                                      fleetdriverList[i]['car_number'].toString() ==
                                                                              'null'
                                                                          ? Container()
                                                                          : MyText(
                                                                              text: fleetdriverList[i]['car_number'].toString(),
                                                                              size: media.width * fourteen,
                                                                            ),
                                                                      fleetdriverList[i]['car_make_name'].toString() ==
                                                                              'null'
                                                                          ? Container()
                                                                          : MyText(
                                                                              text: '${fleetdriverList[i]['car_make_name']},${fleetdriverList[i]['car_model_name']}',
                                                                              size: media.width * fourteen,
                                                                            ),

                                                                      (fleetdriverList[i]['vehicle_type_icon'] !=
                                                                              null)
                                                                          ? Container(
                                                                              height: media.width * 0.1,
                                                                              width: media.width * 0.2,
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(
                                                                                    image: NetworkImage(
                                                                                      fleetdriverList[i]['vehicle_type_icon'].toString(),
                                                                                    ),
                                                                                    fit: BoxFit.cover),
                                                                              ))
                                                                          : Container(),
                                                                    ],
                                                                  ))),
                                                          Expanded(
                                                            flex: 20,
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height:
                                                                  media.width *
                                                                      0.08,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border
                                                                    .all(),
                                                              ),
                                                              child: Container(
                                                                height: media
                                                                        .width *
                                                                    0.04,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: isassigndriver ==
                                                                          i
                                                                              .toString()
                                                                      ? Colors
                                                                          .green
                                                                      : page,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    : (_isLoadingassigndriver == false)
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
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
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_noDataFound'],
                                                    textAlign: TextAlign.center,
                                                    fontweight: FontWeight.w800,
                                                    size:
                                                        media.width * sixteen),
                                              ),
                                            ],
                                          )
                                        : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(media.width * 0.02),
                        child: Button(
                          onTap: () async {
                            setState(() {
                              _isLoadingassigndriver = true;
                            });

                            var result =
                                await assignDriver(driverid, widget.fleetid);
                            if (result == 'true') {
                              var val = await getVehicleInfo();
                              if (val == 'logout') {
                                navigateLogout();
                              } else {
                                pop();
                              }
                            } else if (result == 'logout') {
                              navigateLogout();
                            } else {
                              setState(() {
                                _isLoadingassigndriver = false;
                              });
                              showToast();
                            }
                          },
                          text: languages[choosenLanguage]
                              ['text_assign_driver'],
                        ),
                      ),
                    ],
                  )),
              (_isLoadingassigndriver == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),
              (_showToast == true)
                  ? Positioned(
                      bottom: media.height * 0.2,
                      left: media.width * 0.2,
                      right: media.width * 0.2,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(media.width * 0.025),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent.withOpacity(0.6)),
                        child: MyText(
                          text: languages[choosenLanguage]
                              ['text_select_driver'],
                          size: media.width * twelve,
                          color: topBar,
                        ),
                      ))
                  : Container()
            ])));
  }
}
