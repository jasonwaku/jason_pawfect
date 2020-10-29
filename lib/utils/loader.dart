import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pawfect/utils/cosmetic/styles.dart';

class LoadingDialog {

  static Future<void> showLoadingDialog(
      BuildContext context,
      // GlobalKey key
      ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            // key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitPumpingHeart(
                        color: Color(0xFF03B898),
                        size: 40.0,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        "Please Wait...",
                        style: kTitleStyleBlackMedium,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> hideLoadingDialog(
      BuildContext context,
      )async {
    Navigator.pop(context);
  }

  }
