import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class BankTransfeerScreen extends StatelessWidget {
  const BankTransfeerScreen({Key? key}) : super(key: key);
  final String text = '''شاشة بيانات التحويل البنكي '''
      '''يرجى التحويل على حساب بنك بوبيان الخاص بي وارسال رقم التحويل وصورة منه عبر الواتس اب  لتفعيل الباقة المطلوبة:'''
      '''رقم الواتس اب '''
      '''+96555073335'''
      '''\n\n'''
      '''الاسم الكامل'''
      '''معمر اكليفيخ طماح المطيرى'''
      '''\n\n'''
      '''رقم حساب'''
      '''0238896003'''
      '''\n\n'''
      '''IBAN'''
      '''KW07BBYN0000000000000238896003'''
      '''\n\n'''
      '''اسم البنك'''
      '''Boubyan Bank'''
      '''\n\n'''
      '''SWIFT رمز'''
      '''BBYNKWKW'''
      '''\n\n'''
      '''اسم الفرع'''
      '''العارضية'''
      '''\n\n'''
      '''عنوان البنك'''
      '''Mubarak Tower, Ali Al Salem Street, Block 5, Mubarakiya, Kuwait City'''
      '''\n\n'''
      '''الدولة'''
      '''Kuwait'''
      '''\n\n'''
      '''عملة الحساب'''
      '''دولار أمريكي (USD)''';

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Column(
        children: text
            .split('\n\n')
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: e
                      .split('\n')
                      .map(
                        (e) => Text(e, style: const TextStyle(height: 1)),
                      )
                      .toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
