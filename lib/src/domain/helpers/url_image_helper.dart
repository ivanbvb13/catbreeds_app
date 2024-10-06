import 'package:catbreeds_app/src/domain/constants/const.dart';

class UrlImageHelper {
  static String getUrlImagenById(String? id, {String extencion = "jpg"}) {
    if (id == null) {
      return PLACEHOLDER_CAT_IMAGE;
    }

    return '$PATH_URL_BASE_IMAGEN/$id.$extencion';
  }
}
