class ActivityType {
  String? id;
  String? name;
  String? type;
  String? description;
  String? image;

  ActivityType({this.id, this.name, this.image, this.type, this.description});

  ActivityType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? null;
    data['name'] = this.name ?? null;
    data['image'] = this.image ?? null;
    data['name'] = this.name ?? null;
    data['description'] = this.description ?? null;
    return data;
  }
}
