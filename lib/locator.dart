import 'package:catbreeds_app/src/domain/services/implementations/thecatapi_service.dart';
import 'package:catbreeds_app/src/domain/services/interfaces/i_thecatapi_service.dart';
import 'package:catbreeds_app/src/ui/controllers/landing_controller.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  // Domain
  locator.registerFactory<ITheCatApiService>(() => ThecatapiService());

  // UI
  locator.registerFactory<LandingController>(
      () => LandingController(locator<ITheCatApiService>()));
}
