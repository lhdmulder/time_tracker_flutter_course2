import 'package:flutter/material.dart';

import 'common_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    @required String text,
    VoidCallback onPressed,
  }) : super(
    child: Text(
      text, style: TextStyle(color: Colors.white, fontSize: 22.0,),),
    height: 40,
    color: Colors.indigo,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}