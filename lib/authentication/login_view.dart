import 'package:codelink_mobile/authentication/sign_up_view.dart';
import 'package:codelink_mobile/authentication/validators.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/user/user_service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/authentication/login.dart';
import 'package:codelink_mobile/core/models/authentication/login_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/models/user/get_user_response.dart';
import 'package:codelink_mobile/home_view.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/buttons/my_text_button.dart';
import 'package:codelink_mobile/shared/widgets/buttons/small_text_button.dart';
import 'package:codelink_mobile/shared/widgets/fields/my_check_box.dart';
import 'package:codelink_mobile/shared/widgets/fields/my_password_field.dart';
import 'package:codelink_mobile/shared/widgets/fields/my_text_form_field.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final IAuthenticationDao _authenticationDao = getIt.get<IAuthenticationDao>();
  final IAuthenticationService _authenticationService = getIt.get<IAuthenticationService>();
  final IUserService _userService = getIt.get<IUserService>();

  final _loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ValueNotifier<bool> keepMeSigned = ValueNotifier(false);

  var logger = Logger();

  void onSubmit(String email, String password) {
    _loginKey.currentState!.validate();
    login(email, password);
  }

  final List<FocusNode> _loginFocusNodes = [FocusNode(), FocusNode()];

  login(String email, String password) async {
    Login login = Login(email: email, password: password);
    ServiceResponse<LoginResponse> serviceResponse = await _authenticationService.login(login);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }
    LoginResponse loginResponse = serviceResponse.data!;

    await _authenticationDao.storeToken(loginResponse.data.token);
    if (keepMeSigned.value) {
      await _authenticationDao.storeCredentials(email, password);
    }

    ServiceResponse<GetUserResponse> userResponse = await _userService.getMe();
    if (userResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }
    GetUserResponse getUserResponse = userResponse.data!;
    await _authenticationDao.storeUserId(getUserResponse.data.user.id);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
  }

  @override
  void initState() {
    super.initState();
    _loginFocusNodes.forEach((element) {
      element.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.blockSizeV!;
    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/auth/login_bg_2.png'),
                fit: BoxFit.cover
              )

            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: height * 16,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Column(
                                  children: [
                                    Text('Login', style: kTitle),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Form(
                                        key: _loginKey,
                                        child: Column(
                                          children: [
                                            MyTextFormField(
                                                hint: 'Email',
                                                icon: Icons.email,
                                                fillColor: kThirdColor,
                                                inputType:
                                                    TextInputType.emailAddress,
                                                inputAction:
                                                    TextInputAction.next,
                                                focusNode: _loginFocusNodes[0],
                                                validator: emailValidator,
                                              controller: emailController,
                                            ),
                                            MyPasswordField(
                                                fillColor: kThirdColor,
                                                focusNode: _loginFocusNodes[1],
                                                validator: passwordValidator,
                                              controller: passwordController,
                                            ),
                                            ValueListenableBuilder<bool>(
                                                valueListenable: keepMeSigned,
                                                builder: (builder, keepMe, _) {
                                                  return MyCheckBox(
                                                    text: "Keep me signed",
                                                    isChecked: keepMe,
                                                    onChanged: (bool? value) {
                                                      if (value != null) {
                                                        keepMeSigned.value = value;
                                                        keepMeSigned.notifyListeners();
                                                      }
                                                    },
                                                  );
                                                }
                                            ),
                                            MyTextButton(
                                                buttonName: 'Login',
                                                onPressed:() => onSubmit(emailController.text,passwordController.text),
                                                bgColor: kPrimaryColor)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('You don\'t have account, create it here', style: kBodyText3),
                                        const SmallTextButton(
                                          buttonText: 'Sign up',
                                          page: SignUpView(),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
