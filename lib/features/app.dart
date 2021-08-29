import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:app_web_project/core/blocs/snack_bar_cubit/snack_bar_cubit.dart';
import 'package:app_web_project/core/containts/enum_constants.dart';
import 'package:app_web_project/core/navigator/route_names.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/core/utils/screen_utils.dart';
import 'package:app_web_project/core/widgets/loading_app.dart';
import 'package:app_web_project/features/routes.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../injection_container.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<BlocProvider> _getProviders() => [
        BlocProvider<LoadingCubit>(
          create: (_) => inject<LoadingCubit>(),
        ),
        BlocProvider<SnackBarCubit>(
          create: (_) => inject<SnackBarCubit>(),
        ),
        BlocProvider<AuthenticationCubit>(
          create: (_) => inject<AuthenticationCubit>(),
        ),
      ];

  List<BlocListener> _getBlocListener(context) => [
        BlocListener<SnackBarCubit, SnackBarState>(
            listener: _mapListenerSnackBarState),
      ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getProviders(),
      child: ScreenUtilInit(
        designSize: Size(375, 812),
        builder: () => MaterialApp(
          navigatorKey: Routes.instance.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'COUPLE',
          onGenerateRoute: Routes.generateRoute,
          initialRoute: RouteNames.splash,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          builder: (context, widget) {
            ScreenUtils.init(context);
            return LoadingApp(
              child: MultiBlocListener(
                listeners: _getBlocListener(context),
                child: GestureDetector(
                  child: widget,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _mapListenerSnackBarState(BuildContext context, SnackBarState state) {
    if (state is ShowSnackBarState) {
      var icon;
      var color;
      var title;
      switch (state.type) {
        case SnackBarType.success:
          // TODO: Handle this case.
          icon = Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          );
          color = HexColor('#33B44A');
          title = "Success";
          break;
        case SnackBarType.error:
          // TODO: Handle this case.
          icon = Icon(
            Icons.error_outline,
            color: Colors.white,
          );
          color = HexColor('#F63E43');
          title = "Failure";
          break;
        case SnackBarType.warning:
          // TODO: Handle this case.
          icon = Icon(
            Icons.error_outline,
            color: Colors.white,
          );
          color = Colors.orange;
          title = "Warning";
          break;
        default:
          break;
      }

      showFlash(
        context: Routes.instance.navigatorKey.currentContext!,
        duration: state.duration ?? Duration(milliseconds: 1400),
        builder: (context, controller) {
          return Flash.bar(
            controller: controller,
            backgroundColor: color,
            position: FlashPosition.bottom,
            horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
            margin: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            forwardAnimationCurve: Curves.easeOutBack,
            reverseAnimationCurve: Curves.easeInCubic,
            child: FlashBar(
              title: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
              content: Text(
                state.mess!,
                style: TextStyle(color: Colors.white),
              ),
              icon: icon,
              shouldIconPulse: true,
              showProgressIndicator: false,
            ),
          );
        },
      );
    }
  }
}
