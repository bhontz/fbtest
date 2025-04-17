import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AppMenuEvent {}

final class AppMenuChangeState extends AppMenuEvent {}

class AppMenuBloc extends Bloc<AppMenuEvent, bool> {
  AppMenuBloc() : super(false) {
    on<AppMenuChangeState>((event, emit) {
      emit(!state);
    });
  }
}
