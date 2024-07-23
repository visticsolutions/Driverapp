import 'package:flutter/material.dart';
import 'package:flutter_driver/functions/functions.dart';
import 'package:flutter_driver/pages/login/carinformation.dart';
import 'package:flutter_driver/styles/styles.dart';
import 'package:flutter_driver/translation/translation.dart';
import 'package:flutter_driver/widgets/glassmorphism.dart';
import 'package:flutter_driver/widgets/widgets.dart';

class CarInfoPage extends StatefulWidget {
  const CarInfoPage({super.key});

  @override
  State<CarInfoPage> createState() => _CarInfoPageState();
}

class _CarInfoPageState extends State<CarInfoPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return GlassMorphism(
      onTap: () {
        Navigator.pop(context);
      },
      text: languages[choosenLanguage]['text_car_info'],
      column: Column(
        children: [
          SizedBox(
            height: media.width * 0.05,
          ),
          (userDetails['owner_id'] != null &&
                  userDetails['vehicle_type_name'] == null)
              ? Row(
                  children: [
                    MyText(
                      text: languages[choosenLanguage]
                          ['text_no_fleet_assigned'],
                      size: media.width * eighteen,
                      fontweight: FontWeight.bold,
                      color: whiteText,
                    ),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      width: media.width * 0.9,
                      child: MyText(
                        text: languages[choosenLanguage]['text_type'],
                        size: media.width * fourteen,
                        color: whiteText,
                      ),
                    ),
                    Container(
                      height: media.width * 0.1,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: whiteText)),
                      ),
                      child: Row(
                        children: [
                          if (userDetails['owner_id'] == null)
                            for (int i = 0;
                                i <=
                                    userDetails['driverVehicleType']['data']
                                            .length -
                                        1;
                                i++)
                              MyText(
                                text:
                                    '${userDetails['driverVehicleType']['data'][i]['vehicletype_name']},',
                                size: media.width * fourteen,
                                color: whiteText,
                              ),
                          if (userDetails['owner_id'] != null)
                            MyText(
                              text: userDetails['vehicle_type_name'],
                              size: media.width * sixteen,
                              color: whiteText,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    ProfileDetails(
                      heading: languages[choosenLanguage]['text_make_name'],
                      readyonly: true,
                      value: userDetails['car_make_name'],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    ProfileDetails(
                      heading: languages[choosenLanguage]['text_model_name'],
                      readyonly: true,
                      value: userDetails['car_model_name'],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    ProfileDetails(
                      heading: languages[choosenLanguage]['text_license'],
                      readyonly: true,
                      value: userDetails['car_number'],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    ProfileDetails(
                      heading: languages[choosenLanguage]['text_color'],
                      readyonly: true,
                      value: userDetails['car_color'],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                  ],
                )
        ],
      ),
      error: '',
      loading: false,
      button: (userDetails['owner_id'] == null)
          ? Button(
              width: media.width * 0.5,
              onTap: () async {
                var nav = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CarInformation(
                              frompage: 2,
                            )));
                if (nav != null) {
                  if (nav) {
                    setState(() {});
                  }
                }
              },
              text: languages[choosenLanguage]['text_edit'])
          : Container(),
    );
  }
}
