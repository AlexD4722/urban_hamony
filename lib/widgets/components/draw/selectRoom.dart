import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/draggableImage.dart';
import '../../../providers/roomTypeProvider.dart';
import 'gridPainter.dart';

class SelectRoom extends StatefulWidget {
  final List<DraggableImage> draggableImages;
  const SelectRoom({Key? key, required this.draggableImages}) : super(key: key);

  @override
  State<SelectRoom> createState() => _SelectRoomState();
}

class _SelectRoomState extends State<SelectRoom> {
  late String selectedRoomType = ""; // 'rectangle' hoặc 'square'
  late double roomWidth = 0.0; // Chiều rộng mặc định
  late double roomHeight = 0.0; // Chiều cao mặc định
  @override
  void initState() {
    super.initState();
  }

  double area = 0.0; // Diện tích phòng
  Color wallColor = Color(0xFFB8B8B8)!; // Màu tường xám
  Color floorColor = Color(0xFFFFE2AB)!; // Màu sàn gỗ
  Color lineColor = Colors.white; // Màu đường line
  double wallThickness = 8.0; // Độ dày của tường
  double lineThickness = 2.0; // Độ dày của đường line

  @override
  Widget build(BuildContext context) {
    // Xác định kích thước mặc định là 70% kích thước màn hình
    double width = MediaQuery.of(context).size.width * 0.5;
    double height = MediaQuery.of(context).size.height * 0.5;

    return Stack(
      children: [
        Column(
          children: [
            // Thanh chọn kiểu phòng
            // Container(
            //   color: Colors.grey[200],
            //   padding: EdgeInsets.symmetric(vertical: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       _buildRoomTypeButton('rectangle', 'Rectangle'),
            //       SizedBox(width: 16.0),
            //       _buildRoomTypeButton('square', 'Square'),
            //     ],
            //   ),
            // ),
            // Hình phòng
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () => _showInputDialog(context),
                  child: _buildRoomShape(width, height),
                ),
              ),
            ),
          ],
        ),
        ...widget.draggableImages.map((draggableImage) {
          return Positioned(
            left: draggableImage.position.dx,
            top: draggableImage.position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  draggableImage.position += details.delta;
                });
              },
              onTap: () {
                // Lấy vị trí của draggableImage
                final RenderBox renderBox =
                context.findRenderObject() as RenderBox;
                final Offset offset = renderBox.localToGlobal(Offset(
                    draggableImage.position.dx, draggableImage.position.dy));

                // Hiển thị menu tùy chọn khi nhấp vào draggableImage
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    offset.dx,
                    offset.dy,
                    0,
                    0,
                  ),
                  items: [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('delete'),
                    ),
                    PopupMenuItem(
                      value: 'rotate',
                      child: Text('rotate'),
                    ),
                  ],
                ).then((value) {
                  if (value == 'delete') {
                    // Xử lý xóa draggableImage
                    setState(() {
                      widget.draggableImages.remove(draggableImage);
                    });
                  } else if (value == 'rotate') {
                    // Xử lý xoay draggableImage
                    setState(() {
                      draggableImage.angle += 90; // Xoay 90 độ
                    });
                  }
                });
              },
              child: Transform.rotate(
                angle: draggableImage.angle *
                    (3.14159 / 180), // Chuyển đổi độ sang radian
                child: Image.asset(
                  draggableImage.fileName,
                  width: draggableImage.width,
                  height: draggableImage.height,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }


  Widget _buildRoomShape(double width, double height) {
    final selectedRoomType = context.watch<RoomTypeProvider>().selectedRoomType;
    return Container(
      width: width,
      height: (selectedRoomType == 'square') ? width : height,
      decoration: BoxDecoration(
        color: floorColor,
        border: Border.all(
          color: wallColor,
          width: wallThickness,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: width,
            height: (selectedRoomType == 'square') ? width : height,
          ),
          Positioned(
            left: wallThickness * -0.6,
            right: wallThickness * -0.6,
            top: wallThickness * -0.6,
            child: Container(
              height: lineThickness,
              color: lineColor,
            ),
          ),
          Positioned(
            top: wallThickness * -0.6,
            bottom: wallThickness * -0.6,
            left: wallThickness * -0.6,
            child: Container(
              width: lineThickness,
              color: lineColor,
            ),
          ),
          Positioned(
            left: wallThickness * -0.6,
            right: wallThickness * -0.6,
            bottom: wallThickness * -0.6,
            child: Container(
              height: lineThickness,
              color: lineColor,
            ),
          ),
          Positioned(
            top: wallThickness * -0.6,
            bottom: wallThickness * -0.6,
            right: wallThickness * -0.6,
            child: Container(
              width: lineThickness,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }

  // Hàm để nhập chiều dài và chiều rộng
  void _showInputDialog(BuildContext context) {
    TextEditingController widthController =
    TextEditingController(text: roomWidth.toString());
    TextEditingController heightController =
    TextEditingController(text: roomHeight.toString());

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Enter Width and Height'),
    //       content: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           TextField(
    //             controller: widthController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //               labelText: 'Width (m)',
    //               suffixText: 'm', // Thêm đơn vị vào trường nhập liệu
    //             ),
    //           ),
    //           TextField(
    //             controller: heightController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //               labelText: 'Height (m)',
    //               suffixText: 'm', // Thêm đơn vị vào trường nhập liệu
    //             ),
    //           ),
    //         ],
    //       ),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () {
    //             setState(() {
    //               roomWidth =
    //                   double.tryParse(widthController.text) ?? roomWidth;
    //               roomHeight =
    //                   double.tryParse(heightController.text) ?? roomHeight;
    //               area = roomWidth * roomHeight;
    //             });
    //             Navigator.pop(context); // Đóng hộp thoại sau khi xác nhận
    //           },
    //           child: Text('Confirm'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
