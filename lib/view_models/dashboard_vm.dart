import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:movewise/view_models/plan_vm.dart';
import '../../services/local_storage_service.dart';

class DashboardVM extends GetxController {
  final LocalStorageService _local = LocalStorageService();
  final PlanVM planVM = Get.put(PlanVM(), permanent: true);

  var highestCompletedDay = 0.obs; // integer: highest day the user completed (0..30)
  var loading = false.obs;
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  var selectedPlanIndex = 0.obs;


  @override
  void onInit() {
    super.onInit();
    _loadProgress();
    planVM.loadPlansForUser(currentUserUid); // your UID he
  }

  Future<void> _loadProgress() async {
    loading.value = true;
    final d = await _local.getHighestDayCompleted();
    highestCompletedDay.value = d;
    loading.value = false;
  }
  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }
  Future<void> markDayAsCompleted(int day) async {
    // allow only sequential marking:
    // e.g., if highestCompletedDay == 0, user can mark day 1 as completed only
    if (day == highestCompletedDay.value + 1) {
      highestCompletedDay.value = day;
      await _local.setHighestDayCompleted(day);
      final iso = DateTime.now().toIso8601String();
      await _local.setLastCompletedDate(iso);
    } else {
      // NO-OP or show message: must complete previous day(s) first
    }
  }
}
