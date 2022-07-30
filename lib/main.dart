import 'package:codelink_mobile/authentication/login_view.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/authentication/authentication.service.interface.dart';
import 'package:codelink_mobile/core/ioc/definitions/global/global.dao.interface.dart';
import 'package:codelink_mobile/core/ioc/ioc.dart';
import 'package:codelink_mobile/core/models/authentication/login.dart';
import 'package:codelink_mobile/core/models/authentication/login_response.dart';
import 'package:codelink_mobile/core/models/common/service_response.dart';
import 'package:codelink_mobile/core/services/env/environment.service.dart';
import 'package:codelink_mobile/home_view.dart';
import 'package:codelink_mobile/shared/widgets/toast.dart';
import 'package:codelink_mobile/onboarding/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  await EnvironmentService.load();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]);
  setup();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.top,SystemUiOverlay.bottom
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final IGlobalDao _globalDao = getIt.get<IGlobalDao>();
  final IAuthenticationDao _authenticationDao = getIt.get<IAuthenticationDao>();
  final IAuthenticationService  _authenticationService = getIt.get<IAuthenticationService>();

  Future<Widget> autoLogin(BuildContext context, String email, String password) async {
    Login login = Login(email: email, password: password);
    ServiceResponse<LoginResponse> serviceResponse = await _authenticationService.login(login);

    if (serviceResponse.hasError) {
      Toast.show(serviceResponse.error!, context, duration: 5, backgroundColor: Colors.red);
      return const LoginView();
    }

    LoginResponse loginResponse = serviceResponse.data!;
    await _authenticationDao.storeToken(loginResponse.data.token);

    return const HomeView();
  }

  Future<Widget> initApp(BuildContext context) async {
    bool isFirstUsage = await _globalDao.isFirstAppUsage();
    if (isFirstUsage) {
      return const OnBoardingPage();
    }

    String? login = await _authenticationDao.getLogin();
    String? password = await _authenticationDao.getPassword();
    if (login != null && password != null) {
      return await autoLogin(context, login, password);
    }

    return const LoginView();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeLink',
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(Theme.of(context)
        .textTheme),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white
      ),
      home: FutureBuilder(
        future: initApp(context),
        builder: (BuildContext context, AsyncSnapshot<Widget> widget) {
          if (widget.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }

          return widget.data!;
        },
      )
    );
  }
}
