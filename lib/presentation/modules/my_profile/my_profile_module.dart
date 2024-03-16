import 'package:flutter/material.dart';
import 'package:movies_app/domain/usecases/usecases.dart';
import 'package:movies_app/presentation/modules/my_profile/my_profile_bloc.dart';
import 'package:provider/provider.dart';

import 'my_profile_screen.dart';

export './my_profile_screen.dart';

Future openProfile(BuildContext context) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) {
        return MultiProvider(
          providers: getMyProfileModule(),
          child: const MyProfileScreen(),
        );
      },
    ),
  );
}

List<InheritedProvider> getMyProfileModule() {
  List usecases = [];

  List blocs = [
    ProxyProvider<FetchWatchListUseCase, MyProfileBloC>(
      update: (_, u1, bloC) => bloC ?? MyProfileBloC(u1),
      dispose: (_, bloc) => bloc.dispose(),
    ),
  ];
  return [
    ...usecases,
    ...blocs,
  ];
}
