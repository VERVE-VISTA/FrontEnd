import 'package:get/get.dart';
import 'package:vervevista/pages/launch_screen.dart';
import 'package:vervevista/pages/login_page.dart';
import 'package:vervevista/pages/login_pageA.dart';
import 'package:vervevista/pages/marketing_sm_home.dart';
import 'package:vervevista/pages/role_selection_page.dart';
import 'package:vervevista/pages/signup_page.dart';
import 'package:vervevista/pages/home_page.dart';
import 'package:vervevista/pages/signup_pageA.dart';
class AppPages {
  static final pages = [
    GetPage(name: '/signupU', page: () => SignupPage()),
    GetPage(name: '/signupA', page: () => AdvisorSignupPage()),
    GetPage(name: '/signin', page: () => LoginPage()),
    GetPage(name: '/signinA', page: () => LoginPageA()),
    GetPage(name: '/role', page: () => RoleSelectionPage()),


    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/splash', page: () => LaunchScreen()),
    GetPage(name: '/market', page: () => MarketingSMHome()),


    // Add other routes here
  ];
}
