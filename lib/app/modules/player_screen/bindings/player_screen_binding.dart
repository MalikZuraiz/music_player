import 'package:get/get.dart';

import '../controllers/player_screen_controller.dart';

class PlayerScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayerScreenController>(
      () => PlayerScreenController(),
    );
  }
}
