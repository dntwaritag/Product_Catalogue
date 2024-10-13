// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme.dart';
import 'product.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for persistent storage
  await GetStorage.init();

  runApp(MyApp());
}

// ThemeController to manage theme state using GetX
class ThemeController extends GetxController {
  // Storage key
  final String storageKey = 'themeIndex';

  // Observable index for the current theme
  var themeIndex = 0.obs; // Default to Light Theme (Android)

  // Instance of GetStorage
  final GetStorage box = GetStorage();

  // List of themes and their names
  final List<ThemeData> themes = AppTheme.allThemes;
  final List<String> themeNames = AppTheme.themeNames;

  // Initialize with persisted or platform-specific default theme
  @override
  void onInit() {
    super.onInit();
    // Retrieve saved theme index from storage
    int? savedTheme = box.read(storageKey);
    if (savedTheme != null && savedTheme >= 0 && savedTheme < themes.length) {
      setTheme(savedTheme, save: false);
    } else {
      // If no saved theme, set based on platform
      if (Platform.isIOS) {
        setTheme(5, save: false); // Light (iOS)
      } else {
        setTheme(0, save: false); // Light (Android)
      }
    }
  }

  // Toggle to next theme (optional functionality)
  void toggleNextTheme() {
    themeIndex.value = (themeIndex.value + 1) % themes.length;
    Get.changeTheme(themes[themeIndex.value]);
    box.write(storageKey, themeIndex.value); // Save to storage
  }

  // Set theme by index
  void setTheme(int index, {bool save = true}) {
    if (index >= 0 && index < themes.length) {
      themeIndex.value = index;
      Get.changeTheme(themes[index]);
      if (save) {
        box.write(storageKey, index); // Save to storage
      }
    }
  }
}

class MyApp extends StatelessWidget {
  // Instantiate ThemeController
  final ThemeController _themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    // Lock device orientation to portrait and landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Obx(() {
      return GetMaterialApp(
        title: 'Flutter Store',
        debugShowCheckedModeBanner: false,
        theme: _themeController.themes[_themeController.themeIndex.value],
        home: CatalogPage(),
      );
    });
  }
}

class CatalogPage extends StatelessWidget {
  // Access ThemeController
  final ThemeController _themeController = Get.find();

  // Sample list of products
  final List<Product> products = [
    Product(
      name: 'Smartphone',
      imageUrl: 'https://via.placeholder.com/150',
      price: 699.99,
    ),
    Product(
      name: 'Headphones',
      imageUrl: 'https://via.placeholder.com/150',
      price: 199.99,
    ),
    Product(
      name: 'Laptop',
      imageUrl: 'https://via.placeholder.com/150',
      price: 999.99,
    ),
    Product(
      name: 'Smartwatch',
      imageUrl: 'https://via.placeholder.com/150',
      price: 299.99,
    ),
    Product(
      name: 'Camera',
      imageUrl: 'https://via.placeholder.com/150',
      price: 499.99,
    ),
    Product(
      name: 'Bluetooth Speaker',
      imageUrl: 'https://via.placeholder.com/150',
      price: 149.99,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Store'),
        actions: [
          // Theme selection dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Obx(() {
              return DropdownButton<int>(
                value: _themeController.themeIndex.value,
                icon: Icon(
                  Icons.color_lens,
                  color: Colors.white,
                ),
                dropdownColor: Theme.of(context).primaryColor,
                underline: SizedBox(),
                items: _themeController.themeNames
                    .asMap()
                    .entries
                    .map(
                      (entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    .toList(),
                onChanged: (int? newIndex) {
                  if (newIndex != null) {
                    _themeController.setTheme(newIndex);
                  }
                },
              );
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                orientation == Orientation.portrait ? 2 : 3, // Responsive columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemBuilder: (ctx, index) => ProductCard(product: products[index]),
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.05,
    );

    // Define scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // Handle tap down
  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
      _animationController.forward();
    });
  }

  // Handle tap up
  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
      _animationController.reverse();
    });
  }

  // Handle tap cancel
  void _onTapCancel() {
    setState(() {
      _isPressed = false;
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show dialog with product details
        Get.defaultDialog(
          title: widget.product.name,
          middleText: '\$${widget.product.price.toStringAsFixed(2)}',
          actions: [
            ElevatedButton(
              onPressed: () {
                // Optionally, add to cart functionality here
                Get.back();
                Get.snackbar(
                  'Product Selected',
                  '${widget.product.name} selected.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: _isPressed ? 8 : 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              Expanded(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // Product Name
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Product Price
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                child: Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}