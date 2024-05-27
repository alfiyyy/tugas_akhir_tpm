import 'base_network.dart';

class ApiDataSource {
  static ApiDataSource instance = ApiDataSource();

  Future<dynamic> loadApi() {
    return BaseNetwork.get("api");
  }
}
