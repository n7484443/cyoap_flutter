import 'package:get/get.dart';

class VMEditor extends GetxController{
  String str = '';

  void updateString(String text){
    str = text;
    update();
  }
}