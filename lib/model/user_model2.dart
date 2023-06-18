class UserModel2 {
  String a2;
  String uid;

  UserModel2({
     required this.a2,
    required this.uid,
  });

  // from map
  factory UserModel2.fromMap(Map<String, dynamic> map) {
    return UserModel2(
      a2: map['a2'] ?? '',
      uid: map['uid'] ?? '',
     );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "a2": a2,
      "uid": uid,
    };
  }
}
