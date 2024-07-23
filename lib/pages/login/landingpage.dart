import 'dart:ui';

import 'package:flutter/material.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import 'login.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool colorbutton = false;
  @override
  void initState() {
    checkmodule();
    super.initState();
  }

  checkmodule() {
    if (ownermodule == '0') {
      ischeckownerordriver == 'driver';
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
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/landing.jpg'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                top: 0,
                child: Container(
                  // color: page,
                  height: media.height,
                  width: media.width,
                  color: Colors.transparent.withOpacity(0.4),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: media.height * 0.2,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(media.width * 0.05),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.05),
                            width: media.width * 0.9,
                            decoration: BoxDecoration(
                                border: Border.all(color: page, width: 0.7),
                                borderRadius:
                                    BorderRadius.circular(media.width * 0.05),
                                color: page.withOpacity(0.03)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_choose_to_explore'],
                                  size: media.width * sixteen,
                                  color: const Color(0xffFFCC00),
                                  fontweight: FontWeight.w600,
                                ),
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                                InkWell(
                                  onTap: () {
                                    ischeckownerordriver = 'driver';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  },
                                  child: Container(
                                    height: media.width * 0.131,
                                    width: media.width * 0.65,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                            (media.width * 0.131) / 2),
                                        border: Border.all(
                                            color: const Color(0xffFFCC00))),
                                    alignment: Alignment.center,
                                    child: MyText(
                                      text: languages[choosenLanguage]
                                          ['text_login_driver'],
                                      size: media.width * sixteen,
                                      color: const Color(0xffFFCC00),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                InkWell(
                                  onTap: () {
                                    ischeckownerordriver = 'owner';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Login()));
                                  },
                                  child: Container(
                                    height: media.width * 0.131,
                                    width: media.width * 0.65,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                            (media.width * 0.131) / 2),
                                        border: Border.all(
                                            color: const Color(0xffFFCC00))),
                                    alignment: Alignment.center,
                                    child: MyText(
                                      text: languages[choosenLanguage]
                                          ['text_login_owner'],
                                      size: media.width * sixteen,
                                      color: const Color(0xffFFCC00),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
