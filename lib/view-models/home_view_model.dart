import 'package:flutter/material.dart';
import 'package:healthcare/view-models/physical_status_view_model.dart';
import 'package:healthcare/view-models/target_view_model.dart';
import 'package:healthcare/view-models/track_view_model.dart';
import 'package:healthcare/view-models/user_view_model.dart';
import 'package:provider/provider.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';
import 'addiction_track_view_model.dart';
import 'meal_plan_view_model.dart';
import 'medication_reminder_view_model.dart';

class HomeViewModel {
  Future<void> initizalize(BuildContext context) async {
    await NotificationService().initNotification();
    await FireBaseService().fetchData().then((data) {
      context.read<MedicationReminderViewModel>().getReminders(data);
      context.read<AddictionTrackViewModel>().getAddictionTracks(data);
      context.read<MealPlanViewModel>().getMealPlan(data);
      context.read<UserViewModel>().getUserModel(data);
      context.read<PhysicStatViewModel>().getPhysicStat(data);
      context.read<TrackViewModel>().getTracks(data);
      context.read<TargetViewModel>().getTargets(data);
    });
  }
}
