import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_app/models/personal_alimentar_plan.dart';
import 'package:project_app/variables/global_variables.dart' as globals;

//Alimentar Plan Functions
Future<void> updateAlimentarPlan(
    AlimentarPlanDiary dailyPlan, String day) async {
  var coll = await FirebaseFirestore.instance
      .collection("alimentarPlans")
      .where("uid", isEqualTo: globals.uidUser)
      .where("day", isEqualTo: day)
      .get();
  var id = coll.docs.first.id;
  FirebaseFirestore.instance
      .collection("alimentarPlans")
      .doc(id)
      .set(dailyPlan.toJson());
}
