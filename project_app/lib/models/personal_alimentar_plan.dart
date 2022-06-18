import 'package:project_app/models/pair.dart';

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

  factory AlimentarPlanDiary.fromJson(Map<String, dynamic> json) =>
      AlimentarPlanDiary(
        uid: json["uid"],
        day: json["day"],
        breakfast:
            List<Pair>.from(json["breakfast"].map((x) => Pair.fromJson(x))),
        lunch: List<Pair>.from(json["lunch"].map((x) => Pair.fromJson(x))),
        snack: List<Pair>.from(json["snack"].map((x) => Pair.fromJson(x))),
        dinner: List<Pair>.from(json["dinner"].map((x) => Pair.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "day": day,
        "breakfast": List<dynamic>.from(breakfast.map((x) => x.toJson())),
        "lunch": List<dynamic>.from(lunch.map((x) => x.toJson())),
        "snack": List<dynamic>.from(snack.map((x) => x.toJson())),
        "dinner": List<dynamic>.from(dinner.map((x) => x.toJson())),
      };
}
