import 'package:flutter/material.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';
import 'package:simple_animations/simple_animations.dart';

class ChartLineSmall extends StatelessWidget {
  const ChartLineSmall({
    Key key,
    @required this.rate,
    @required this.title,
    this.number,
  })  : assert(title != null),
        assert(rate != null),
        assert(rate >= 0),
        // assert(rate < 1),
        super(key: key);

  final double rate;
  final String title;
  final double number;

  final int _baseDurationMs = 1000;
  final double _maxElementWidth = 100;

  @override
  Widget build(BuildContext context) {
    return ControlledAnimation(
        duration: Duration(milliseconds: (rate * _baseDurationMs).round()),
        tween: Tween(begin: 0.0, end: rate),
        builder: (context, animatedHeight) {
          return LayoutBuilder(builder: (context, constraints) {
            final lineWidget = constraints.maxWidth * animatedHeight;
            // ignore: deprecated_member_use
            return
              // Padding(
              // padding: const EdgeInsets.only(bottom: 10.0),
              // child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    constraints: BoxConstraints(minWidth: lineWidget),
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: kSubContentStyleBlack,
                          ),
                          if (number != null)
                            Text(
                              number.toString(),
                              style: kSubContentStyleBlack,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xFF32BEFA),
                    height: 16,
                    width: lineWidget,
                  ),
                  SizedBox(height: 12.0),
                ],
                // ),
              );
          });
        });
  }
}
