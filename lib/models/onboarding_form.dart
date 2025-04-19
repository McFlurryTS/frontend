import 'package:hive/hive.dart';

part 'onboarding_form.g.dart';

@HiveType(typeId: 3)
class OnboardingForm extends HiveObject {
  @HiveField(0)
  Map<String, dynamic> answers;

  @HiveField(1)
  DateTime? completedAt;

  OnboardingForm({required this.answers, this.completedAt});

  factory OnboardingForm.fromJson(Map<String, dynamic> json) {
    return OnboardingForm(
      answers: Map<String, dynamic>.from(json),
      completedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => answers;
}
