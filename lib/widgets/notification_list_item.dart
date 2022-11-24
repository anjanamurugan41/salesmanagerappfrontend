import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_manager_app/Constants/CustomColorCodes.dart';

class NotificationListItem extends StatelessWidget {
  final VoidCallback onTap;
  final names;
  final title;
  String time;
  final image;
  int id;

  NotificationListItem(
      {Key key,
        @required this.onTap,
        @required this.names,
        this.title,
        this.time,
        this.image,
        this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(buttonBgColor),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        color: Colors.grey[200],
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 50,
                width: 50,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                  "https://www.cocoalabs.in/salesapp/public/profileimage/" + image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Center(
                    child: Image(
                      image: AssetImage(
                        'assets/images/ic_avatar.png',
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.height * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Text(
                  "$names Assigned You",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Text(
                  "Task time : $time",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            // Spacer(),
            // IconButton(onPressed: (){
            // }, icon: Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}