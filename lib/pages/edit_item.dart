import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/items.dart';
import 'package:fitness/services/database_service.dart';
import 'package:fitness/utils/helper.dart';
import 'package:fitness/utils/validation.dart';
import 'package:flutter/material.dart';


class EditItemPage extends StatefulWidget {
  final String itemId;
  final Item item;

  const EditItemPage({
    super.key, 
    required this.itemId,
    required this.item
    });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  late String _name;
  late int _quantity;
  late double _price;

   // Store original data for undo
  late String originalName;
  late int originalQuantity;
  late double originalPrice;

   void _checkConnectionAndUpdate() async {
    bool isConnected = await checkFirebaseConnection();

    if (!isConnected) {
      showConnectionDialog(context, _checkConnectionAndUpdate);
    } else {
      // Perform add item operation
      if (_formKey.currentState?.validate() ?? false) {
        _databaseService.updateItem(widget.itemId,Item(
          name: _name,
          quantity: _quantity,
          price: _price,
        ));
        Navigator.pop(context); 
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _name = widget.item.name;
    _quantity = widget.item.quantity;
    _price = widget.item.price;

    originalName = widget.item.name;
    originalQuantity = widget.item.quantity;
    originalPrice = widget.item.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(context),

    );
  }

    PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Edit Items",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            //Name
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Item Name'),
              validator: (value) => value == null || value.isEmpty? 'Please enter item name'
              : null,
            onSaved: (value) => _name=value!,
            ),

            // Quantity
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: validateQuantity,
                 onSaved: (value) => _quantity = int.parse(value!),
              ),
              // Price
              TextFormField(
                initialValue: _price.toString(), 
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: validatePrice,
                onSaved: (value) => _price = double.parse(value!),
              ),
              
              const SizedBox(height: 20),
              Row(
                children: [
                  
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.edit),
                      label: const Text("Update"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                      bool deleted = await showDeleteDialog(context, widget.itemId);
                        if (deleted) {
                          Navigator.pop(context); 
                        }
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ], 
        ),
      ),

    );
  }

void _submitForm() async {
  bool isConnected = await checkFirebaseConnection();
    if (!isConnected) {
      showConnectionDialog(context, _submitForm);
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final updatedItem = Item(
          name: _name,
          quantity: _quantity,
          price: _price,
          updatedAt: Timestamp.now(),
          isDeleted: false,
        );
 
        _databaseService.updateItem(widget.itemId, updatedItem);

        if (mounted) {
          showSuccessSnackBar(context, "Item updated successfully!", 
          onUndo: () async{
            final restoredItem = Item (
              name: originalName,
              quantity: originalQuantity,
              price: originalPrice,
              updatedAt: Timestamp.now(),
              isDeleted: false, 
              );

            await _databaseService.updateItem(widget.itemId, restoredItem);

            if(mounted){
              showSuccessSnackBar(context, "Undo successful!",  onUndo: () async {
                await _databaseService.restoreItem(widget.itemId);
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context);
              });
            }
          }
          );
      }
    }
  }
}
}