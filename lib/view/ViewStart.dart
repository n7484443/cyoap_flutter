import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/VMStartPlatform.dart';
import 'ViewMake.dart';
import 'ViewPlay.dart';

class FrequentlyUsed extends StatefulWidget {
  const FrequentlyUsed({Key? key}) : super(key: key);

  @override
  _FrequentlyUsedState createState() => _FrequentlyUsedState();
}

class _FrequentlyUsedState extends State<FrequentlyUsed> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<VMStartPlatform>(context, listen: false).initFrequentPath();
    });
  }

  @override
  Widget build(BuildContext context) {
    var listViewModel =
        Provider.of<VMStartPlatform>(context).pathQueue.toList().reversed;
    return ListView.separated(
      itemCount: listViewModel.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: InkWell(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<VMStartPlatform>(context, listen: false)
                        .selectFrequentPath(index);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      return Provider.of<VMStartPlatform>(context,
                              listen: false)
                          .getColor(index);
                    }),
                  ),
                  child: Text(listViewModel.elementAt(index)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<VMStartPlatform>(context, listen: false)
                        .removeFrequentPath(index);
                  },
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}

class ViewStart extends StatelessWidget {
  const ViewStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VMStartPlatform(),
      child: Consumer<VMStartPlatform>(
        builder: (context, product, child) => Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const Expanded(
                      flex: 18,
                      child: FrequentlyUsed(),
                    ),
                    Expanded(
                      child: TextButton(
                        child: Text('Add Path'),
                        onPressed: () async {
                          if (await product.openDirectory() ==
                              0) {
                            product.selected = 0;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(
                child: SelectMode(),
              )
            ],
          ),
          bottomNavigationBar: const BottomAppBar(
            color: Colors.black12,
            child: Text(
              'by n7484443',
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectMode extends StatelessWidget {
  const SelectMode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Provider.of<VMStartPlatform>(context, listen: false).setDirectory();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewPlay()),
              );
            },
            child: Container(
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
            onTap: () {
              Provider.of<VMStartPlatform>(context, listen: false).setDirectory();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewMake()),
              );
            },
            child: Container(
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
    );
  }
}
