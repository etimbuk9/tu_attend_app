import 'package:http/http.dart';
import 'dart:convert';

class Networker {
  Networker(this.url);
  Uri url;

  Future syncData(attendInfo) async {
    Response response = await post(
      url,
      body: attendInfo,
    );
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else {
      return response.statusCode;
    }
  }
}
