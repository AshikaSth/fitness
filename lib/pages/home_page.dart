import 'package:fitness/pages/add_item.dart';
import 'package:fitness/utils/item_list_view.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {

  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{


  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context){
        return Scaffold(
          appBar: _appBar(),
          body: ItemListView(),
          floatingActionButton: _floatingActionButton(),
        );
  }

  PreferredSizeWidget _appBar(){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Inventory List",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return SizedBox(
      width: 120,  
      height: 56, 
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 24, color: Colors.white,), 
              SizedBox(width: 8), 
              Text(
                "Add Item",
                style: TextStyle(fontSize: 16, color: Colors.white,), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}