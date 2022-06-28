import 'package:awesome_cafe/global/enum/view_state.dart';
import 'package:awesome_cafe/global/model/cafe_model.dart';
import 'package:awesome_cafe/global/provider/cafe_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:html/dom.dart' show Document;
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CafeProvider()),
        // ChangeNotifierProvider(create: (_) => ParentProvider()),
      ],
      child: MaterialApp(
        title: 'Awesome Cafe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Awesome Cafe'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 250), () {
      context.read<CafeProvider>().getCafe();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<CafeProvider>(builder: (_, watch, __) {
        if (watch.state == ViewState.Busy) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return ListView.builder(
            itemCount: watch.cafeList.length,
            itemBuilder: (context, index) {
              CafeModel? item = watch.cafeList[index];
              return Column(
                children: [Text(item?.name ?? ''), Text(item?.link ?? ''), Text(item?.location ?? '')],
              );
            });
      }),
    );
  }
}
