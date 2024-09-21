import 'package:flutter/material.dart'; // Đảm bảo chỉ cần import này

class DraggableImage {
  String fileName;
  Offset position;
  double width;
  double height;
  double angle;

  DraggableImage({
    required this.fileName,
    required this.position,
    required this.width,
    required this.height,
    this.angle = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'fileName': fileName,
    'position': {'dx': position.dx, 'dy': position.dy},
    'width': width,
    'height': height,
    'angle': angle, // Lưu angle
  };

  factory DraggableImage.fromJson(Map<String, dynamic> json) {
    return DraggableImage(
      fileName: json['fileName'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      width: json['width'],
      height: json['height'],
      angle: json['angle'], // Khôi phục angle
    );
  }
}
