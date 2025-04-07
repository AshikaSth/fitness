import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/models/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String ITEMS_COLLECTION_REF = "items";
class DatabaseService{
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _itemsRef;

   DatabaseService(){
    _itemsRef = _firestore.collection(ITEMS_COLLECTION_REF).withConverter<Item>(fromFirestore: (snapshots, _) => Item.fromJson(snapshots.data()!,), toFirestore: (item, _) => item.toJson());
  }

  Stream<QuerySnapshot> getItems(){
    return _itemsRef.snapshots();
  }

  Future<DocumentReference> addItems(Item item) async {
  return await _itemsRef.add(item);
  }


  Future<void> updateItem(String itemId, Item item) async {
    await _itemsRef.doc(itemId).update(item.toJson());
  }


 
  Future <void> deleteItem(String itemId) async {
     try {
      await _itemsRef.doc(itemId).update({
        'is_deleted': true,
        'deleted_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle any errors that occur during the update operation
      print('Error marking item as deleted: $e');
    }
  }



  Future<void> restoreItem(String docId) async {
    try{
      await _itemsRef.doc(docId).update({
      'is_deleted': false,
      'deleted_at': null, 
      'updated_at': FieldValue.serverTimestamp(),
      });
    }catch (e) {
    print('Error restoring item: $e');
  }
}


}

Future<bool> checkFirebaseConnection() async {
  try {
    await FirebaseFirestore.instance
        .collection('connectivity_check')
        .doc('ping')
        .get();
    return true;
  } catch (e) {
    return false;
  }
}

void showConnectionDialog(BuildContext context, Function retryCallback) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: const Text("Connection Error"),
      content: const Text("Couldn't connect to the server at the moment. Please try again."),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            retryCallback(); // Retry the action that failed
          },
          child: const Text("Try Again"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 100), () {
              SystemNavigator.pop(); // Exit the app if needed
            });
          },
          child: const Text("Exit"),
        ),
      ],
    ),
  );
}

