import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nequo/domain/services/network_info_service.dart';

class NetworkInfoServiceImpl implements NetworkInfoService {
  @override
  Future<bool> get isConnected => InternetConnectionChecker().hasConnection;
}
