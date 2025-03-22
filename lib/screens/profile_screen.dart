import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netclash/services/auth_service.dart';
import 'package:netclash/services/storage_service.dart';
import 'package:netclash/models/user_model.dart';
import 'package:netclash/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _image;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(String userId) async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    final photoUrl = await _storageService.uploadProfileImage(userId, _image!);
    if (photoUrl != null) {
      await _firestore.collection('users').doc(userId).update({'photoUrl': photoUrl});
    }

    setState(() {
      _isUploading = false;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _authService.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('User not found.'));
        }

        final user = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: Padding(
            padding: const EdgeInsets.all(AppSizes.padding),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: AppSizes.avatarRadius,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (user.photoUrl != null
                              ? NetworkImage(user.photoUrl!)
                              : null) as ImageProvider?,
                      child: user.photoUrl == null && _image == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    if (_isUploading)
                      const Positioned.fill(
                        child: Center(
                          child: SpinKitFadingCircle(
                            color: AppColors.primaryColor,
                            size: 50.0,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSizes.padding),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                if (_image != null)
                  ElevatedButton(
                    onPressed: () => _uploadImage(user.uid),
                    child: const Text('Upload Image'),
                  ),
                const SizedBox(height: AppSizes.padding),
                Text('Name: ${user.displayName}', style: const TextStyle(fontSize: 20)),
                Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: AppSizes.padding),
                ElevatedButton(
                  onPressed: () async {
                    await _authService.signOut();
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}