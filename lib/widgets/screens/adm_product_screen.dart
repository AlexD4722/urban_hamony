import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:urban_hamony/models/product_model.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/widgets/screens/add_product_screen.dart';
import 'package:urban_hamony/widgets/screens/product_detail_screen.dart';

import 'detailScreen.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  DatabaseService _databaseService = DatabaseService();

  List<ProductModel> _generateProductsList(List<ProductModel> chats) {
    return chats.where((c) => c.status == "1").map((c) {
      return ProductModel(
        name: c.name,
        code: c.code,
        price: c.price,
        description: c.description,
        status: c.status,
        category: c.category,
        quantity: c.quantity,
        urlImages: c.urlImages,
      );
    }).toList();
  }

  void _deleteProduct(String productId) async {
    await _databaseService.updateProductStatusByCode(productId, "0");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Product List",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.deepOrangeAccent,
            ),
            splashColor: Colors.deepOrangeAccent,
            focusColor: Colors.deepOrangeAccent,
            iconSize: 40,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddProductPage()));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _databaseService.getProductCollection(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> data = snapshot.data!;
            List<ProductModel> products = _generateProductsList(data);
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: products[index],
                              )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                tag: index,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    child: CachedNetworkImage(
                                      imageUrl: products[index].urlImages[0] ?? "",
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].name ?? "",
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        maxLines: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\$${products[index].price}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xfffbb448),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _deleteProduct(products[index].code ?? ""),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            );
          }
        },
      ),
    );
  }
}