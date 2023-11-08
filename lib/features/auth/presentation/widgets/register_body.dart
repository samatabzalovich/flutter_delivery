import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/core/common/widgets/my_button.dart';
import 'package:flutter_delivery/core/common/widgets/my_textfield.dart';
import 'package:flutter_delivery/core/enum/user_enums.dart';
import 'package:flutter_delivery/features/auth/domain/usecases/register.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_event.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SizedBox(height: 50),
          Icon(Icons.lock, size: 50),
          SizedBox(height: 50),
          Text(
            'Create a new Account',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          CustomForm(),
        ],
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  const CustomForm({
    super.key,
  });

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isRider = false;

  void showmessage(String errorMessage, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(errorMessage));
        });
  }

  void _signUserup(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showmessage("Password does not match", context);
      return;
    }
    context.read<AuthBloc>().add(AuthRegisterEvent(RegisterUseCaseParams(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _userNameController.text,
        type: isRider ? UserType.driver : UserType.customer)));
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(child: CircularProgressIndicator());
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        MyTextField(
          controller: _userNameController,
          hintText: 'username',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: _emailController,
          hintText: 'email',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: _passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: _confirmPasswordController,
          hintText: 'Confirm Password',
          obscureText: true,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              UserType.customer.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Switch.adaptive(
                value: isRider,
                onChanged: (val) => setState(() {
                      isRider = val;
                    })),
            Text(
              UserType.driver.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 25),
        MyButton(
          text: "Sign Up",
          onTap: () => _signUserup(context),
        ),
        const SizedBox(height: 50),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Login now',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
