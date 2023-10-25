import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/core/common/widgets/loading_screen.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/core/service/dependencies_injector.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_delivery/features/auth/presentation/pages/auth_sign_in.dart';
import 'package:flutter_delivery/features/auth/presentation/pages/auth_sign_up.dart';
import 'package:flutter_delivery/features/auth/presentation/widgets/generic_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _pageBuilder((context) {
        return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthLoadingState) {
            LoadingScreen.instance().show(
              context: context,
              text: 'Loading...',
            );
          } else {
            LoadingScreen.instance().hide();
          }

          final StateException? authError = state.error;
          if (authError != null) {
            showAuthError(
              authError: authError,
              context: context,
            );
          }
        }, builder: (_, state) {
          if (state is AuthLoggedInState) {
            return Scaffold(body: Center(child: Text("Logged in")));
          }
          return AuthSignIn();
        });
      }, settings: settings);

    case RegisterPage.routeName:
      return _pageBuilder(
          (context) => BlocProvider<AuthBloc>(
                create: (context) => sl(),
                child: RegisterPage(),
              ),
          settings: settings);

    // case '/SavedArticles':
    //   return _materialRoute(const SavedArticles());

    default:
      return _pageBuilder((context) {
        return const Center(
          child: Text("error"),
        );
      }, settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
