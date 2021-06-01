import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rendezvous/main.dart';

class AvatarBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget avatar;
  final Animation<double> animation;

  const AvatarBottomSheet(
      {Key key, @required this.child, @required this.animation, this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Brightness _brightness = Theme.of(context).brightness;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: _brightness == Brightness.dark
            ? MyApp.navigationBarColorDark
            : MyApp.navigationBarColorLight,
        statusBarColor: _brightness == Brightness.dark
            ? MyApp.statusBarColorDark
            : MyApp.navigationBarColorLight,
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            SafeArea(
                bottom: false,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) => Transform.translate(
                      offset: Offset(0, (1 - animation.value) * 100),
                      child: Opacity(
                          child: child,
                          opacity: max(0, animation.value * 2 - 1))),
                  child: avatar ?? Container(),
                )),
            SizedBox(height: 12),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black12,
                            spreadRadius: 5)
                      ]),
                  width: double.infinity,
                  child: MediaQuery.removePadding(
                      context: context, removeTop: true, child: child),
                ),
              ),
            ),
          ]),
    );
  }
}

Future<T> showAvatarModalBottomSheet<T>(
    {@required BuildContext context,
    @required WidgetBuilder builder,
    Color backgroundColor,
    double elevation,
    ShapeBorder shape,
    Widget avatarWidget,
    Clip clipBehavior,
    Color barrierColor = Colors.black87,
    bool bounce = true,
    bool expand = false,
    AnimationController secondAnimation,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Duration duration,
    String routeName}) async {
  assert(context != null);
  assert(builder != null);
  assert(expand != null);
  assert(useRootNavigator != null);
  assert(isDismissible != null);
  assert(enableDrag != null);
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final result = Navigator.of(context, rootNavigator: false)
        .push(ModalBottomSheetRoute<T>(
      settings: RouteSettings(name: routeName),
      builder: builder,
      containerBuilder: (_, animation, child) => AvatarBottomSheet(
        child: child,
        animation: animation,
        avatar: avatarWidget,
      ),
      bounce: bounce,
      secondAnimationController: secondAnimation,
      expanded: expand,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor,
      enableDrag: enableDrag,
      duration: duration,
    ));
    return result;
  });
}
