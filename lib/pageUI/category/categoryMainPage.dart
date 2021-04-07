import 'package:arkroot_store/dataModel/categoryDataModel.dart';
import 'package:arkroot_store/references/firebaseReferences.dart';
import 'package:arkroot_store/widgets/appBarWidget.dart';
import 'package:arkroot_store/widgets/drawerWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _categoryMainPageBody(context),
    );
  }

  _categoryMainPageBody(context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        AdminDrawer(selectedMenu: 'category',),

        Container(
          width: _pageSize.width*.84,
          child: ListView(
            children: [
              AppBarWidget(selectedMenu: 'Category',),

              _categorySection(context)
            ],
          ),
        )
      ],
    );
  }

  _categorySection(context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Container(
      height: _pageSize.height*.8,
      child: StreamBuilder(
        stream: productCategoryCollection.where('serialNum', isGreaterThanOrEqualTo: 1).snapshots(),
        builder: (context, _categorySnapshot){
          if(_categorySnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else if(!_categorySnapshot.hasData){
            return Container();
          }else{
            return GridView.count(
              crossAxisCount: 4 ,
              children: List.generate(_categorySnapshot.data.docs.length,(index){
                // return Container(height: 100, width: 100, color: Colors.blue,);
                CategoryDataModel _categoryModel = CategoryDataModel.fromDoc(_categorySnapshot.data.docs[index]);

                return Card(
                  elevation: 9,
                  child: Container(
                    child: Center(child: Text(_categoryModel.categoryNameDynamic['english'],
                      style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40),
                    )),
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}
