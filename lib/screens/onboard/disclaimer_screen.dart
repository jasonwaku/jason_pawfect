import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pawfect/screens/onboard/onboarding_screen.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';

class DisclaimerScreen extends StatelessWidget {
  static String tag = 'disclaimer-page';

  @override
  Widget build(BuildContext context) {
    final agreedBtn = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(PageTransition(
            child: OnboardingScreen(),
            type: PageTransitionType.rightToLeftWithFade,
          ));
//              MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()));
        },
//          Navigator.push(context,
//              PageTransition(type:
//              PageTransitionType.rightToLeft, child: ScreenTwo()));
//
        padding: EdgeInsets.all(12),
        color: Color(0xFF03B898),
        child: Container(
          width: 120.0,
//          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 64.0),
//           child: FittedBox(
//             fit: BoxFit.fitWidth,
            child: Text(
              'AGREED',
              style: kMainHeadingStyleWhite,
              textAlign: TextAlign.center,
            ),
          // ),
        ),
      ),
    );

    final disclaimer =
        // Stack(
        //   alignment: Alignment.center,
        //   children: <Widget>[
        //     Column(
        //       children: <Widget>[
        //         logo,
        //         description,
        //       ],
        //     ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(vertical: 32.0),
      alignment: Alignment.center,
      color: Colors.white, //.withOpacity(0.90),
//          decoration: BoxDecoration(),
//          alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
//                Icon(
//                  Icons.camera_alt,
//                  color: Colors.white,
//                ),
//             SizedBox(height: 10.0),
            // FittedBox(
            //   fit: BoxFit.fitWidth,
            //   child:
              Text(
                'DISCLAIMER',
                style: kSubTitleStyleBlackLight,
                textAlign: TextAlign.center,
              // ),
            ),
            // SizedBox(height: 12.0),
            // FittedBox(
            //   fit: BoxFit.fitWidth,
            //   child:
              Text(
                'This application is a guide and for informational purposes only. Always seek the advice of your veterinarian with any queries you have regarding the medical condition of your pet. Do not delay, avoid or disregard veterinary advise based on the information supplied in this application. Users who rely on this application for information do so at their own risk. \n\n  Any changes to your dog’s diet must be made gradually.',
                style: kSubContentStyle2Black,
                textAlign: TextAlign.left,
              // ),
            ),
            // SizedBox(height: 12.0),
            // FittedBox(
            //   fit: BoxFit.fitWidth,
            //   child:
              Text(
                ' Usage of this Application',
                style: kMainHeadingStyleBlack,
                textAlign: TextAlign.center,
              // ),
            ),
            // SizedBox(height: 12.0),
            // FittedBox(
            //   fit: BoxFit.fitWidth,
            //   child:
              Text(
                'This application is designed for adult dogs only. This information is not suitable for puppies or gestating/lactating dogs.',
                style: kSubContentStyle2Black,
                textAlign: TextAlign.left,
              // ),
            ),
            // SizedBox(height: 18.0),
            agreedBtn,
            // SizedBox(height: 12.0),
          ],
//              ),
        ),
      ),
      //   ),
      // ],
    );

    final body = AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      // child: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       stops: [0.5, 1.0],
      //       colors: [
      //         Color(0xFF03B898),
      //         Color(0xFF01816B),
      //       ],
      //     ),
      //   ),
      child: disclaimer,
      // ),
    );
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: body,
          ),
        ),
    );
  }
}
