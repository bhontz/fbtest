import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/settings.dart';
import '../screens/home.dart';
import '../screens/menu.dart';
import '../bloc/appbarmenu/appbarmenu_bloc.dart';

class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appMenuBloc = context.read<AppMenuBloc>();

    return BlocBuilder<AppMenuBloc, bool>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(
              title: Text('T E A C H E R', style: TextStyle(fontSize: 18)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  appMenuBloc.add(AppMenuChangeState());
                },
                icon: Icon(
                  appMenuBloc.state == false ? Icons.menu : Icons.cancel,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => SettingsPage()));
                  },
                ),
              ],
            ),
            body: NavigatorWidget(),
          ),
    );
  }
}

class NavigatorWidget extends StatelessWidget {
  const NavigatorWidget({super.key});

  //   CommentsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final appMenuBloc = context.read<AppMenuBloc>();

    return BlocBuilder<AppMenuBloc, bool>(
      builder:
          (context, state) => Navigator(
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute(
                builder:
                    (_) => appMenuBloc.state == false ? HomePage() : MenuPage(),
              );
            },
          ),
    );
  }
}
