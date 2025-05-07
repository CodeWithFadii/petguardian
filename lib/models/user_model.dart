import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/constants/constants.dart';

class UserModel {
  final String? id;
  final String? email;
  final String? createdAt;
  final String? name;
  final List<String> blocks;
  final String password;
  final UserType? userType;
  final String? img;
  final bool? isPaid;
  final DateTime? planEndDate;

  UserModel({
    this.id = '',
    this.email = 'guest@example.com',
    this.createdAt = '',
    this.name = '',
    this.blocks = const [],
    this.password = '',
    this.planEndDate,
    this.isPaid = false,
    this.userType = UserType.email,
    this.img,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'password': password,
      'name': name,
      'blocks': blocks,
      'userType': userType?.name,
      'isPaid': isPaid,
      'planEndDate': planEndDate != null ? Timestamp.fromDate(planEndDate!) : null,
      'img': img,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? 'guest@example.com',
      name: data['name'] ?? 'xyzUser',
      blocks: List<String>.from(data['blocks'] ?? []),
      password: data['password'] ?? 'defaultPassword123',
      userType: UserType.values.firstWhere((e) => e.name == data['userType'], orElse: () => UserType.email),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? '',
      isPaid: data['isPaid'] ?? false,
      planEndDate: data['planEndDate'] != null ? (data['planEndDate'] as Timestamp).toDate() : null,
      img: data['img'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? createdAt,
    String? name,
    List<String>? blocks,
    String? password,
    UserType? userType,
    bool? isPaid,
    DateTime? planEndDate,
    String? img,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      blocks: blocks ?? this.blocks,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      isPaid: isPaid ?? this.isPaid,
      planEndDate: planEndDate ?? this.planEndDate,
      img: img ?? this.img,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, createdAt: $createdAt, name: $name, blocks: $blocks, password: $password, userType: $userType, isPaid: $isPaid, planEndDate: $planEndDate, img: $img)';
  }
}
