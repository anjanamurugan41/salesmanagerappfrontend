import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';

class AppIcon extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onTap;

  const AppIcon({Key key, @required this.iconData, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Color(drawerIconColor),
            width: 1
          ),
        ),
        child: Icon(
          iconData,
          size: 22,
          color: Color(drawerIconColor),
        ),
      ),
    );
  }
}
