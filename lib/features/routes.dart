import 'package:app_web_project/core/model/chat_room.dart';
import 'package:app_web_project/core/model/user_model.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:app_web_project/core/utils/logger_utils.dart';
import 'package:app_web_project/features/change_password/presentation/pages/change_password.dart';
import 'package:app_web_project/features/forgor_password/presentation/pages/forgot_password.dart';
import 'package:app_web_project/features/register/presentation/pages/signup_screen.dart';
import 'package:app_web_project/features/splash/presentation/pages/splash_screen.dart';
import 'package:app_web_project/features/update_info/presentation/pages/update_info.dart';
import 'package:app_web_project/features/video_call/presentation/pages/video_call_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login/presentation/pages/login_screen.dart';
import 'main/presentation/pages/home_screen.dart';

class Routes {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  factory Routes() => _instance;

  Routes._internal();

  static final Routes _instance = Routes._internal();

  static Routes get instance => _instance;

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) async {
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndRemove(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (Route<dynamic> route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateAndReplace(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndReplaceName(String routeName,
      {dynamic arguments}) async {
    return navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  dynamic pop({dynamic result}) {
    return navigatorKey.currentState?.pop(result);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    LOG.info('Route name: ${settings.name}');
    switch (settings.name) {
      case RouteNames.splash:
        return _pageRoute(page: SplashScreen(), setting: settings);
      case RouteNames.home:
        return _pageRoute(page: HomeScreen(), setting: settings);
      case RouteNames.login:
        return _pageRoute(page: LoginScreen(), setting: settings);
      case RouteNames.signUp:
        return _pageRoute(page: SignUpScreen(), setting: settings);
      case RouteNames.changePassword:
        return _pageRoute(page: ChangedPassword(), setting: settings);
      case RouteNames.forgotPassWord:
        return _pageRoute(page: ForgotPassword(), setting: settings);
      case RouteNames.editInfo:
        final arg = settings.arguments as UserModel;
        return _pageRoute(page: UpdateInfo(userModel: arg), setting: settings);
      case RouteNames.videoCall:
        final arg = settings.arguments as ChatRoom;
        return _pageRoute(
            page: VideoCall(
              chatRoom: arg,
            ),
            setting: settings);
      default:
        return _emptyRoute(settings);
    }
  }

  static PageTransition _pageRoute({
    PageTransitionType? transition,
    RouteSettings? setting,
    required Widget page,
  }) =>
      PageTransition(
        child: page,
        type: transition ?? PageTransitionType.rightToLeft,
        settings:
            RouteSettings(arguments: setting?.arguments, name: setting?.name),
      );

  static MaterialPageRoute _emptyRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Center(
              child: Text(
                'Back',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        body: Center(
          child: Text('No path for ${settings.name}'),
        ),
      ),
    );
  }
}
