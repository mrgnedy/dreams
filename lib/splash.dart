import 'dart:async';
import 'dart:developer';

import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/home/ui/navigation_screen.dart';
import 'package:dreams/utils/draw_actions.dart';
import 'package:dreams/main.dart';
import 'package:flutter/material.dart';
import 'package:dreams/const/resource.dart';

import 'features/auth/ui/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((s) async {
      await di<AuthCubit>().checkUser();
      if (di<AuthCubit>().state.id != null) {
        const NavigationScreen().pushAndRemoveAll(context);
        log("${di<AuthCubit>().state.id}");
      } else
        LoginScreen().pushAndRemoveAll(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          // Timer(5.s, () => LoginScreen().pushAndRemoveAll(context));
          return Image.asset(
            R.ASSETS_IMAGES_SPLASH_PNG,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        });
  }
}
