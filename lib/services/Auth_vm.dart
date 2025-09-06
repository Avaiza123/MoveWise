import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthVM extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Ensure Firestore doc exists
      await _createUserDocIfNotExists(cred.user);

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Unknown error");
    }
  }

  Future<void> signup(String email, String password, String name) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Create Firestore user doc on signup
      await _firestore.collection("users").doc(cred.user!.uid).set({
        "uid": cred.user!.uid,
        "email": email,
        "name": name,
        "createdAt": FieldValue.serverTimestamp(),
      });

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Error", e.message ?? "Unknown error");
    }
  }

  Future<void> _createUserDocIfNotExists(User? user) async {
    if (user == null) return;

    DocumentReference userDoc = _firestore.collection("users").doc(user.uid);
    DocumentSnapshot docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
