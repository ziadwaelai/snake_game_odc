import 'package:flutter/material.dart';
import 'package:odc_game/layout/cubit/cubit.dart';
import 'package:odc_game/layout/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odc_game/layout/homeScreen.dart';
import 'package:odc_game/shered/cacheHelper.dart';
import 'layout/cubit/blocObserver/blocObserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            home: HomePage(),
          );
        },
      ),
    );
  }
}
