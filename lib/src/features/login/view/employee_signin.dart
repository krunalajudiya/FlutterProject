import 'dart:async';
import 'package:emgage_flutter/src/features/login/view/validate_company_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../commonWidgets/common_widgets.dart';
import '../../../constants/image_path.dart';
import '../../../constants/login/login_constants.dart';
import '../../../utils/common_functions.dart';
import '../../attandance/punching/view/punching_view.dart';
import '../bloc/login_bloc.dart';
import 'widgets/bottom_bar.dart';

class EmployeeSignin extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static String? employeeIdText, passwordText;
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  String? companyLogoUrl = "";
  bool _passwordVisibilityToggle = true;
  StreamController<bool> passwordToggleStreamController =
      StreamController<bool>();
  final loginBloc = LoginBloc();

  EmployeeSignin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => loginBloc..add(LoadDataEvent()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is ChangeCompanyState) {
              CommonFunction.pageRouteOrReplace(context, ValidateCompanyView());
            } else if (state is LoadedDataState) {
              companyLogoUrl = state.companyLogoUrl;
              employeeIdText = state.employeeIdText;
              passwordText = state.passwordText;
            } else if (state is CredentialValidateState) {
              CommonFunction.pageRouteOrReplace(context, Punching());
            }
          },
          buildWhen: (context, state) => state is LoadedDataState,
          builder: (context, state) {
            _employeeIdController.text = employeeIdText ?? "";
            _passwordController.text = passwordText ?? "";
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  FadeInImage.assetNetwork(
                                    height: 60,
                                    placeholder: ImagePath.companyLogo,
                                    image: companyLogoUrl!,
                                    imageErrorBuilder:
                                        ((context, error, stacktrace) {
                                      return Image.asset(ImagePath.companyLogo);
                                    }),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: _employeeIdController,
                                    decoration:
                                        CommonWidgets.inputBoxDecoration(
                                            LoginConstants.userNameLabel.tr),
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return LoginConstants
                                            .requiredFieldErrorMessage.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<bool>(
                                      stream:
                                          passwordToggleStreamController.stream,
                                      builder: (context, snapshot) {
                                        return TextFormField(
                                          controller: _passwordController,
                                          obscureText: snapshot.data ?? true,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  _passwordVisibilityToggle =
                                                      !_passwordVisibilityToggle;
                                                  passwordToggleStreamController
                                                      .add(
                                                          _passwordVisibilityToggle);
                                                },
                                                child: Icon(
                                                    _passwordVisibilityToggle
                                                        ? Icons.visibility_off
                                                        : Icons.visibility),
                                              ),
                                              hintText: LoginConstants
                                                  .passwordLabel.tr),
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return LoginConstants
                                                  .requiredFieldErrorMessage.tr;
                                            }
                                            return null;
                                          },
                                        );
                                      }),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(40)),
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          loginBloc.add(CredentialValidateEvent(
                                              context,
                                              _employeeIdController.text,
                                              _passwordController.text));
                                        }
                                      },
                                      child:
                                          Text(LoginConstants.loginLabel.tr)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      loginBloc.add(ChangeCompanyEvent());
                                    },
                                    child: Text(
                                        LoginConstants.changeCompanyLabel.tr),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Divider(
                                    color: Colors.black38,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 20),
                                      child: Image.asset(
                                          ImagePath.powerByEmgageLogo))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  loginBloc.add(LanguageChangeEvent(
                                      LoginConstants.englishLanguage));
                                },
                                child: const Text(LoginConstants.englishLabel)),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  loginBloc.add(LanguageChangeEvent(
                                      LoginConstants.hindiLanguage));
                                },
                                child: const Text(LoginConstants.hindiLabel))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                BottomBar.bottomInfo(),
              ],
            );
          },
        ),
      ),
    );
  }
}
