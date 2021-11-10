import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rave_flutter/src/rave_result.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool isProcessing = false;
  String confirmationMessage = 'Do you want to cancel payment?';
  bool alwaysPop = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context);

  Future<bool> _onWillPop() async {
    if (isProcessing) {
      return false;
    }

    var returnValue = getPopReturnValue();

    if (alwaysPop ||
        (returnValue != null &&
            (returnValue is RaveResult &&
                returnValue.status == RaveStatus.success))) {
      Navigator.of(context).pop(returnValue);
      return false;
    }

    var text = Text(confirmationMessage);

    var dialog = Platform.isIOS
        ? CupertinoAlertDialog(
            title: text,
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Yes'),
                isDestructiveAction: true,
                onPressed: () {
                  // Returning true to _onWillPop will pop again.
                  Navigator.pop(context, true);
                },
              ),
              CupertinoDialogAction(
                child: Text('No'),
                isDefaultAction: true,
                onPressed: () {
                  // Pops the confirmation dialog but not the page.
                  Navigator.pop(context, false);
                },
              ),
            ],
          )
        : AlertDialog(
            content: text,
            actions: <Widget>[
              TextButton(
                child: Text('NO'),
                onPressed: () {
                  // Pops the confirmation dialog but not the page.
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('YES'),
                onPressed: () {
                  // Returning true to _onWillPop will pop again.
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );

    bool exit = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => dialog,
        ) ??
        false;

    if (exit) {
      Navigator.of(context).pop(returnValue);
    }
    return false;
  }

  void onCancelPress() async {
    bool close = await _onWillPop();
    if (close) {
      Navigator.of(context).pop(await getPopReturnValue());
    }
  }

  getPopReturnValue() {}
}
