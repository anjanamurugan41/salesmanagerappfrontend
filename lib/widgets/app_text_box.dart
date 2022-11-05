import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppTextBox extends StatelessWidget {
  final TextFieldControl textFieldControl;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final int minLines;
  final int maxLines;
  final bool obscureText;
  final bool enabled;

  const AppTextBox(
      {Key key,
        this.textFieldControl,
        this.keyboardType = TextInputType.text,
        this.textInputAction = TextInputAction.next,
        this.hintText,
        this.prefixIcon,
        this.suffixIcon,
        this.minLines=1,
        this.maxLines=1, this.obscureText=false, this.enabled=true})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextFieldControl textFieldControl1 = (textFieldControl??TextFieldControl());
    int maxLine ,minLine;
    if(keyboardType == TextInputType.multiline){
      maxLine = null;
       minLine = null;
    }else{
      minLine = minLines;
      maxLine = maxLines;
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: CupertinoTextField(
          enabled: enabled,
          obscureText: obscureText,
          scrollPhysics: BouncingScrollPhysics(),
          controller: textFieldControl1.controller,
          focusNode: textFieldControl1.focusNode,
          keyboardType: keyboardType,
          minLines: minLine,
          maxLines: maxLine,
          textInputAction: textInputAction,
          placeholder: hintText,
          prefix: prefixIcon,
          suffix: suffixIcon,
          placeholderStyle: TextStyle(fontSize: 14,color: Colors.grey),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black26),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ));

    // return Padding(
    //     padding: EdgeInsets.symmetric(vertical: 8),
    //     child: TextField(
    //       enabled: enabled,
    //       obscureText: obscureText,
    //       scrollPhysics: BouncingScrollPhysics(),
    //       controller: textFieldControl1.controller,
    //       focusNode: textFieldControl1.focusNode,
    //       keyboardType: keyboardType,
    //       minLines: minLine,
    //       maxLines: maxLine,
    //       textInputAction: textInputAction,
    //       decoration: InputDecoration(
    //         border:  OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
    //         disabledBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
    //         enabledBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
    //         errorBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
    //         focusedBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
    //         focusedErrorBorder: OutlineInputBorder( borderSide: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(12)),
    //         hintText: hintText,
    //         hintStyle: TextStyle(fontSize: 14),
    //         prefix: prefixIcon,
    //         suffix: suffixIcon,
    //         contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    //       ),
    //     ));
  }
}


class TextFieldControl {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
}


