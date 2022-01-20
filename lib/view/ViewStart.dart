import 'package:flutter/material.dart';

import '../viewmodel/ViewModelLoadPlatform.dart';
import 'ViewMake.dart';
import 'ViewPlay.dart';

class ViewStart extends StatelessWidget {
  const ViewStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                if(await ViewModelLoadPlatform().openDirectory() == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ViewPlay()),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Play',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                if(await ViewModelLoadPlatform().openDirectory() == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ViewMake()),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black12,
                child: const Center(
                  child: Text(
                    'Make',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.black12,
        child: Text(
            'by n7484443',
          textAlign: TextAlign.end,
        ),
      ),
    );
  }
}
