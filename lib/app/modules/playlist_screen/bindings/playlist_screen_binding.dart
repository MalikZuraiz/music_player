import 'package:get/get.dart';

import '../controllers/playlist_screen_controller.dart';

class PlaylistScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistScreenController>(
      () => PlaylistScreenController(),
    );
  }
}
