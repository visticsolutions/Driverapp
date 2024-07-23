import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/landingpage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/login.dart';
import '../noInternet/nointernet.dart';
import 'withdraw.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
//text controller for editing bank details
  TextEditingController holderName = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController bankCode = TextEditingController();

  bool _isLoading = true;
  String _showError = '';
  bool _edit = false;

  @override
  void initState() {
    getBankDetails();
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

  getBankDetails() async {
    var val = await getBankInfo();
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

//showing error
  _errorClear() async {
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showError = '';
      });
    });
  }

  //navigate pop
  pop() {
    Navigator.pop(context, true);
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
                height: media.height * 1,
                width: media.width * 1,
                color: page,
                padding: EdgeInsets.all(media.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Stack(
                      children: [
                        Container(
                            padding:
                                EdgeInsets.only(bottom: media.width * 0.05),
                            width: media.width * 1,
                            alignment: Alignment.center,
                            child: MyText(
                              text: languages[choosenLanguage]
                                  ['text_bankDetails'],
                              size: media.width * twenty,
                              fontweight: FontWeight.w600,
                            )),
                        Positioned(
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.arrow_back_ios,
                                    color: textColor)))
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: (bankData.isEmpty || _edit == true)
                          ? Column(
                              children: [
                                SizedBox(
                                  height: media.width * 0.02,
                                ),
                                TextField(
                                  controller: holderName,
                                  decoration: InputDecoration(
                                      labelText: languages[choosenLanguage]
                                          ['text_accoutHolderName'],
                                      labelStyle: TextStyle(
                                          color: (isDarkTheme == true)
                                              ? textColor
                                              : null),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : Colors.blue)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : hintColor),
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      isDense: true),
                                  style: GoogleFonts.notoSans(color: textColor),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                TextField(
                                  controller: accountNumber,
                                  decoration: InputDecoration(
                                      labelText: languages[choosenLanguage]
                                          ['text_accountNumber'],
                                      labelStyle: TextStyle(
                                          color: (isDarkTheme == true)
                                              ? textColor
                                              : null),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : Colors.blue)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : hintColor),
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      isDense: true),
                                  style: GoogleFonts.notoSans(color: textColor),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                TextField(
                                  controller: bankName,
                                  decoration: InputDecoration(
                                      labelText: languages[choosenLanguage]
                                          ['text_bankName'],
                                      labelStyle: TextStyle(
                                          color: (isDarkTheme == true)
                                              ? textColor
                                              : null),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : Colors.blue)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : hintColor),
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      isDense: true),
                                  style: GoogleFonts.notoSans(color: textColor),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                TextField(
                                  controller: bankCode,
                                  decoration: InputDecoration(
                                      labelText: languages[choosenLanguage]
                                          ['text_bankCode'],
                                      labelStyle: TextStyle(
                                          color: (isDarkTheme == true)
                                              ? textColor
                                              : null),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : Colors.blue)),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: (isDarkTheme == true)
                                                  ? textColor
                                                  : hintColor),
                                          borderRadius: BorderRadius.circular(
                                              media.width * 0.02),
                                          gapPadding: 1),
                                      isDense: true),
                                  style: GoogleFonts.notoSans(color: textColor),
                                ),
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(media.width * 0.025),
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: page,
                                      boxShadow: [
                                        boxshadow,
                                      ]),
                                  child: Column(
                                    children: [
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_accoutHolderName'],
                                        size: media.width * sixteen,
                                        color: hintColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.025,
                                      ),
                                      MyText(
                                        text: bankData['account_name'],
                                        size: media.width * sixteen,
                                        color: textColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_bankName'],
                                        size: media.width * sixteen,
                                        color: hintColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.025,
                                      ),
                                      MyText(
                                        text: bankData['bank_name'],
                                        size: media.width * sixteen,
                                        color: textColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_accountNumber'],
                                        size: media.width * sixteen,
                                        color: hintColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.025,
                                      ),
                                      MyText(
                                        text: bankData['account_no'],
                                        size: media.width * sixteen,
                                        color: textColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.05,
                                      ),
                                      MyText(
                                        text: languages[choosenLanguage]
                                            ['text_bankCode'],
                                        size: media.width * sixteen,
                                        color: hintColor,
                                      ),
                                      SizedBox(
                                        height: media.width * 0.025,
                                      ),
                                      MyText(
                                        text: bankData['bank_code'],
                                        size: media.width * sixteen,
                                        color: textColor,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                              ],
                            ),
                    )),
                    (_edit == true || bankData.isEmpty)
                        ? Row(
                            mainAxisAlignment: (bankData.isEmpty)
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              (bankData.isNotEmpty)
                                  ? Button(
                                      onTap: () {
                                        setState(() {
                                          _edit = false;
                                        });
                                      },
                                      width: media.width * 0.35,
                                      text: languages[choosenLanguage]
                                          ['text_cancel'])
                                  : Container(),
                              Button(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (holderName.text.isNotEmpty &&
                                      accountNumber.text.isNotEmpty &&
                                      bankCode.text.isNotEmpty &&
                                      bankName.text.isNotEmpty) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    var val = await addBankData(
                                        holderName.text,
                                        accountNumber.text,
                                        bankCode.text,
                                        bankName.text);
                                    if (val == 'success') {
                                      setState(() {
                                        _edit = false;
                                      });
                                      if (addBank == true) {
                                        pop();
                                      }
                                    } else if (val == 'logout') {
                                      navigateLogout();
                                    } else {
                                      setState(() {
                                        _showError = val.toString();
                                        _errorClear();
                                      });
                                    }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                width: (bankData.isNotEmpty)
                                    ? media.width * 0.35
                                    : media.width * 0.8,
                                color: (holderName.text == '' &&
                                        accountNumber.text == '' &&
                                        bankCode.text == '' &&
                                        bankName.text == '')
                                    ? null
                                    : (isDarkTheme)
                                        ? Colors.white
                                        : Colors.black,
                                text: languages[choosenLanguage]
                                    ['text_confirm'],
                              ),
                            ],
                          )
                        : Button(
                            onTap: () {
                              setState(() {
                                accountNumber.text =
                                    bankData['account_no'].toString();
                                bankName.text = bankData['bank_name'];
                                bankCode.text = bankData['bank_code'];
                                holderName.text = bankData['account_name'];
                                _edit = true;
                              });
                            },
                            width: media.width * 0.9,
                            text: languages[choosenLanguage]['text_edit'])
                  ],
                ),
              ),
              (_showError != '')
                  ? Positioned(
                      top: 0,
                      child: Container(
                        height: media.height * 1,
                        width: media.width * 1,
                        color: Colors.transparent.withOpacity(0.6),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: media.width * 0.8,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: page,
                                    boxShadow: [boxshadow]),
                                padding: EdgeInsets.all(media.width * 0.05),
                                child: SizedBox(
                                    width: media.width * 0.7,
                                    child: MyText(
                                        text: _showError.toString(),
                                        size: media.width * sixteen)),
                              )
                            ]),
                      ))
                  : Container(),

              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(onTap: () {
                        setState(() {
                          internetTrue();
                        });
                      }))
                  : Container(),

              //loader
              (_isLoading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
