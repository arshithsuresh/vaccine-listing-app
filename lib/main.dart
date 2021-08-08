import 'package:cowinapp/providers/selectionProvider.dart';
import 'package:cowinapp/views/viewVaccine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './views/home.dart';

void main() async {  
  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>LocationSelectorProvider())
      ],
      child: MaterialApp(
        title: 'Vaccine Finder',
        theme: ThemeData(        
        ),
        initialRoute: '/',
        routes: {
          '/': (context)=> HomePage(),
          '/viewVaccine' : (context) => VaccineViewer()
        },
      ),
    );
  }
}

