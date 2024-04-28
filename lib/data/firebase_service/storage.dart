import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:martialartconnect/data/message_model.dart';
import 'package:martialartconnect/utils/exception.dart';
import 'package:uuid/uuid.dart';


class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var uid = Uuid().v4();

  Future<String> uploadImageToStorage(String name, File file) async {
    Reference ref =
        _storage.ref().child(name).child(_auth.currentUser!.uid).child(uid);

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateImageToStorage( String URL, File file) async {
    Reference ref =
      _storage.refFromURL(URL);

      try {
        await ref.putFile(File(file.path));

        
      } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }

      
  }
}