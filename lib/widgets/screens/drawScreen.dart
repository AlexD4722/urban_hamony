import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';
import '../../models/DesignStorage.dart';
import '../../models/auth_model.dart';
import '../../models/design.dart';
import '../../models/draggableImage.dart';
import '../../models/imageDetails.dart';
import '../../providers/roomTypeProvider.dart';
import '../../services/database_service.dart';
import '../../utils/userInfoUtil.dart';
import '../components/draw/CustomIconButton.dart';
import '../components/draw/gridPainter.dart';
import '../components/draw/selectRoom.dart';
import '../components/indicator.dart';

class DrawScreen extends StatefulWidget {
  final Design? design;

  const DrawScreen({super.key, this.design});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  String selectedRoomType = 'rectangle';
  double roomWidth = 0.0;
  double roomHeight = 0.0;

  String _option = "";
  double _scale = 1.5;
  double _previousScale = 1.5;
  Map<String, List<ImageDetails>>? imagesMap;
  List<DraggableImage> draggableImages = [];

  @override
  void initState() {
    super.initState();
    if (widget.design != null) {
      setState(() {
        draggableImages = widget.design!.draggableImages;
        roomWidth = widget.design!.width;
        roomHeight = widget.design!.height;
        selectedRoomType = widget.design!.roomType;
      });
    }
    loadImagesMap();
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    File imageFile = File(imagePath);
    String fileName = 'design_screenshots/${DateTime.now().millisecondsSinceEpoch}.png';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> loadImagesMap() async {
    // Load file JSON từ assets
    String jsonString = await rootBundle.loadString('assets/images_list.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // Chuyển dữ liệu JSON thành Map<String, List<ImageDetails>>
    setState(() {
      imagesMap = jsonData.map((key, value) {
        List<ImageDetails> imageDetailsList = (value as List<dynamic>)
            .map((item) => ImageDetails.fromJson(item as Map<String, dynamic>))
            .toList();
        return MapEntry(key, imageDetailsList);
      });
    });
  }

  void _showImageSelection(BuildContext context, String imageType) {
    setState(() {
      _option = imageType;
    });
    if (imagesMap == null || !imagesMap!.containsKey(imageType)) {
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 180,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Indicator(),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imagesMap![imageType]!.length,
                  itemBuilder: (context, index) {
                    final imageDetails = imagesMap![imageType]![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _addDraggableImage(
                              imageDetails, imageType);
                        },
                        child: Container(
                          child: Image.asset(
                            'assets/images/$imageType/${imageDetails.fileName}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addDraggableImage(ImageDetails imageDetails, String imageType) {
    setState(() {
      String imagePath = 'assets/images/$imageType/${imageDetails.fileName}';

      String alternateImagePath = imageDetails.alternateFileName != null
          ? 'assets/images/$imageType/${imageDetails.alternateFileName}'
          : imagePath;

      double imageWidth = ImageDetails.defaultWidth;
      double imageHeight =
          imageDetails.alternateHeight ?? ImageDetails.defaultHeight;

      draggableImages.add(DraggableImage(
        fileName: alternateImagePath,
        width: imageWidth,
        height: imageHeight,
        position: Offset(
            MediaQuery.of(context).size.width * 0.5 - imageWidth * 0.5,
            MediaQuery.of(context).size.height * 0.5 -
                imageHeight * 0.5), // Vị trí mặc định
      ));
    });
  }

  Widget _buildRoomTypeButton(String type, String label) {
    return ElevatedButton(
      onPressed: () {
        context.read<RoomTypeProvider>().setSelectedRoomType(type);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            context.watch<RoomTypeProvider>().selectedRoomType == type
                ? const Color(0xfffbb448)
                : Colors.white,
      ),
      child: Text(label,
          style: TextStyle(
              color: context.watch<RoomTypeProvider>().selectedRoomType == type
                  ? Colors.white
                  : const Color(0xffe46b10))),
    );
  }

  Future<void> _loadCurrentUser(UserModel? currentUser) async {
    currentUser = await UserinfoUtil.getCurrentUser();
    if (currentUser != null) {
    } else {}
    setState(() {});
  }

  void _saveDesign() async {
    try {
      Map<String, String?>? designDetails = await _showNameInputDialog();
      if (designDetails != null && designDetails['name']!.isNotEmpty) {
        final imagePath = designDetails['imagePath'];
        if (imagePath != null) {
          final imageUrl = await _uploadImageToFirebase(imagePath);
          final design = Design(
            id: Uuid().v4(),
            name: designDetails['name']!,
            description: designDetails['description']!,
            image: imageUrl,
            draggableImages: draggableImages,
            width: roomWidth,
            height: roomHeight,
            roomType: selectedRoomType,
            status: 1,
          );
          UserModel? currentUser = await UserinfoUtil.getCurrentUser();
          String email = currentUser!.email ?? ""; // Replace with the current user's email
          bool success = await DatabaseService().saveDesignToUser(email, design);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Design saved successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save design')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No image selected')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _applyDesign(Design design) {
    setState(() {
      draggableImages = design.draggableImages;
      roomWidth = design.width;
      roomHeight = design.height;
      selectedRoomType = design.roomType;
      context.read<RoomTypeProvider>().setSelectedRoomType(design.roomType);
      print("=========== $selectedRoomType ===========");
    });
  }

  Future<String?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  }
  Future<Map<String, String?>?> _showNameInputDialog() async {
    String? designName;
    String? designDescription;
    String? selectedImagePath;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter design details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      designName = value;
                    },
                    decoration: InputDecoration(hintText: "Design name"),
                  ),
                  TextField(
                    onChanged: (value) {
                      designDescription = value;
                    },
                    decoration: InputDecoration(hintText: "Design description"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final imagePath = await _pickImage();
                      if (imagePath != null) {
                        setState(() {
                          selectedImagePath = imagePath;
                        });
                      }
                    },
                    child: Text('Upload Image'),
                  ),
                  if (selectedImagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.file(
                        File(selectedImagePath!),
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () => Navigator.of(context).pop({
                    'name': designName,
                    'description': designDescription,
                    'imagePath': selectedImagePath,
                  }),
                ),
              ],
            );
          },
        );
      },
    );

    return {'name': designName, 'description': designDescription, 'imagePath': selectedImagePath};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              _previousScale = _scale;
            },
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() {
                _scale = (_previousScale * details.scale).clamp(1, 1.8);
              });
            },
            child: Transform.scale(
              scale: _scale,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      painter: GridPainter(
                        gridSpacing: 15.0,
                        scale: _scale,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: SelectRoom(
                      draggableImages: draggableImages,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () =>{
                            Navigator.pop(context)
                          }, icon: const Icon(Icons.arrow_back)),
                          Expanded(child: _buildRoomTypeButton('rectangle', 'Rectangle'),),
                          SizedBox(width: 16.0),
                          Expanded(child: _buildRoomTypeButton('square', 'Square')),
                          IconButton(
                            icon: Icon(Icons.save),
                            onPressed: _saveDesign,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomAppBar(
                color: Colors.white,
                shape: const CircularNotchedRectangle(),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CustomIconButton(
                      option: _option,
                      icon: Icons.table_restaurant_rounded,
                      title: 'Table',
                      onPressed: () => _showImageSelection(context, 'Table'),
                    ),
                    CustomIconButton(
                      option: _option,
                      icon: Icons.chair_rounded,
                      title: 'Chair',
                      onPressed: () => _showImageSelection(context, 'Chair'),
                    ),
                    CustomIconButton(
                      option: _option,
                      icon: Icons.sensor_door,
                      title: 'Door',
                      onPressed: () => _showImageSelection(context, 'Door'),
                    ),
                    CustomIconButton(
                      option: _option,
                      icon: Icons.window,
                      title: 'Window',
                      onPressed: () => _showImageSelection(context, 'Window'),
                    ),
                    CustomIconButton(
                      option: _option,
                      icon: Icons.bed_rounded,
                      title: 'Bed',
                      onPressed: () => _showImageSelection(context, 'Bed'),
                    ),
                    CustomIconButton(
                      option: _option,
                      icon: Icons.local_florist,
                      title: 'Tree',
                      onPressed: () => _showImageSelection(context, 'Tree'),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
