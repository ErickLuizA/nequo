import 'package:nequo/domain/services/network_info_service.dart';

class NetworkInfoServiceImpl implements NetworkInfoService {
  @override
  Future<bool> get isConnected => Future.value(false);
}
