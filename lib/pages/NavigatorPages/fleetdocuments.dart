import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/landingpage.dart';
import '../login/login.dart';
import '../login/uploaddocument.dart';
import '../noInternet/nointernet.dart';

// ignore: must_be_immutable
class FleetDocuments extends StatefulWidget {
  // const Docs({ Key? key }) : super(key: key);
  final String fleetid;
  const FleetDocuments({Key? key, required this.fleetid}) : super(key: key);
  @override
  State<FleetDocuments> createState() => _FleetDocumentsState();
}

int fleetdocsId = 0;
int fleetchoosenDocs = 0;
bool fleetdocumentCompleted = false;

class _FleetDocumentsState extends State<FleetDocuments> {
  bool _loaded = true;

  @override
  void initState() {
    fleetdocumentsNeeded.clear();
    getdata();
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

  getdata() async {
    var val = await getFleetDocumentsNeeded(widget.fleetid);
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: true,
      child: Material(
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Stack(
            children: [
              Container(
                height: media.height * 1,
                width: media.width * 1,
                color: page,
                padding: EdgeInsets.only(
                    left: media.width * 0.05, right: media.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(
                      height: media.width * 0.05 +
                          MediaQuery.of(context).padding.top,
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: media.width * 0.05),
                          width: media.width * 1,
                          alignment: Alignment.center,
                          child: MyText(
                            text: languages[choosenLanguage]['text_docs'],
                            size: media.width * sixteen,
                            fontweight: FontWeight.w600,
                          ),
                        ),
                        Positioned(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {
                                    if (enableDocumentSubmit == true) {
                                      fleetdocumentCompleted = true;
                                    } else {
                                      fleetdocumentCompleted = false;
                                    }
                                    Navigator.pop(context, true);
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      color: textColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    SizedBox(
                      width: media.width * 0.9,
                      child: MyText(
                        text: languages[choosenLanguage]['text_docs']
                            .toString()
                            .toUpperCase(),
                        size: media.width * fourteen,
                        fontweight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    if (fleetdocumentsNeeded.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: fleetdocumentsNeeded
                                .asMap()
                                .map((i, value) {
                                  return MapEntry(
                                      i,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            text: fleetdocumentsNeeded[i]
                                                ['name'],
                                            size: media.width * fourteen,
                                            fontweight: FontWeight.bold,
                                          ),
                                          SizedBox(
                                            height: media.width * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              fleetdocsId =
                                                  fleetdocumentsNeeded[i]['id'];
                                              fleetchoosenDocs = i;

                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UploadDocs(
                                                            fleetid:
                                                                widget.fleetid,
                                                          )));
                                              setState(() {});
                                            },
                                            child: Container(
                                              width: media.width * 0.9,
                                              height: media.width * 0.165,
                                              padding: EdgeInsets.only(
                                                  right: media.width * 0.04,
                                                  left: media.width * 0.03),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color: (isDarkTheme ==
                                                              true)
                                                          ? textColor
                                                              .withOpacity(0.4)
                                                          : textColor,
                                                      width: 1),
                                                  color: (isDarkTheme == true)
                                                      ? Colors.black
                                                      : const Color(
                                                          0xffF8F8F8)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    (fleetdocumentsNeeded[i][
                                                                'is_uploaded'] ==
                                                            false)
                                                        ? MainAxisAlignment
                                                            .center
                                                        : MainAxisAlignment
                                                            .spaceBetween,
                                                children: [
                                                  (fleetdocumentsNeeded[i]
                                                              ['is_uploaded'] ==
                                                          true)
                                                      ? Container(
                                                          height:
                                                              media.width * 0.1,
                                                          width:
                                                              media.width * 0.1,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                                    image:
                                                                        NetworkImage(
                                                                      fleetdocumentsNeeded[i]['fleet_document']['data']
                                                                              [
                                                                              'document']
                                                                          .toString(),
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover),
                                                          ),
                                                        )
                                                      : Container(),
                                                  (fleetdocumentsNeeded[i]
                                                              ['is_uploaded'] ==
                                                          true)
                                                      ? SizedBox(
                                                          width:
                                                              media.width * 0.5,
                                                          child: MyText(
                                                            text: fleetdocumentsNeeded[
                                                                        i][
                                                                    'document_status_string']
                                                                .toString(),
                                                            size: media.width *
                                                                fourteen,
                                                            textAlign: TextAlign
                                                                .center,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      : Container(),
                                                  Icon(
                                                    (fleetdocumentsNeeded[i][
                                                                'is_uploaded'] ==
                                                            false)
                                                        ? Icons.cloud_upload
                                                        : Icons.done_outlined,
                                                    color: textColor,
                                                    size: media.width * 0.06,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (fleetdocumentsNeeded[i]
                                                  ['fleet_document'] !=
                                              null)
                                            if (fleetdocumentsNeeded[i]
                                                        ['fleet_document']
                                                    ['data']['comment'] !=
                                                null)
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: media.width * 0.02),
                                                width: media.width * 0.9,
                                                child: MyText(
                                                  text: fleetdocumentsNeeded[i]
                                                              ['fleet_document']
                                                          ['data']['comment']
                                                      .toString(),
                                                  size: media.width * fourteen,
                                                  textAlign: TextAlign.center,
                                                  color: Colors.red,
                                                ),
                                              ),
                                          SizedBox(
                                            height: media.width * 0.08,
                                          ),
                                        ],
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                    SizedBox(height: media.height * 0.02),

                    //submit documents
                    (enablefleetDocumentSubmit == true)
                        ? (fleetdocumentsNeeded.isNotEmpty)
                            ? Button(
                                onTap: () async {
                                  setState(() {
                                    _loaded = false;
                                  });
                                  Navigator.pop(context, true);
                                },
                                text: languages[choosenLanguage]['text_submit'])
                            : Container()
                        : Container(),
                    SizedBox(
                      height: media.width * 0.05,
                    )
                  ],
                ),
              ),
              if (_loaded == false)
                const Positioned(
                  child: Loading(),
                ),
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

class UploadDocs extends StatefulWidget {
  final String fleetid;
  const UploadDocs({Key? key, required this.fleetid}) : super(key: key);

  @override
  State<UploadDocs> createState() => _UploadDocsState();
}

String fleetdocIdNumber = '';
String fleetdate = '';
DateTime fleetexpDate = DateTime.now();
final ImagePicker _fleetpicker = ImagePicker();
dynamic fleetimageFile;

class _UploadDocsState extends State<UploadDocs> {
  bool _uploadImage = false;

  TextEditingController idNumber = TextEditingController();

  DateTime current = DateTime.now();
  bool _loading = false;
  String _error = '';
  String _permission = '';

//date picker
  _datePicker() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: current,
        lastDate: DateTime(2100));
    if (picker != null) {
      setState(() {
        fleetexpDate = picker;
        fleetdate = picker.toString().split(" ")[0];
      });
    }
  }

//get gallery permission
  getGalleryPermission() async {
    dynamic status;
    if (platform == TargetPlatform.android) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }

        /// use [Permissions.storage.status]
      } else {
        status = await Permission.photos.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.photos.request();
        }
      }
    } else {
      status = await Permission.photos.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }

// navigate pop
  pop() {
    Navigator.pop(context);
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

//get camera permission
  getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status;
  }

//image pick from gallery
  imagePick() async {
    var permission = await getGalleryPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await _fleetpicker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      setState(() {
        fleetimageFile = pickedFile?.path;
        _uploadImage = false;
      });
    } else {
      setState(() {
        _permission = 'noPhotos';
      });
    }
  }

//image pick from camera
  cameraPick() async {
    var permission = await getCameraPermission();
    if (permission == PermissionStatus.granted) {
      final pickedFile = await _fleetpicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);
      setState(() {
        fleetimageFile = pickedFile?.path;
        _uploadImage = false;
      });
    } else {
      setState(() {
        _permission = 'noCamera';
      });
    }
  }

  @override
  void initState() {
    fleetimageFile = null;
    fleetdate = '';
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
          child: Stack(
            children: [
              Container(
                height: media.height * 1,
                width: media.width * 1,
                padding: EdgeInsets.only(
                    left: media.width * 0.05, right: media.width * 0.05),
                color: page,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: media.width * 0.05 +
                                  MediaQuery.of(context).padding.top,
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: media.width * 0.05),
                                  width: media.width * 1,
                                  alignment: Alignment.center,
                                  child: MyText(
                                      text: languages[choosenLanguage]
                                          ['text_upload_docs'],
                                      size: media.width * fourteen),
                                ),
                                Positioned(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(Icons.arrow_back_ios,
                                              color: textColor)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: media.width * 0.05,
                            ),
                            Stack(
                              children: [
                                Container(
                                    height: media.width * 0.5,
                                    width: media.width * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      // color: Colors.transparent.withOpacity(0.2),
                                    ),
                                    child: (fleetimageFile != null)
                                        ? Container(
                                            height: media.width * 0.5,
                                            width: media.width * 0.5,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        File(fleetimageFile)),
                                                    fit: BoxFit.contain)),
                                          )
                                        : Container()),
                                Positioned(
                                    child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _uploadImage = true;
                                    });
                                  },
                                  child: Container(
                                    height: media.width * 0.5,
                                    width: media.width * 0.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload,
                                          size: media.width * 0.08,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MyText(
                                            text: (fleetimageFile == null)
                                                ? languages[choosenLanguage]
                                                    ['text_upload_image']
                                                : languages[choosenLanguage]
                                                    ['text_editimage'],
                                            size: media.width * twelve)
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                            if (fleetdocumentsNeeded[choosenDocs]
                                    ['has_identify_number'] ==
                                true)
                              Column(
                                children: [
                                  SizedBox(
                                    height: media.height * 0.05,
                                  ),
                                  SizedBox(
                                    width: media.width * 0.9,
                                    child: MyText(
                                      text: fleetdocumentsNeeded[choosenDocs]
                                              ['identify_number_locale_key']
                                          .toString(),
                                      size: media.width * sixteen,
                                      fontweight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: media.height * 0.02,
                                  ),
                                  Container(
                                      height: media.width * 0.13,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: (isDarkTheme == true)
                                                  ? textColor.withOpacity(0.4)
                                                  : underline),
                                          color: (isDarkTheme == true)
                                              ? Colors.black
                                              : const Color(0xffF8F8F8)),
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      child: MyTextField(
                                        textController: idNumber,
                                        hinttext: fleetdocumentsNeeded[
                                                    choosenDocs]
                                                ['identify_number_locale_key']
                                            .toString(),
                                        onTap: (val) {
                                          setState(() {
                                            fleetdocIdNumber = val;
                                          });
                                        },
                                      )),
                                ],
                              ),
                            if (fleetdocumentsNeeded[choosenDocs]
                                    ['has_expiry_date'] ==
                                true)
                              Column(
                                children: [
                                  SizedBox(
                                    height: media.height * 0.05,
                                  ),
                                  SizedBox(
                                    width: media.width * 0.9,
                                    child: MyText(
                                      text: languages[choosenLanguage]
                                          ['text_expiry_date'],
                                      size: media.width * sixteen,
                                      fontweight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: media.height * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _datePicker();
                                    },
                                    child: Container(
                                        height: media.width * 0.13,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: (isDarkTheme == true)
                                                    ? textColor.withOpacity(0.4)
                                                    : underline),
                                            color: (isDarkTheme == true)
                                                ? Colors.black
                                                : const Color(0xffF8F8F8)),
                                        width: media.width * 0.9,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        alignment: Alignment.centerLeft,
                                        child: MyText(
                                          text: (fleetdate != '')
                                              ? fleetdate
                                              : languages[choosenLanguage]
                                                  ['text_choose_expiry'],
                                          size: media.width * fourteen,
                                        )),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Column(
                        children: [
                          if (_error != '')
                            SizedBox(
                              width: media.width * 0.9,
                              child: MyText(
                                text: _error,
                                size: media.width * fourteen,
                                color: Colors.red,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          (fleetimageFile != null &&
                                      (fleetdocumentsNeeded[fleetchoosenDocs]
                                              ['has_identify_number'] ==
                                          true)
                                  ? idNumber.text.isNotEmpty
                                  : 1 + 1 == 2 &&
                                          (fleetdocumentsNeeded[
                                                      fleetchoosenDocs]
                                                  ['has_expiry_date'] ==
                                              true)
                                      ? fleetdate != ''
                                      : 1 + 1 == 2)
                              ? Button(
                                  onTap: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    setState(() {
                                      _loading = true;
                                    });
                                    var result =
                                        await uploadFleetDocs(widget.fleetid);
                                    if (result == 'success') {
                                      var val = await getFleetDocumentsNeeded(
                                          widget.fleetid);
                                      if (val == 'logout') {
                                        navigateLogout();
                                      } else {
                                        pop();
                                      }
                                    } else if (result == 'logout') {
                                      navigateLogout();
                                    } else {
                                      setState(() {
                                        _error = languages[choosenLanguage]
                                            ['text_somethingwentwrong'];
                                      });
                                    }
                                    setState(() {
                                      _loading = false;
                                    });
                                  },
                                  text: languages[choosenLanguage]
                                      ['text_submit'])
                              : Container()
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //upload image popup
              (_uploadImage == true)
                  ? Positioned(
                      bottom: 0,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _uploadImage = false;
                          });
                        },
                        child: Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          color: Colors.transparent.withOpacity(0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 1,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        topRight: Radius.circular(25)),
                                    border: Border.all(
                                      color: borderLines,
                                      width: 1.2,
                                    ),
                                    color: page),
                                child: Column(
                                  children: [
                                    Container(
                                      height: media.width * 0.02,
                                      width: media.width * 0.15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            media.width * 0.01),
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                cameraPick();
                                              },
                                              child: Container(
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: media.width * 0.064,
                                                    color: textColor,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.02,
                                            ),
                                            MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_camera'],
                                              size: media.width * ten,
                                              color: (isDarkTheme == true)
                                                  ? textColor.withOpacity(0.4)
                                                  : const Color(0xff666666),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                imagePick();
                                              },
                                              child: Container(
                                                  height: media.width * 0.171,
                                                  width: media.width * 0.171,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child: Icon(
                                                    Icons.image_outlined,
                                                    size: media.width * 0.064,
                                                    color: textColor,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: media.width * 0.02,
                                            ),
                                            MyText(
                                              text: languages[choosenLanguage]
                                                  ['text_gallery'],
                                              size: media.width * ten,
                                              color: (isDarkTheme == true)
                                                  ? textColor.withOpacity(0.4)
                                                  : const Color(0xff666666),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  : Container(),

              //permission denied error
              (_permission != '')
                  ? Positioned(
                      child: Container(
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: media.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _permission = '';
                                      _uploadImage = false;
                                    });
                                  },
                                  child: Container(
                                    height: media.width * 0.1,
                                    width: media.width * 0.1,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle, color: page),
                                    child: Icon(
                                      Icons.cancel_outlined,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: page,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2.0,
                                      spreadRadius: 2.0,
                                      color: Colors.black.withOpacity(0.2))
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                    width: media.width * 0.8,
                                    child: MyText(
                                      text: (_permission == 'noPhotos')
                                          ? languages[choosenLanguage]
                                              ['text_open_photos_setting']
                                          : languages[choosenLanguage]
                                              ['text_open_camera_setting'],
                                      size: media.width * sixteen,
                                      fontweight: FontWeight.w600,
                                    )),
                                SizedBox(height: media.width * 0.05),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          await openAppSettings();
                                        },
                                        child: MyText(
                                          text: languages[choosenLanguage]
                                              ['text_open_settings'],
                                          size: media.width * sixteen,
                                          color: buttonColor,
                                          fontweight: FontWeight.w600,
                                        )),
                                    InkWell(
                                        onTap: () async {
                                          (_permission == 'noCamera')
                                              ? cameraPick()
                                              : imagePick();
                                          setState(() {
                                            _permission = '';
                                          });
                                        },
                                        child: MyText(
                                          text: languages[choosenLanguage]
                                              ['text_done'],
                                          size: media.width * sixteen,
                                          color: buttonColor,
                                          fontweight: FontWeight.w600,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  : Container(),
              if (_loading == true) const Positioned(child: Loading()),
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
          )),
    );
  }
}
