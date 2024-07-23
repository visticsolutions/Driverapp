import 'package:flutter/material.dart';
import 'package:flutter_driver/pages/onTripPage/map_page.dart';
import 'package:flutter_driver/pages/onTripPage/rides.dart';
import 'package:flutter_driver/translation/translation.dart';
import '../../functions/functions.dart';
import '../../styles/styles.dart';
import '../../widgets/widgets.dart';
import '../loadingPage/loading.dart';
import 'outstation.dart';

class OutStationDetails extends StatefulWidget {
  final dynamic requestId;
  final dynamic i;
  const OutStationDetails({super.key, this.requestId, this.i});

  @override
  State<OutStationDetails> createState() => _OutStationDetailsState();
}

class _OutStationDetailsState extends State<OutStationDetails> {
  List _tripStops = [];

  bool _isLoading = false;
  TextEditingController updateAmount = TextEditingController();
  List driverBck = [];
  navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const OutStation()));
  }

  @override
  void initState() {
    _isLoading = false;
    _tripStops = outStationList[widget.i]['requestStops']['data'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
        child: Stack(
      children: [
        if (outStationList.isNotEmpty)
          Container(
            width: media.width * 1,
            height: media.height * 1,
            color: page,
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      media.width * 0.05,
                      media.width * 0.05 + MediaQuery.of(context).padding.top,
                      media.width * 0.05,
                      media.width * 0.05),
                  color: page,
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios, color: textColor)),
                      Expanded(
                        child: MyText(
                          textAlign: TextAlign.center,
                          text: languages[choosenLanguage]['text_outstation'],
                          size: media.width * twenty,
                          maxLines: 1,
                          fontweight: FontWeight.w600,
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(media.width * 0.05),
                  width: media.width * 1,
                  color: Colors.grey.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    color: page,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: outStationList[widget.i]
                                    ['trip_start_time'],
                                size: media.width * twelve,
                                fontweight: FontWeight.w600,
                              ),
                              (outStationList[widget.i]['is_round_trip'] == 1)
                                  ? MyText(
                                      text:
                                          ' TO ${outStationList[widget.i]['return_time']}',
                                      size: media.width * twelve,
                                      fontweight: FontWeight.w600,
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: outStationList[widget.i]
                                    ['request_number'],
                                size: media.width * twelve,
                                color: hintColor,
                              ),
                              MyText(
                                text: (outStationList[widget.i]
                                            ['is_round_trip'] ==
                                        1)
                                    ? languages[choosenLanguage]
                                        ['text_round_trip']
                                    : languages[choosenLanguage]
                                        ['text_one_way_trip'],
                                size: media.width * sixteen,
                                color: Colors.orange,
                                fontweight: FontWeight.w600,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          const MySeparator(),
                          SizedBox(
                            height: media.width * 0.02,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: media.width * 0.02,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: media.width * 0.7,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: media.width * 0.1,
                                          width: media.width * 0.1,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      outStationList[widget.i]
                                                                  ['userDetail']
                                                              ['data']
                                                          ['profile_picture']),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          width: media.width * 0.025,
                                        ),
                                        Expanded(
                                          child: MyText(
                                            text: outStationList[widget.i]
                                                        ['userDetail']['data']
                                                    ['name']
                                                .toString(),
                                            size: media.width * sixteen,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  MyText(
                                    text: outStationList[widget.i]
                                            ['ride_user_rating']
                                        .toString(),
                                    size: media.width * eighteen,
                                    fontweight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: media.width * twenty,
                                    color: Colors.yellow[600],
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   height: media.width * 0.02,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: media.width * 0.1,
                                      ),
                                      MyText(
                                          text: outStationList[widget.i]
                                                      ['userDetail']['data']
                                                  ['mobile']
                                              .toString(),
                                          fontweight: FontWeight.bold,
                                          size: media.width * fourteen),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      makingPhoneCall(outStationList[widget.i]
                                          ['userDetail']['data']['mobile']);
                                    },
                                    child: Icon(
                                      Icons.call,
                                      color: textColor,
                                      size: media.width * twentyfour,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: media.width * 0.02,
                              ),
                              const MySeparator(),
                              SizedBox(
                                height: media.width * 0.04,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: media.width * 0.05,
                                    width: media.width * 0.05,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green.withOpacity(0.4)),
                                    child: Container(
                                      height: media.width * 0.025,
                                      width: media.width * 0.025,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green),
                                    ),
                                  ),
                                  SizedBox(
                                    width: media.width * 0.03,
                                  ),
                                  Expanded(
                                    child: MyText(
                                      text: outStationList[widget.i]
                                          ['pick_address'],
                                      maxLines: 1,
                                      size: media.width * twelve,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: media.width * 0.03,
                              ),
                              Column(
                                children: _tripStops
                                    .asMap()
                                    .map((i, value) {
                                      return MapEntry(
                                          i,
                                          (i < _tripStops.length - 1)
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: media.width *
                                                              0.06,
                                                          width: media.width *
                                                              0.06,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.3)),
                                                          child: MyText(
                                                            text: (i + 1)
                                                                .toString(),
                                                            size: media.width *
                                                                twelve,
                                                            maxLines: 1,
                                                            color:
                                                                verifyDeclined,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: media.width *
                                                              0.05,
                                                        ),
                                                        Expanded(
                                                          child: MyText(
                                                            text: _tripStops[i]
                                                                ['address'],
                                                            size: media.width *
                                                                twelve,
                                                            // maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          media.width * 0.02,
                                                    ),
                                                  ],
                                                )
                                              : Container());
                                    })
                                    .values
                                    .toList(),
                              ),
                              if (outStationList[widget.i]['drop_address'] !=
                                  null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: media.width * 0.06,
                                      width: media.width * 0.06,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.location_on,
                                        color: const Color(0xFFFF0000),
                                        size: media.width * eighteen,
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.03,
                                    ),
                                    Expanded(
                                      child: MyText(
                                        text: outStationList[widget.i]
                                            ['drop_address'],
                                        maxLines: 1,
                                        size: media.width * twelve,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: media.width * 0.02,
                              ),
                              (outStationList[widget.i]['goods_type'] != '-')
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: MyText(
                                            maxLines: 1,
                                            text:
                                                '${languages[choosenLanguage]['text_goods_type']}  : ${outStationList[widget.i]['goods_type']}',
                                            size: media.width * twelve,
                                            color: verifyDeclined,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(
                                height: media.width * 0.1,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: media.height * 0.02,
                                  ),
                                  MyText(
                                    text: (outStationList[widget.i]
                                                ['payment_opt'] ==
                                            '1')
                                        ? languages[choosenLanguage]
                                            ['text_cash']
                                        : (outStationList[widget.i]
                                                    ['payment_opt'] ==
                                                '2')
                                            ? languages[choosenLanguage]
                                                ['text_wallet']
                                            : (outStationList[widget.i]
                                                        ['payment_opt'] ==
                                                    '0')
                                                ? languages[choosenLanguage]
                                                    ['text_card']
                                                : '',
                                    size: media.width * twentyeight,
                                    fontweight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                  SizedBox(
                                    height: media.width * 0.03,
                                  ),
                                  MyText(
                                    text: outStationList[widget.i]
                                            ['requested_currency_symbol'] +
                                        ' ' +
                                        outStationList[widget.i]
                                                ['accepted_ride_fare']
                                            .toString(),
                                    size: media.width * twentysix,
                                    fontweight: FontWeight.w600,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                Container(
                  margin: EdgeInsets.all(media.width * 0.05),
                  color: page,
                  child: Button(
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      var val =
                          await readyToPickup(outStationList[widget.i]['id']);
                      if (val == 'success') {
                        var res = await getUserDetails();
                        if (res == true) {
                          choosenRide.clear();
                          setState(() {
                            _isLoading = false;
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Maps()),
                                (route) => false);
                          });
                        }
                      }
                    },
                    text: languages[choosenLanguage]['text_ready_to_pickup'],
                    color: online,
                    borcolor: online,
                    textcolor: page,
                  ),
                )
              ],
            ),
          ),

        //loader
        (_isLoading == true)
            ? const Positioned(top: 0, child: Loading())
            : Container(),
      ],
    ));
  }
}
