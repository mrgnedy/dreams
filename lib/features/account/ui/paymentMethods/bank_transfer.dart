import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:flutter/material.dart';

class BankTransfeerScreen extends StatelessWidget {
  BankTransfeerScreen({Key? key}) : super(key: key);
  final String text = '''شاشة بيانات التحويل البنكي '''
      '''يرجى التحويل على حساب بنك بوبيان الخاص بي وارسال رقم التحويل وصورة منه عبر الواتس اب  لتفعيل الباقة المطلوبة:'''
      '''رقم الواتس اب '''
      '''\n'''
      '''+96555073335'''
      '''\n\n'''
      '''الاسم الكامل'''
      '''\n'''
      '''معمر اكليفيخ طماح المطيرى'''
      '''\n\n'''
      '''رقم حساب'''
      '''\n'''
      '''0238896003'''
      '''\n\n'''
      '''IBAN'''
      '''\n'''
      '''KW07BBYN0000000000000238896003'''
      '''\n\n'''
      '''اسم البنك'''
      '''\n'''
      '''Boubyan Bank'''
      '''\n\n'''
      '''SWIFT رمز'''
      '''\n'''
      '''BBYNKWKW'''
      '''\n\n'''
      '''اسم الفرع'''
      '''\n'''
      '''العارضية'''
      '''\n\n'''
      '''عنوان البنك'''
      '''\n'''
      '''Mubarak Tower, Ali Al Salem Street, Block 5, Mubarakiya, Kuwait City'''
      '''\n\n'''
      '''الدولة'''
      '''\n'''
      '''Kuwait'''
      '''\n\n'''
      '''عملة الحساب'''
      '''\n'''
      '''دولار أمريكي (USD)''';
  final FocusNode textNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: text
                .split('\n\n')
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: e
                          .split('\n')
                          .map(
                            (e) => SelectableText(
                              e,
                              focusNode: textNode,
                              textAlign: TextAlign.start,
                              style: const TextStyle(height: 1),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
