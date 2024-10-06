import 'package:catbreeds_app/src/domain/models/cat.dart';
import 'package:catbreeds_app/src/domain/models/cat_detail.dart';

abstract class ITheCatApiService {
  /// Metodo que nos permite hacer una peticion a la api de thecatapi para obtener una lista de gatos 
  Future<List<Cat>> getListCats();

  /// Metodo que nos permite hacer una peticion a la api de thecatapi para obtener un gato por su id
  Future<CatDetail?> getCatById(String id);

  /// Metodo que nos permite buscar una raza de gato por su raza
  Future<List<Cat>> searchCatByBreed(String query);
}
