import 'package:arkroot_store/pageUI/products/editProductPage.dart';
import 'package:arkroot_store/pageUI/products/viewOnlyProducts.dart';
import 'package:arkroot_store/references/constColors.dart';
import 'package:arkroot_store/services/pageRoutingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class EachProductWidget extends StatelessWidget {

  final String prodImage;
  final String prodName;
  final String prodID;
  final String prodPrice;
  final String permission;

  const EachProductWidget({Key key, this.prodImage, this.prodName, this.prodID, this.prodPrice, this.permission}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Card(
      elevation: 9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
      ),
      child: Container(
        height: _pageSize.height*.2,
        width: _pageSize.width*.125,
        decoration: BoxDecoration(
          color: constWhiteColor,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Image.network(prodImage, height: _pageSize.height*.1,),
            ),

            Container(
              height: _pageSize.height*.05,
              child: Text(prodName, style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.02, fontWeight: FontWeight.bold, color: Colors.black),),
            ),

            Container(
              height: _pageSize.height*.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(prodPrice, style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.015, fontWeight: FontWeight.bold, color: Colors.black),),

                  permission=='edit'?
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(createRoute(UpdateProductList(productID: prodID,)));
                      },
                      child: Icon(EvilIcons.pencil, size: 40,),
                    ) :
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(createRoute(ViewOnlyProduct(productID: prodID,)));
                    },
                    child: Icon(Entypo.eye, size: 40,),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
