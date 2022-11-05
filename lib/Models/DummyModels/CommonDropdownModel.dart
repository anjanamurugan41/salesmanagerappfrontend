import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CommonDropdownModel{
  int id;
  String name;
  RxBool isSelected = false.obs;
  CommonDropdownModel({this.id, this.name, this.isSelected});
}