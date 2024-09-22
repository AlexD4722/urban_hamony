class ProductModel {
  late List<String?> urlImages;
  String? name;
  String? code;
  int? quantity;
  double? price;
  String? category;
  String? description;
  String? status;

  ProductModel({
    required this.urlImages,
    this.name,
    this.code,
    this.quantity,
    this.price,
    this.category,
    this.description,
    this.status,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    if (json['urlImages'] is String) {
      urlImages = (json['urlImages'] as String).split(',').map((e) => e.trim()).toList();
    } else if (json['urlImages'] is List) {
      urlImages = (json['urlImages'] as List).map((e) => e.toString()).toList();
    } else {
      urlImages = [];
    }
    name = json['name'];
    code = json['code'];
    quantity = json['quantity'] is String ? int.tryParse(json['quantity']) ?? 0 : json['quantity'];
    price = json['price'] is String ? double.tryParse(json['price']) ?? 0.0 : json['price'];
    category = json['category'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urlImages'] = this.urlImages;
    data['name'] = this.name;
    data['code'] = this.code;
    data['quantity'] = this.quantity.toString();
    data['price'] = this.price.toString();
    data['category'] = this.category;
    data['description'] = this.description;
    data['status'] = this.status;
    return data;
  }
}