import 'package:flutter/material.dart';
import 'package:pawfect/screens/login/login_screen.dart';
import 'package:pawfect/utils/page_transition.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String tag = 'forgot_password-page';

  @override
  Widget build(BuildContext context) {
//     final alucard = Hero(
//       tag: 'hero',
//       child: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Center(
//           child: Image(
//             fit: BoxFit.fitWidth,
//             image: AssetImage(
//               'assets/images/logo_small.png',
//             ),
//             height: 120.0,
//             width: 160.0,
//           ),
//         ),
// //        CircleAvatar(
// //          radius: 72.0,
// //          backgroundColor: Colors.transparent,
// //          backgroundImage: AssetImage('assets/images/onboarding_logo_small.png'),
// //        ),
//       ),
//     );
//     final email = TextFormField(
//       keyboardType: TextInputType.emailAddress,
//       autofocus: false,
// //      initialValue: 'alucard@gmail.com',
//       style: TextStyle(
//         color: Colors.white,
//       ),
//       decoration: InputDecoration(
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.white, width: 1.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.transparent, width: 1.0),
//         ),
//         filled: true,
//         fillColor: Color(0xFF3ebfa9),
//         hintText: 'Enter Your Email',
//         hintStyle: TextStyle(color: Colors.white70),
//         contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
//       ),
//     );
    final logo = Container(
      padding: EdgeInsets.only(top: 12.0),
      child: Center(
        child: Image.asset(
          'assets/images/logo_large.png',
          fit: BoxFit.cover,
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Password Reset',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final description = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '"A password reset message has been sent to your email address. Please click the link in the email to reset your password and login”.',
        style: kMainHeadingStyleWhite,
        textAlign: TextAlign.center,
      ),
    );

    final backToButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: () {
          Navigator.of(context).pushReplacement(PageTransition(
            child: LoginScreen(),
            type: PageTransitionType.leftToRight,
          ));
//          Navigator.of(context).pushNamed(HomeScreen.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            'BACK TO LOGIN',
            style: TextStyle(
              color: Color(0xFF01816B),
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    final body = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.5, 1.0],
          colors: [
            Color(0xFF03B898),
            Color(0xFF01816B),
          ],
        ),
      ),
      // width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.all(18.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: logo,
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 32.0),
                  child: Column(
                    children: [
                      // SizedBox(height: 12.0),
                      // welcome,
                      SizedBox(height: 12.0),
//          email,
//          SizedBox(height: 12.0),
                      description,
                      SizedBox(height: 24.0),
                      backToButton,
                    ],
                  ),
                ),
              ), //Text('this text here'),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
