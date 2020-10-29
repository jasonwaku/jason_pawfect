import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class ChartLineRatio extends StatelessWidget {
  const ChartLineRatio({
    Key key,
    @required this.rate,
    @required this.title,
    this.number,
  })  : assert(title != null),
        assert(rate != null),
        assert(rate > 0),
        // assert(rate <= 2),
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
              Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child:
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
                      color: Color(0xFF32BEFA),
                      height: 24,
                      width: lineWidget,
                    ),
                  ],
                ),
              );
          });
        });
  }
}

// {
// "id": 1,
// "amount": 45,
// "imperial_amount": 1.58733,
// "unit": "g",
// "nutrient": {
// "id": 4,
// "category": "macro",
// "name": "Protein"
// }
// },
// //
// {
// "name": "Protein",
// "amount": 25.82,
// "unit": "g",
// "imperial_amount": "0.91"
// },