import 'package:arkroot_store/dataModel/categoryDataModel.dart';
import 'package:arkroot_store/references/constColors.dart';
import 'package:arkroot_store/references/firebaseReferences.dart';
import 'package:arkroot_store/services/bloc/searchBloc.dart';
import 'package:arkroot_store/services/fireStorageServiceForWeb.dart';
import 'package:arkroot_store/services/pageRoutingService.dart';
import 'package:arkroot_store/services/showSnackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase/firebase.dart' as fb;

import '../homePage.dart';

class AddProductList extends StatefulWidget {

  @override
  _AddProductListState createState() => _AddProductListState();
}

class _AddProductListState extends State<AddProductList> {

  PickedFile _productImageFile;

  MediaInfo _pickedMediaInfo;
  String _productImageUrl='';


  int serviceListCount=0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _categoryID='', _categoryName='';

  var _productReqDataFieldArray = new List(50);
  
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _stockController = TextEditingController();

  final _prodInfoFormKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: constIvoryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height*.075),
        child: _productAppBar(),
      ),
      // body: _scaffoldBody(),
      body: _categoryID==''? _blankPageMsg() : _addProductBody(),
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

              InkWell(
                onTap: _selectCategoryAlertDialog,
                child: Container(
                  child: _categoryID==''? Text('Select Category') : Text(_categoryName, style: GoogleFonts.ubuntu(color: constWhiteColor, fontSize: 25),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _selectCategoryAlertDialog(){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: TextStyle(fontSize: 14.0, color: Colors.black54),
                // controller: _serviceNameController,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  hintText: "Category Name",
                  border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(10.0),),
                ),
                onChanged: (value) {
                  bloc.feedSearchVal(value);
                },
              ),
              Expanded(
                child: StreamBuilder(
                    initialData: "",
                    stream: bloc.receiveSearchVal,
                    builder: (context, blocSnapshot) {
                      String _searchVal = blocSnapshot.data;
                      return Container(
                        height: MediaQuery.of(context).size.height*.5,
                        width: MediaQuery.of(context).size.width*.15,
                        child: StreamBuilder(
                          stream: productCategoryCollection
                              .where('categoryStatus', isEqualTo: 'Active')
                              .snapshots(),
                          builder: (BuildContext context, AsyncSnapshot _categorySnapshot){
                            if(_categorySnapshot.connectionState==ConnectionState.waiting){
                              return Center(
                                child: Text("Loading"),
                              );
                            }else if (!_categorySnapshot.hasData) {
                              return Center();
                            } else if (_searchVal != null && _searchVal != '') {

                              List<DocumentSnapshot> listLocal = [];
                              for (int i = 0; i < _categorySnapshot.data.docs.length; ++i) {
                                if (_categorySnapshot.data.docs[i]['categoryNameDynamic']['english'].toLowerCase().toString().contains(_searchVal.toLowerCase()) ) {
                                  listLocal.add(_categorySnapshot.data.docs[i]);
                                }
                              }
                              return (listLocal.length != 0)
                                  ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: listLocal.length,
                                  itemBuilder: (_, index){
                                    CategoryDataModel categoryDataModel= CategoryDataModel.fromDoc(listLocal[index]);
                                    return ListTile(
                                      title: GestureDetector(
                                        onTap:() {
                                          setState(() {
                                            _categoryID=categoryDataModel.categoryID;
                                            _categoryName=categoryDataModel.categoryNameDynamic['english'];
                                          });
                                          Navigator.pop(context);
                                          bloc.feedSearchVal('');
                                        },
                                        // child: Text(_categorySnapshot.data.docs[index]["categoryID"])
                                        child: Text(categoryDataModel.categoryNameDynamic['english']),
                                      ),
                                    );
                                  }
                              )
                                  : Text('No Data');

                            }else{
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _categorySnapshot.data.docs.length,
                                  itemBuilder: (_, index){
                                    CategoryDataModel categoryDataModel= CategoryDataModel.fromDoc(_categorySnapshot.data.docs[index]);
                                    return ListTile(
                                      title: GestureDetector(
                                        onTap:() {
                                          setState(() {
                                            _categoryID=categoryDataModel.categoryID;
                                            _categoryName=categoryDataModel.categoryNameDynamic['english'];
                                          });
                                          Navigator.pop(context);
                                          bloc.feedSearchVal('');
                                        },
                                        // child: Text(snapshot.data.docs[index]["categoryName"])
                                        child: Text(categoryDataModel.categoryNameDynamic['english']),
                                      ),
                                    );
                                  }
                              );
                            }
                          },
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        )
    );
  }

  _addProductBody(){
    Size _pageSize = MediaQuery.of(context).size;

    return Container(
      child: FutureBuilder(
          future: productCategoryCollection.doc(_categoryID).get(),
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
                      child: _addImageWidget(_categoryModel),
                    ),

                    Container(
                      width: _pageSize.width*.3,
                      color: constIvoryColor,
                      child: _addProductInfoWidget(),
                    ),

                    Container(
                      width: _pageSize.width*.3,
                      color: constIvoryColor,
                      child: Column(
                        children: [
                          Text('Required Data Fields', style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.02, fontWeight: FontWeight.bold),),

                          _categorySpecificData(_categoryModel)
                        ],
                      ),
                    ),


                  ],
                ),
              );
            }
      }),
    );
  }
  
  _blankPageMsg(){
    return Center(
      child: InkWell(
        onTap: _selectCategoryAlertDialog,
          child: Text('Please select category to proceed', style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 30),)
      ),
    );
  }

  _showLoadingIndicator(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height:50, width: 50,
                  child: new CircularProgressIndicator(
                    backgroundColor: Theme.of(context).backgroundColor,
                  ),
                ),
                SizedBox(height: 25,),
                // new Text(googleTranslator.translate("Adding to Cart...", from: 'en', to: applicationLanguage).toString(),
                //   style: GoogleFonts.arvo(fontSize: 18),
                // ),
                new Text('Uploading...',
                  style: GoogleFonts.arvo(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onImageButtonPressed() async {

    MediaInfo pickedImageMedia = await ImagePickerWeb.getImageInfo;
    PickedFile _imageMediaInfo = PickedFile(pickedImageMedia.base64WithScheme.toString()) ;

    setState(() {
      _productImageFile = _imageMediaInfo;
      _pickedMediaInfo = pickedImageMedia;
    });
  }

  _addProductInfoWidget() {
    Size _pageSize = MediaQuery.of(context).size;
    
    return Container(
      width: _pageSize.width*.3,
      child: Form(
        key: _prodInfoFormKey,
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
                  style: TextStyle(fontSize: 18.0), enabled: true,
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
                  style: TextStyle(fontSize: 18.0), enabled: true,
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
                  style: TextStyle(fontSize: 18.0), enabled: true,
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
                  style: TextStyle(fontSize: 18.0), enabled: true,
                  decoration: InputDecoration(
                    //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                    labelText: "Product Price",
                    hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                    border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                  ),
                  onSaved: (input)=> _priceController.text= input,
                  validator: (input) => input.trim().length<1 ? "Please provide valid price" : null,
                  onChanged: (input){
                    if(input.contains(new RegExp(r'[a-zA-Z_\-=@,\;]+$'))){
                      ShowSnackBar.showSnackBar(context,'Use Only digit');
                    }
                  },
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
                  style: TextStyle(fontSize: 18.0), enabled: true,
                  decoration: InputDecoration(
                    //  icon: Icon(FlutterAppIcons.event_note, size: 30.0, color: Colors.cyan[700],),
                    labelText: "Product Available Stock",
                    hintText: "Type Here", hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                    border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                  ),
                  onSaved: (input)=> _stockController.text= input,
                  validator: (input) => input.trim().length<1 ? "Please provide valid Stock count" : null,
                  onChanged: (input){
                    if(input.contains(new RegExp(r'[a-zA-Z_\-=@,\;]+$'))){
                      ShowSnackBar.showSnackBar(context,'Use Only digit');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addImageWidget(_categoryModel) {
    Size _pageSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: _pageSize.width*.2,
          height: _pageSize.width*.2,
          color: constWhiteColor,
          child: Center(
            child: InkWell(
              onTap: _onImageButtonPressed,
                child:  Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _productImageFile == null
                        ? Icon(MaterialCommunityIcons.image_plus, size: _pageSize.width*.025,)
                        : Image.network(_productImageFile.path, fit: BoxFit.cover,),
                  ),
                )
              // child: Icon(MaterialCommunityIcons.image_plus, size: _pageSize.width*.025,),
            ),
          ),
        ),

        InkWell(
          onTap: ()=> _saveToDatabase (_categoryModel),
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
              child: Text('Save', style: GoogleFonts.ubuntu(fontSize: _pageSize.width*.025, fontWeight: FontWeight.bold),),
            ),
          ),
        )
      ],
    );
  }

  _categorySpecificData(CategoryDataModel _categoryModel) {
    Size _pageSize = MediaQuery.of(context).size;

    return  Container(
      width: _pageSize.width*.3,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(_categoryModel.requiredFields.length, (index) {
            return Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_categoryModel.requiredFields[index]),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Container(
                      width: _pageSize.width*.1,
                      child: TextFormField(
                        style: TextStyle(fontSize: 14.0, color: Colors.black54),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                          hintText: _categoryModel.requiredFields[index],
                          border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(5.0),),
                        ),
                        onChanged: (input){
                          _productReqDataFieldArray[index] = input;
                        },
                      ),
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

  _saveToDatabase(CategoryDataModel _categoryModel) async{

    if(_prodInfoFormKey.currentState.validate()){
      _prodInfoFormKey.currentState.save();

      _showLoadingIndicator();

      String _prodID=_categoryName.replaceAll(RegExp('/'), '')+"_"+DateTime.now().toString()+"_"+ 'arkroot';

      if(_productImageFile!=null){
        try {
          String _mediaExtension='image/png';

          var metadata = fb.UploadMetadata(
            contentType: _mediaExtension,
          );

          String _filePath = 'serviceImage/'+ _prodID;

          fb.UploadTaskSnapshot uploadTaskSnapshot =
          await productImageStorageRef.child(_filePath).put(_pickedMediaInfo.data, metadata).future;

          await FireStorageService.loadFromStorage('Service Image/$_filePath').then((downloadUrl) => {
            setState(() {
              _productImageUrl = downloadUrl.toString();
            })
          });

        } catch (e) {
          print("File Upload Error $e");
          return null;
        }
      }

      productsListCollection.doc(_prodID).set({
        "productUniqueID": _prodID,
        "productName": {
          "english": _nameController.text
        },
        "categoryID": _categoryID,
        "productImage": {
          'img1': _productImageUrl
        },
        "productNote": {
          "english": _noteController.text
        },
        "productDescription": {
          "english": _descriptionController.text
        },
        "productCurrentStatus": "Active",
        "modifiedTimeStamp": DateTime.now(),
        "productUserReviews": {
        },
        "productVariant":{
          for(int i=0; i<_categoryModel.requiredFields.length; i++){
            _categoryModel.requiredFields[i] : _productReqDataFieldArray[i]
          }
        },
        "stockAvailable": double.parse(_stockController.text),
        "price": double.parse(_priceController.text),

      });

      Navigator.of(context).push(createRoute(HomePage()));
    }
  }
}
