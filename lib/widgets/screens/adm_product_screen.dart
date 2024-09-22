import 'package:flutter/material.dart';
import 'package:urban_hamony/models/product_model.dart';
import 'package:urban_hamony/services/database_service.dart';
import 'package:urban_hamony/widgets/screens/add_product_screen.dart';
import 'package:urban_hamony/widgets/screens/product_detail_screen.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);



  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  DatabaseService _databaseService = DatabaseService();
  List<ProductModel> _generateProductsList(List<ProductModel> chats){
    List<ProductModel> products = chats.map((c) {
      return ProductModel(
        name: c.name,
        code: c.code,
        price: c.price,
        description: c.description,
        status: c.status,
        category: c.category,
        quantity: c.quantity,
        urlImages: c.urlImages
      );
    }).toList();
    return products;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(
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
          builder: (context, snapshot){
            if(snapshot.hasData){
              List<ProductModel> data = snapshot.data!;
              List<ProductModel> products = _generateProductsList(
                  data
              );
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SecondPage(
                              heroTag: index,
                              product: products[index],
                            )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Hero(
                              tag: index,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 150,
                                  height: 100,
                                  child: Image.network(
                                  fit: BoxFit.cover,
                                  products[index].urlImages[0]!,
                                ),
                                )
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ListTile(// Icon đại diện cho sản phẩm
                                title: Text('Name: ${products[index].name}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price: \$${products[index].price}'),
                                    Text('Quantity: ${products[index].quantity}'),
                                    Text('Description: ${products[index].description}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );

          }else {
              return Center(
                child: CircularProgressIndicator(color: Colors.pinkAccent,),
              );
            }
    }
      ),
    );
  }


}


final List<String> _images = [
  'https://images.pexels.com/photos/167699/pexels-photo-167699.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
  'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/273935/pexels-photo-273935.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/462024/pexels-photo-462024.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
];