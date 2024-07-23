import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/login.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../login/landingpage.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  void initState() {
    choosenLanguage = 'en';
    languageDirection = 'ltr';
    super.initState();
  }

  navigate() {
    if (ownermodule == '1') {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingPage()));
      });
    } else {
      ischeckownerordriver = 'driver';
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.fromLTRB(media.width * 0.05, media.width * 0.05,
              media.width * 0.05, media.width * 0.05),
          height: media.height * 1,
          width: media.width * 1,
          color: page,
          child: Column(
            children: [
              Container(
                height: media.width * 0.11 + MediaQuery.of(context).padding.top,
                width: media.width * 1,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: page,
                child: Stack(
                  children: [
                    Container(
                      height: media.width * 0.11,
                      width: media.width * 1,
                      alignment: Alignment.center,
                      child: MyText(
                        text: (choosenLanguage.isEmpty)
                            ? 'Choose Language'
                            : languages[choosenLanguage]
                                ['text_choose_language'],
                        size: media.width * sixteen,
                        fontweight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              SizedBox(
                width: media.width * 0.9,
                height: media.height * 0.16,
                child: Image.asset(
                  'assets/images/selectLanguage.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                height: media.width * 0.1,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: languages
                        .map(
                          (i, value) => MapEntry(
                            i,
                            InkWell(
                              onTap: () {
                                setState(() {
                                  choosenLanguage = i;
                                  if (choosenLanguage == 'ar' ||
                                      choosenLanguage == 'ur' ||
                                      choosenLanguage == 'iw') {
                                    languageDirection = 'rtl';
                                  } else {
                                    languageDirection = 'ltr';
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(media.width * 0.025),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyText(
                                      text: languagesCode
                                          .firstWhere(
                                              (e) => e['code'] == i)['name']
                                          .toString(),
                                      size: media.width * sixteen,
                                    ),
                                    Container(
                                      height: media.width * 0.05,
                                      width: media.width * 0.05,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xff222222),
                                              width: 1.2)),
                                      alignment: Alignment.center,
                                      child: (choosenLanguage == i)
                                          ? Container(
                                              height: media.width * 0.03,
                                              width: media.width * 0.03,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff222222)),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .values
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              (choosenLanguage != '')
                  ? Button(
                      onTap: () async {
                        await getlangid();
                        //saving language settings in local
                        pref.setString('languageDirection', languageDirection);
                        pref.setString('choosenLanguage', choosenLanguage);
                        navigate();
                      },
                      text: languages[choosenLanguage]['text_confirm'])
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
