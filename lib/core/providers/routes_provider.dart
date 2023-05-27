import 'package:get/get.dart';
import 'package:notey/features/todo/presentaion/pages/todo_page.dart';

class RoutesProvider {
  static const String start = '/';
  static const String onBoarding = '/on_start_screen';
  static const String phoneNumber = '/phone_number_verification';

  static List<GetPage<dynamic>> routes = [
    GetPage(name: start, page: () => TodoPage(title: 'Notey',)), //StartScreen
  ];
}
