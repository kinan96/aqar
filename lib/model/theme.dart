import 'package:aqar/model/design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' ;
ThemeData appTheme(){

  return ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: Colors.transparent,
      disabledElevation: 0,
      focusElevation: 0,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      highlightElevation: 0,
      hoverColor: Colors.transparent,
      hoverElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15))
      )
    ),
    primaryColor: Colors.blue,
accentColor: Colors.blue.withOpacity(0.6),
focusColor: appDesign.black,
toggleableActiveColor: Colors.blue,
hintColor: appDesign.hint,
textSelectionHandleColor: Colors.blue,
textSelectionColor: Colors.blue.withOpacity(0.3),
indicatorColor: Colors.blue,
    backgroundColor: appDesign.bg,
    buttonColor: Colors.blue,
    primaryColorLight: Colors.blue,
primarySwatch: generateMaterialColor(Colors.blue),
cursorColor: Colors.blue,
inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor:appDesign.white,
  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  enabledBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide(
          width: 0,
          color: Colors.blue.withOpacity(0.2),
          style: BorderStyle.solid)),
  hintStyle: TextStyle(
    color: appDesign.hint
  ),
  isDense: false,
floatingLabelBehavior: FloatingLabelBehavior.auto,
  focusedBorder: OutlineInputBorder(
    // borderRadius: BorderRadius.all(Radius.circular(15)),
    borderSide: BorderSide(
      color: Colors.blue,
      
    )
  ),
  border: OutlineInputBorder(
      gapPadding: 0,
      // borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
          width: 0,
          color: appDesign.hint,
          style: BorderStyle.none)),

labelStyle: TextStyle(
  color: Colors.grey.shade600,
  fontWeight: FontWeight.bold,
  fontSize: 15,
)
),

buttonTheme: ButtonThemeData(buttonColor: Colors.blue,
  textTheme:ButtonTextTheme.primary,
  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10))
  ),

),
fontFamily: 'tajawal',
textTheme: TextTheme(
button: TextStyle(
  fontWeight: FontWeight.bold,

  fontSize: 15,

  wordSpacing: 1,
  color: appDesign.white
),
),
    scaffoldBackgroundColor: appDesign.bg,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(
        color: appDesign.white,
        fontWeight: FontWeight.bold
      ),
      backgroundColor: Colors.blue
    ),
    appBarTheme: AppBarTheme(
      color: appDesign.bg,
      elevation: 0,
    ),
    
  );
}
