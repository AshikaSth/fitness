import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/items.dart';
import 'package:fitness/pages/edit_item.dart';
import 'package:fitness/services/database_service.dart';
import 'package:fitness/utils/helper.dart';
import 'package:flutter/material.dart';

class ItemListView extends StatefulWidget {
  ItemListView({super.key});

  @override
  _ItemListViewState createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final DatabaseService _databaseService = DatabaseService(); 
  String? _selectedItemId;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: _itemListView(context)),
        ],
      ),
    );
  }

  Widget _itemListView(BuildContext context) {
    return StreamBuilder(
      stream: _databaseService.getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching items."));
        }

        List items = snapshot.data?.docs ?? [];

        items = items.where((item) => !item['is_deleted']).toList();

        items.sort((a, b) {
          final aItem = a.data();
          final bItem = b.data();

          final aDate = aItem.updatedAt ?? aItem.createdAt;
          final bDate = bItem.updatedAt ?? bItem.createdAt;

          final Timestamp aTimestamp = aDate is Timestamp ? aDate : Timestamp(0, 0);
          final Timestamp bTimestamp = bDate is Timestamp ? bDate : Timestamp(0, 0);

          return bTimestamp.compareTo(aTimestamp);
        });

        if (items.isEmpty) {
          return const Center(
            child: Text("There are no items in the inventory. Add an item!"),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {}); 
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              Item item = items[index].data();
              String itemId = items[index].id;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedItemId = (_selectedItemId == itemId) ? null : itemId;

                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemPage(
                          itemId: itemId,
                          item: item,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), 
                    ),
                    
                    color: _selectedItemId == itemId
                      ? Theme.of(context).colorScheme.secondaryContainer 
                      : Theme.of(context).colorScheme.primaryContainer,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10), 
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantity: ${item.quantity}"),
                          Text("Price: Rs.${item.price}"),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditItemPage(
                                  itemId: itemId,
                                  item: item,
                                ),
                              ),
                            );
                          } else if (value == 'delete') {
                            showDeleteDialog(context, itemId);
                          }
                        },
                        itemBuilder: (BuildContext context) => const [
                          PopupMenuItem(
                            value: 'edit',
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),

                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.purple, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w600),
                                ),
                              ]
                              
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 20), // Delete icon
                                SizedBox(width: 10),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.white, // Background color of the popup menu
                        elevation: 5,
                      ),
                      isThreeLine: true,
                    ),
                  ),
                )
              );
            },
          ),
        );
      },
    );
  }
}