import 'dart:convert';
import 'draggableImage.dart';

class Design {
  final String id;
  final String name;
  final String image;
  final String description;
  final List<DraggableImage> draggableImages;
  final double width;
  final double height;
  final String roomType;
  final int status;
  Design({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.draggableImages,
    required this.width,
    required this.height,
    required this.roomType,
    required this.status, // Add status field
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'draggableImages':
            draggableImages.map((image) => image.toJson()).toList(),
        'width': width,
        'height': height,
        'roomType': roomType,
        "description": description,
        "image": image,
        "status": status, // Add status field
      };

  factory Design.fromJson(Map<String, dynamic> json) {
    return Design(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      draggableImages: (json['draggableImages'] as List)
          .map((imageJson) => DraggableImage.fromJson(imageJson))
          .toList(),
      width: (json['width'] ?? 0).toDouble(),
      height: (json['height'] ?? 0).toDouble(),
      roomType: json['roomType'] ?? '',
      status: json['status'] ?? 1, // Add status field
    );
  }

  Design copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    double? width,
    double? height,
    String? roomType,
    List<DraggableImage>? draggableImages,
    int? status,
  }) {
    return Design(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      width: width ?? this.width,
      height: height ?? this.height,
      roomType: roomType ?? this.roomType,
      draggableImages: draggableImages ?? this.draggableImages,
      status: status ?? this.status,
    );
  }
}
