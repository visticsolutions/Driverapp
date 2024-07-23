import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/login.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../login/landingpage.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  var _choosenLanguage = choosenLanguage;

  //navigate pop
  pop() {
    Navigator.pop(context, true);
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
          child: Scaffold(
            backgroundColor: Colors.grey.withOpacity(0.1),
            body: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      media.width * 0.05,
                      media.width * 0.05,
                      media.width * 0.05,
                      media.width * 0.05),
                  color: page,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context, false);
                          },
                          child: Icon(Icons.arrow_back_ios, color: textColor)),
                      Expanded(
                        child: MyText(
                          textAlign: TextAlign.center,
                          text: languages[choosenLanguage]
                              ['text_change_language'],
                          size: media.width * twenty,
                          maxLines: 1,
                          fontweight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Expanded(
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    margin: EdgeInsets.only(
                        left: media.width * 0.05, right: media.width * 0.05),
                    decoration: BoxDecoration(
                        color: page,
                        borderRadius:
                            BorderRadius.circular(media.width * 0.03)),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: languages
                                  .map((i, value) {
                                    return MapEntry(
                                        i,
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _choosenLanguage = i;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                                media.width * 0.025),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                MyText(
                                                  text: languagesCode
                                                      .firstWhere((e) =>
                                                          e['code'] ==
                                                          i)['name']
                                                      .toString(),
                                                  size: media.width * sixteen,
                                                ),
                                                Container(
                                                  height: media.width * 0.05,
                                                  width: media.width * 0.05,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: textColor,
                                                          width: 1.2)),
                                                  alignment: Alignment.center,
                                                  child: (_choosenLanguage == i)
                                                      ? Container(
                                                          height: media.width *
                                                              0.03,
                                                          width: media.width *
                                                              0.03,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  buttonColor),
                                                        )
                                                      : Container(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                                  })
                                  .values
                                  .toList(),
                            ),
                          ),
                        ),
                        Button(
                            onTap: () async {
                              choosenLanguage = _choosenLanguage;
                              if (choosenLanguage == 'ar' ||
                                  choosenLanguage == 'ur' ||
                                  choosenLanguage == 'iw') {
                                languageDirection = 'rtl';
                              } else {
                                languageDirection = 'ltr';
                              }
                              var val = await getlangid();
                              if (val == 'logout') {
                                navigateLogout();
                              }
                              pref.setString(
                                  'languageDirection', languageDirection);
                              pref.setString(
                                  'choosenLanguage', _choosenLanguage);
                              valueNotifierHome.incrementNotifier();
                              pop();
                            },
                            text: languages[choosenLanguage]['text_confirm'])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
