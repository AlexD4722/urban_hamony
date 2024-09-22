class ProductModel {
  late List<String?> urlImages;
  String? name;
  String? code;
  String? quantity;
  String? price;
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
    quantity = json['quantity'];
    price = json['price'];
    category = json['category'];
    description = json['description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['urlImages'] = this.urlImages;
    data['name'] = this.name;
    data['code'] = this.code;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['category'] = this.category;
    data['status'] = this.status;
    return data;
  }
}