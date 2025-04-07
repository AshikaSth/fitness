import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/items.dart';
import 'package:fitness/services/database_service.dart';
import 'package:fitness/utils/item_list_view.dart';
import 'package:flutter/material.dart';
import 'package:fitness/utils/helper.dart';
import 'package:fitness/utils/validation.dart';



class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
    final _formKey = GlobalKey<FormState>();
    final DatabaseService _databaseService = DatabaseService();

    String _name ='';
     int _quantity=0;
    double _price= 0.0;

    void _checkConnectionAndAdd() async {
    bool isConnected = await checkFirebaseConnection();

    if (!isConnected) {
      showConnectionDialog(context, _checkConnectionAndAdd);
    } else {
      
      if (_formKey.currentState?.validate() ?? false) {
        _databaseService.addItems(Item(
          name: _name,
          quantity: _quantity,
          price: _price,
        ));
        Navigator.pop(context); // Close the page after adding the item
      }
    }
  }
    

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: _appBar(),
      body: Column(
      children: [
        Container(
          color: Colors.white, 
          child: _buildUI(context),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child:ItemListView(),
          ),
        ),
      ],
    ),
  );
}
  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Add Items",
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
              decoration: const InputDecoration(labelText: 'Item Name'),
              validator: (value) => value == null || value.isEmpty? 'Please enter item name'
              : null,
            onSaved: (value) => _name=value!.trim(),
            ),

            // Quantity
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: validateQuantity,
                onSaved: (value) => _quantity=int.tryParse(value!.trim())??0,

              ),
              // Price
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: validatePrice,
                onSaved: (value) => _price = double.parse(value!.trim()),
              ),
              
              const SizedBox(height: 20),
              Row(
                children: [
                  // Add Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      label: const Text("Add Item"),
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
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      
                      label: const Text("Cancel"),
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

  void _submitForm() async{
    bool isConnected = await checkFirebaseConnection();
    if (!isConnected) {
      showConnectionDialog(context, _submitForm);
    } else {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
          final newItem = Item(
            name: _name,
            quantity: _quantity,
            price: _price,
            createdAt: Timestamp.now(),
            isDeleted: false,
          );
          final docRef = await _databaseService.addItems(newItem);

          if (mounted){
            showSuccessSnackBar(
            context,
            "Item added successfully!",
            onUndo: () async {
              await _databaseService.deleteItem(docRef.id);
            },
          );
          }

          

          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
          });
        }
      }
    } 
}

