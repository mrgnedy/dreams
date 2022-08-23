// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dreams/const/locale_keys.dart';
import 'package:dreams/const/resource.dart';
import 'package:dreams/helperWidgets/main_scaffold.dart';

class AboutUsScreen extends StatelessWidget {
  final List<String>? aboutUs;
  final String? title;
  const AboutUsScreen({
    Key? key,
    this.aboutUs,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<String> aboutUs = this.aboutUs ??
        '''تطبيق أذكاري و رؤياي'''
                '''\n'''
                '''يمكنك تصفح الأذكار والأدعية اليومية في الصباح و المساء و التعاملات التي تفيد كل مسلم '''
                '''ويمكنك التواصل مع نخبة من مفسري الرؤى الموثوقين ويأتيك الرد في وقت يسير'''
                '''والعديد من المزايا الأخرى'''
                '''\n\n'''
                '''الرؤيا وما يتعلق بها '''
                '''\n'''
                '''الحمد لله رب العالمين وأشهد أن لا إله إلا الله وحده لا شريك له وأشهد أن محمداً عبده ورسوله r وعلى آله وصحبه أجمعين.'''
                '''أما بعد: فإن علم تعبير الرؤيا علم عظيم مهم ورد في القرآن العظيم والسنة المطهرة ومبناه على حسن الفهم والعبور من الألفاظ والمحسوسات والمعنويات أو ما يناسبها بحسب حال الرائي وبحسب الوقت والحال المعلقة بالرؤيا وقد أثنى الله على يوسف بن يعقوب عليهما السلام بعلمه بتأويل أحاديث الأحكام الشرعية والأحاديث المتعلقة بتعبير الرؤيا والفرق بين الأحلام التي لا تأويل لها مثل ما يراه من يكفر في شيء ويطيل تأمله لبعض الأمور فإنه كثيراً ما يرى في منامه من جنس ما يفكر فيه في يقظته فهذا النوع الغالب عليه أنه أضغاث أحلام لا تعبير له وكذلك ما يلقيه الشيطان على روح النائم من المرائي الكاذبة والمعاني المتخبطة فهذه أيضاً لا تعبير لها ولا ينبغي للعاقل أن يشغل بها فكره. وأما الرؤيا الصحيحة فهي إلهامات يلهمها الله للروح عند تجردها عن البدن وقت النوم، وأمثال مضروبة يضربها الملك للإنسان ليفهم بها ما يناسبها([1]).'''
                '''ولأهمية تعبير الرؤيا في حياة الإنسان فقد جمعت في هذه الرسالة ما تيسر من ما يتعلق بالرؤيا من آداب الرؤيا الصالحة وضدها وما يتعلق بها من أنواع التعبير الوارد عن النبي r والمستنبط من القرآن الكريم، وأن الرؤيا الصالحة من الله والحلم من الشيطان، وتحريم الكذب في الرؤيا بأن يقول رأيت في منامي كذا وكذا وهو كاذب وقد ورد الوعيد الشديد على ذلك، ولا ينبغي أن يؤول الرؤيا إلا عالم أو طالب علم لأنها إذا أولت وقعت كما ورد في الحديث الذي رواه الحاكم وصححه أهل السنن.'''
                '''وقد أرشدنا رسول الله r ودلنا على (قاعدة مهمة) عندما يرى الإنسان في منامه شيئاً يسره أو يكرهه وهي أنه إذا رأى ما يسره فليحمد الله عليه وليستبشر به وأن يحدث به من يحب. وإذا رأى ما يكره فليستعذ بالله من الشيطان ومن شر هذه الرؤيا وأن ينفث عن يساره ثلاثا، ويتحول عن جنبه الذي كان عليه، ولا يحدث بها أحداً فإذا فعل ذلك فإنها لا تضره، وهي تقع على ما تفسر به كما تقدم وكما يأتي كما ذكر في هذه الرسالة أقسام تأويل الرؤيا للإمام البغوي ورسالة في تعبير الرؤيا لابن القيم رحمهما الله تعالى.'''
                '''أسأل الله تعالى أن ينفع بها وصلى الله وسلم على نبينا محمد وعلى آله وصحبه أجمعين.'''
                '''\n'''
                '''([1]) مقدمة من كتب الرؤية وما يتعلق بها - جمع الشيخ عبدالله الجار الله.'''
            .split('\n');

    return MainScaffold(
      title: (title ?? LocaleKeys.aboutUs).tr(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24.h),
              child: CircleAvatar(
                radius: 80.r,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Image.asset(
                    R.ASSETS_IMAGES_LOGO_PNG,
                  ),
                ),
              ),
            ),
            ...aboutUs
                .map((p) => Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0.w, vertical: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.all(0.h),
                                  child: Text(
                                    p,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: p.length < 50
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: p.length < 50 ? 16.sp : 14.sp,
                                    ),
                                  ))),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
