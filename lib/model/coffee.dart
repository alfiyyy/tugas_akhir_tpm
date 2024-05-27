import 'package:hive/hive.dart';

part 'coffee.g.dart';

@HiveType(typeId: 1)
class Coffee {
  @HiveField(0)
  String? sId;

  @HiveField(1)
  int? id;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? description;

  @HiveField(4)
  double? price;

  @HiveField(5)
  String? region;

  @HiveField(6)
  int? weight;

  @HiveField(7)
  List<String>? flavorProfile;

  @HiveField(8)
  List<String>? grindOption;

  @HiveField(9)
  int? roastLevel;

  @HiveField(10)
  String? imageUrl;

  Coffee({
    this.sId,
    this.id,
    this.name,
    this.description,
    this.price,
    this.region,
    this.weight,
    this.flavorProfile,
    this.grindOption,
    this.roastLevel,
    this.imageUrl,
  });

  Coffee.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    region = json['region'];
    weight = json['weight'];
    flavorProfile = json['flavor_profile'].cast<String>();
    grindOption = json['grind_option'].cast<String>();
    roastLevel = json['roast_level'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['region'] = this.region;
    data['weight'] = this.weight;
    data['flavor_profile'] = this.flavorProfile;
    data['grind_option'] = this.grindOption;
    data['roast_level'] = this.roastLevel;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
