import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/get_navigation.dart' as nav;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notey/core/providers/routes_provider.dart';
import 'package:notey/core/util/app_constants.dart';
import 'package:notey/features/todo/presentaion/cubit/todo_cubit.dart';
import 'package:notey/core/widgets/colors.dart';
import 'package:notey/injection_container.dart' as injection_container;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection_container.dart';

void main() async{
  await injection_container.init();

  // Initialize hive
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.app_local_db);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<TodoCubit>()..getTodoList()),
      ],
      child: GetMaterialApp(
        navigatorKey: Get.key,
        enableLog: true,
        defaultTransition: nav.Transition.cupertino,
        initialRoute: RoutesProvider.start,
        getPages: RoutesProvider.routes,
        title: "Notey",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: darkBlue,
            secondary: lightBlue,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          primaryIconTheme: IconThemeData(color: Colors.white),
          fontFamily: 'ceraRegular',
          //scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        navigatorObservers: [
        ],
      ),
    );
  }
}
