
import 'amicane_caller_platform_interface.dart';

class AmicaneCaller {
  Future<String?> placeCall(String phone) {
    return AmicaneCallerPlatform.instance.placeCall(phone);
  }
}
