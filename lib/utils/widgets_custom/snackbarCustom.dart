import 'package:flutter/material.dart';

import '../helpers/response_size.dart';

class snackBarCustom {
  void showSnackBar(BuildContext context, String msg, String type) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                msg,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xff252525),
        duration: const Duration(seconds: 5),
      ));
  }
}
