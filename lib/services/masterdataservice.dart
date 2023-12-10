part of 'services.dart';

class MasterDataService {
  static Future<List<Province>> getProvince() async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          "Content-Type": "application/json, charset=UTF-8",
          "key": Const.apiKey,
        });

    var job = json.decode(response.body);
    // print(job.toString());
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => Province.fromJson(e))
          .toList();
    }
    return result;
  }

  static Future<List<City>> getCity(var provId) async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/city"),
        headers: <String, String>{
          "Content-Type": "application/json, charset=UTF-8",
          "key": Const.apiKey,
        });

    var job = json.decode(response.body);
    List<City> result = [];
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromJson(e))
          .toList();
    }

    List<City> selectedCities = [];
    for (var c in result) {
      if (c.provinceId == provId) {
        selectedCities.add(c);
      }
    }

    return selectedCities;
  }

  static Future<List<Costs>> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    final Map<String, dynamic> requestData = {
      "origin": originId,
      "destination": destinationId,
      "weight": weight.toString(),
      "courier": courier.toString().toLowerCase(),
    };

    var response = await http.post(
      Uri.https(Const.baseUrl, "/starter/cost"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "key": Const.apiKey,
      },
      body: jsonEncode(requestData),
    );

    var job = json.decode(response.body);
    // print(job.toString());
    // List<Map<String, dynamic>> costs = job['rajaongkir']['results']['costs'];
    // print(costs);

    List<Costs> result = [];
    // List<Cost> result2 = [];
    // List akhir = [result, result2];
    if (response.statusCode == 200) {
      return (job['rajaongkir']['results'][0]['costs'] as List)
          .map((e) => Costs.fromJson(e))
          .toList();
      // result2 = (job['rajaongkir']['results'][0]['costs'][0]['cost'] as List<dynamic>)
      //     .map((e) => Cost.fromJson(e))
      //     .toList();
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
    // print(akhir[0]);
    // print(akhir[1]);
    // print(result);
    // print(result);
    return result;
  }
}
