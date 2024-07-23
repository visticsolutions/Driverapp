import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/login.dart';
import 'package:image_picker/image_picker.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../noInternet/nointernet.dart';
import 'carinformation.dart';
import 'requiredinformation.dart';

class OwnersRegister extends StatefulWidget {
  const OwnersRegister({Key? key}) : super(key: key);

  @override
  State<OwnersRegister> createState() => _OwnersRegisterState();
}

String ownerName = ''; //name of user
String ownerEmail = ''; // email of user
String companyName = '';
String companyAddress = '';
String city = '';
String postalCode = '';
String taxNumber = '';
String ownerServiceLocation = '';

class _OwnersRegisterState extends State<OwnersRegister> {
  bool chooseWorkArea = false;

  bool _loading = true;
  dynamic tempServiceLocationId;
  bool serviceConfirmed = false;
  // ignore: unused_field, prefer_final_fields
  bool _chooseLocation = false;
  var verifyEmailError = '';
  var error = '';
  ImagePicker picker = ImagePicker();

  TextEditingController emailText =
      TextEditingController(); //email textediting controller
  TextEditingController nameText =
      TextEditingController(); //name textediting controller
  TextEditingController companyText =
      TextEditingController(); //name textediting controller
  TextEditingController addressText =
      TextEditingController(); //name textediting controller
  TextEditingController cityText =
      TextEditingController(); //name textediting controller
  TextEditingController postalText =
      TextEditingController(); //name textediting controller
  TextEditingController taxText =
      TextEditingController(); //name textediting controller

  getLocations() async {
    if (enabledModule == 'both') {
      transportType = '';
    }
    myServiceId = '';
    var result = await getServiceLocation();
    if (result == 'success') {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = true;
      });
    }
  }

  @override
  void initState() {
    proImageFile1 = null;
    getLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/carinfo.jpg'),
                        fit: BoxFit.cover)),
              ),

              Positioned(
                  child: Container(
                color: Colors.transparent.withOpacity(0.2),
                padding: EdgeInsets.all(media.width * 0.05),
                height: media.height,
                width: media.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    SizedBox(
                      width: media.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(media.width * 0.05),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: media.width * 0.11,
                                  width: media.width * 0.11,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.17)),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: media.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(media.width * 0.05),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                width: media.width * 0.65,
                                height: media.width * 0.11,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                        (media.width * 0.11) / 2),
                                    color: Colors.black.withOpacity(0.17)),
                                alignment: Alignment.center,
                                child: MyText(
                                  text: languages[choosenLanguage]
                                      ['text_company_info'],
                                  size: media.width * sixteen,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: media.width * 0.05,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Expanded(
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(media.width * 0.05),
                            child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: Container(
                                  width: media.width * 0.9,
                                  padding: EdgeInsets.only(
                                      left: media.width * 0.05,
                                      right: media.width * 0.05),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      borderRadius: BorderRadius.circular(
                                          (media.width * 0.11) / 2),
                                      color: Colors.black.withOpacity(0.17)),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        if (enabledModule == 'both')
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: media.width * 0.05,
                                              ),
                                              SizedBox(
                                                  width: media.width * 0.8,
                                                  child: MyText(
                                                    text: languages[
                                                            choosenLanguage]
                                                        ['text_register_for'],
                                                    size:
                                                        media.width * fourteen,
                                                    fontweight: FontWeight.w600,
                                                    maxLines: 1,
                                                    color: whiteText,
                                                  )),
                                              SizedBox(
                                                height: media.height * 0.012,
                                              ),
                                              SizedBox(
                                                width: media.width * 0.8,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: media.width *
                                                                0.025,
                                                            right: media.width *
                                                                0.01),
                                                        width:
                                                            media.width * 0.25,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              transportType =
                                                                  'taxi';
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            whiteText,
                                                                        width:
                                                                            1.2)),
                                                                child: (transportType ==
                                                                        'taxi')
                                                                    ? Center(
                                                                        child:
                                                                            Icon(
                                                                        Icons
                                                                            .done,
                                                                        color:
                                                                            whiteText,
                                                                        size: media.width *
                                                                            0.04,
                                                                      ))
                                                                    : Container(),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.025,
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.15,
                                                                child: MyText(
                                                                  text: languages[
                                                                          choosenLanguage]
                                                                      [
                                                                      'text_taxi_'],
                                                                  size: media
                                                                          .width *
                                                                      fourteen,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      whiteText,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: media.width *
                                                                0.025,
                                                            right: media.width *
                                                                0.025),
                                                        width:
                                                            media.width * 0.26,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              transportType =
                                                                  'delivery';
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            whiteText,
                                                                        width:
                                                                            1.2)),
                                                                child: (transportType ==
                                                                        'delivery')
                                                                    ? Center(
                                                                        child:
                                                                            Icon(
                                                                        Icons
                                                                            .done,
                                                                        color:
                                                                            whiteText,
                                                                        size: media.width *
                                                                            0.04,
                                                                      ))
                                                                    : Container(),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.025,
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.18,
                                                                child: MyText(
                                                                  text: languages[
                                                                          choosenLanguage]
                                                                      [
                                                                      'text_delivery'],
                                                                  size: media
                                                                          .width *
                                                                      fourteen,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      whiteText,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: media.width *
                                                                0.025,
                                                            right: media.width *
                                                                0.025),
                                                        width:
                                                            media.width * 0.25,
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              transportType =
                                                                  'both';
                                                            });
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                height: media
                                                                        .width *
                                                                    0.05,
                                                                width: media
                                                                        .width *
                                                                    0.05,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color:
                                                                            whiteText,
                                                                        width:
                                                                            1.2)),
                                                                child: (transportType ==
                                                                        'both')
                                                                    ? Center(
                                                                        child:
                                                                            Icon(
                                                                        Icons
                                                                            .done,
                                                                        color:
                                                                            whiteText,
                                                                        size: media.width *
                                                                            0.04,
                                                                      ))
                                                                    : Container(),
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.025,
                                                              ),
                                                              SizedBox(
                                                                width: media
                                                                        .width *
                                                                    0.15,
                                                                child: MyText(
                                                                  text: languages[
                                                                          choosenLanguage]
                                                                      [
                                                                      'text_both'],
                                                                  size: media
                                                                          .width *
                                                                      fourteen,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      whiteText,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: media.width * 0.02,
                                              )
                                            ],
                                          ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        MyText(
                                          text: languages[choosenLanguage]
                                              ['text_service_location'],
                                          size: media.width * sixteen,
                                          fontweight: FontWeight.w600,
                                          color: whiteText,
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            if (transportType != '' ||
                                                enabledModule != 'both') {
                                              tempServiceLocationId =
                                                  myServiceId;
                                              serviceConfirmed = false;
                                              await showModalBottomSheet(
                                                  context: context,
                                                  builder: (builder) {
                                                    return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            setState) {
                                                      return Container(
                                                        padding: EdgeInsets.all(
                                                            media.width * 0.05),
                                                        width: media.width,
                                                        decoration: BoxDecoration(
                                                            color: page,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        media.width *
                                                                            0.05),
                                                                topRight: Radius
                                                                    .circular(media
                                                                            .width *
                                                                        0.05))),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  media.width *
                                                                      0.9,
                                                              child: MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_service_loc'],
                                                                size: media
                                                                        .width *
                                                                    sixteen,
                                                                fontweight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    SingleChildScrollView(
                                                              child: Column(
                                                                children: serviceLocations
                                                                    .asMap()
                                                                    .map((k, value) => MapEntry(
                                                                        k,
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              tempServiceLocationId = serviceLocations[k]['id'];
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(media.width * 0.05),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: media.width * 0.05,
                                                                                  height: media.width * 0.05,
                                                                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: theme)),
                                                                                  alignment: Alignment.center,
                                                                                  child: (tempServiceLocationId == serviceLocations[k]['id'])
                                                                                      ? Container(
                                                                                          width: media.width * 0.025,
                                                                                          height: media.width * 0.025,
                                                                                          decoration: BoxDecoration(shape: BoxShape.circle, color: theme),
                                                                                        )
                                                                                      : Container(),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: media.width * 0.025,
                                                                                ),
                                                                                Expanded(child: MyText(text: serviceLocations[k]['name'], size: media.width * sixteen)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )))
                                                                    .values
                                                                    .toList(),
                                                              ),
                                                            )),
                                                            Button(
                                                                onTap: () {
                                                                  serviceConfirmed =
                                                                      true;
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_confirm'])
                                                          ],
                                                        ),
                                                      );
                                                    });
                                                  });
                                              if (myServiceId !=
                                                      tempServiceLocationId &&
                                                  serviceConfirmed == true) {
                                                myServiceId =
                                                    tempServiceLocationId;
                                                setState(() {
                                                  error = '';
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: media.width * 0.13,
                                            width: media.width * 0.8,
                                            decoration: BoxDecoration(
                                              color: (transportType != '' ||
                                                      enabledModule != 'both')
                                                  ? Colors.transparent
                                                  : const Color(0xFFD9D9D9)
                                                      .withOpacity(0.31),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.01),
                                              border:
                                                  Border.all(color: whiteText),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: media.width * 0.05,
                                                right: media.width * 0.05),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  // width: media.width * 0.7,
                                                  child: MyText(
                                                      text: (myServiceId == '')
                                                          ? languages[
                                                                  choosenLanguage][
                                                              'text_service_loc']
                                                          : (myServiceId !=
                                                                      null &&
                                                                  myServiceId !=
                                                                      '')
                                                              ? serviceLocations
                                                                      .isNotEmpty
                                                                  ? serviceLocations
                                                                      .firstWhere(
                                                                          (element) =>
                                                                              element['id'] ==
                                                                              myServiceId)[
                                                                          'name']
                                                                      .toString()
                                                                  : ''
                                                              : userDetails[
                                                                  'service_location_name'],
                                                      size: media.width *
                                                          fourteen,
                                                      color: (myServiceId == '')
                                                          ? whiteText
                                                          : whiteText),
                                                ),
                                                Icon(
                                                  (transportType != '' ||
                                                          enabledModule !=
                                                              'both')
                                                      ? Icons
                                                          .keyboard_arrow_down
                                                      : Icons
                                                          .lock_outline_rounded,
                                                  size: media.width * 0.05,
                                                  color: whiteText,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Container(
                                            height: media.width * 0.13,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02),
                                              border:
                                                  Border.all(color: whiteText),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: media.width * 0.05,
                                                right: media.width * 0.05),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: media.width * 0.0125),
                                              child: InputField(
                                                textController: companyText,
                                                text: languages[choosenLanguage]
                                                    ['text_company_name'],
                                                onTap: (val) {
                                                  companyName =
                                                      companyText.text;
                                                },
                                                color: whiteText,
                                              ),
                                            )),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Container(
                                          height: media.width * 0.13,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                media.width * 0.02),
                                            border:
                                                Border.all(color: whiteText),
                                          ),
                                          padding: EdgeInsets.only(
                                              left: media.width * 0.05,
                                              right: media.width * 0.05),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: media.width * 0.0125),
                                            child: InputField(
                                              textController: addressText,
                                              text: languages[choosenLanguage]
                                                  ['text_address'],
                                              onTap: (val) {
                                                companyAddress =
                                                    addressText.text;
                                              },
                                              color: whiteText,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Container(
                                            height: media.width * 0.13,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02),
                                              border:
                                                  Border.all(color: whiteText),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: media.width * 0.05,
                                                right: media.width * 0.05),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: media.width * 0.0125),
                                              child: InputField(
                                                  textController: cityText,
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_city'],
                                                  onTap: (val) {
                                                    city = cityText.text;
                                                  },
                                                  color: whiteText),
                                            )),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Container(
                                            height: media.width * 0.13,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02),
                                              border:
                                                  Border.all(color: whiteText),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: media.width * 0.05,
                                                right: media.width * 0.05),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: media.width * 0.0125),
                                              child: InputField(
                                                  textController: postalText,
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_postal_code'],
                                                  inputType:
                                                      TextInputType.number,
                                                  onTap: (val) {
                                                    postalCode =
                                                        postalText.text;
                                                  },
                                                  color: whiteText),
                                            )),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                        Container(
                                            height: media.width * 0.13,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      media.width * 0.02),
                                              border:
                                                  Border.all(color: whiteText),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: media.width * 0.05,
                                                right: media.width * 0.05),
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: media.width * 0.0125),
                                              child: InputField(
                                                textController: taxText,
                                                text: languages[choosenLanguage]
                                                    ['text_tax_number'],
                                                onTap: (val) {
                                                  taxNumber = taxText.text;
                                                },
                                                color: whiteText,
                                              ),
                                            )),
                                        SizedBox(
                                          height: media.width * 0.05,
                                        ),
                                      ],
                                    ),
                                  ),
                                )))),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    if (error != '')
                      Column(
                        children: [
                          SizedBox(
                            width: media.width * 0.9,
                            child: MyText(
                              text: error,
                              size: media.width * fourteen,
                              color: Colors.red,
                              textAlign: TextAlign.center,
                              maxLines: 5,
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.025,
                          ),
                        ],
                      ),
                    Button(
                        width: media.width * 0.5,
                        onTap: () async {
                          if (companyText.text.isNotEmpty &&
                              addressText.text.isNotEmpty &&
                              cityText.text.isNotEmpty &&
                              postalText.text.isNotEmpty &&
                              taxText.text.isNotEmpty &&
                              (transportType != '' ||
                                  enabledModule != 'both')) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              verifyEmailError = '';
                              error = '';
                              _loading = true;
                            });

                            var val = await registerOwner();
                            if (val == 'true') {
                              carInformationCompleted = true;
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context, true);
                              serviceLocations.clear();
                            } else {
                              error = val.toString();
                            }

                            setState(() {
                              _loading = false;
                            });
                          } else {
                            setState(() {
                              error = 'Please enter all data to proceed';
                            });
                          }
                        },
                        text: languages[choosenLanguage]['text_next']),
                  ],
                ),
              )),

              //permission denied popup

              //internet not connected
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

              //loader
              (_loading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
