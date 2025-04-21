import 'package:flutter/material.dart';

class Product {
  final String name;
  final String type;
  final String unit;
  final List<String> tags;
  final int price;
  final int stock;

  Product({
    required this.name,
    required this.type,
    required this.unit,
    required this.tags,
    required this.price,
    required this.stock,
  });
}

class ProductsScreen extends StatefulWidget {
  static const routeName = '/farmer-products';

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<Product> _products = [
    Product(
        name: 'Organic Tomatoes',
        type: 'Vegetable',
        unit: 'kg',
        tags: ['Organic'],
        price: 40,
        stock: 100),
    Product(
        name: 'Fresh Carrots',
        type: 'Vegetable',
        unit: 'dozen',
        tags: ['Fresh'],
        price: 30,
        stock: 150),
    Product(
        name: 'Green Peppers',
        type: 'Vegetable',
        unit: 'mg',
        tags: [],
        price: 35,
        stock: 80),
  ];

  final List<String> _productTypes = [
    'Dairy',
    'Poultry',
    'Vegetable',
    'Fruits',
    'Crops'
  ];

  final List<String> _units = ['kg', 'dozen', 'mg'];

  void _showAddProductSheet() {
    final _formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    final tagsCtrl = TextEditingController();
    String? selectedType;
    String? selectedUnit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add Product',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter a name' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type'),
                  value: selectedType,
                  items: _productTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    selectedType = value;
                  }),
                  validator: (val) => val == null ? 'Select a type' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Unit'),
                  value: selectedUnit,
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedUnit = value),
                  validator: (val) => val == null ? 'Select a unit' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: priceCtrl,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || int.tryParse(val) == null
                      ? 'Enter a valid price'
                      : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: stockCtrl,
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || int.tryParse(val) == null) {
                      return 'Enter valid stock';
                    }
                    if (int.parse(val) <= 50) {
                      return 'Stock must be greater than 50';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: tagsCtrl,
                  decoration:
                      InputDecoration(labelText: 'Tags (comma separated)'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedType != null &&
                        selectedUnit != null) {
                      setState(() {
                        _products.add(Product(
                          name: nameCtrl.text,
                          type: selectedType!,
                          unit: selectedUnit!,
                          tags: tagsCtrl.text.isNotEmpty
                              ? tagsCtrl.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList()
                              : [],
                          price: int.parse(priceCtrl.text),
                          stock: int.parse(stockCtrl.text),
                        ));
                      });
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Add'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProductSheet(int index) {
    final _formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: _products[index].name);
    final priceCtrl =
        TextEditingController(text: _products[index].price.toString());
    final stockCtrl =
        TextEditingController(text: _products[index].stock.toString());
    final tagsCtrl =
        TextEditingController(text: _products[index].tags.join(', '));
    String? selectedType = _products[index].type;
    String? selectedUnit = _products[index].unit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Edit Product',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Enter a name' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Type'),
                  value: selectedType,
                  items: _productTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    selectedType = value;
                  }),
                  validator: (val) => val == null ? 'Select a type' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Unit'),
                  value: selectedUnit,
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedUnit = value),
                  validator: (val) => val == null ? 'Select a unit' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: priceCtrl,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || int.tryParse(val) == null
                      ? 'Enter a valid price'
                      : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: stockCtrl,
                  decoration: InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || int.tryParse(val) == null) {
                      return 'Enter valid stock';
                    }
                    if (int.parse(val) <= 50) {
                      return 'Stock must be greater than 50';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: tagsCtrl,
                  decoration:
                      InputDecoration(labelText: 'Tags (comma separated)'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedType != null &&
                        selectedUnit != null) {
                      setState(() {
                        _products[index] = Product(
                          name: nameCtrl.text,
                          type: selectedType!,
                          unit: selectedUnit!,
                          tags: tagsCtrl.text.isNotEmpty
                              ? tagsCtrl.text
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList()
                              : [],
                          price: int.parse(priceCtrl.text),
                          stock: int.parse(stockCtrl.text),
                        );
                      });
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: Text('Save'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Product'),
        content:
            Text('Are you sure you want to delete ${_products[index].name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _products.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E603A),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _showAddProductSheet,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: _products.map((prod) {
                return _buildProductCard(
                  name: prod.name,
                  type: prod.type,
                  unit: prod.unit,
                  price: prod.price,
                  stock: prod.stock,
                  onEdit: () {
                    _showEditProductSheet(_products.indexOf(prod));
                  },
                  onDelete: () {
                    _confirmDelete(_products.indexOf(prod));
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String name,
    required String type,
    required String unit,
    required int price,
    required int stock,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Stock: $stock $unit',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
