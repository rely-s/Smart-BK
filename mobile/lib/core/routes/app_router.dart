import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/main_shell_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final matchedLoc = state.matchedLocation;

        if (authState is AuthLoading) {
          return null;
        }

        if (authState is Authenticated) {
          if (matchedLoc == '/' || matchedLoc == '/login') {
            return '/home';
          }
          return null;
        }

        if (authState is Unauthenticated || authState is AuthInitial) {
          if (matchedLoc != '/login') {
            return '/login';
          }
          return null;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Memuat Smart BK Care...',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const MainShellScreen(),
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
