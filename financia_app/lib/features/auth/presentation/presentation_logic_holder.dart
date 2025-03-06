import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../injection_container.dart';
import '../../auth/domain/usecases/auth_usecases.dart';
import 'viewmodels/auth_viewmodel.dart';

class PresentationLogicHolder extends StatelessWidget {
  final Widget child;
  const PresentationLogicHolder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(sl<AuthUseCases>()),
        ),
        // Add other providers as needed
      ],
      child: child,
    );
  }
}
