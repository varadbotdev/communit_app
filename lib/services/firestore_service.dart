import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_request.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all user requests that need approval
  Future<List<UserRequest>> getUserRequests() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('user_requests').get();
      return snapshot.docs.map((doc) {
        return UserRequest.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch user requests: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getAnnouncements() {
    return _firestore
        .collection('announcements')
        .orderBy('timestamp', descending: true) // Sort by timestamp
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  // Approve a user request
  Future<void> approveUserRequest(String requestId) async {
    try {
      await _firestore.collection('user_requests').doc(requestId).update({
        'status': 'approved',
      });
    } catch (e) {
      throw Exception("Failed to approve user request: $e");
    }
  }
}
