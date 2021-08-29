part of 'loading_cubit.dart';

@immutable
abstract class LoadingState {
  final bool? loading;

  LoadingState({this.loading});
}

class ShowLoading extends LoadingState {
  ShowLoading() : super(loading: true);
}

class HideLoading extends LoadingState {
  HideLoading() : super(loading: false);
}
