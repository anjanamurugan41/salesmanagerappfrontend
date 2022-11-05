import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets margin;
  final double height ;
  final double width ;
  const AppCard({Key key, this. margin=const EdgeInsets.symmetric(vertical: 8), @required this.child, this.onTap, this.height, this.width=double.maxFinite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius:const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 6,
            offset: const Offset(2,2),
          )
        ],
      ),
      child: ClipRRect(
          borderRadius:const BorderRadius.all(Radius.circular(12)),
          child: Material(
            color: Colors.white,
            child: InkWell(
                onTap: onTap,
                child: child),
          )),
    );
  }
}
