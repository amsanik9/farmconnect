import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/products_grid.dart';
import '../../widgets/cart_badge.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wallet_provider.dart';
import 'cart_screen.dart';
import 'wallet_screen.dart';
import '../../models/product.dart';
import '../widgets/product_grid.dart';
import '../widgets/category_filter.dart';
import '../../l10n/app_localizations.dart';

enum FilterOptions {
  all,
  organic,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyOrganic = false;
  String? _selectedCategory;
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    // Load products from Supabase when the screen initializes
    _productsFuture = _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    return Provider.of<ProductsProvider>(context, listen: false)
        .fetchProductsFromSupabase();
  }

  void _selectCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final appLocalizations = AppLocalizations.of(context);
    
    // Filter products by category if a category is selected
    List<Product> displayedProducts = _selectedCategory == null
        ? productsData.items
        : productsData.getProductsByCategory(_selectedCategory!);

    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back button
          title: const Text('FarmConnect'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.filter_list),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.organic) {
                    _showOnlyOrganic = true;
                  } else {
                    _showOnlyOrganic = false;
                  }
                });
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show All'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.organic,
                  child: Text('Only Organic'),
                ),
              ],
            ),
            // Wallet Button with loyalty points indicator
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.account_balance_wallet),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WalletScreen(),
                      ),
                    );
                  },
                ),
                if (walletProvider.totalPoints > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        walletProvider.totalPoints.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            Consumer<CartProvider>(
              builder: (_, cart, child) => CartBadge(
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fresh from the Farm',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Support local farmers and get fresh, high-quality produce delivered to your doorstep.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green.shade700,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showOnlyOrganic ? 'Organic Products' : 'All Products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  PopupMenuButton(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Sort'),
                        SizedBox(width: 4),
                        Icon(Icons.sort),
                      ],
                    ),
                    onSelected: (SortOption value) {
                      productsData.setSortOption(value);
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: SortOption.nameAsc,
                        child: Text('Name (A to Z)'),
                      ),
                      const PopupMenuItem(
                        value: SortOption.nameDesc,
                        child: Text('Name (Z to A)'),
                      ),
                      const PopupMenuItem(
                        value: SortOption.priceAsc,
                        child: Text('Price (Low to High)'),
                      ),
                      const PopupMenuItem(
                        value: SortOption.priceDesc,
                        child: Text('Price (High to Low)'),
                      ),
                      const PopupMenuItem(
                        value: SortOption.organic,
                        child: Text('Organic First'),
                      ),
                      const PopupMenuItem(
                        value: SortOption.newest,
                        child: Text('Newest First'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _productsFuture,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (productsData.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productsData.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${productsData.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _productsFuture = _refreshProducts();
                              });
                            },
                            child: Text(appLocalizations.retry),
                          ),
                        ],
                      ),
                    );
                  } else if (displayedProducts.isEmpty) {
                    return Center(
                      child: Text(appLocalizations.noProductsFound),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refreshProducts,
                      child: ProductGrid(products: displayedProducts),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
