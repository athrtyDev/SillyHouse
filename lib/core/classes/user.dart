import 'dart:io';

class User {
  String id;
  String name;
  String password;
  int age;
  String email;
  String gender;
  String profile_pic;
  String registeredDate;
  String type; // null=normal, teacher=online zuwluh bagsh
  // tuslah
  int postTotal;
  int skillTotal;
  int likeTotal;
  File profileFile;

  User(
      {this.id,
      this.name,
      this.password,
      this.age,
      this.email,
      this.gender,
      this.profile_pic,
      this.registeredDate,
      this.postTotal,
      this.likeTotal,
      this.skillTotal,
      this.type});

  User.initial()
      : id = null,
        name = '',
        password = '',
        profile_pic = null,
        age = 0,
        email = null,
        gender = "",
        type = null,
        registeredDate = null;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    password = json['password'];
    age = json['age'];
    email = json['email'];
    gender = json['gender'];
    profile_pic = json['profile_pic'];
    registeredDate = json['registeredDate'].toString();
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? null;
    data['name'] = this.name ?? '';
    data['password'] = this.password ?? null;
    data['age'] = this.age ?? 0;
    data['email'] = this.email ?? null;
    data['gender'] = this.gender ?? "";
    data['profile_pic'] = this.profile_pic ?? null;
    data['registeredDate'] = this.registeredDate ?? null;
    data['type'] = this.type ?? '';
    return data;
  }
}
