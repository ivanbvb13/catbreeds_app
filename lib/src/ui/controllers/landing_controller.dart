import 'package:catbreeds_app/src/domain/models/cat.dart';
import 'package:catbreeds_app/src/domain/services/interfaces/i_thecatapi_service.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  final ITheCatApiService _theCatApiService;

  LandingController(this._theCatApiService);

  // Rx variables
  var catsListRx = Rx<List<Cat>>([]);
  var isLoadingRx = RxBool(false);

  void limpiarData() {
    catsListRx.value = [];
  } 

  Future fetchCatBreeds() async {
    isLoadingRx.value = true;
    var catsRequest = await _theCatApiService.getListCats();
    catsListRx.value = catsRequest;
    isLoadingRx.value = false;
  }

  Future fetchCatById(String id) async {
    var catsRequest = await _theCatApiService.getCatById(id);
    return catsRequest;
  } 

  Future searchCatByBreed(String query) async {
    isLoadingRx.value = true;
    catsListRx.value = [];
    var catsRequest = await _theCatApiService.searchCatByBreed(query);
    catsListRx.value = catsRequest;
    isLoadingRx.value = false;
  }
}
