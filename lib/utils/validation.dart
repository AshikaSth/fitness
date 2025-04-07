String? validatePrice(String? value){
  if (value==null || value.trim().isEmpty){
    return 'Price is required';
  }
  final parsed = double.tryParse(value);
  if(parsed == null){
    return 'Enter a valid number';
  }

    if (parsed <= 0){
      return 'Price must be greater than zero';
    }
  
  return null;
}

String? validateQuantity(String? value){
  if (value==null || value.trim().isEmpty){
    return 'Quantity is required';
  }
  final parsed = int.tryParse(value);
  if(parsed == null){
    return 'Enter a valid whole number';
  }

    if (parsed <= 0){
      return 'Quantity must be greater than zero';
    }
  
  return null;
}