import 'package:project_app/screens/alimentar_plan.dart';

class AlimentarPlanDiary {
  AlimentarPlanDiary(
      {required this.uid,
      required this.day,
      required this.breakfast,
      required this.lunch,
      required this.snack,
      required this.dinner});

  String uid;
  String day;
  List<Pair> breakfast;
  List<Pair> lunch;
  List<Pair> snack;
  List<Pair> dinner;

  //TODO: double check the implementation
  factory AlimentarPlanDiary.fromJson(Map<String, dynamic> json) =>
      AlimentarPlanDiary(
        uid: json["uid"],
        day: json["day"],
        breakfast: List<Pair>.from(json["breakfast"].map((x) => x)),
        lunch: List<Pair>.from(json["lunch"].map((x) => x)),
        snack: List<Pair>.from(json["snack"].map((x) => x)),
        dinner: List<Pair>.from(json["dinner"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "day": day,
        "breakfast": List<Pair>.from(breakfast.map((x) => x)),
        "lunch": List<Pair>.from(lunch.map((x) => x)),
        "snack": List<Pair>.from(snack.map((x) => x)),
        "dinner": List<Pair>.from(dinner.map((x) => x)),
      };
}
