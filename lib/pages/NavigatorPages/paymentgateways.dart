import 'package:flutter/material.dart';
import 'package:flutter_driver/functions/functions.dart';
import 'package:flutter_driver/pages/NavigatorPages/walletpage.dart';
import 'package:flutter_driver/pages/noInternet/nointernet.dart';
import 'package:flutter_driver/styles/styles.dart';
import 'package:flutter_driver/translation/translation.dart';
import 'package:flutter_driver/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class PaymentGateWaysPage extends StatefulWidget {
  // dynamic from;
  dynamic url;
  PaymentGateWaysPage({super.key, this.url});

  @override
  State<PaymentGateWaysPage> createState() => _PaymentGateWaysPageState();
}

class _PaymentGateWaysPageState extends State<PaymentGateWaysPage> {
  bool pop = true;
  bool _success = false;
  late final WebViewController _controller;

  @override
  void initState() {
    // #docregion platform_features
    dynamic paymentUrl;

    paymentUrl =
        '${widget.url}?amount=$addMoney&payment_for=wallet&currency=${walletBalance['currency_symbol']}&user_id=${userDetails['user_id'].toString()}';

    late final PlatformWebViewControllerCreationParams params;

    params = const PlatformWebViewControllerCreationParams();

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('${widget.url}/payment/success')) {
              setState(() {
                pop = true;
                _success = true;
              });
            } else if (request.url.startsWith('${url}failure')) {
              setState(() {
                pop = false;
              });
            } else if (request.url.startsWith('${url}failure')) {
              setState(() {
                pop = true;
              });
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));

    _controller = controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Material(
        child: Stack(
          children: [
            Container(
              height: media.height,
              width: media.width,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  if (pop == true)
                    Container(
                      width: media.width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(media.width * 0.05),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: const Icon(Icons.arrow_back)),
                    ),
                  Expanded(
                    child: WebViewWidget(
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
            //payment success
            (_success == true)
                ? Positioned(
                    top: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: media.height * 1,
                      width: media.width * 1,
                      color: Colors.transparent.withOpacity(0.6),
                      child: Container(
                        padding: EdgeInsets.all(media.width * 0.05),
                        width: media.width * 0.9,
                        height: media.width * 0.8,
                        decoration: BoxDecoration(
                            color: page,
                            borderRadius:
                                BorderRadius.circular(media.width * 0.03)),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/paymentsuccess.png',
                              fit: BoxFit.contain,
                              width: media.width * 0.5,
                            ),
                            MyText(
                              text: languages[choosenLanguage]
                                  ['text_paymentsuccess'],
                              textAlign: TextAlign.center,
                              size: media.width * sixteen,
                              fontweight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: media.width * 0.07,
                            ),
                            Button(
                                onTap: () {
                                  setState(() {
                                    _success = false;
                                    // super.detachFromGLContext();
                                    Navigator.pop(context, true);
                                  });
                                },
                                text: languages[choosenLanguage]['text_ok'])
                          ],
                        ),
                      ),
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
                        });
                      },
                    ))
                : Container(),
          ],
        ),
      ),
    );
  }
}
