import 'package:flutter/material.dart';
import '../../controllers/login_controller.dart';

class GetinController {
  final LoginController _loginController;
  GetinController(
    this._loginController,
  ) {
    formKey = GlobalKey<FormState>();
  }

  late GlobalKey<FormState> formKey;

  set email(String value) => _loginController.emailField = value;
  set pass(String value) => _loginController.passField = value;

  Future<void> login(BuildContext context) async {
    _loginController.formState = formKey;
    await _loginController.login(context);
  }
}
