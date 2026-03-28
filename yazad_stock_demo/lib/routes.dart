import 'package:go_router/go_router.dart';
import 'screens/home_screen/page/home_screen.dart';
import 'screens/watch_list_reodering_screen/page/reorder_watchlist_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/reorder/:tabName',
      name: 'reorder',
      builder: (context, state) {
        final tabName = state.pathParameters['tabName']!;
        return WatchlistReorderScreen(tabName: tabName);
      },
    ),
  ],
);
