import 'package:get/get.dart';
import 'package:lji/network_controller.dart';

class DependencyInjection {
  static void Init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
