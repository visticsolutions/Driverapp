import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/login/login.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../translation/translation.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import '../login/landingpage.dart';
import '../noInternet/nointernet.dart';
import 'bankdetails.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({Key? key}) : super(key: key);

  @override
  State<Withdraw> createState() => _WithdrawState();
}

dynamic withDrawMoney;
bool addBank = false;

class _WithdrawState extends State<Withdraw> {
  TextEditingController addMoneyController = TextEditingController();
  bool _isLoading = true;
  bool _addPayment = false;
  bool _showError = false;
  dynamic _error;

  @override
  void initState() {
    getWithdrawel();

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

//get withdrawed money list
  getWithdrawel() async {
    var val = await getWithdrawList();
    if (val == 'logout') {
      navigateLogout();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        addBank = false;
      });
    }
  }

  _errorClear() async {
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showError = false;
        _error = null;
      });
    });
  }

  //navigate
  navigate() async {
    var nav = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const BankDetails()));
    if (nav) {
      setState(() {
        addMoneyController.text = withDrawMoney;
        addBank = false;
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
                          padding: EdgeInsets.only(bottom: media.width * 0.05),
                          width: media.width * 1,
                          alignment: Alignment.center,
                          child: MyText(
                            text: languages[choosenLanguage]['text_withdraw'],
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
                                  color: textColor,
                                )))
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    (withDrawList.isNotEmpty)
                        ? Column(children: [
                            MyText(
                              text: languages[choosenLanguage]
                                  ['text_availablebalance'],
                              size: media.width * twelve,
                            ),
                            SizedBox(
                              height: media.width * 0.01,
                            ),
                            MyText(
                              text: walletBalance['currency_symbol'] +
                                  withDrawList['wallet_balance'].toString(),
                              size: media.width * fourty,
                              fontweight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: media.width * 0.1,
                            ),
                            SizedBox(
                              width: media.width * 0.9,
                              child: MyText(
                                text: languages[choosenLanguage]
                                    ['text_withdrawHistory'],
                                size: media.width * twenty,
                                fontweight: FontWeight.w600,
                              ),
                            )
                          ])
                        : Container(),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: (withDrawList.isNotEmpty)
                          ? SizedBox(
                              width: media.width * 0.9,
                              child: Column(
                                children: [
                                  (withDrawHistory.isNotEmpty)
                                      ? Column(
                                          children: withDrawHistory
                                              .asMap()
                                              .map((i, value) {
                                                return MapEntry(
                                                    i,
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: media.width *
                                                              0.025,
                                                          bottom: media.width *
                                                              0.025),
                                                      width: media.width * 0.9,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              MyText(
                                                                text: languages[
                                                                        choosenLanguage]
                                                                    [
                                                                    'text_withdrawReqAt'],
                                                                size: media
                                                                        .width *
                                                                    fourteen,
                                                                color:
                                                                    hintColor,
                                                              ),
                                                              SizedBox(
                                                                height: media
                                                                        .width *
                                                                    0.02,
                                                              ),
                                                              MyText(
                                                                text: withDrawHistory[
                                                                            i][
                                                                        'created_at']
                                                                    .toString(),
                                                                size: media
                                                                        .width *
                                                                    fourteen,
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              MyText(
                                                                text: withDrawHistory[
                                                                            i][
                                                                        'status']
                                                                    .toString(),
                                                                size: media
                                                                        .width *
                                                                    fourteen,
                                                                color:
                                                                    buttonColor,
                                                              ),
                                                              SizedBox(
                                                                height: media
                                                                        .width *
                                                                    0.02,
                                                              ),
                                                              MyText(
                                                                text: withDrawHistory[
                                                                            i][
                                                                        'requested_currency'] +
                                                                    ' ' +
                                                                    withDrawHistory[i]
                                                                            [
                                                                            'requested_amount']
                                                                        .toString(),
                                                                size: media
                                                                        .width *
                                                                    fourteen,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ));
                                              })
                                              .values
                                              .toList(),
                                        )
                                      : (_isLoading == false &&
                                              withDrawHistory.isEmpty)
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                (isDarkTheme == false)
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            media.width * 0.5,
                                                        width:
                                                            media.width * 0.5,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/walletl.gif'),
                                                                fit: BoxFit
                                                                    .contain)),
                                                      )
                                                    : Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            media.width * 0.5,
                                                        width:
                                                            media.width * 0.5,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/walletd.gif'),
                                                                fit: BoxFit
                                                                    .contain)),
                                                      ),
                                                SizedBox(
                                                  height: media.width * 0.07,
                                                ),
                                                SizedBox(
                                                  width: media.width * 0.8,
                                                  child: MyText(
                                                      text: languages[
                                                              choosenLanguage]
                                                          ['text_noDataFound'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      fontweight:
                                                          FontWeight.w800,
                                                      size: media.width *
                                                          sixteen),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                  (withDrawHistoryPages.isNotEmpty)
                                      ? (withDrawHistoryPages['current_page'] <
                                              withDrawHistoryPages[
                                                  'total_pages'])
                                          ? InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                var val =
                                                    await getWithdrawListPages(
                                                        (withDrawHistoryPages[
                                                                    'current_page'] +
                                                                1)
                                                            .toString());
                                                if (val == 'logout') {
                                                  navigateLogout();
                                                }

                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    media.width * 0.025),
                                                margin: EdgeInsets.only(
                                                    bottom: media.width * 0.05),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: page,
                                                    border: Border.all(
                                                        color: borderLines,
                                                        width: 1.2)),
                                                child: MyText(
                                                  text:
                                                      languages[choosenLanguage]
                                                          ['text_loadmore'],
                                                  size: media.width * sixteen,
                                                ),
                                              ),
                                            )
                                          : Container()
                                      : Container()
                                ],
                              ),
                            )
                          : Container(),
                    )),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Button(
                        onTap: () {
                          withDrawMoney = null;
                          addMoneyController.clear();
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (builder) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    // margin:
                                    //     EdgeInsets.only(bottom: media.width * 0.05),
                                    width: media.width,
                                    padding:
                                        EdgeInsets.all(media.width * 0.025),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: borderLines, width: 1.2),
                                        color: page),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MyText(
                                              textAlign: TextAlign.center,
                                              text: (languages[choosenLanguage]
                                                  ['text_withdraw']),
                                              size: media.width * sixteen,
                                              fontweight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.06,
                                          ),
                                          Container(
                                            height: media.width * 0.128,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: borderLines,
                                                  width: 1.2),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                    width: media.width * 0.1,
                                                    height: media.width * 0.128,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            (languageDirection ==
                                                                    'ltr')
                                                                ? const BorderRadius
                                                                    .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            12),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            12),
                                                                  )
                                                                : const BorderRadius
                                                                    .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            12),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            12),
                                                                  ),
                                                        color: const Color(
                                                            0xffF0F0F0)),
                                                    alignment: Alignment.center,
                                                    child: MyText(
                                                      text: walletBalance[
                                                          'currency_symbol'],
                                                      size:
                                                          media.width * fifteen,
                                                      fontweight:
                                                          FontWeight.w600,
                                                    )),
                                                SizedBox(
                                                  width: media.width * 0.05,
                                                ),
                                                Container(
                                                    height: media.width * 0.128,
                                                    width: media.width * 0.6,
                                                    alignment: Alignment.center,
                                                    child: MyTextField(
                                                      textController:
                                                          addMoneyController,
                                                      hinttext: languages[
                                                              choosenLanguage]
                                                          ['text_enteramount'],
                                                      inputType:
                                                          TextInputType.number,
                                                      onTap: (val) {
                                                        setState(() {
                                                          if (double.parse(withDrawList[
                                                                      'wallet_balance']
                                                                  .toString()) >=
                                                              double.parse(
                                                                  val)) {
                                                            withDrawMoney =
                                                                double.parse(
                                                                    val);
                                                          } else {
                                                            addMoneyController
                                                                    .text =
                                                                withDrawList[
                                                                        'wallet_balance']
                                                                    .toString();
                                                            withDrawMoney =
                                                                withDrawList[
                                                                    'wallet_balance'];
                                                          }
                                                        });
                                                      },
                                                    ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: media.width * 0.05,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (withDrawList[
                                                            'wallet_balance'] >=
                                                        100.0) {
                                                      addMoneyController.text =
                                                          '100';
                                                      withDrawMoney = 100;
                                                    } else {
                                                      addMoneyController
                                                          .text = withDrawList[
                                                              'wallet_balance']
                                                          .toString();
                                                      withDrawMoney =
                                                          withDrawList[
                                                              'wallet_balance'];
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: media.width * 0.11,
                                                  width: media.width * 0.17,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      color: page,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: walletBalance[
                                                            'currency_symbol'] +
                                                        '100',
                                                    size: media.width * twelve,
                                                    fontweight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (withDrawList[
                                                            'wallet_balance'] >=
                                                        500.0) {
                                                      addMoneyController.text =
                                                          '500';
                                                      withDrawMoney = 500;
                                                    } else {
                                                      addMoneyController
                                                          .text = withDrawList[
                                                              'wallet_balance']
                                                          .toString();
                                                      withDrawMoney =
                                                          withDrawList[
                                                              'wallet_balance'];
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: media.width * 0.11,
                                                  width: media.width * 0.17,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      color: page,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: walletBalance[
                                                            'currency_symbol'] +
                                                        '500',
                                                    size: media.width * twelve,
                                                    fontweight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: media.width * 0.05,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (withDrawList[
                                                            'wallet_balance'] >=
                                                        1000.0) {
                                                      addMoneyController.text =
                                                          '1000';
                                                      withDrawMoney = 1000;
                                                    } else {
                                                      addMoneyController
                                                          .text = withDrawList[
                                                              'wallet_balance']
                                                          .toString();
                                                      withDrawMoney =
                                                          withDrawList[
                                                              'wallet_balance'];
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: media.width * 0.11,
                                                  width: media.width * 0.17,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: borderLines,
                                                          width: 1.2),
                                                      color: page,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  alignment: Alignment.center,
                                                  child: MyText(
                                                    text: walletBalance[
                                                            'currency_symbol'] +
                                                        '1000',
                                                    size: media.width * twelve,
                                                    fontweight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: media.width * 0.1,
                                          ),
                                          Button(
                                            onTap: () async {
                                              if (withDrawMoney != null) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                Navigator.pop(context);
                                                var val = await getBankInfo();
                                                if (val == 'logout') {
                                                  navigateLogout();
                                                }
                                                if (bankData.isNotEmpty) {
                                                  setState(() {
                                                    _addPayment = false;
                                                  });
                                                  //withdraw request
                                                  var val =
                                                      await requestWithdraw(
                                                          withDrawMoney);
                                                  if (val == 'logout') {
                                                    navigateLogout();
                                                  } else if (val != 'success' &&
                                                      val != 'no internet') {
                                                    setState(() {
                                                      _error = val;
                                                      _showError = true;
                                                    });
                                                    _errorClear();
                                                  }
                                                } else {
                                                  addBank = true;
                                                  setState(() {
                                                    _isLoading = false;
                                                  });

                                                  navigate();
                                                }
                                                setState(() {
                                                  addMoneyController.clear();
                                                  withDrawMoney = null;
                                                  _isLoading = false;
                                                });
                                              }
                                            },
                                            text: languages[choosenLanguage]
                                                ['text_withdraw'],
                                            width: media.width * 0.8,
                                          ),
                                          SizedBox(
                                            height: media.width * 0.02,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  media.width * 0.02),
                                              child: MyText(
                                                textAlign: TextAlign.center,
                                                text: languages[choosenLanguage]
                                                    ['text_cancel'],
                                                size: media.width * sixteen,
                                                color: verifyDeclined,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                );
                              });
                          // setState(() {
                          //   _addPayment = true;
                          // });
                        },
                        text: languages[choosenLanguage]['text_withdraw'])
                  ],
                ),
              ),
              (_addPayment == true)
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        height: media.height * 1,
                        width: media.width * 1,
                        color: Colors.transparent.withOpacity(0.6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: media.width * 0.05),
                              width: media.width * 0.9,
                              padding: EdgeInsets.all(media.width * 0.025),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: borderLines, width: 1.2),
                                  color: page),
                              child: Column(children: [
                                Container(
                                  height: media.width * 0.128,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: borderLines, width: 1.2),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: media.width * 0.1,
                                          height: media.width * 0.128,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  (languageDirection == 'ltr')
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12),
                                                        )
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                              color: const Color(0xffF0F0F0)),
                                          alignment: Alignment.center,
                                          child: MyText(
                                            text: walletBalance[
                                                'currency_symbol'],
                                            size: media.width * fifteen,
                                            fontweight: FontWeight.w600,
                                          )),
                                      SizedBox(
                                        width: media.width * 0.05,
                                      ),
                                      Container(
                                          height: media.width * 0.128,
                                          width: media.width * 0.6,
                                          alignment: Alignment.center,
                                          child: MyTextField(
                                            textController: addMoneyController,
                                            hinttext: languages[choosenLanguage]
                                                ['text_enteramount'],
                                            inputType: TextInputType.number,
                                            onTap: (val) {
                                              setState(() {
                                                if (double.parse(withDrawList[
                                                            'wallet_balance']
                                                        .toString()) >=
                                                    double.parse(val)) {
                                                  withDrawMoney =
                                                      double.parse(val);
                                                } else {
                                                  addMoneyController.text =
                                                      withDrawList[
                                                              'wallet_balance']
                                                          .toString();
                                                  withDrawMoney = withDrawList[
                                                      'wallet_balance'];
                                                }
                                              });
                                            },
                                          ))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (withDrawList['wallet_balance'] >=
                                              100.0) {
                                            addMoneyController.text = '100';
                                            withDrawMoney = 100;
                                          } else {
                                            addMoneyController.text =
                                                withDrawList['wallet_balance']
                                                    .toString();
                                            withDrawMoney =
                                                withDrawList['wallet_balance'];
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: media.width * 0.11,
                                        width: media.width * 0.17,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: borderLines, width: 1.2),
                                            color: page,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        alignment: Alignment.center,
                                        child: MyText(
                                          text:
                                              walletBalance['currency_symbol'] +
                                                  '100',
                                          size: media.width * twelve,
                                          fontweight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.05,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (withDrawList['wallet_balance'] >=
                                              500.0) {
                                            addMoneyController.text = '500';
                                            withDrawMoney = 500;
                                          } else {
                                            addMoneyController.text =
                                                withDrawList['wallet_balance']
                                                    .toString();
                                            withDrawMoney =
                                                withDrawList['wallet_balance'];
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: media.width * 0.11,
                                        width: media.width * 0.17,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: borderLines, width: 1.2),
                                            color: page,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        alignment: Alignment.center,
                                        child: MyText(
                                          text:
                                              walletBalance['currency_symbol'] +
                                                  '500',
                                          size: media.width * twelve,
                                          fontweight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.05,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (withDrawList['wallet_balance'] >=
                                              1000.0) {
                                            addMoneyController.text = '1000';
                                            withDrawMoney = 1000;
                                          } else {
                                            addMoneyController.text =
                                                withDrawList['wallet_balance']
                                                    .toString();
                                            withDrawMoney =
                                                withDrawList['wallet_balance'];
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: media.width * 0.11,
                                        width: media.width * 0.17,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: borderLines, width: 1.2),
                                            color: page,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        alignment: Alignment.center,
                                        child: MyText(
                                          text:
                                              walletBalance['currency_symbol'] +
                                                  '1000',
                                          size: media.width * twelve,
                                          fontweight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: media.width * 0.1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Button(
                                      onTap: () async {
                                        setState(() {
                                          _addPayment = false;
                                          withDrawMoney = null;
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          addMoneyController.clear();
                                        });
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_cancel'],
                                      width: media.width * 0.4,
                                    ),
                                    Button(
                                      onTap: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        var val = await getBankInfo();
                                        if (val == 'logout') {
                                          navigateLogout();
                                        }
                                        if (bankData.isNotEmpty) {
                                          setState(() {
                                            _addPayment = false;
                                          });
                                          //withdraw request
                                          var val = await requestWithdraw(
                                              withDrawMoney);
                                          if (val == 'logout') {
                                            navigateLogout();
                                          } else if (val != 'success' &&
                                              val != 'no internet') {
                                            setState(() {
                                              _error = val;
                                              _showError = true;
                                            });
                                            _errorClear();
                                          }
                                        } else {
                                          addBank = true;
                                          setState(() {
                                            _isLoading = false;
                                          });

                                          navigate();
                                        }
                                        setState(() {
                                          addMoneyController.clear();
                                          withDrawMoney = null;
                                          _isLoading = false;
                                        });
                                      },
                                      text: languages[choosenLanguage]
                                          ['text_withdraw'],
                                      width: media.width * 0.2,
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ],
                        ),
                      ))
                  : Container(),

              //show error
              (_showError == true)
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
                                    border: Border.all(
                                        color: borderLines.withOpacity(0.5)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 2)
                                    ]),
                                padding: EdgeInsets.all(media.width * 0.05),
                                child: MyText(
                                  text: _error,
                                  size: media.width * sixteen,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ]),
                      ))
                  : Container(),
              //no internet
              (internet == false)
                  ? Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          setState(() {
                            internetTrue();

                            _isLoading = true;
                          });
                        },
                      ))
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
