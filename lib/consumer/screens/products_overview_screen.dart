import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/products_grid.dart';
import '../../widgets/cart_badge.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import 'cart_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

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
                      productsProvider.setSortOption(value);
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
              child: ProductsGrid(showOnlyOrganic: _showOnlyOrganic),
            ),
          ],
        ),
      ),
    );
  }
}
