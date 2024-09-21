import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final int quantity;
  final double price;
  final String  category ;

  Product({
    required this.id,
    required this.images,
    required this.title,
    required this.price,
    required this.description,
    required this.quantity,
    required this.category,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      images: List<String>.from(json['images']),
      title: json['title'],
      price: json['price'],
      description: json['description'],
      quantity: json['quantity'],
      category: json['category'],
    );
  }
}

// Our demo Products
