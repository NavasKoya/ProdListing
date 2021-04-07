import 'package:arkroot_store/dataModel/productListDataModel.dart';
import 'package:arkroot_store/references/constColors.dart';
import 'package:arkroot_store/references/firebaseReferences.dart';
import 'package:arkroot_store/services/pageRoutingService.dart';
import 'package:arkroot_store/widgets/appBarWidget.dart';
import 'package:arkroot_store/widgets/drawerWidget.dart';
import 'package:arkroot_store/widgets/eachProductWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'products/addProductPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constIvoryColor,
      body: _homePageBody(context),
    );
  }

  _homePageBody(context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AdminDrawer(selectedMenu: 'dashboard',),

        Container(
          width: _pageSize.width*.84,
          child: ListView(
            children: [
              AppBarWidget(selectedMenu: 'Dashboard',),

              _homePageSection(context)
            ],
          ),
        )
      ],
    );
  }

  _homePageSection(context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Container(
      height: _pageSize.height*.8,
      child: StreamBuilder(
        stream: productsListCollection.where('productCurrentStatus', isEqualTo: 'Active').snapshots(),
        builder: (context, _prodSnapshot){
          if(_prodSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(!_prodSnapshot.hasData){
            return Container();
          }else{
            return GridView.count(
              crossAxisCount: 4 ,
              children: List.generate(_prodSnapshot.data.docs.length,(index){
                // return Container(height: 100, width: 100, color: Colors.blue,);
                ProductListDataModel _prodModel = ProductListDataModel.fromDoc(_prodSnapshot.data.docs[index]);

                return EachProductWidget(
                  prodPrice: _prodModel.price.toString(),
                  prodName: _prodModel.productName['english'],
                  prodID: _prodModel.productUniqueID,
                  prodImage: _prodModel.productImage['img1'],
                  permission: 'view',
                );
              }),
            );
          }
        },
      ),
    );

  }
}
