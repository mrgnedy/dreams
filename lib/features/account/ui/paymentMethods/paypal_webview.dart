// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dreams/helperWidgets/main_scaffold.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalWebview extends StatefulWidget {
  final String url;
  final Function() onSubscribe;
  const PaypalWebview({Key? key, required this.url, required this.onSubscribe})
      : super(key: key);

  @override
  State<PaypalWebview> createState() => _PaypalWebviewState();
}

class _PaypalWebviewState extends State<PaypalWebview> {
  WebViewController? _controller;
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: "PayPal",
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
        onPageStarted: (s){
          log('started: $s');
        },
        onPageFinished: (s) {
          log("finished: $s");
          // _controller?.goBack();
          if (s.contains("https://www.sandbox.paypal.com/webapps/billing/")) {
            widget.onSubscribe.call();
            Future.delayed(5.s, () {
              context.pop(s);
            });
          }
        },
        onWebViewCreated: (c) {
          _controller = c;
        },
      ),
    );
  }
}
