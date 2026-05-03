import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restapi/data/repositories/hewan_repository.dart';

// import halaman & bloc kamu
import 'package:restapi/logic/bloc/auth/auth_bloc.dart';
import 'package:restapi/data/repositories/auth_repository.dart';
import 'package:restapi/logic/bloc/hewan/hewan_bloc.dart';
import 'package:restapi/logic/ui/pages/add_hewan_page.dart';
import 'package:restapi/logic/ui/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ✅ AuthBloc untuk login
        BlocProvider(
          create: (context) => AuthBloc(
            repository: AuthRepository(),
          ),
        ),
        BlocProvider(
          create:(context)=>HewanBloc(
            repository:HewanRepository(),
          )
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // ✅ HALAMAN PERTAMA
        home: const LoginPage(),
      ),
    );
  }
}