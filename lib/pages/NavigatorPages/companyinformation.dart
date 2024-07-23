import 'package:flutter/material.dart';
import 'package:flutter_driver/functions/functions.dart';
import 'package:flutter_driver/styles/styles.dart';
import 'package:flutter_driver/translation/translation.dart';
import 'package:flutter_driver/widgets/glassmorphism.dart';
import 'package:flutter_driver/widgets/widgets.dart';

class CompanyInformation extends StatefulWidget {
  const CompanyInformation({super.key});

  @override
  State<CompanyInformation> createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: GlassMorphism(
        text: languages[choosenLanguage]['text_company_info'],
        column: Column(
          children: [
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                text: languages[choosenLanguage]['text_registered_for']
                    .toString()
                    .replaceAll('1111', userDetails['transport_type']),
                size: media.width * fifteen,
                fontweight: FontWeight.w500,
                color: whiteText,
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              height: 1,
              width: media.width * 0.9,
              color: greyText,
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                  text: languages[choosenLanguage]['text_service_location'],
                  size: media.width * fifteen,
                  fontweight: FontWeight.w500,
                  color: whiteText),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              width: media.width * 0.9,
              height: media.width * 0.14,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  )),
              child: Row(children: [
                Expanded(
                    child: MyText(
                        text: userDetails['service_location_name'],
                        size: media.width * fifteen,
                        fontweight: FontWeight.w400,
                        color: whiteText)),
              ]),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              height: 1,
              width: media.width * 0.9,
              color: greyText,
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                  text: languages[choosenLanguage]['text_company_name'],
                  size: media.width * fifteen,
                  fontweight: FontWeight.w500,
                  color: whiteText),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              width: media.width * 0.9,
              height: media.width * 0.12,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  )),
              child: Row(children: [
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: MyText(
                      text: userDetails['company_name'],
                      size: media.width * fourteen,
                      fontweight: FontWeight.w500,
                      color: whiteText),
                )),
              ]),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                  text: languages[choosenLanguage]['text_address'],
                  size: media.width * fifteen,
                  fontweight: FontWeight.w500,
                  color: whiteText),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              width: media.width * 0.9,
              height: media.width * 0.12,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  )),
              // alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                      text: userDetails['address'].toString(),
                      size: media.width * fourteen,
                      fontweight: FontWeight.w500,
                      color: whiteText),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                  text: languages[choosenLanguage]['text_city'],
                  size: media.width * fifteen,
                  fontweight: FontWeight.w500,
                  color: whiteText),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              width: media.width * 0.9,
              height: media.width * 0.12,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  )),
              // alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                      text: userDetails['city'].toString(),
                      size: media.width * fourteen,
                      fontweight: FontWeight.w500,
                      color: whiteText),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                  text: languages[choosenLanguage]['text_postal_code'],
                  size: media.width * fifteen,
                  fontweight: FontWeight.w500,
                  color: whiteText),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              width: media.width * 0.9,
              height: media.width * 0.12,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  )),
              // alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                      text: userDetails['postal_code'].toString(),
                      size: media.width * fourteen,
                      fontweight: FontWeight.w500,
                      color: whiteText),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            SizedBox(
              width: media.width * 0.9,
              child: MyText(
                  text: languages[choosenLanguage]['text_tax_number'],
                  size: media.width * fifteen,
                  fontweight: FontWeight.w500,
                  color: whiteText),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
            Container(
              width: media.width * 0.9,
              height: media.width * 0.12,
              padding: EdgeInsets.only(
                  left: media.width * 0.05, right: media.width * 0.05),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                  )),
              // alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                      text: userDetails['tax_number'],
                      size: media.width * fourteen,
                      fontweight: FontWeight.w500,
                      color: whiteText),
                ],
              ),
            ),
            SizedBox(
              height: media.width * 0.05,
            ),
          ],
        ),
        error: error,
        loading: false,
        onTap: () {
          Navigator.pop(context);
        },
        button: Container(),
      ),
    );
  }
}
