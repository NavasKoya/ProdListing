import 'package:arkroot_store/references/constColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget {

  final String selectedMenu;

  const AppBarWidget({Key key, this.selectedMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _pageSize = MediaQuery.of(context).size;

    return Container(
      height: _pageSize.height*.125,
      width: _pageSize.width*.84,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(selectedMenu, style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.022, fontWeight: FontWeight.bold),),

          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  height: _pageSize.height*.05,
                  width: _pageSize.height*.05,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: constWhiteColor
                  ),
                  child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.notification_important)
                  ),
                ),

                SizedBox(width: _pageSize.width*.01,),

                Container(
                  height: _pageSize.height*.075,
                  decoration: BoxDecoration(
                      color: constWhiteColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
                  ),
                  padding: EdgeInsets.symmetric(vertical: _pageSize.height*.015, horizontal: _pageSize.width*.03),
                  child: Text('Arkroot',
                    style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.013, fontWeight: FontWeight.bold, color: constCoalBlack),
                    textAlign: TextAlign.left,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
