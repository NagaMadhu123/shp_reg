class UserModel6 {
  String itemName;
  String itemCost;
  String itemCat;
  String weight;
  String nop;
  String itemImage;
  String uid; 
  String date;

  UserModel6({
    required this.itemName,
    required this.itemCost,
    required this.itemCat,
    required this.itemImage,
    required this.uid,
    required this.nop,
    required this.weight,
    required this.date,
  });

  // from map
  factory UserModel6.fromMap(Map<String, dynamic> map) {
    return UserModel6(
      itemName: map['itemName'] ?? '',
      itemCat: map['itemCat'] ?? '',
      itemCost: map['itemCost'] ?? '',
      itemImage:map['itemImage'] ?? '',
      uid: map['uid'] ?? '',
      weight:map['weight'] ?? '',
      nop: map['nop'] ?? '',
      date: map['date']?? '',
     );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "itemName": itemName,
      "itemCost": itemCost,
      "itemCat":itemCat,
      "itemImage":itemImage,
      "uid":uid,
      "weight":weight,
      "nop":nop,
      "date":date,
    };
  }
}
