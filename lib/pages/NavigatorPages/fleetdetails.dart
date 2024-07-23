import 'package:flutter/material.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';

class FleetDetails extends StatefulWidget {
  const FleetDetails({Key? key}) : super(key: key);

  @override
  State<FleetDetails> createState() => _FleetDetailsState();
}

class _FleetDetailsState extends State<FleetDetails> {
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
          color: (isDarkTheme && userDetails['vehicle_type_id'] == null)
              ? Colors.black
              : page,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: media.width * 0.05),
                    width: media.width * 1,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: media.width * 0.7,
                      child: MyText(
                        text: languages[choosenLanguage]['text_fleet_details'],
                        size: media.width * twenty,
                        fontweight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
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
              SizedBox(
                height: media.width * 0.05,
              ),
              Expanded(
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: (userDetails['vehicle_type_id'] != null)
                        ? Container(
                            width: media.width * 0.9,
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2),
                                ],
                                color: page),
                            child: Column(
                              children: [
                                MyText(
                                  text: languages[choosenLanguage]['text_type'],
                                  size: media.width * sixteen,
                                  color: hintColor,
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                userDetails['vehicle_type_name'] != null
                                    ? MyText(
                                        text: userDetails['vehicle_type_name'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      )
                                    : const Text(''),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]['text_make'],
                                  size: media.width * sixteen,
                                  color: hintColor,
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                userDetails['car_make_name'] != null
                                    ? MyText(
                                        text: userDetails['car_make_name'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      )
                                    : const Text(''),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_model'],
                                  size: media.width * sixteen,
                                  color: hintColor,
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                userDetails['car_model_name'] != null
                                    ? MyText(
                                        text: userDetails['car_model_name'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      )
                                    : const Text(''),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_number'],
                                  size: media.width * sixteen,
                                  color: hintColor,
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                userDetails['car_number'] != null
                                    ? MyText(
                                        text: userDetails['car_number'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      )
                                    : const Text(''),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                MyText(
                                  text: languages[choosenLanguage]
                                      ['text_color'],
                                  size: media.width * sixteen,
                                  color: hintColor,
                                ),
                                SizedBox(
                                  height: media.width * 0.025,
                                ),
                                userDetails['car_color'] != null
                                    ? MyText(
                                        text: userDetails['car_color'],
                                        size: media.width * sixteen,
                                        fontweight: FontWeight.w600,
                                      )
                                    : const Text(''),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                              ],
                            ),
                          )
                        : Column(
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
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
