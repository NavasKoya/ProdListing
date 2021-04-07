import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';

final productCategoryCollection=FirebaseFirestore.instance.collection("Product Categories");
final productsListCollection=FirebaseFirestore.instance.collection("Product Lists");

final Reference categoryImageStorageRef  = FirebaseStorage.instance.ref('Category Image');
// final Reference productImageStorageRef  = FirebaseStorage.instance.ref('Product Image');
final StorageReference productImageStorageRef  = app().storage().ref('Service Image');