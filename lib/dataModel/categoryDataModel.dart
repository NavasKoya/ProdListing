
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDataModel{

  final String categoryID;
  final dynamic categoryNameDynamic;
  final String categoryStatus;
  final String categoryImage;
  final dynamic categoryDescriptionDynamic;
  final Timestamp modifiedTimeStamp;
  final double serialNum;
  final dynamic requiredFields;

  CategoryDataModel({this.categoryID, this.categoryNameDynamic, this.categoryStatus, this.categoryImage, this.categoryDescriptionDynamic,
     this. modifiedTimeStamp, this.serialNum, this.requiredFields});

  factory CategoryDataModel.fromDoc(DocumentSnapshot doc){
    return CategoryDataModel(
        categoryID: doc["categoryID"],
        categoryNameDynamic: doc["categoryNameDynamic"],
        categoryStatus: doc["categoryStatus"],
        categoryImage: doc["categoryImage"],
        categoryDescriptionDynamic: doc["categoryDescriptionDynamic"],
        modifiedTimeStamp: doc["modifiedTimeStamp"],
        serialNum: doc["serialNum"],
        requiredFields: doc["requiredFields"]
    );
  }


}