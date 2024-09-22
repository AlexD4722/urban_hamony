import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/services/storage_service.dart';

import '../components/bezierContainer.dart';

class AddBlogPage extends StatefulWidget {
  const AddBlogPage({Key? key}) : super(key: key);


  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  DatabaseService _databaseService = DatabaseService();
  StorageService _storageService = StorageService();
  List<String> _newPhotos = [];
  File? _image;
  Future<File> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        _image = image;
      });
      return image;
    }
    return File('');
  }


  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(width: 10,),
              Text(
                'Add Blog'
                , style: TextStyle(fontWeight: FontWeight.w500),)
            ],
          ),
          automaticallyImplyLeading: false,
          elevation: 1,
          shadowColor: Colors.grey,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(CupertinoIcons.arrow_left),
          ),
        ),
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _propertiesWidget(),
                      GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 16 / 9
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if (!(_newPhotos.isNotEmpty && (index < _newPhotos.length))){
                                  var photo = await _getImage();
                                  setState(() {
                                    _newPhotos.add(photo.path);

                                  });
                                }
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child:
                                      _newPhotos.isNotEmpty && (index < _newPhotos.length)
                                          ?
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(File(_newPhotos[index]))
                                          ),
                                        ),
                                      )
                                      //     :
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.grey.shade300,
                                      //     borderRadius: BorderRadius.circular(8),
                                      //     image: DecorationImage(
                                      //         fit: BoxFit.cover,
                                      //         image: FileImage(File(_[index]))
                                      //     ),
                                      //   ),
                                      // )
                                          :
                                      DottedBorder(
                                        color: Colors.grey.shade700,
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(8),
                                        dashPattern: [ 5, 5, 5, 5 ],
                                        padding: EdgeInsets.zero,
                                        strokeWidth: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        ),
                                      )
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Material(
                                      elevation: 4,
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                                style: BorderStyle.solid,
                                              ),
                                              color: Colors.white
                                          ),
                                          child: Center(
                                            child: _newPhotos.isNotEmpty && (index < _newPhotos.length)
                                                ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _newPhotos.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                        style: BorderStyle.solid,
                                                      ),
                                                      color: Colors.white
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Image.asset(
                                                      'lib/assets/images/clear_icon.png',
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                              ),
                                            )
                                                : Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.deepOrange
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Image.asset(
                                                    'lib/assets/images/add.png',
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                      ),
                      SizedBox(height: height * .04),
                      _submitButton()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _entryField(String title, TextEditingController controller,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xFFD1D1D1),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        await _getImage;
        print(_image);
        final uploadImages = await _storageService.uploadBlogImage(
            _image!,
            _codeController.text
        );
        if(uploadImages != null){
          print(uploadImages);
          await _databaseService.addBlog(
            _codeController.text,
            _titleController.text,
            uploadImages,
            _categoryController.text,
            _descriptionController.text,
          );
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _propertiesWidget() {
    return Column(
      children: <Widget>[
        _entryField("Code", _codeController),
        _entryField("Title", _titleController),
        _entryField("Description", _descriptionController),
        _entryField("Category ", _categoryController),

      ],
    );
  }
}



