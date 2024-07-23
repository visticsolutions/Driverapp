import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/onTripPage/map_page.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../noInternet/nointernet.dart';
import '../onTripPage/rides.dart';
import 'upload_docs.dart';

class DocsProcess extends StatefulWidget {
  const DocsProcess({Key? key}) : super(key: key);

  @override
  State<DocsProcess> createState() => _DocsProcessState();
}

class _DocsProcessState extends State<DocsProcess> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: ValueListenableBuilder(
            valueListenable: valueNotifierHome.value,
            builder: (context, value, child) {
              if (userDetails['approve'] == true) {
                Future.delayed(const Duration(milliseconds: 0), () {
                  if (userDetails['role'] != 'owner' &&
                      userDetails['enable_bidding'] == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RidePage()),
                        (route) => false);
                  } else if (userDetails['role'] != 'owner' &&
                      userDetails['enable_bidding'] == false) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Maps()),
                        (route) => false);
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Maps()),
                        (route) => false);
                  }
                });
              }
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: media.width * 0.08,
                        right: media.width * 0.08,
                        top: 20,
                        bottom: 20),
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        (userDetails['approve'] == false &&
                                userDetails['declined_reason'] == null)
                            ? Column(
                                children: [
                                  Container(
                                    height: media.width * 0.4,
                                    width: media.width * 0.4,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: verifyPendingBck),
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: media.width * 0.3,
                                      width: media.width * 0.3,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: verifyPending),
                                      child: Icon(
                                        Icons.access_time_rounded,
                                        color: buttonText,
                                        size: media.width * 0.1,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  MyText(
                                    text: languages[choosenLanguage]
                                        ['text_approval_waiting'],
                                    size: media.width * twenty,
                                    fontweight: FontWeight.bold,
                                  ),
                                  SizedBox(height: media.height * 0.02),
                                  MyText(
                                    text: languages[choosenLanguage]
                                        ['text_send_approval'],
                                    size: media.width * sixteen,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : (userDetails['approve'] == false &&
                                    userDetails['declined_reason'] != null)
                                ? Column(
                                    children: [
                                      Container(
                                        height: media.width * 0.4,
                                        width: media.width * 0.4,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: verifyPendingBck),
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: media.width * 0.3,
                                          width: media.width * 0.3,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: verifyDeclined),
                                          child: Icon(
                                            Icons.access_time_rounded,
                                            color: buttonText,
                                            size: media.width * 0.1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_account_blocked'],
                                        size: media.width * twenty,
                                        fontweight: FontWeight.bold,
                                      ),
                                      SizedBox(height: media.height * 0.02),
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_document_rejected'],
                                        size: media.width * sixteen,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: media.height * 0.02),
                                      MyText(
                                        text: (userDetails['declined_reason'] !=
                                                null)
                                            ? userDetails['declined_reason']
                                                .toString()
                                            : '',
                                        size: media.width * sixteen,
                                        textAlign: TextAlign.center,
                                        fontweight: FontWeight.w500,
                                      ),
                                    ],
                                  )
                                : Container(),

                        //button
                        (userDetails['declined_reason'].toString() ==
                                'profile-info-updated')
                            ? Container()
                            : Button(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Docs(
                                                fromPage: '1',
                                              )));
                                },
                                text: languages[choosenLanguage]
                                    ['text_edit_docs'])
                      ],
                    ),
                  ),

                  //no internet
                  (internet == false)
                      ? Positioned(
                          top: 0,
                          child: NoInternet(
                            onTap: () {
                              setState(() {
                                internetTrue();

                                getUserDetails();
                              });
                            },
                          ))
                      : Container(),
                ],
              );
            }),
      ),
    );
  }
}
