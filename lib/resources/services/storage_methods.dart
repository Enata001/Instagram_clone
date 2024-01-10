import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      {required String childName,
      required Uint8List file,
      bool isPost = false}) async {
    var ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    var upload = await ref.putData(file);
    var downloadUrl = await upload.ref.getDownloadURL();

    return downloadUrl;
  }
}
