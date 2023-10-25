import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/core/common/widgets/loading_screen.dart';
import 'package:flutter_delivery/core/error/state_exception.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_delivery/features/auth/presentation/widgets/generic_dialog.dart';
import 'package:flutter_delivery/features/auth/presentation/widgets/register_body.dart';

class RegisterPage extends StatelessWidget {
  static const String routeName = "/sign-up";
  RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
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
          } else if (state.successStateMessage != null) {
            showSuccessDialog(
                message: state.successStateMessage!, context: context);
          }
          
        },
        builder: (context, state) {
          return const SafeArea(child: RegisterBody());
        },
      ),
    );
  }
}
