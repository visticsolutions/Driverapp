import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../functions/functions.dart';
import '../pages/NavigatorPages/walletpage.dart';
import '../styles/styles.dart';
import 'package:google_fonts/google_fonts.dart';

import '../translation/translation.dart';

//button style
// ignore: must_be_immutable
class Button extends StatefulWidget {
  dynamic onTap;
  final String text;
  dynamic color;
  dynamic borcolor;
  dynamic textcolor;
  dynamic width;
  dynamic height;
  dynamic borderRadius;
  dynamic fontweight;
  // ignore: use_key_in_widget_constructors
  Button(
      {required this.onTap,
      required this.text,
      this.color,
      this.borcolor,
      this.textcolor,
      this.width,
      this.height,
      this.fontweight,
      this.borderRadius});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
// F9C27D
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: widget.onTap,
      child: Container(
        width: (widget.width != null) ? widget.width : media.width * 0.9,
        decoration: BoxDecoration(
            color: (widget.color != null)
                ? widget.color
                : (isDarkTheme)
                    ? buttonColor
                    : Colors.black,
            border: Border.all(
                color: (widget.borcolor != null)
                    ? widget.borcolor
                    : (isDarkTheme)
                        ? buttonColor
                        : Colors.black),
            borderRadius: BorderRadius.circular(media.width * 0.02)),
        child: Container(
          height: widget.height ?? media.width * 0.12,
          // width: (widget.width != null) ? widget.width : media.width * 0.9,
          padding: EdgeInsets.only(
              left: media.width * twenty, right: media.width * twenty),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.text,
              style: GoogleFonts.notoSans(
                  fontSize: media.width * sixteen,
                  color: (widget.textcolor != null)
                      ? widget.textcolor
                      : const Color(0xffD88D0D),
                  fontWeight: widget.fontweight ?? FontWeight.bold,
                  letterSpacing: 1),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowUpWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const ShowUpWidget({super.key, required this.child, required this.delay});

  @override
  // ignore: library_private_types_in_public_api
  _ShowUpWidgetState createState() => _ShowUpWidgetState();
}

class _ShowUpWidgetState extends State<ShowUpWidget> {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: MyTickerProvider(), duration: const Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
        .animate(curve);

    // ignore: unnecessary_null_comparison
    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

//input field style

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  dynamic icon;
  dynamic onTap;
  final String text;
  final TextEditingController textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic color;

  dynamic underline;
  dynamic autofocus;
  bool? readonly;
  dynamic textColor;

  // ignore: use_key_in_widget_constructors
  InputField(
      {this.icon,
      this.onTap,
      required this.text,
      required this.textController,
      this.inputType,
      this.maxLength,
      this.color,
      this.readonly,
      this.autofocus,
      this.underline,
      this.textColor});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return TextFormField(
      maxLength: (widget.maxLength == null) ? null : widget.maxLength,
      keyboardType: (widget.inputType == null)
          ? TextInputType.emailAddress
          : widget.inputType,
      autofocus: widget.autofocus ?? false,
      readOnly: widget.readonly ?? false,
      controller: widget.textController,
      decoration: InputDecoration(
        counterText: '',
        border: InputBorder.none,
        prefixIcon: (widget.icon != null)
            ? Icon(
                widget.icon,
                size: media.width * 0.064,
                color: textColor,
              )
            : null,
        hintText: widget.text,
        hintStyle: GoogleFonts.notoSans(
          fontSize: media.width * fourteen,
          color: (widget.color != null) ? widget.color : hintColor,
        ),
      ),
      style: GoogleFonts.notoSans(
        fontSize: media.width * sixteen,
        color: widget.color,
      ),
      onChanged: widget.onTap,
    );
  }
}

//text
class MyText extends StatelessWidget {
  @required
  final String? text;
  // final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final double? size;
  final FontWeight? fontweight;
  final Color? color;
  const MyText({
    Key? key,
    required this.text,

    // this.style,
    this.maxLines,
    required this.size,
    this.overflow,
    this.textAlign,
    this.fontweight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text == null ? '' : text.toString(),
      style: GoogleFonts.notoSans(
          fontSize: size,
          fontWeight: fontweight ?? FontWeight.normal,
          color: color ?? textColor),

      maxLines: maxLines,

      // textDirection: TextDirection.RTL,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

// ignore: must_be_immutable
class NavMenu extends StatefulWidget {
  dynamic onTap;
  final String text;
  dynamic textcolor;
  final String? image;
  dynamic icon;

  NavMenu({
    Key? key,
    required this.onTap,
    required this.text,
    this.textcolor,
    this.image,
    this.icon,
  }) : super(key: key);

  @override
  State<NavMenu> createState() => _NavMenuState();
}

class _NavMenuState extends State<NavMenu> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
// F9C27D
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(top: media.width * 0.07),
        child: Column(
          children: [
            Row(
              children: [
                widget.icon == null
                    ? Image.asset(
                        widget.image.toString(),
                        fit: BoxFit.contain,
                        width: media.width * 0.04,
                        color: widget.textcolor ?? textColor,
                      )
                    : Icon(
                        widget.icon,
                        size: media.width * 0.04,
                        color: widget.textcolor ?? textColor,
                        // color: textColor.withOpacity(0.5),
                      ),
                SizedBox(
                  width: media.width * 0.025,
                ),
                Expanded(
                  child: MyText(
                    text: widget.text.toString(),
                    size: media.width * sixteen,
                    overflow: TextOverflow.ellipsis,
                    color: widget.textcolor ?? textColor,
                    // color: textColor.withOpacity(0.8),
                  ),
                )
              ],
            ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   padding: EdgeInsets.only(
            //     top: media.width * 0.05,
            //     left: media.width * 0.09,
            //   ),
            //   child: Container(
            //     color: textColor.withOpacity(0.1),
            //     height: 1,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PaymentSuccess extends StatefulWidget {
  dynamic onTap;
  bool? transfer;
  PaymentSuccess({
    Key? key,
    required this.onTap,
    this.transfer,
  }) : super(key: key);

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(media.width * 0.05),
      height: media.height * 1,
      width: media.width * 1,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
      child: Column(
        children: [
          SizedBox(
            height: media.height * 0.2,
          ),
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/paymentsuccess.png',
                  fit: BoxFit.contain,
                  width: media.width * 0.7,
                ),
                MyText(
                  text: widget.transfer == null
                      ? '${languages[choosenLanguage]['text_amount_of']} $addMoney ${userDetails['currency_symbol']} ${languages[choosenLanguage]['text_tranferred_to']} ${userDetails['mobile']}'
                      : '${languages[choosenLanguage]['text_amount_of']} ${amount.text} ${userDetails['currency_symbol']} ${languages[choosenLanguage]['text_tranferred_to']} ${phonenumber.text}',
                  textAlign: TextAlign.center,
                  size: media.width * eighteen,
                  fontweight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Button(
              onTap: widget.onTap, text: languages[choosenLanguage]['text_ok'])
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  dynamic onTap;
  final String hinttext;
  dynamic textController;
  dynamic inputType;
  dynamic maxLength;
  dynamic countertext;
  dynamic color;
  dynamic fontsize;
  dynamic maxline;
  dynamic minline;
  dynamic contentpadding;
  dynamic readonly;
  dynamic prefixtext;

  // ignore: use_key_in_widget_constructors
  MyTextField(
      {this.onTap,
      this.textController,
      required this.hinttext,
      this.inputType,
      this.maxLength,
      this.countertext,
      this.fontsize,
      this.maxline,
      this.minline,
      this.contentpadding,
      this.readonly,
      this.prefixtext,
      this.color});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return TextField(
        controller: widget.textController,
        readOnly: (widget.readonly == true) ? true : false,
        maxLength: widget.maxLength,
        maxLines: widget.maxline,
        minLines: widget.minline,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          prefixText: widget.prefixtext,
          prefixStyle: GoogleFonts.notoSans(
              fontSize: widget.fontsize ?? media.width * fourteen,
              fontWeight: FontWeight.normal,
              color: textColor),
          contentPadding: widget.contentpadding,
          counterText: widget.countertext ?? '',
          border: InputBorder.none,
          hintText: widget.hinttext,
          hintStyle: (isDarkTheme == true)
              ? GoogleFonts.notoSans(
                  fontSize: media.width * fourteen,
                  fontWeight: FontWeight.normal,
                  color: (widget.color != null)
                      ? widget.color
                      : textColor.withOpacity(0.3),
                )
              : GoogleFonts.notoSans(
                  fontSize: widget.fontsize ?? media.width * fourteen,
                  fontWeight: FontWeight.normal,
                  color: (widget.color != null)
                      ? widget.color
                      : (isDarkTheme == true)
                          ? textColor.withOpacity(0.4)
                          : hintColor),
        ),
        style: GoogleFonts.notoSans(
            fontSize: widget.fontsize ?? media.width * fourteen,
            fontWeight: FontWeight.normal,
            color: (widget.color != null)
                ? widget.color
                : (isDarkTheme == true)
                    ? Colors.white
                    : textColor),
        onChanged: widget.onTap);
  }
}

class ShowUp extends StatefulWidget {
  final Widget child;
  final int delay;

  const ShowUp({super.key, required this.child, required this.delay});

  @override
  // ignore: library_private_types_in_public_api
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: MyTickerProvider(), duration: const Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.3, 0.0), end: Offset.zero)
        .animate(curve);

    // ignore: unnecessary_null_comparison
    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}

class SubMenu extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? image;
  final dynamic onTap;
  const SubMenu(
      {super.key, required this.text, this.icon, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: page,
        padding: EdgeInsets.all(media.width * 0.03),
        child: Column(
          children: [
            Row(
              children: [
                // ignore: unnecessary_null_comparison
                icon == null
                    ? Image.asset(
                        image.toString(),
                        fit: BoxFit.contain,
                        width: media.width * 0.075,
                        color: textColor.withOpacity(0.5),
                      )
                    : Icon(
                        icon,
                        size: media.width * 0.075,
                        color: textColor.withOpacity(0.5),
                      ),
                SizedBox(
                  width: media.width * 0.025,
                ),
                Expanded(
                  child: MyText(
                    text: text.toString(),
                    size: media.width * sixteen,
                    overflow: TextOverflow.ellipsis,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
                Icon(
                  Icons.arrow_right_rounded,
                  size: media.width * 0.05,
                  color: textColor.withOpacity(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class ProfileDetails extends StatelessWidget {
  final String? heading;
  final String? value;
  final String? hinttext;
  final double? width;
  final bool? readyonly;
  final TextEditingController? controller;
  const ProfileDetails(
      {super.key,
      required this.heading,
      this.value,
      this.width,
      this.controller,
      this.hinttext,
      this.readyonly});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(
            width: width ?? media.width * 0.9,
            child: MyText(
              text: heading,
              size: media.width * fourteen,
              color: whiteText,
              maxLines: 1,
            )),
        Container(
          height: media.width * 0.1,
          width: width ?? media.width * 0.9,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: whiteText)),
          ),
          padding: const EdgeInsets.only(right: 5, bottom: 5),
          child: (controller == null)
              ? MyText(
                  text: value,
                  size: media.width * sixteen,
                  color: whiteText,
                )
              : TextField(
                  controller: controller,
                  // maxLength: 9,
                  // keyboardType: TextInputType.number,
                  readOnly: readyonly!,
                  decoration: InputDecoration(
                    counterText: '',
                    // prefixText: '+962 ',
                    prefixStyle: GoogleFonts.notoSans(
                      fontSize: media.width * fourteen,
                      fontWeight: FontWeight.normal,
                      color: whiteText,
                    ),
                    border: InputBorder.none,
                    hintText: hinttext,
                    hintStyle: GoogleFonts.notoSans(
                      fontSize: media.width * fourteen,
                      fontWeight: FontWeight.normal,
                      color: textColor.withOpacity(0.3),
                    ),
                  ),
                  style: GoogleFonts.notoSans(
                    color: whiteText,
                    fontSize: media.width * fourteen,
                    fontWeight: FontWeight.normal,
                  ),
                  // onChanged: (val) {
                  //   setState(() {});
                  // },
                ),
        ),
        SizedBox(
          height: media.width * 0.02,
        ),
      ],
    );
  }
}

class PopUp extends StatelessWidget {
  final String? heading;
  final bool close;
  final String heading2;
  final String buttonText;
  final dynamic closeonTap;
  final dynamic buttononTap;

  const PopUp(
      {super.key,
      this.heading,
      required this.close,
      required this.heading2,
      required this.buttonText,
      this.closeonTap,
      this.buttononTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      // padding: EdgeInsets.all(media.width * 0.05),
      width: media.width * 0.9,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
      child: Column(
        children: [
          Container(
            height: media.width * 0.12,
            width: media.width * 0.9,
            padding: EdgeInsets.fromLTRB(media.width * 0.05, media.width * 0.02,
                media.width * 0.03, media.width * 0.02),
            decoration: BoxDecoration(color: buttonColor.withOpacity(0.3)),
            child: Row(
              children: [
                SizedBox(
                  width: media.width * 0.75,
                  child: MyText(
                    text: heading ?? '',
                    size: media.width * sixteen,
                    fontweight: FontWeight.w600,
                  ),
                ),
                (close)
                    ? InkWell(
                        onTap: closeonTap,
                        child: const Expanded(
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(media.width * 0.05),
            child: Column(
              children: [
                Text(
                  heading2,
                  // 'contact permisssion.....',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                      fontSize: media.width * sixteen,
                      color: textColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Button(
                    onTap: buttononTap,
                    text: languages[choosenLanguage]['text_continue'])
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * 2)).floor();
        return Flex(
          // ignore: sort_child_properties_last
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: 2,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: hintColor),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
