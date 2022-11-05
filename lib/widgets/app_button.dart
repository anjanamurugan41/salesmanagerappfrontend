import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  int type;
  AppButton.elevated({Key key, @required this.text,  this.onTap}) : super(key: key){
    this.type = 1;
  }
  AppButton.text({Key key, @required this.text, @required this.onTap}) : super(key: key){
    this.type = 2;
  }
  AppButton.outlined({Key key, @required this.text,  this.onTap}) : super(key: key){
    this.type = 3;
  }

  @override
  Widget build(BuildContext context) {
    switch (type){
      case 1:
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: Color(buttonBgColor),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
            ),
            onPressed: onTap,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      case 2:
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: Colors.transparent,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
            ),
            onPressed: onTap,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(buttonBgColor),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      case 3 :
        return  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1.0, color: Colors.black87),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              primary: Colors.transparent,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
            ),
            onPressed: onTap,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(buttonBgColor),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        );
      default:
        return SizedBox();
    }
  }
}
