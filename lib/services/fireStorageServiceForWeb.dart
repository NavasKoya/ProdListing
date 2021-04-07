// use this class to get file url from firebase storage for Flutter web

import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {

  FireStorageService._();

  FireStorageService() {
    fb.initializeApp(
        // apiKey: "AIzaSyB_bUcwGOCL24AbaijhKDR26WnMO6YaXog",
        // authDomain: "typingbro-friggy.firebaseapp.com",
        // databaseURL: "https://typingbro-friggy.firebaseio.com",
        // projectId: "typingbro-friggy",
        // storageBucket: "typingbro-friggy.appspot.com",
        // messagingSenderId: "1080626552396",
        // appId: "1:1080626552396:web:9fb904649b662505fb9ee9",
        // measurementId: "G-7G6XKS04NY"

        apiKey: "AIzaSyCAGfLSFnUn4nsXVSaFpfuz5m8mCynVJL0",
        authDomain: "arkroot-store.firebaseapp.com",
        projectId: "arkroot-store",
        storageBucket: "arkroot-store.appspot.com",
        messagingSenderId: "441204788138",
        appId: "1:441204788138:web:a181442c623a88a52ab9d3",
        measurementId: "G-F0XJ6KT6N5"
    );
  }

  static Future<dynamic> loadFromStorage(String image) async {
    // var url = await newsMediaStorageRef.getDownloadURL();
    var url = await fb.storage().ref(image).getDownloadURL();
    return url;
  }
}