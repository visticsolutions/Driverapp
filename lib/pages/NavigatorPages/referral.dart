import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_driver/pages/login/login.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/landingpage.dart';
import '../noInternet/nointernet.dart';
import 'package:http/http.dart' as http;

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key}) : super(key: key);

  @override
  State<ReferralPage> createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool _isLoading = true;
  bool _showToast = false;
  dynamic _package;

  @override
  void initState() {
    _getReferral();
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

//get referral code
  _getReferral() async {
    var val = await getReferral();
    _package = await PackageInfo.fromPlatform();

    if (val == 'logout') {
      navigateLogout();
    }
    await getUrls();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String androidPackage = '';
  String iOSBundle = '';
  var android = '';
  var ios = '';

  getUrls() async {
    var packageName = await FirebaseDatabase.instance
        .ref()
        .child('driver_package_name')
        .get();
    if (packageName.value != null) {
      androidPackage = packageName.value.toString();
      android = 'https://play.google.com/store/apps/details?id=$androidPackage';
    }
    var bundleId =
        await FirebaseDatabase.instance.ref().child('driver_bundle_id').get();
    if (bundleId.value != null) {
      iOSBundle = bundleId.value.toString();
      var response = await http
          .get(Uri.parse('http://itunes.apple.com/lookup?bundleId=$iOSBundle'));
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['results'].isNotEmpty) {
          ios = jsonDecode(response.body)['results'][0]['trackViewUrl'];
        }
      }
    }
  }

//show toast for copied
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    child: (myReferralCode.isNotEmpty)
                        ? Column(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).padding.top),
                                    Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: media.width * 0.05),
                                          width: media.width * 1,
                                          alignment: Alignment.center,
                                          child: MyText(
                                            text: languages[choosenLanguage]
                                                ['text_referral'],
                                            size: media.width * twenty,
                                            fontweight: FontWeight.w600,
                                          ),
                                        ),
                                        Positioned(
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(
                                                    Icons.arrow_back_ios,
                                                    color: textColor)))
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    SizedBox(
                                      width: media.width * 0.9,
                                      height: media.height * 0.16,
                                      child: Image.asset(
                                        'assets/images/referralpage.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.1,
                                    ),
                                    Row(
                                      children: [
                                        MyText(
                                          text: myReferralCode[
                                              'referral_comission_string'],
                                          textAlign: TextAlign.center,
                                          size: media.width * sixteen,
                                          fontweight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Container(
                                        width: media.width * 0.9,
                                        padding:
                                            EdgeInsets.all(media.width * 0.05),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: borderLines, width: 1.2),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyText(
                                              text: myReferralCode[
                                                  'refferal_code'],
                                              size: media.width * sixteen,
                                              color: textColor.withOpacity(0.5),
                                              fontweight: FontWeight.w600,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    Clipboard.setData(ClipboardData(
                                                        text: myReferralCode[
                                                            'refferal_code']));
                                                  });
                                                  showToast();
                                                },
                                                child: Icon(Icons.copy,
                                                    color: textColor))
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: media.width * 0.05,
                                    bottom: media.width * 0.05),
                                child: Button(
                                    onTap: () async {
                                      await Share.share(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          languages[choosenLanguage]
                                                      ['text_invitation_1']
                                                  .toString()
                                                  .replaceAll(
                                                      '55', _package.appName) +
                                              ' ' +
                                              myReferralCode['refferal_code'] +
                                              ' ' +
                                              languages[choosenLanguage]
                                                  ['text_invitation_2'] +
                                              ' \n \n ' +
                                              android +
                                              '\n \n  ' +
                                              ios);
                                    },
                                    text: languages[choosenLanguage]
                                        ['text_invite']),
                              )
                            ],
                          )
                        : Container(),
                  ),
                  (internet == false)
                      ? Positioned(
                          top: 0,
                          child: NoInternet(
                            onTap: () {
                              setState(() {
                                internetTrue();
                                _isLoading = true;
                                getReferral();
                              });
                            },
                          ))
                      : Container(),

                  //loader
                  (_isLoading == true)
                      ? const Positioned(top: 0, child: Loading())
                      : Container(),

                  //display toast
                  (_showToast == true)
                      ? Positioned(
                          bottom: media.height * 0.2,
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent.withOpacity(0.6)),
                            child: MyText(
                              text: languages[choosenLanguage]
                                  ['text_code_copied'],
                              size: media.width * twelve,
                              color: topBar,
                            ),
                          ))
                      : Container()
                ],
              ),
            );
          }),
    );
  }
}
