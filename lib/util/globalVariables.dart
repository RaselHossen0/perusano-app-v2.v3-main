import 'package:get/get.dart';
import '../util/controller/connectionStatus/connectionCheck.dart';
import '../util/controller/connectionStatus/connectionStatusController.dart';

enum Languages { ES, EN }

class GlobalVariables {
  static String appName = 'PERUSANO';

  static String language = 'ES';
  //static String endpoint = 'http://10.0.2.2:3000';
  //static String endpoint = 'localhost:3000';
  static String endpoint =
      'https://c835-2800-bf0-8162-f01-c49a-15db-d009-873d.sa.ngrok.io';
  //static String endpoint = 'http://127.0.0.1:3000';

  static String logosAddress = 'assets/images/';
  static String logosCREDAddress = 'assets/images/cred/';
  static String publicAddress = 'assets/images/public/';
  static String recipesAddress = 'assets/images/recipes';

  static Future<bool> isConnected() async {
    final internetController = await Get.put(ConnectionStatusController());
    print('Dentro del IsConnected');
    print(internetController.status.value);
    print("Always false for now");
    return false;
    if (internetController.status.value == ConnectionStatus.online) {
      return true;
    } else {
      return false;
    }
  }
}
