import 'package:ch3_lec9/screen/fifthtask.dart';
import 'package:ch3_lec9/screen/firsttask.dart';
import 'package:ch3_lec9/screen/fourtask.dart';
import 'package:ch3_lec9/screen/homepage.dart';
import 'package:ch3_lec9/screen/secondtask.dart';
import 'package:ch3_lec9/screen/sixtask.dart';
import 'package:ch3_lec9/screen/thirdtask.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/":(context){
          return HomePage();
        },
        "firsttask":(context){
          return First_Task();
        },
        "secondtask":(context){
          return SecondTask();
        },
        "thirdtask":(context){
          return ThirdTask();
        },
        "fourtask":(context){
          return FourTask();
        },
        "fifthtask":(context){
          return FifthTask();
        },
        "sixtask":(context){
          return SixTask();
        },
      },
    )
  );
}