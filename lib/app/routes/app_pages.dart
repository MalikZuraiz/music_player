import 'package:get/get.dart';

import '../modules/home_screen/bindings/home_screen_binding.dart';
import '../modules/home_screen/views/home_screen_view.dart';
import '../modules/player_screen/bindings/player_screen_binding.dart';
import '../modules/player_screen/views/player_screen_view.dart';
import '../modules/playlist_screen/bindings/playlist_screen_binding.dart';
import '../modules/playlist_screen/views/playlist_screen_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME_SCREEN,
      page: () => const HomeScreenView(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.PLAYLIST_SCREEN,
      page: () => PlaylistScreenView(),
      binding: PlaylistScreenBinding(),
    ),
    GetPage(
      name: _Paths.PLAYER_SCREEN,
      page: () => const PlayerScreenView(),
      binding: PlayerScreenBinding(),
    ),
  ];
}
