import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyOrganic;

  const ProductsGrid({
    Key? key,
    this.showOnlyOrganic = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products =
        showOnlyOrganic ? productsData.organicProducts : productsData.items;

    return products.isEmpty
        ? Center(
            child: Text(
              'No products found!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => ProductItem(
              product: products[i],
            ),
          );
  }
}
