import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthScreensEvent {}

final class AuthScreensChangeState extends AuthScreensEvent {}

class AuthScreensBloc extends Bloc<AuthScreensEvent, bool> {
  AuthScreensBloc() : super(false) {
    on<AuthScreensChangeState>((event, emit) {
      emit(!state);
    });
  }
}
