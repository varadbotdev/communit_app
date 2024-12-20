import 'package:cloud_firestore/cloud_firestore.dart';
class UserRequest {
  final String id;
  final String userName;
  final String status;

  UserRequest({required this.id, required this.userName, required this.status});

  // Factory method to create a UserRequest from Firestore document
  factory UserRequest.fromFirestore(DocumentSnapshot doc) {
    return UserRequest(
      id: doc.id,
      userName: doc['user_name'],
      status: doc['status'],
    );
  }
}
