import 'package:catbreeds_app/src/domain/models/cat_detail.dart';
import 'package:catbreeds_app/src/domain/services/interfaces/i_thecatapi_service.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  final ITheCatApiService _theCatApiService;

  DetailController(this._theCatApiService);

  // Rx variables
  var isLoadingRx = RxBool(false);
  var catRx = Rx<CatDetail?>(null);

  void limpiarData() {
    isLoadingRx.value = false;
    catRx.value = null;
  }

  Future fetchCatById(String catId) async {
    isLoadingRx.value = true;

    try {
      var catResponse = await _theCatApiService.getCatById(catId);

      catRx.value = catResponse;
    } catch (e) {
      print(e);
    } finally {
      isLoadingRx.value = false;
    }
  }
}
