import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:communit_app/screens/home_screen.dart';  
import 'package:fluttertoast/fluttertoast.dart';
import '../services/firestore_service.dart';

import 'package:flutter/material.dart';
import '../services/firestore_service.dart'; // We'll create this for managing Firestore data
import '../models/user_request.dart'; // Define user request model

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserRequest> _userRequests = [];

  @override
  void initState() {
    super.initState();
    // Fetch user requests for admin to approve/reject
    _fetchUserRequests();
  }

  Future<void> _fetchUserRequests() async {
    List<UserRequest> userRequests = await _firestoreService.getUserRequests();
    setState(() {
      _userRequests = userRequests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: _userRequests.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _userRequests.length,
              itemBuilder: (context, index) {
                final request = _userRequests[index];
                return ListTile(
                  title: Text(request.userName),
                  subtitle: Text(request.status),
                  trailing: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () async {
                      // Approve the user request
                      await _firestoreService.approveUserRequest(request.id);
                      _fetchUserRequests();  // Refresh the request list
                    },
                  ),
                );
              },
            ),
    );
  }
}
