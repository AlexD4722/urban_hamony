import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/DesignStorage.dart';
import '../../models/design.dart';
import '../../models/draggableImage.dart';
import '../../models/imageDetails.dart';
import '../../providers/roomTypeProvider.dart';
import '../components/draw/CustomIconButton.dart';
import '../components/draw/gridPainter.dart';
import '../components/draw/selectRoom.dart';
import '../components/indicator.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  String selectedRoomType = 'rectangle'; // 'rectangle' hoặc 'square'
  double roomWidth = 0.0; // Chiều rộng mặc định
  double roomHeight = 0.0; // Chiều cao mặc định

  String _option = "";
  double _scale = 1.5;
  double _previousScale = 1.5;
  Map<String, List<ImageDetails>>? imagesMap;
  List<DraggableImage> draggableImages = [];

  @override
  void initState() {
    super.initState();
    loadImagesMap();
  }

  Future<void> loadImagesMap() async {
    // Load file JSON từ assets
    String jsonString =
        await rootBundle.loadString('assets/images_list.json');
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

  // Hàm để hiển thị chọn ảnh
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
                      // Giảm khoảng cách
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _addDraggableImage(
                              imageDetails, imageType); // Thêm ảnh
                        },
                        child: Container(
                          // Kích thước cố định cho tất cả ảnh
                          child: Image.asset(
                            'assets/images/$imageType/${imageDetails.fileName}', // Đường dẫn ảnh từ JSON
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
      // Đường dẫn đầy đủ cho ảnh ban đầu
      String imagePath =
          'assets/images/$imageType/${imageDetails.fileName}';

      // Đường dẫn cho ảnh thay thế
      String alternateImagePath = imageDetails.alternateFileName != null
          ? 'assets/images/$imageType/${imageDetails.alternateFileName}'
          : imagePath;

      // Sử dụng kích thước mặc định, chỉ thay đổi chiều cao nếu ảnh thay thế có kích thước khác
      double imageWidth =
          ImageDetails.defaultWidth; // Kích thước mặc định cho tất cả ảnh
      double imageHeight =
          imageDetails.alternateHeight ?? ImageDetails.defaultHeight;

      // Thêm ảnh thay thế hoặc ảnh gốc vào draggableImages
      draggableImages.add(DraggableImage(
        fileName: alternateImagePath, // Dùng ảnh thay thế nếu có
        width: imageWidth, // Dùng độ rộng mặc định
        height: imageHeight, // Dùng chiều cao thay thế nếu có
        position: Offset(MediaQuery.of(context).size.width * 0.5 - imageWidth * 0.5,
            MediaQuery.of(context).size.height * 0.5 - imageHeight * 0.5), // Vị trí mặc định
      ));
    });
  }

  Widget _buildRoomTypeButton(String type, String label) {
    return ElevatedButton(
      onPressed: () {
        context.read<RoomTypeProvider>().setSelectedRoomType(type);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: context.watch<RoomTypeProvider>().selectedRoomType == type
            ? Colors.blue
            : Colors.white,
      ),
      child: Text(label, style:  TextStyle(color: context.watch<RoomTypeProvider>().selectedRoomType == type
          ? Colors.white
          : Colors.blue)),
    );
  }


  void _saveDesign() async {
    String? designName = await _showNameInputDialog();
    if (designName != null && designName.isNotEmpty) {
      final design = Design(
        name: designName,
        draggableImages: draggableImages,
        width: roomWidth,
        height: roomHeight,
        roomType: selectedRoomType,
      );
      await DesignStorage.saveDesign(design);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Design saved successfully')),
      );
    }
  }

  void _loadDesign() async {
    List<Design> savedDesigns = await DesignStorage.loadDesigns();
    if (savedDesigns.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No saved designs')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a design'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: savedDesigns.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(savedDesigns[index].name),
                  onTap: () {
                    Navigator.of(context).pop();
                    _applyDesign(savedDesigns[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );
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
  Future<String?> _showNameInputDialog() async {
    String? designName;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter design name'),
          content: TextField(
            onChanged: (value) {
              designName = value;
            },
            decoration: InputDecoration(hintText: "Design name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () => Navigator.of(context).pop(designName),
            ),
          ],
        );
      },
    );
    return designName;
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
                          _buildRoomTypeButton('rectangle', 'Rectangle'),
                          SizedBox(width: 16.0),
                          _buildRoomTypeButton('square', 'Square'),
                          IconButton(
                            icon: Icon(Icons.save),
                            onPressed: _saveDesign,
                          ),
                          IconButton(
                            icon: Icon(Icons.folder_open),
                            onPressed: _loadDesign,
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
