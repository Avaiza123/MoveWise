import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileVM extends GetxController {
  var name = "".obs;
  var email = "".obs;
  var weight = "".obs;
  var height = "".obs;
  var heightUnit = "".obs; // cm, ft, in
  var bmi = "".obs;

  var isEditing = false.obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ProfileVM();
  @override
  void onInit() {
    super.onInit();
    loadProfile(); // load cache + firestore on init
  }

  /// Load profile → Cache first, then Firestore
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();

      // ✅ Load cached values first
      weight.value = prefs.getString("weight") ?? "";
      height.value = prefs.getString("height") ?? "";
      heightUnit.value = prefs.getString("heightUnit") ?? "cm";
      bmi.value = prefs.getString("bmi") ?? "";
      name.value = prefs.getString("name") ?? "";
      email.value = prefs.getString("email") ?? "";

      // ✅ Then fetch from Firestore (if available)
      await _loadFromFirestore(prefs);
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Force refresh from Firestore (used when user clicks Profile)
  Future<void> refreshProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await _loadFromFirestore(prefs);
    } catch (e) {
      Get.snackbar("Error", "Failed to refresh profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Private helper → fetch Firestore + save to cache
  Future<void> _loadFromFirestore(SharedPreferences prefs) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection("users").doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        name.value = data?["name"] ?? "";
        email.value = data?["email"] ?? "";

        // save to cache
        prefs.setString("name", name.value);
        prefs.setString("email", email.value);

        final profile = data?["profile"];
        if (profile != null) {
          if ((profile["weight"] ?? "").toString().isNotEmpty) {
            weight.value = profile["weight"];
            prefs.setString("weight", weight.value);
          }
          if ((profile["height"] ?? "").toString().isNotEmpty) {
            height.value = profile["height"];
            prefs.setString("height", height.value);
          }
          if ((profile["heightUnit"] ?? "").toString().isNotEmpty) {
            heightUnit.value = profile["heightUnit"];
            prefs.setString("heightUnit", heightUnit.value);
          }
          if ((profile["bmi"] ?? "").toString().isNotEmpty) {
            bmi.value = profile["bmi"];
            prefs.setString("bmi", bmi.value);
          }
        }
      }
    }
  }

  /// Enable edit mode
  void enableEdit() {
    isEditing.value = true;
  }

  /// Cancel edit → reload from cache + Firestore
  void cancelEdit() {
    isEditing.value = false;
    loadProfile();
  }

  /// Save updates → Firestore + Cache
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": name.value,
          "email": user.email,
          "profile": {
            "weight": weight.value,
            "height": height.value,
            "heightUnit": heightUnit.value,
            "bmi": bmi.value,
          }
        }, SetOptions(merge: true));
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("name", name.value);
      await prefs.setString("email", email.value ?? "");
      await prefs.setString("weight", weight.value);
      await prefs.setString("height", height.value);
      await prefs.setString("heightUnit", heightUnit.value);
      await prefs.setString("bmi", bmi.value);

      isEditing.value = false;
      Get.snackbar("Success", "Profile updated!");
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
