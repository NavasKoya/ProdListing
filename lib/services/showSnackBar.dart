
import 'package:flutter/material.dart';

class ShowSnackBar{
  static showSnackBar(context, msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: 1),
        )
    );
  }
}