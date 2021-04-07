import 'package:arkroot_store/dataModel/categoryDataModel.dart';
import 'package:arkroot_store/dataModel/productListDataModel.dart';
import 'package:arkroot_store/references/constColors.dart';
import 'package:arkroot_store/references/firebaseReferences.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewOnlyProduct extends StatefulWidget {

  final productID;

  const ViewOnlyProduct({Key key, this.productID}) : super(key: key);

  @override
  _ViewOnlyProductState createState() => _ViewOnlyProductState();
}

class _ViewOnlyProductState extends State<ViewOnlyProduct> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();

  var _productReqDataFieldArray = new List(50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constIvoryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*.075),
        child: _productAppBar(),
      ),
      // body: _scaffoldBody(),
      body: _updateProductBody(),
    );
  }

  _productAppBar(){
    Size _pageSize = MediaQuery.of(context).size;
    return AppBar(
      flexibleSpace: Padding(
        padding: EdgeInsets.symmetric(horizontal: _pageSize.width*.025),
        child: Container(
          height: _pageSize.height*.075,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
            ],
          ),
        ),
      ),
    );
  }


  _updateProductBody(){
    Size _pageSize = MediaQuery.of(context).size;

    return Container(
      child: FutureBuilder(
          future: productsListCollection.doc(widget.productID).get(),
          builder: (context, _prodSnapshot) {
            if(_prodSnapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else if( !_prodSnapshot.hasData){
              return Container();
            }else{

              ProductListDataModel _prodListModel = ProductListDataModel.fromDoc(_prodSnapshot.data);

              return FutureBuilder(
                  future: productCategoryCollection.doc(_prodListModel.categoryID).get(),
                  builder: (context, _categorySnapshot) {
                    if(_categorySnapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }else if( !_categorySnapshot.hasData){
                      return Container();
                    }else{
                      CategoryDataModel _categoryModel = CategoryDataModel.fromDoc(_categorySnapshot.data);
                      return Container(
                        height: _pageSize.height,
                        width: _pageSize.width,
                        // decoration: BoxDecoration(
                        //   color: constCoalBlack
                        // ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: _pageSize.width*.3,
                              color: constCoalBlack,
                              child: _viewImageWidget(_categoryModel, _prodListModel),
                            ),

                            Container(
                              width: _pageSize.width*.3,
                              color: constIvoryColor,
                              child: _viewProductInfoWidget(_prodListModel),
                            ),

                            Container(
                              width: _pageSize.width*.3,
                              color: constIvoryColor,
                              child: Column(
                                children: [
                                  Text('Product Details', style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.02, fontWeight: FontWeight.bold),),

                                  _categorySpecificData(_categoryModel, _prodListModel)
                                ],
                              ),
                            ),


                          ],
                        ),
                      );
                    }
                  });
            }
          }
      ),
    );
  }

  _viewProductInfoWidget(ProductListDataModel _prodDataModel) {
    Size _pageSize = MediaQuery.of(context).size;

    _nameController.text = _prodDataModel.productName['english'];
    _descriptionController.text = _prodDataModel.productDescription['english'];
    _noteController.text = _prodDataModel.productNote['english'];
    _priceController.text = _prodDataModel.price.toString();
    _stockController.text = _prodDataModel.stockAvailable.toString();

    return Container(
      width: _pageSize.width*.3,
      child: Column(
        children: [
          SizedBox(height: _pageSize.height*.01),
          Container(
            constraints: BoxConstraints(
                maxHeight: _pageSize.height*.15
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:10.0, right: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _nameController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0), enabled: false,
                decoration: InputDecoration(
                  //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                  labelText: "Product Name",
                  hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                  border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                ),
                onSaved: (input)=> _nameController.text= input,
                validator: (input) => input.trim().length<1 ? "Please provide product name" : null,
              ),
            ),
          ),

          SizedBox(height: _pageSize.height*.01),
          Container(
            constraints: BoxConstraints(
                maxHeight: _pageSize.height*.35
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:10.0, right: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _descriptionController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0), enabled: false,
                decoration: InputDecoration(
                  //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                  labelText: "Product description",
                  hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                  border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                ),
                onSaved: (input)=> _descriptionController.text= input,
                validator: (input) => input.trim().length<1 ? "Please provide valid description for product" : null,
              ),
            ),
          ),

          SizedBox(height: _pageSize.height*.01),

          Container(
            constraints: BoxConstraints(
                maxHeight: _pageSize.height*.25
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:10.0, right: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _noteController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0), enabled: false,
                decoration: InputDecoration(
                  //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                  labelText: "Product Note",
                  hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                  border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                ),
                onSaved: (input)=> _noteController.text= input,
              ),
            ),
          ),

          SizedBox(height: _pageSize.height*.01),
          Container(
            constraints: BoxConstraints(
                maxHeight: _pageSize.height*.35
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:10.0, right: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _priceController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0), enabled: false,
                decoration: InputDecoration(
                  //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                  labelText: "Product Price",
                  hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                  border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                ),
              ),
            ),
          ),

          SizedBox(height: _pageSize.height*.01),
          Container(
            constraints: BoxConstraints(
                maxHeight: _pageSize.height*.35
            ),
            child: Padding(
              padding: const EdgeInsets.only(left:10.0, right: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _stockController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0), enabled: false,
                decoration: InputDecoration(
                  //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                  labelText: "Product Available Stock",
                  hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                  border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _viewImageWidget(_categoryModel, ProductListDataModel _prodDataModel) {
    Size _pageSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: _pageSize.width*.2,
          height: _pageSize.width*.2,
          color: constWhiteColor,
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(_prodDataModel.productImage['img1'], fit: BoxFit.cover,)
              ),
            ),
          ),
        ),

        InkWell(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            ),
            elevation: 9,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25)
              ),
              padding: EdgeInsets.symmetric(horizontal: _pageSize.width*.035, vertical: _pageSize.height*.015),
              child: Text('Add to Cart', style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.025, fontWeight: FontWeight.bold),),
            ),
          ),
        )
      ],
    );
  }

  _categorySpecificData(CategoryDataModel _categoryModel, ProductListDataModel _prodDataModel) {
    Size _pageSize = MediaQuery.of(context).size;

    return  Container(
      width: _pageSize.width*.3,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(_categoryModel.requiredFields.length, (index) {
            _productReqDataFieldArray[index] = _prodDataModel.productVariant[index][_categoryModel.requiredFields[index]];
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_categoryModel.requiredFields[index]),



                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Container(
                      width: _pageSize.width*.1,
                      child: Text(_prodDataModel.productVariant[index][_categoryModel.requiredFields[index]]),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
