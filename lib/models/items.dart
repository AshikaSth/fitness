import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String name;
  int quantity;
  double price;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  Timestamp? deletedAt;
  bool isDeleted;

  Item({
    required this.name,
    required this.quantity,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isDeleted = false,
  });

  
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0, 
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] as Timestamp?,  
      updatedAt: json['updated_at'] as Timestamp?,   
      deletedAt: json['deleted_at'] as Timestamp?,  
      isDeleted: json['is_deleted'] ?? false,
    );
  }

  /// Convert Dart object to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(), 
      'deleted_at': isDeleted ? (deletedAt ?? FieldValue.serverTimestamp()) : null,  //  Set deletedAt only when deleted
      'is_deleted': isDeleted,
    };
  }

  /// Create a copy of the object with modified values
  Item copyWith({
    String? name,
    int? quantity,
    double? price,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? deletedAt,
    bool? isDeleted,
  }) {
    return Item(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
