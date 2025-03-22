import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadProfileImage(String userId, File image) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}