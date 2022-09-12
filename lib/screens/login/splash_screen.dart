import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sillyhouseorg/bloc/app/cubit.dart';
import '../../bloc/user/cubit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppCubit appCubit = AppCubit();
  late UserCubit userCubit;

  @override
  void initState() {
    super.initState();
    userCubit = context.read<UserCubit>();
    appCubit.checkUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<AppCubit, AppState>(
        bloc: appCubit,
        listener: _appBlocListener,
      ),
      BlocListener<UserCubit, UserState>(
        bloc: userCubit,
        listener: _userCubitListener,
      ),
    ], child: buildScreen());
  }

  void _appBlocListener(BuildContext context, AppState state) {
    if (state is OldVersion) {
      Navigator.pushNamed(context, '/update');
    }
    if (state is LatestVersion) {
      if (context.read<UserCubit>().state.user == null) {
        Navigator.pushNamed(context, '/greeting');
      } else {
        Navigator.pushNamed(context, '/mainPage');
      }
    }
  }

  void _userCubitListener(BuildContext context, UserState state) {
    if (state.user != null) {
      Navigator.pushNamed(context, '/mainPage');
    } else if (state.user == null) {
      Navigator.pushNamed(context, '/greeting');
    }
  }

  Widget buildScreen() {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('lib/assets/logo.png'),
          SizedBox(height: 20),
          SvgPicture.asset('lib/assets/home_header.svg', height: 25),
        ],
      )),
    );
  }
}
