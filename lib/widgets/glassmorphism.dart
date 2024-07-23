import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_driver/functions/functions.dart';
import 'package:flutter_driver/pages/loadingPage/loading.dart';
import 'package:flutter_driver/pages/noInternet/nointernet.dart';
import 'package:flutter_driver/styles/styles.dart';
import 'package:flutter_driver/widgets/widgets.dart';

class GlassMorphism extends StatefulWidget {
  final dynamic button;
  final String text;
  final dynamic column;
  final String error;
  final bool loading;
  final dynamic onTap;
  const GlassMorphism(
      {super.key,
      this.button,
      required this.text,
      required this.column,
      required this.error,
      required this.loading,
      required this.onTap});

  @override
  State<GlassMorphism> createState() => _GlassMorphismState();
}

class _GlassMorphismState extends State<GlassMorphism> {
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
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/carinfo.jpg'),
                        fit: BoxFit.cover)),
              ),

              Positioned(
                  child: Container(
                color: Colors.transparent.withOpacity(0.2),
                padding: EdgeInsets.all(media.width * 0.05),
                height: media.height,
                width: media.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    SizedBox(
                      width: media.width * 0.9,
                      child: Row(
                        mainAxisAlignment: (widget.onTap != null)
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          if (widget.onTap != null)
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(media.width * 0.05),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                                child: InkWell(
                                  onTap: widget.onTap,
                                  child: Container(
                                    height: media.width * 0.11,
                                    width: media.width * 0.11,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 0.5),
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.17)),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: media.width * 0.05,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(media.width * 0.05),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                              child: Container(
                                width: media.width * 0.6,
                                height: media.width * 0.11,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 0.5),
                                    borderRadius: BorderRadius.circular(
                                        (media.width * 0.11) / 2),
                                    color: Colors.black.withOpacity(0.17)),
                                alignment: Alignment.center,
                                child: MyText(
                                  text: widget.text,
                                  size: media.width * sixteen,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          if (widget.onTap != null)
                            SizedBox(
                              width: media.width * 0.05,
                            )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(media.width * 0.05),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                        child: Container(
                          width: media.width * 0.9,
                          padding: EdgeInsets.only(
                              left: media.width * 0.05,
                              right: media.width * 0.05),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 0.5),
                              borderRadius: BorderRadius.circular(
                                  (media.width * 0.11) / 2),
                              color: Colors.black.withOpacity(0.17)),
                          child: SingleChildScrollView(child: widget.column),
                        ),
                      ),
                    )),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    if (widget.error != '')
                      Column(
                        children: [
                          SizedBox(
                            width: media.width * 0.9,
                            child: MyText(
                              text: widget.error,
                              size: media.width * fourteen,
                              color: Colors.red,
                              textAlign: TextAlign.center,
                              maxLines: 5,
                            ),
                          ),
                          SizedBox(
                            height: media.width * 0.025,
                          ),
                        ],
                      ),
                    widget.button
                  ],
                ),
              )),

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
              //loader
              (widget.loading == true)
                  ? const Positioned(top: 0, child: Loading())
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
