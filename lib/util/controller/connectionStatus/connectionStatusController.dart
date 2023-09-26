import 'dart:async';

import 'package:perusano/main.dart';
import 'package:perusano/util/controller/connectionStatus/connectionCheck.dart';
import 'package:get/get.dart';

class ConnectionStatusController extends GetxController {
  late StreamSubscription _connectionSubscription;

  final status = Rx<ConnectionStatus>(ConnectionStatus.offline);

  ConnectionStatusController() {
    _connectionSubscription = internetChecker
        .internetStatus()
        .listen((newStatus) => status.value = newStatus);
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}
