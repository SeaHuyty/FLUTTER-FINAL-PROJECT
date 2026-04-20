import 'package:velo_toulouse_redesign/models/pass.dart';

class PassDto {
  static const String title = 'title';
  static const String price = 'price';
  static const String duration = 'duration';

  static PassModel fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    return PassModel(
      id: key,
      title: data[title] as String,
      price: data[price] as double,
      duration: data[duration] as String,
    );
  }  
}