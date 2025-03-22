import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signUp(String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(
          uid: user.uid,
          email: email,
          displayName: displayName,
          role: 'player', // Default role; change to 'admin' for specific users
        );

        await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
        return userModel;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, user.uid);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<UserModel?> get currentUser {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, user.uid);
    });
  }
}