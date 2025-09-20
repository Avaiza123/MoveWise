import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProfileVM extends GetxController {
  var name = "".obs;
  var email = "".obs;
  var weight = "".obs; // Stored/displayed as string for UI
  var weightUnit = "kg".obs;
  var height = "".obs; // Stored/displayed as string for UI
  var heightUnit = "cm".obs;
  var bmi = "".obs;
  var gender = "".obs;
  var goals = <String>[].obs;
  var dietPreferences = <String>[].obs;
  var error = "".obs;
  var createdAt = "".obs;
  var lastLogin = "".obs;
  var updatedAt = "".obs;

  var isEditing = false.obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  /// Load profile from Firestore
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        error.value = "User not logged in.";
        return;
      }

      final doc = await _firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        final data = doc.data() ?? {};

        // root-level fields
        email.value = data["email"] ?? _auth.currentUser?.email ?? "";
        name.value = data["name"] ?? "";

        createdAt.value = _formatDate(data["createdAt"]);
        lastLogin.value = _formatDate(data["lastLogin"]);
        updatedAt.value = _formatDate(data["updatedAt"]);

        // ✅ nested profile map
        final profile = data["profile"] as Map<String, dynamic>?;

        if (profile != null) {
          weight.value = profile["weight"]?.toString() ?? "";
          weightUnit.value = profile["weightUnit"] ?? "kg";
          height.value = profile["height"]?.toString() ?? "";
          heightUnit.value = profile["heightUnit"] ?? "cm";
          bmi.value = profile["bmi"]?.toString() ?? "";
          gender.value = profile["gender"] ?? "";

          goals.assignAll(List<String>.from(profile["goals"] ?? []));
          dietPreferences.assignAll(List<String>.from(profile["diet_preferences"] ?? []));
        }

        _calculateBMI();
      } else {
        error.value = "Profile not found.";
      }
    } catch (e) {
      error.value = "Failed to load profile: $e";
    } finally {
      isLoading.value = false;
    }
  }



  /// Format Firestore timestamp
  String _formatDate(Timestamp? ts) {
    if (ts == null) return "-";
    return DateFormat("dd MMM yyyy, hh:mm a").format(ts.toDate());
  }

  /// Fetch Firestore data safely
  Future<void> _loadFromFirestore(SharedPreferences prefs) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();

        name.value = data?["name"] ?? "";
        email.value = data?["email"] ?? "";

        createdAt.value = _formatDate(data?["createdAt"]);
        lastLogin.value = _formatDate(data?["lastLogin"]);
        updatedAt.value = _formatDate(data?["updatedAt"]);

        final profile = data?["profile"];
        if (profile != null) {
          // ✅ Convert everything to String for UI
          weight.value = (profile["weight"] ?? "").toString();
          weightUnit.value = profile["weightUnit"] ?? "kg";
          height.value = (profile["height"] ?? "").toString();
          heightUnit.value = profile["heightUnit"] ?? "cm";
          gender.value = profile["gender"] ?? "";

          goals.assignAll(List<String>.from(profile["goals"] ?? []));
          dietPreferences.assignAll(List<String>.from(profile["diet_preferences"] ?? []));
        }

        _calculateBMI();

        // Save locally
        await prefs.setString("name", name.value);
        await prefs.setString("email", email.value);
        await prefs.setString("weight", weight.value);
        await prefs.setString("weightUnit", weightUnit.value);
        await prefs.setString("height", height.value);
        await prefs.setString("heightUnit", heightUnit.value);
        await prefs.setString("bmi", bmi.value);
        await prefs.setString("gender", gender.value);
      }
    }
  }

  /// Calculate BMI
  void _calculateBMI() {
    final w = double.tryParse(weight.value) ?? 0;
    final h = double.tryParse(height.value) ?? 0;
    final hMeters = heightUnit.value == "cm" ? h / 100 : h;

    if (w > 0 && hMeters > 0) {
      final bmiVal = w / (hMeters * hMeters);
      bmi.value = bmiVal.toStringAsFixed(1);
    }
  }

  /// Enable edit mode
  void enableEdit() => isEditing.value = true;

  /// Cancel edit mode
  Future<void> cancelEdit() async {
    isEditing.value = false;
    await loadProfile();
  }

  /// Save profile to Firestore
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      _calculateBMI();

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": name.value,   // ✅ save username
          "email": email.value,
          "updatedAt": FieldValue.serverTimestamp(),
          "profile": {
            "weight": double.tryParse(weight.value) ?? 0.0,
            "weightUnit": weightUnit.value,
            "height": height.value, // string "5'4\"" is fine
            "heightUnit": heightUnit.value,
            "bmi": bmi.value,
            "gender": gender.value,
            "goals": goals.toList(),
            "diet_preferences": dietPreferences.toList(),
          }
        }, SetOptions(merge: true));
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", name.value);
      await prefs.setString("email", email.value);
      await prefs.setString("weight", weight.value);
      await prefs.setString("weightUnit", weightUnit.value);
      await prefs.setString("height", height.value);
      await prefs.setString("heightUnit", heightUnit.value);
      await prefs.setString("bmi", bmi.value);
      await prefs.setString("gender", gender.value);

      isEditing.value = false;
      Get.snackbar("Success", "Profile updated!");
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
