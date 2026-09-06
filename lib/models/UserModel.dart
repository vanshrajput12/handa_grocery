 class UserModel {
  final String uid;
  final String email;
  final String name;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
  });

  factory UserModel.fromFirebaseUser(dynamic firebaseUser, {String? name}) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: name ?? firebaseUser.displayName ?? '',
    );
  }
}