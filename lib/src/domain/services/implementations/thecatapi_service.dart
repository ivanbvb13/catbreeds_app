import 'package:catbreeds_app/src/domain/constants/const.dart';
import 'package:catbreeds_app/src/domain/models/cat.dart';
import 'package:catbreeds_app/src/domain/models/cat_detail.dart';
import 'package:catbreeds_app/src/domain/services/interfaces/i_thecatapi_service.dart';
import 'package:http/http.dart' as http;

class ThecatapiService implements ITheCatApiService {
  @override
  Future<List<Cat>> getListCats() async {
    try {
      var url = "$API_URL_BASE/v1/breeds";

      var headers = {
        "x-api-key": API_KEY,
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        List<Cat> cats = catFromJson(response.body);
        return cats;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<CatDetail?> getCatById(String id) async {
    try {
      var url = "$API_URL_BASE/v1/images/$id";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var catDetail = catDetailFromJson(response.body);
        return catDetail;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Cat>> searchCatByBreed(String query) async {
    try {
      // lista breeds
      var listBreeds = await getListCats();

      // filtrar por query
      var razasEncontradas = listBreeds.where((raza) {
        return raza.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      return razasEncontradas;
    } catch (e) {
      return [];
    }
  }
}
