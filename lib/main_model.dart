import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier{
  double currentSliderValue = 3;

  void changeSlider (double value){
    currentSliderValue = value;
    notifyListeners();
  }

}