import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

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
  List<Product> _products = [];
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appLocalizations = AppLocalizations.of(context);
    
    // Initialize products with localized names
    if (_products.isEmpty) {
      _products = [
        Product(
            name: appLocalizations.organicTomatoes,
            type: appLocalizations.vegetable,
            unit: 'kg',
            tags: [appLocalizations.organic],
            price: 40,
            stock: 100),
        Product(
            name: appLocalizations.freshCarrots,
            type: appLocalizations.vegetable,
            unit: 'dozen',
            tags: [appLocalizations.fresh],
            price: 30,
            stock: 150),
        Product(
            name: appLocalizations.greenPeppers,
            type: appLocalizations.vegetable,
            unit: 'mg',
            tags: [],
            price: 35,
            stock: 80),
      ];
    }
  }

  final List<String> _productTypes = [
    'Dairy',
    'Poultry',
    'Vegetable',
    'Fruits',
    'Crops'
  ];

  final List<String> _units = ['kg', 'dozen', 'mg'];

  void _showAddProductSheet() {
    final appLocalizations = AppLocalizations.of(context);
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
                Text(
                  appLocalizations.addProductTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.name),
                  validator: (val) =>
                      val == null || val.isEmpty ? appLocalizations.enterName : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: appLocalizations.type),
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
                  validator: (val) => val == null ? appLocalizations.selectType : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: appLocalizations.unit),
                  value: selectedUnit,
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedUnit = value),
                  validator: (val) => val == null ? appLocalizations.selectUnit : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.price),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || int.tryParse(val) == null
                      ? appLocalizations.enterValidPrice
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stockCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.stock),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || int.tryParse(val) == null) {
                      return appLocalizations.enterValidStock;
                    }
                    if (int.parse(val) <= 50) {
                      return appLocalizations.stockMustBeGreater;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: tagsCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.tags),
                ),
                const SizedBox(height: 16),
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
                  child: Text(appLocalizations.add),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProductSheet(int index) {
    final appLocalizations = AppLocalizations.of(context);
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
                Text(
                  appLocalizations.editProductTitle,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.name),
                  validator: (val) =>
                      val == null || val.isEmpty ? appLocalizations.enterName : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: appLocalizations.type),
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
                  validator: (val) => val == null ? appLocalizations.selectType : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: appLocalizations.unit),
                  value: selectedUnit,
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedUnit = value),
                  validator: (val) => val == null ? appLocalizations.selectUnit : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.price),
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || int.tryParse(val) == null
                      ? appLocalizations.enterValidPrice
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: stockCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.stock),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || int.tryParse(val) == null) {
                      return appLocalizations.enterValidStock;
                    }
                    if (int.parse(val) <= 50) {
                      return appLocalizations.stockMustBeGreater;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: tagsCtrl,
                  decoration: InputDecoration(labelText: appLocalizations.tags),
                ),
                const SizedBox(height: 16),
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
                  child: Text(appLocalizations.save),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(int index) {
    final appLocalizations = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appLocalizations.deleteProduct),
        content: Text('${appLocalizations.deleteConfirmation} ${_products[index].name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(appLocalizations.cancel)),
          TextButton(
            onPressed: () {
              setState(() {
                _products.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
            child: Text(
              appLocalizations.delete,
              style: const TextStyle(color: Colors.red)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.products),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  appLocalizations.products,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E603A),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _showAddProductSheet,
                  icon: const Icon(Icons.add),
                  label: Text(appLocalizations.addProduct),
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
                hintText: appLocalizations.searchProducts,
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
    final appLocalizations = AppLocalizations.of(context);
    
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
                  tooltip: appLocalizations.edit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                  color: Colors.red,
                  tooltip: appLocalizations.delete,
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
                  '${appLocalizations.stock}: $stock $unit',
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
