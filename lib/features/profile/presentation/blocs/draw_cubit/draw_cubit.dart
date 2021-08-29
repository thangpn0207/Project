import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'draw_state.dart';

class DrawCubit extends Cubit<DrawState> {
  DrawCubit() : super(DrawInitial());
}
