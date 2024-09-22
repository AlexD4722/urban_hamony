import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:urban_hamony/widgets/screens/detailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product.dart';
import '../../models/product_model.dart';
import '../../providers/cartProvider.dart';
import '../../services/database_service.dart';
import 'cart.dart';
import 'cartEmpty.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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
  List<Product> demoProducts = [
    Product(
      id: 1,
      images: [
        "https://i.postimg.cc/c19zpJ6f/Image-Popular-Product-1.png",
        "https://i.postimg.cc/zBLc7fcF/ps4-console-white-2.png",
        "https://i.postimg.cc/KYpWtTJY/ps4-console-white-3.png",
        "https://i.postimg.cc/YSCV4RNV/ps4-console-white-4.png"
      ],
      title: "Wireless Controller for PS4™",
      price: 64.99,
      description: "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …",
      quantity: 100,
      category: "table",
    ),
    Product(
      id: 1,
      images: [
        "https://i.postimg.cc/c19zpJ6f/Image-Popular-Product-1.png",
        "https://i.postimg.cc/zBLc7fcF/ps4-console-white-2.png",
        "https://i.postimg.cc/KYpWtTJY/ps4-console-white-3.png",
        "https://i.postimg.cc/YSCV4RNV/ps4-console-white-4.png"
      ],
      title: "Wireless Controller for PS4™",
      price: 64.99,
      description: "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …",
      quantity: 100,
      category: "chair",
    ),
    Product(
      id: 1,
      images: [
        "https://i.postimg.cc/c19zpJ6f/Image-Popular-Product-1.png",
        "https://i.postimg.cc/zBLc7fcF/ps4-console-white-2.png",
        "https://i.postimg.cc/KYpWtTJY/ps4-console-white-3.png",
        "https://i.postimg.cc/YSCV4RNV/ps4-console-white-4.png"
      ],
      title: "Wireless Controller for PS4™",
      price: 64.99,
      description: "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …",
      quantity: 100,
      category: "door",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: StreamBuilder(
        stream: _databaseService.getProductCollection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<ProductModel> data = snapshot.data!;
          List<ProductModel> products = _generateProductsList(
              data
          );
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const HomeHeader(),
                  TableProducts(listProduct: demoProducts.where((product) => product
                      .category == "table").toList()),
                  SizedBox(height: 20),
                  ChairProducts(listProduct: demoProducts.where((product) => product
                      .category == "chair").toList()),
                  SizedBox(height: 20),
                  DoorProducts(listProduct: demoProducts.where((product) => product
                      .category == "door").toList()),
                  SizedBox(height: 20),
                  WindowProducts(
                      listProduct: demoProducts.where((product) => product
                          .category == "window").toList()),
                  SizedBox(height: 20),
                  BedProducts(listProduct: demoProducts.where((product) => product
                      .category == "bed").toList()),
                  SizedBox(height: 20),
                  TreeProducts(listProduct: demoProducts.where((product) => product
                      .category == "tree").toList()),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

}

class TableProducts extends StatelessWidget {
  final List<Product> listProduct;
  const TableProducts({super.key, required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Table",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: listProduct.isEmpty
              ? const Text("No products available", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listProduct.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                product: listProduct[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChairProducts extends StatelessWidget {
  final List<Product> listProduct;

  const ChairProducts({super.key, required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Chair",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: listProduct.isEmpty
              ? const Text("No products available", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: listProduct[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class DoorProducts extends StatelessWidget {
  final List<Product> listProduct;

  const DoorProducts({super.key, required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Door",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: listProduct.isEmpty
              ? const Text("No products available", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: listProduct[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class WindowProducts extends StatelessWidget {
  final List<Product> listProduct;
  const WindowProducts({super.key, required this.listProduct});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Window",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: listProduct.isEmpty
              ? const Text("No products available", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: listProduct[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class BedProducts extends StatelessWidget {
  final List<Product> listProduct;
  const BedProducts({super.key, required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Bed",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: listProduct.isEmpty
              ? const Text("No products available", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: listProduct[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class TreeProducts extends StatelessWidget {
  final List<Product> listProduct;
  const TreeProducts({super.key, required this.listProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Tree",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: listProduct.isEmpty
              ? const Text("No products available", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listProduct.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: listProduct[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Products",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  final demoCarts =
                      Provider
                          .of<CartProvider>(context, listen: false)
                          .demoCarts;
                  if (demoCarts.isEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartEmpty()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
                  }
                },
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    int totalItems = cartProvider.demoCarts.fold(
                        0, (sum, cart) => sum + cart.numOfItem);
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(12),
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.string(cartIcon),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xfffbb448),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$totalItems',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    Key? key,
    required this.svgSrc,
    this.numOfitem = 0,
    required this.press,
  }) : super(key: key);

  final String svgSrc;
  final int numOfitem;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: press,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF979797).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.string(svgSrc),
          ),
          if (numOfitem != 0)
            Positioned(
              top: -3,
              right: 0,
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfitem",
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () =>
        {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product)))
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF979797).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.images[0],
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xfffbb448),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

const cartIcon =
'''<svg width="22" height="18" viewBox="0 0 22 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M18.4524 16.6669C18.4524 17.403 17.8608 18 17.1302 18C16.3985 18 15.807 17.403 15.807 16.6669C15.807 15.9308 16.3985 15.3337 17.1302 15.3337C17.8608 15.3337 18.4524 15.9308 18.4524 16.6669ZM11.9556 16.6669C11.9556 17.403 11.3631 18 10.6324 18C9.90181 18 9.30921 17.403 9.30921 16.6669C9.30921 15.9308 9.90181 15.3337 10.6324 15.3337C11.3631 15.3337 11.9556 15.9308 11.9556 16.6669ZM20.7325 5.7508L18.9547 11.0865C18.6413 12.0275 17.7685 12.6591 16.7846 12.6591H10.512C9.53753 12.6591 8.66784 12.0369 8.34923 11.1095L6.30162 5.17154H20.3194C20.4616 5.17154 20.5903 5.23741 20.6733 5.35347C20.7563 5.47058 20.7771 5.61487 20.7325 5.7508ZM21.6831 4.62051C21.3697 4.18031 20.858 3.91682 20.3194 3.91682H5.86885L5.0002 1.40529C4.70961 0.564624 3.92087 0 3.03769 0H0.621652C0.278135 0 0 0.281266 0 0.62736C0 0.974499 0.278135 1.25472 0.621652 1.25472H3.03769C3.39158 1.25472 3.70812 1.48161 3.82435 1.8183L4.83311 4.73657C4.83622 4.74598 4.83934 4.75434 4.84245 4.76375L7.17339 11.5215C7.66531 12.9518 9.00721 13.9138 10.512 13.9138H16.7846C18.304 13.9138 19.6511 12.9383 20.1347 11.4859L21.9135 6.14917C22.0847 5.63369 21.9986 5.06175 21.6831 4.62051Z" fill="#7C7C7C"/>
</svg>
''';
