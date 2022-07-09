import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String? url;
  NetworkHelper({required this.url});
  Future getData() async {
    print('getData() called');
    String link = url ?? '';
    Uri weatherUrl = Uri.parse(link);
    print('uri formed: $weatherUrl');
    http.Response response = await http
        .get(weatherUrl); //an asynchronous method, returns a future response
    //use async and await to wait for the response, since the get method is asynchronous
    if (response.statusCode == 200) {
      var responseData = response.body;
      var decodedData = jsonDecode(responseData);
      return decodedData;
    } else {
      print('Error: ');
      print(response.statusCode);
    }
    print('leaving getData()');
  }
}
