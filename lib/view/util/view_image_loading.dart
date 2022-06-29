import 'package:flutter/material.dart';
import '../../model/image_db.dart';

class ViewImageLoading extends StatelessWidget {
  final String name;
  const ViewImageLoading(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: ImageDB().getImage(name), builder: (buildContext, snapshot){
      if(!snapshot.hasData){
        return SizedBox.fromSize(
          size: const Size(100, 100),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if(snapshot.data == null){
        return ImageDB().noImage;
      }
      return snapshot.data as Widget;
    });
  }
}