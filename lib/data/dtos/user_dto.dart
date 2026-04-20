import 'package:velo_toulouse_redesign/models/user.dart';

class UserDto {
  static const String nameKey = 'name';
  static const String genderKey = 'gender';
  static const String emailKey = 'email';
  static const String phoneNumberKey = 'phone_number';
  static const String imageUrlKey = 'image_url';

  static UserModel fromSnapshot(String key, dynamic value) {
    final data = Map<String, dynamic>.from(value as Map);

    return UserModel(
      id: key,
      name: data[nameKey]?.toString() ?? '',
      gender: data[genderKey]?.toString() ?? '',
      email: data[emailKey]?.toString() ?? '',
      phoneNumber: data[phoneNumberKey]?.toString() ?? '',
      imageUrl: data[imageUrlKey]?.toString() ?? '',
    );
  }

  static Map<String, dynamic> toMap(UserModel user) {
    return {
      nameKey: user.name,
      genderKey: user.gender,
      emailKey: user.email,
      phoneNumberKey: user.phoneNumber,
      imageUrlKey: user.imageUrl,
    };
  }
}
