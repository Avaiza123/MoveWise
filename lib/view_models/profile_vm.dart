// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // ✅ for formatting timestamps
//
// class ProfileVM extends GetxController {
//   // Core fields
//   var name = "".obs;
//   var email = "".obs;
//   var uid = "".obs;
//
//   // Profile details
//   var weight = "".obs;
//   var weightUnit = "".obs;
//   var height = "".obs;
//   var heightUnit = "".obs;
//   var bmi = "".obs;
//   var gender = "".obs;
//
//   // Lists
//   var goals = <String>[].obs;
//   var dietPreferences = <String>[].obs;
//
//   // Timestamps (formatted)
//   var createdAt = "".obs;
//   var lastLogin = "".obs;
//   var updatedAt = "".obs;
//
//   var isEditing = false.obs;
//   var isLoading = false.obs;
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadProfile();
//   }
//
//   Future<void> loadProfile() async {
//     try {
//       isLoading.value = true;
//       final prefs = await SharedPreferences.getInstance();
//
//       // ✅ Load cached values first (basic fields only)
//       name.value = prefs.getString("name") ?? "";
//       email.value = prefs.getString("email") ?? "";
//       weight.value = prefs.getString("weight") ?? "";
//       height.value = prefs.getString("height") ?? "";
//       heightUnit.value = prefs.getString("heightUnit") ?? "cm";
//       bmi.value = prefs.getString("bmi") ?? "";
//
//       // ✅ Load Firestore data
//       await _loadFromFirestore(prefs);
//     } catch (e) {
//       Get.snackbar("Error", "Failed to load profile: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> _loadFromFirestore(SharedPreferences prefs) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final userDoc = await _firestore.collection("users").doc(user.uid).get();
//       if (userDoc.exists) {
//         final data = userDoc.data();
//
//         // Core
//         name.value = data?["name"] ?? "";
//         email.value = data?["email"] ?? "";
//         uid.value = data?["uid"] ?? user.uid;
//
//         prefs.setString("name", name.value);
//         prefs.setString("email", email.value);
//
//         // Profile map
//         final profile = data?["profile"];
//         if (profile != null) {
//           weight.value = profile["weight"].toString();
//           weightUnit.value = profile["weightUnit"] ?? "";
//           height.value = profile["height"].toString();
//           heightUnit.value = profile["heightUnit"] ?? "";
//           bmi.value = profile["bmi"].toString();
//           gender.value = profile["gender"] ?? "";
//           goals.value = List<String>.from(profile["goals"] ?? []);
//           dietPreferences.value =
//           List<String>.from(profile["diet_preferences"] ?? []);
//
//           prefs.setString("weight", weight.value);
//           prefs.setString("height", height.value);
//           prefs.setString("heightUnit", heightUnit.value);
//           prefs.setString("bmi", bmi.value);
//         }
//
//         // ✅ Format timestamps
//         createdAt.value = _formatTimestamp(data?["createdAt"]);
//         lastLogin.value = _formatTimestamp(data?["lastLogin"]);
//         updatedAt.value = _formatTimestamp(data?["updatedAt"]);
//       }
//     }
//   }
//
//   String _formatTimestamp(dynamic ts) {
//     if (ts is Timestamp) {
//       return DateFormat("d MMMM yyyy 'at' HH:mm:ss 'UTC+5'")
//           .format(ts.toDate().toUtc().add(const Duration(hours: 5)));
//     }
//     return "";
//   }
//
//   void enableEdit() => isEditing.value = true;
//
//   void cancelEdit() {
//     isEditing.value = false;
//     loadProfile();
//   }
//
//   Future<void> saveProfile() async {
//     try {
//       isLoading.value = true;
//       final user = _auth.currentUser;
//
//       if (user != null) {
//         await _firestore.collection("users").doc(user.uid).set({
//           "name": name.value,
//           "email": email.value,
//           "uid": user.uid,
//           "updatedAt": FieldValue.serverTimestamp(),
//           "profile": {
//             "weight": double.tryParse(weight.value) ?? weight.value,
//             "weightUnit": weightUnit.value,
//             "height": height.value,
//             "heightUnit": heightUnit.value,
//             "bmi": bmi.value,
//             "gender": gender.value,
//             "goals": goals,
//             "diet_preferences": dietPreferences,
//           }
//         }, SetOptions(merge: true));
//       }
//
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString("name", name.value);
//       await prefs.setString("email", email.value);
//       await prefs.setString("weight", weight.value);
//       await prefs.setString("height", height.value);
//       await prefs.setString("heightUnit", heightUnit.value);
//       await prefs.setString("bmi", bmi.value);
//
//       isEditing.value = false;
//       Get.snackbar("Success", "Profile updated!");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to save profile: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class ProfileVM extends GetxController {
  var name = "".obs;
  var email = "".obs;
  var weight = "".obs;
  var weightUnit = "".obs;
  var height = "".obs;
  var heightUnit = "".obs;
  var bmi = "".obs;
  var gender = "".obs;
  var goals = <String>[].obs;
  var dietPreferences = <String>[].obs;

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

  /// Load profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      await _loadFromFirestore(prefs);
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Format timestamp
  String _formatDate(Timestamp? ts) {
    if (ts == null) return "-";
    return DateFormat("dd MMM yyyy, hh:mm a").format(ts.toDate());
  }

  /// Get data from Firestore
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
          weight.value = profile["weight"]?.toString() ?? "";
          weightUnit.value = profile["weightUnit"]?.toString() ?? "";
          height.value = profile["height"]?.toString() ?? "";
          heightUnit.value = profile["heightUnit"]?.toString() ?? "cm";
          bmi.value = profile["bmi"]?.toString() ?? "";
          gender.value = profile["gender"]?.toString() ?? "";

          goals.assignAll(List<String>.from(profile["goals"] ?? []));
          dietPreferences.assignAll(List<String>.from(profile["diet_preferences"] ?? []));
        }

        prefs.setString("name", name.value);
        prefs.setString("email", email.value);
      }
    }
  }

  /// Enable edit mode
  void enableEdit() => isEditing.value = true;

  /// Cancel edit mode
  void cancelEdit() => isEditing.value = false;

  /// Save profile back to Firestore
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "name": name.value,
          "email": email.value,
          "updatedAt": FieldValue.serverTimestamp(),
          "profile": {
            "weight": weight.value,
            "weightUnit": weightUnit.value,
            "height": height.value,
            "heightUnit": heightUnit.value,
            "bmi": bmi.value,
            "gender": gender.value,
            "goals": goals,
            "diet_preferences": dietPreferences,
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

      isEditing.value = false;
      Get.snackbar("Success", "Profile updated!");
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
