import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/features/account/ui/about_us.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);
  final String ar =
      '''بموافقتك على شروط الخصوصية فإنك توافق صراحة على استخدام هذا  التطبيق على مسؤوليتك وتتحمل جميع المخاطر المترتبة على ذلك. و توافق علي أن موقعنا أو أي من أعضاء مجلس إدارتها أو موظفيها أو وكلائها أو الأشخاص الذين يوفرون المادة الموجودة في هذا التطبيق أو الذين يرخصون لموقعنا باستعمالها أو أي منهم لا يقدم أي ضمانات على أن الخدمة الموجودة في هذا التطبيق ستكون دون انقطاع أو خالية من الأخطاء. أو أن أي عيوب قد توجد فيها سوف تصحح. أو أن التطبيق الذي تقدم فيه أو وسيلة تقديمها خاليان من الفيروسات أو آفات البرامج.'''
      '''\n'''
      '''مشاكل البق و البرمجيات'''
      '''\n'''
      '''نحاول دائماً إصلاح المشكلات و تحسين البرامج ، و لكن نظراً لتشتت الأجهزة و إصدارات مختلفة من أندرويد ، قد يكون أداء البرنامج علي بعض الأجهزة أو الإصدارات مصحوباً بأخطاء و مشكلات ، و نعتذر عن ذلك.'''
      '''\n'''
      '''نحن نسعى بكل مجهوداتنا إلى توفير مادة صحيحة و من طرف أشخاص أكفاء والسهر على حماية كل البيانات واحترام الأشخاص والمحافظة على الآداب العامة ونقوم بحجب أي مواد أو تعليقات مسيئة للأشخاص أو أي طرف كان وحجب القائم بها. لكن لا نتحمل مسؤولية سوء استخدام التطبيق من طرف المستخدم.'''
      '''\n'''
      '''يحتفظ موقعنا ببيانات المشتركين في عضويته على أجهزة تشغيل وقواعد بيانات  ونظم حماية ذات كفاءة عالية وإنك توافق على أن التطبيق يحتفظ ببياناتك الشخصية واستخدامها من قبل أقسامه المعنية. و إنك توافق على عدم إعطاء هذه البيانات لأي مؤسسات أو شركات تجارية او غير تجارية إلا بعد موافقة صريحة منك. و إنك توافق علي أن التطبيق لا يتحمل مسؤولية تسرب جزء أو كل بيانات''';

  final String en =
      '''By agreeing to the Privacy Terms, you expressly agree to use this app at your own risk and responsibility. And you agree that our site or any of its directors, employees, agents or persons who provide the material on this site or who license our site to use or any of them does not make any guarantee that the service on this site will be uninterrupted or error-free . or that any defects that may exist in it will be corrected. or that the site on which it is provided or the means for providing it is free of viruses or software bugs'''
      '''\n'''
      '''Bugs and software problems'''
      '''\n'''
      '''We always try to fix problems and improve programs, but due to the dispersion of devices and different versions of Android, the performance of the program on some devices or versions may be accompanied by errors and problems, and we apologize for that'''
      '''\n'''
      ''''We strive with all our efforts to provide correct material and by competent people and to ensure the protection of all data, respect for people and maintain public morals, and we block any material or comments offensive to persons or any party and block the author. However, we are not responsible for the misuse of the app by the user'''
      '''\n'''
      '''Our app maintains the data of its subscribers on highly efficient operating devices, databases and security systems, and you agree that the site retains your personal data and its use by its respective departments. And you agree not to give this data to any commercial or non-commercial institutions or companies without your express consent. And you agree that the site is not responsible for the leakage of part or all of the subscriber's member data due to theft and sabotage carried out by attackers and hackers on the Internet. And that the site or any of its officials is not responsible for the damage or loss of this data for any reason. And you agree to enter it into the site without any restrictions''';
  @override
  Widget build(BuildContext context) {
    return AboutUsScreen(
      title: LocaleKeys.privacyPolicy,
      aboutUs: (context.isAr ? ar : en).split('\n'),
    );
  }
}
