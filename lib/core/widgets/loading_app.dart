
import 'package:app_web_project/core/blocs/loading_cubit/loading_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingApp extends StatelessWidget {
  final Widget? child;

  LoadingApp({this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child!,
        BlocBuilder<LoadingCubit, LoadingState>(
          bloc: context.read<LoadingCubit>(),
          builder: (context, state) {
            return Visibility(
              visible: state.loading!,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
