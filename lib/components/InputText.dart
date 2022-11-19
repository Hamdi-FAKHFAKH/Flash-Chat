import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  InputText(
      {this.holdText, @required this.OnChange, this.onTap, this.obs_text});
  final Function OnChange;
  final String holdText;
  final Function onTap;
  final bool obs_text;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      obscureText: obs_text,
      textAlign: TextAlign.center,
      onTap: onTap,
      onChanged: OnChange,
      decoration: KInputTextDecoration.copyWith(hintText: holdText),
    );
  }
}
