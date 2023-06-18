class UserModel1 {
  String dob;
  String add;
  String padd;
  String a1;
  String uid;

  UserModel1({
    required this.dob,
    required this.add,
    required this.padd,
    required this.a1,
    required this.uid,
  });

  // from map
  factory UserModel1.fromMap(Map<String, dynamic> map) {
    return UserModel1(
      dob: map['dob'] ?? '',
      add: map['add'] ?? '',
      padd: map['padd'] ?? '',
      a1: map['a1'] ?? '',
      uid: map['uid'] ?? '',
     );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "dob": dob,
      "add": add,
      "padd": padd,
      "a1": a1,
      "uid": uid,
    };
  }
}
