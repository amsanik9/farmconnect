import 'package:flutter/material.dart';
import '../models/product.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  organic,
  newest,
}

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      name: 'Fresh Tomatoes',
      description: 'Organic, locally grown tomatoes from Green Valley Farm.',
      price: 30,
      imageUrl:
          'https://images.unsplash.com/photo-1607305387299-a3d9611cd469?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Vegetables',
      farmerId: 'f1',
      farmerName: 'Green Valley Farm',
      weight: 1.0,
      unit: 'kg',
      isOrganic: true,
      location: 'Pune, Maharashtra',
    ),
    Product(
      id: 'p2',
      name: 'Fresh Potatoes',
      description: 'Farm-fresh potatoes, perfect for roasting or mashing.',
      price: 12,
      imageUrl:
          'https://images.unsplash.com/photo-1518977676601-b53f82aba655?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Vegetables',
      farmerId: 'f2',
      farmerName: 'Sunrise Farms',
      weight: 1.0,
      unit: 'kg',
      isOrganic: false,
      location: 'Shimla, Himachal Pradesh',
    ),
    Product(
      id: 'p3',
      name: 'Red Apples',
      description: 'Sweet and crunchy apples from local orchards.',
      price: 120,
      imageUrl:
          'https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Fruits',
      farmerId: 'f3',
      farmerName: 'Orchard Hills',
      weight: 1.0,
      unit: 'kg',
      isOrganic: true,
      location: 'Srinagar, Kashmir',
    ),
    Product(
      id: 'p4',
      name: 'Fresh Milk',
      description: 'Creamy, pasteurized milk from grass-fed cows.',
      price: 58,
      imageUrl:
          'https://images.unsplash.com/photo-1563636619-e9143da7973b?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Dairy',
      farmerId: 'f4',
      farmerName: 'Meadow Dairy',
      weight: 1.0,
      unit: 'L',
      isOrganic: false,
      location: 'Anand, Gujarat',
    ),
    Product(
      id: 'p5',
      name: 'Free Range Eggs',
      description: 'Eggs from free-range hens raised on natural feed.',
      price: 100,
      imageUrl:
          'https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Poultry',
      farmerId: 'f5',
      farmerName: 'Happy Hen Farm',
      weight: 1.0,
      unit: 'dozen',
      isOrganic: true,
      location: 'Namakkal, Tamil Nadu',
    ),
    Product(
      id: 'p6',
      name: 'Organic Spinach',
      description: 'Fresh spinach leaves, locally grown without pesticides.',
      price: 170,
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      category: 'Vegetables',
      farmerId: 'f1',
      farmerName: 'Green Valley Farm',
      weight: 1.0,
      unit: 'kg',
      isOrganic: true,
      location: 'Pune, Maharashtra',
    ),
  ];

  SortOption _currentSortOption = SortOption.nameAsc;

  List<Product> get items {
    return [..._sortedItems()];
  }

  List<Product> get organicProducts {
    return _items.where((product) => product.isOrganic).toList();
  }

  SortOption get currentSortOption {
    return _currentSortOption;
  }

  void setSortOption(SortOption option) {
    _currentSortOption = option;
    notifyListeners();
  }

  List<Product> _sortedItems() {
    List<Product> sortedList = [..._items];

    switch (_currentSortOption) {
      case SortOption.nameAsc:
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        sortedList.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.priceAsc:
        sortedList.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        sortedList.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.organic:
        sortedList.sort((a, b) => a.isOrganic == b.isOrganic
            ? 0
            : a.isOrganic
                ? -1
                : 1);
        break;
      case SortOption.newest:
        // In a real app, you'd sort by date added, but we'll just use ID here
        sortedList.sort((a, b) => b.id.compareTo(a.id));
        break;
    }

    return sortedList;
  }

  List<Product> getProductsByCategory(String category) {
    return _items.where((product) => product.category == category).toList();
  }

  List<Product> getProductsByFarmer(String farmerId) {
    return _items.where((product) => product.farmerId == farmerId).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      farmerId: product.farmerId,
      farmerName: product.farmerName,
      weight: product.weight,
      unit: product.unit,
      isOrganic: product.isOrganic,
      location: product.location,
    );
    _items.add(newProduct);
    notifyListeners();
  }
}
