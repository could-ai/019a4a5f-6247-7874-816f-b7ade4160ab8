import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cash_provider.dart';
import '../models/purchase.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Purchase? _editingPurchase;

  @override
  void dispose() {
    _itemNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _itemNameController.clear();
    _priceController.clear();
    _selectedDate = DateTime.now();
    _editingPurchase = null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<CashProvider>(context, listen: false);
      final itemName = _itemNameController.text.trim();
      final price = double.parse(_priceController.text);

      if (_editingPurchase != null) {
        provider.updatePurchase(_editingPurchase!.id, itemName, price, _selectedDate);
      } else {
        provider.addPurchase(itemName, price, _selectedDate);
      }

      _clearForm();
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showPurchaseDialog([Purchase? purchase]) {
    if (purchase != null) {
      _editingPurchase = purchase;
      _itemNameController.text = purchase.itemName;
      _priceController.text = purchase.price.toString();
      _selectedDate = purchase.date;
    } else {
      _clearForm();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingPurchase != null ? 'Edit Purchase' : 'Add Purchase'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price (RM)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  final price = double.tryParse(value!);
                  if (price == null || price <= 0) return 'Invalid price';
                  return null;
                },
              ),
              ListTile(
                title: Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(_editingPurchase != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CashProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
      ),
      body: provider.purchases.isEmpty
          ? const Center(child: Text('No purchases recorded yet.'))
          : ListView.builder(
              itemCount: provider.purchases.length,
              itemBuilder: (context, index) {
                final purchase = provider.purchases[index];
                return ListTile(
                  title: Text(purchase.itemName),
                  subtitle: Text('RM ${purchase.price.toStringAsFixed(2)} - ${purchase.date.toLocal().toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showPurchaseDialog(purchase),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(purchase),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPurchaseDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(Purchase purchase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Purchase'),
        content: Text('Are you sure you want to delete purchase of ${purchase.itemName} for RM ${purchase.price.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CashProvider>(context, listen: false).deletePurchase(purchase.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
