import 'package:dreams/const/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

class Validators {
  static String? email(String? s) =>
      RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
              .hasMatch(s!)
          ? null
          : LocaleKeys.incorrectValidator.tr(args: [LocaleKeys.email.tr()]);

  static String? generalValidator(String? s) => s!.isEmpty
      ? LocaleKeys.generalValidator.tr(args: [LocaleKeys.email.tr()])
      : null;
  static String? phone(String? s) => s!.isEmpty
      ? LocaleKeys.incorrectValidator.tr(args: [LocaleKeys.phone.tr()])
      : null;
  static String? name(String? s) => s!.isEmpty
      ? LocaleKeys.incorrectValidator.tr(args: [LocaleKeys.name.tr()])
      : null;
  static String? birthdate(String? s) => s!.isEmpty
      ? LocaleKeys.incorrectValidator.tr(args: [LocaleKeys.birthdate.tr()])
      : null;

  static String? job(String? s) => s!.isEmpty
      ? LocaleKeys.incorrectValidator.tr(args: [LocaleKeys.yourJob.tr()])
      : null;
  static String? passowrd(String? s) =>
      s!.isEmpty ? LocaleKeys.passwordValidator.tr() : null;
  static String? passConfirmowrd(String? old, String? newP) =>
      old != newP ? LocaleKeys.passConfirValidator.tr() : null;

  static String? country<T>(T? s) => s == null
      ? LocaleKeys.chooseValidator.tr(args: [LocaleKeys.country.tr()])
      : null;
  static String? city<T>(T? s) => s == null
      ? LocaleKeys.chooseValidator.tr(args: [LocaleKeys.city.tr()])
      : null;
}
