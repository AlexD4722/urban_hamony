class BlogModel {
  String? id;
  String? image;
  String? title;
  String? category;
  String? description;
  String? html;
  String? status;

  BlogModel({
    this.id,
    this.image,
    this.title,
    this.category,
    this.description,
    this.status,
    this.html
  });

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'];
    category = json['category'];
    description = json['description'];
    status = json['status'];
    html = json['html'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['category'] = this.category;
    data['status'] = this.status;
    data['html'] = this.html;
    return data;
  }
}