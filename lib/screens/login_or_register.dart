import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authscreens/auth_bloc.dart';
import 'register.dart';
import 'login.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final authScreensBloc = context.read<AuthScreensBloc>();

    void togglePages() {
      authScreensBloc.add(AuthScreensChangeState());
    }

    return BlocBuilder<AuthScreensBloc, bool>(
      builder:
          (context, state) => Navigator(
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder:
                    (_) =>
                        authScreensBloc.state == false
                            ? RegisterPage(onTap: togglePages)
                            : LoginPage(onTap: togglePages),
              );
            },
          ),
    );
  }
}
