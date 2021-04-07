import 'package:cloud_firestore/cloud_firestore.dart';

class ProductListDataModel{

  final String productUniqueID;
  final dynamic productName;
  final String categoryID;
  final dynamic productImage;
  final dynamic productNote;
  final dynamic productDescription;
  final String productCurrentStatus;
  final Timestamp modifiedTimeStamp;
  final dynamic productUserReviews;
  final dynamic productVariant;
  final double price;
  final double stockAvailable;

  ProductListDataModel({this.productUniqueID, this.productName, this.categoryID, this.productImage, this.productNote,
  this.productDescription, this.productCurrentStatus, this.modifiedTimeStamp, this.productUserReviews, this.productVariant,
  this.price, this.stockAvailable});


  factory ProductListDataModel.fromDoc(DocumentSnapshot doc){
    return ProductListDataModel(
      productUniqueID: doc["productUniqueID"],
      productName: doc["productName"],
      categoryID: doc["categoryID"],
      productImage: doc["productImage"],
      productNote: doc["productNote"],
      productDescription: doc["productDescription"],
      productCurrentStatus:doc["productCurrentStatus"],
      modifiedTimeStamp: doc["modifiedTimeStamp"],
      productUserReviews: doc["productUserReviews"],
      productVariant: doc["productVariant"],
      price: doc["price"],
      stockAvailable: doc["stockAvailable"]
    );
  }
}