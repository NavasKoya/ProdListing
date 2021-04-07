import 'package:arkroot_store/pageUI/category/categoryMainPage.dart';
import 'package:arkroot_store/pageUI/homePage.dart';
import 'package:arkroot_store/pageUI/products/productMainPage.dart';
import 'package:arkroot_store/references/constColors.dart';
import 'package:arkroot_store/services/pageRoutingService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDrawer extends StatelessWidget {

  final String selectedMenu;

  const AdminDrawer({Key key, this.selectedMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Container(
      width: _pageSize.width*.15,
      height: _pageSize.height,
      color: constWhiteColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: _pageSize.height*.025),
        child: ListView(
          children: [
            Center(
              child: Text('ArkRoot',
                style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.02, fontWeight: FontWeight.bold, color: constDarkGreenColor),
              ),
            ),

            SizedBox(height: _pageSize.height*.025,),

            Padding(
              padding: EdgeInsets.symmetric(vertical: _pageSize.height*.01),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(createRoute(HomePage()));
                },
                child: Container(
                  decoration:  BoxDecoration(
                      gradient: LinearGradient(
                          colors: selectedMenu=='dashboard'?
                          [ constLightGreenColor, constDarkGreenColor ] :
                          [ constWhiteColor, constWhiteColor ]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: _pageSize.width*.01),
                  padding: EdgeInsets.symmetric(vertical: _pageSize.height*.01, horizontal: _pageSize.width*.01),
                  child: Text('Dashboard',
                    style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.015, fontWeight: FontWeight.bold, color: constCoalBlack),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: _pageSize.height*.01),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(createRoute(CategoryMainPage()));
                },
                child: Container(
                  decoration:  BoxDecoration(
                      gradient: LinearGradient(
                          colors: selectedMenu=='category'?
                          [ constLightGreenColor, constDarkGreenColor ] :
                          [ constWhiteColor, constWhiteColor ]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: _pageSize.width*.01),
                  padding: EdgeInsets.symmetric(vertical: _pageSize.height*.01, horizontal: _pageSize.width*.01),
                  child: Text('Category',
                    style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.015, fontWeight: FontWeight.bold, color: constCoalBlack),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: _pageSize.height*.01),
              child: InkWell(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProductsMainPage())
                  );
                },
                child: Container(
                  decoration:  BoxDecoration(
                      gradient: LinearGradient(
                          colors: selectedMenu=='product'?
                          [ constLightGreenColor, constDarkGreenColor ] :
                          [ constWhiteColor, constWhiteColor ]
                      ),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  margin: EdgeInsets.symmetric(horizontal: _pageSize.width*.01),
                  padding: EdgeInsets.symmetric(vertical: _pageSize.height*.01, horizontal: _pageSize.width*.01),
                  child: Text('Products',
                    style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.015, fontWeight: FontWeight.bold, color: constCoalBlack),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
