import 'package:hive/hive.dart';
import 'package:proyek_akhir_tpm/model/coffee.dart';

part 'user.g.dart';


@HiveType(typeId: 0)
class User extends HiveObject {

  @HiveField(0)
  String? id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String birth;

  @HiveField(4)
  final String password;

  @HiveField(5)
  final List<Coffee> coffees;
  
  @HiveField(6)
   String? profilePicPath;

  User({
    required this.username,
    required this.email,
    required this.birth,
    required this.password,
    required this.coffees,
    required this.profilePicPath
  });

}