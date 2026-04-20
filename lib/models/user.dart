class UserModel {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String phoneNumber;
  final String? password;
  final String imageUrl;
  final String? activePassId;
  final String? activePassTitle;
  final String? activePassExpiry;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    this.password,
    required this.imageUrl,
    this.activePassId,
    this.activePassTitle,
    this.activePassExpiry,
  });

  UserModel copyWith({
    String? name,
    String? gender,
    String? phoneNumber,
    String? imageUrl,
    String? activePassId,
    String? activePassTitle,
    String? activePassExpiry,
    bool clearActivePass = false,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      activePassId: clearActivePass ? null : (activePassId ?? this.activePassId),
      activePassTitle: clearActivePass ? null : (activePassTitle ?? this.activePassTitle),
      activePassExpiry: clearActivePass ? null : (activePassExpiry ?? this.activePassExpiry),
    );
  }
}
