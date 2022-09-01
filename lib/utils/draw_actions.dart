import 'dart:math' as math;
import 'dart:ui';

import 'package:dreams/features/auth/state/auth_cubit.dart';
import 'package:dreams/features/locale_cubit.dart';
import 'package:dreams/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supercharged/supercharged.dart';

enum PageDirection { vertical, horizontal, free }

extension ObjExt<T> on T {
  MaterialStateProperty<T> get materialPro =>
      MaterialStateProperty.all<T>(this);
} // import 'package:flutter/cupertino.dart';

extension OffsetExtensions on Offset {
  ///Returns the absolute distance between two given offsets
  double operator <<(Offset o) {
    final dx = this.dx - o.dx;
    final dy = this.dy - o.dy;
    final dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    return dist;
  }

  ///Returns the offset relative to screen dimentions
  Offset get toResp =>
      Offset(dx * ([1.sw, 1.sh].max()!), dy * ([1.sw, 1.sh].min()!));

  ///Size(667.0, 375.0)

  ///Returns a given offset without the sign if negative
  Offset get abs => Offset(dx.abs(), dy.abs());
  clamp(Offset min, Offset max) {
    if (this > max) return max;

    if (this < min) return min;
    return this;
  }
}

class OffsetLong extends Offset {
  ///Same functionality as Offset but toString returns the offset without rounding
  OffsetLong(double dx, double dy) : super(dx, dy);

  @override
  String toString() => 'Offset($dx, $dy)';
}

extension ListExtensions on List {
  operator [](int index) {
    if (this == null || this.length <= index) {
      print("Max Index is ${this.length - 1}");
      return null;
    } else
      return this[index];
  }

  // List get reverse => this.reversed
}

_setOrientation(PageDirection direction) {
  switch (direction) {
    case PageDirection.vertical:
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      break;
    case PageDirection.horizontal:
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      break;
    case PageDirection.free:
      break;
  }
}

extension WidgetExt on Widget {
  MaterialPageRoute _materialRoute([name, arguments]) => MaterialPageRoute(
        // pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
        //   opacity: animation,
        //   child: this,
        // ),
        builder: (context) => this,
        settings: RouteSettings(name: name ?? toString(), arguments: arguments),
      );
  PageRoute _pageRoute([name, arguments]) => NoAnimationPageRoute(
        builder: (
          context,
        ) =>
            this,
        settings: RouteSettings(name: name ?? toString(), arguments: arguments),
        // transitionDuration: 0.s,
        // reverseTransitionDuration: 0.s,
      );

  Future pushNamed(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    return Navigator.pushNamed(
      context,
      name,
      arguments: arguments,
      // isMaterial
      //     ? this._materialRoute(name, arguments)
      //     : this._pageRoute(name, arguments),
    );
  }

  Future push(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    return Navigator.push(
      context,
      isMaterial
          ? _materialRoute(name, arguments)
          : _pageRoute(name, arguments),
    );
  }

  Future pushReplace(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    return Navigator.pushReplacement(
      context,
      isMaterial
          ? this._materialRoute(name, arguments)
          : this._pageRoute(name, arguments),
    );
  }

  Future pushAndRemoveAll(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    return Navigator.pushAndRemoveUntil(
      context,
      isMaterial
          ? this._materialRoute(name, arguments)
          : this._pageRoute(name, arguments),
      (route) => false,
    );
  }

  void popUntil(BuildContext context,
      {name,
      arguments,
      bool isMaterial = true,
      PageDirection direction = PageDirection.free}) {
    _setOrientation(direction);
    Navigator.popUntil(context, ModalRoute.withName(name));
  }
}

extension EdgeDirectional on EdgeInsetsDirectional {
  EdgeInsetsDirectional copyWith(
      {double? start, double? end, double? top, double? bottom}) {
    return EdgeInsetsDirectional.only(
      start: start ?? this.start,
      end: end ?? this.end,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }
}

extension ContextExtension on BuildContext {
  bool get isAr => locale.languageCode == 'ar';

  Offset getOffset() {
    final renderBox = this.findRenderObject() as RenderBox;
    final overlay = Overlay.of(this)!.context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(
      renderBox.size.center(Offset.zero),
      ancestor: overlay,
    );
  }

  Orientation get orientation => MediaQuery.of(this).orientation;

  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  Locale get appLocale => (this).locale;
  updateLocale(Locale locale) {
    setLocale(locale);
    di<LocaleCubit>().updateLocale(locale);
    di<AuthCubit>().updateLanguage(locale.languageCode);
  }

  String translate(String s) => s.tr();
  String tr(String text) => text.tr();
  void pop([result]) => Navigator.pop(this, result);
  void popUntil(String name) =>
      Navigator.popUntil(this, ModalRoute.withName(name));
  // Future push(Widget screen, [bool isMaterial = true]) => Navigator.push(
  //     this, isMaterial ? screen._materialRoute : screen._pageRoute());
  // Future pushReplace(Widget screen, [bool isMaterial = true]) =>
  //     Navigator.pushReplacement(
  //         this, isMaterial ? screen._materialRoute : screen._pageRoute());
  // Future pushAndRemoveAll(Widget screen, [bool isMaterial = true]) =>
  //     Navigator.pushAndRemoveUntil(
  //       this,
  //       isMaterial ? screen._materialRoute(name, arguments) : screen._pageRoute(name, arguments),
  //       (route) => false,
  //     );
  // Future push(String screen, [arguments, bool isMaterial = true]) =>
  //     Navigator.pushNamed(
  //         this, isMaterial ? screen._materialRoute : screen._pageRoute());
  // Future pushReplace(Widget screen, [bool isMaterial = true]) =>
  //     Navigator.pushReplacement(
  //         this, isMaterial ? screen._materialRoute : screen._pageRoute());
  // Future pushAndRemoveAll(Widget screen, [bool isMaterial = true]) =>
  //     Navigator.pushAndRemoveUntil(
  //       this,
  //       isMaterial ? screen._materialRoute : screen._pageRoute(),
  //       (route) => false,
  //     );
}

extension DateTimeExt on DateTime {
  bool operator >(DateTime s) => this.isAfter(s);
  bool operator <(DateTime s) => this.isBefore(s);
}

extension IntToDur on int {
  Duration get s => Duration(seconds: this);
  Duration get hr => Duration(hours: this);
  Duration get m => Duration(minutes: this);
  Duration get ms => Duration(milliseconds: this);
}

extension NumExt on num {
  double get wd => (this / 750).sw;
  double get hd => (this / 376).sh;
  double get sf => this + 0.02.sw;
  double get tf {
    final shortSide = MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
        .size
        .shortestSide;

    if (shortSide > 800)
      return 1.55 * this;
    else if (shortSide < 600)
      return 1.0 * this;
    else
      return 1.25 * this;
  }
  // this *
  // (MediaQueryData.fromWindow(WidgetsBinding.instance.window)
  //             .size
  //             .shortestSide >
  //         700
  //     ? 1.5
  //     : 1.0);
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

// extension EasyLocaleExt on String {
//   Locale get toLocale => Locale(this);
// }

// extension FunctionExtension on Function {
//   delay(duration) => Future.delayed(duration, () => this.call());
// }

// extension BlocExt<Event, State> on Bloc<Event, State> {
//   StreamSubscription<State> publishDelayListen(
//     void onData(State value), {
//     Function onError,
//     void onDone(),
//     bool cancelOnError,
//   }) {
//     onData(state);
//     return listen(
//       onData,
//       onError: onError,
//       onDone: onDone,
//       cancelOnError: cancelOnError,
//     );
//   }
// }
class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute(
      {required WidgetBuilder builder, required RouteSettings settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
