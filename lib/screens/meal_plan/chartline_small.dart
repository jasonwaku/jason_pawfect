import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class ChartLineSmall extends StatelessWidget {
  const ChartLineSmall({
    Key key,
    @required this.rate,
    @required this.title,
    @required this.color,
    this.number,
  })  : assert(title != null),
        // assert(color != null),
        assert(rate != null),
        assert(rate >= 0),
        // assert(rate <= 1),
        super(key: key);

  final double rate;
  final String title;
  final double number;
  final Color color;

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
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.w400
                            ),
                          ),
                          if (number != null)
                            Text(
                              number.toString(),
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black87, fontWeight: FontWeight.w500
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: color,//Color(0xFF32BEFA),
                    height: 12,
                    width: lineWidget,
                  ),
                  SizedBox(height: 8.0),
                ],
                // ),
              );
          });
        });
  }
}
