import 'package:codelink_mobile/authentication/login_view.dart';
import 'package:codelink_mobile/authentication/validators.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.service.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/authentication/create_user.dart';
import 'package:codelink_mobile/core/models/authentication/create_user_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/home_view.dart';
import 'package:codelink_mobile/shared/styles/app_styles.dart';
import 'package:codelink_mobile/shared/styles/size_configs.dart';
import 'package:codelink_mobile/shared/widgets/buttons/small_text_button.dart';
import 'package:codelink_mobile/shared/widgets/fields/my_check_box.dart';
import 'package:codelink_mobile/shared/widgets/buttons/my_text_button.dart';
import 'package:codelink_mobile/shared/widgets/fields/my_password_field.dart';
import 'package:codelink_mobile/shared/widgets/fields/my_text_form_field.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final IAuthenticationDao _authenticationDao = getIt.get<IAuthenticationDao>();
  final IAuthenticationService _authenticationService = getIt.get<IAuthenticationService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  ValueNotifier<bool> keepMeSigned = ValueNotifier(false);

  final _signUpKey = GlobalKey<FormState>();

  var logger = Logger();

  void onSubmit(String email, String password, String username) async{
    _signUpKey.currentState!.validate();
    signup(email, password, username);
  }

  final List<FocusNode> _signUpFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];


  void signup(String email, String password, String username) async {
    CreateUser createUser = CreateUser(email: email, password: password, username: username);
    ServiceResponse<CreateUserResponse> serviceResponse = await _authenticationService.createUser(createUser);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return;
    }

    CreateUserResponse createUserResponse = serviceResponse.data!;

    await _authenticationDao.storeToken(createUserResponse.data.token);
    if (keepMeSigned.value) {
      await _authenticationDao.storeCredentials(email, password);
    }
    await _authenticationDao.storeUserId(createUserResponse.data.user.id);

    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
  }
  
  
  @override
  void initState() {
    super.initState();
    _signUpFocusNodes.forEach((element) {
      element.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.blockSizeV!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child:
                    Image.asset('assets/images/auth/signup_illustration.png'),
              ),
              Text('Create your account', style: kTitle),
              SizedBox(
                height: height * 2,
              ),
              Form(
                key: _signUpKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            MyTextFormField(
                              fillColor: kThirdColor,
                              hint: 'Username',
                              icon: Icons.person_outline,
                              focusNode: _signUpFocusNodes[0],
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.name,
                              validator: nameValidator,
                              controller: usernameController,
                            ),
                            MyTextFormField(
                              fillColor: kThirdColor,
                              hint: 'Email',
                              icon: Icons.email_outlined,
                              focusNode: _signUpFocusNodes[1],
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.emailAddress,
                              validator: emailValidator,
                              controller: emailController,
                            ),
                            MyPasswordField(
                                fillColor: kThirdColor,
                                focusNode: _signUpFocusNodes[2],
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
                              bgColor: kPrimaryColor,
                              onPressed: () => onSubmit(
                                  emailController.text,
                                  passwordController.text,
                                  usernameController.text
                              ),
                              buttonName: 'Create Account',
                            )
                          ],
                        )),
                    SizedBox(
                      height: height * 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?', style: kBodyText3),
                        const SmallTextButton(
                          buttonText: 'Sign in',
                          page: LoginView(),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
