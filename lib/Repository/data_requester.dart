import 'package:http/http.dart' as http;

class DataRequest {
  final url;
  DataRequest(this.url);

  Future<String> get_raw_data() async {
    http.Response response = await http.get(url);
    return response.body;
    print(response.body);
  }
}
