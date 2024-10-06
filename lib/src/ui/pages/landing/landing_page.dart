import 'package:catbreeds_app/locator.dart';
import 'package:catbreeds_app/src/domain/helpers/url_image_helper.dart';
import 'package:catbreeds_app/src/domain/models/cat.dart';
import 'package:catbreeds_app/src/ui/controllers/landing_controller.dart';
import 'package:catbreeds_app/src/ui/pages/detail/detail_page.dart';
import 'package:catbreeds_app/src/ui/shared/helper/navigator_helper.dart';
import 'package:catbreeds_app/src/ui/widgets/cat_breed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  static const route = '/';
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // controllers
  var landingController = Get.put(locator<LandingController>());

  final searchController = TextEditingController();

  final scrollController = ScrollController();

  bool isSearchVisible = false;

  @override
  void initState() {
    fetchCatBreeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CatBreeds',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearchVisible = true;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Sección de búsqueda de razas de gatos
          getSearchSection(),

          Expanded(
            child: getListaCardsCats(),
          ),
        ],
      ),
    );
  }

  Obx getListaCardsCats() {
    return Obx(() {
      var catsList = landingController.catsListRx.value;
      var isLoading = landingController.isLoadingRx.value;

      // si esta cargando, mostramos un indicador de carga
      if (isLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        );
      }

      // si la lista esta vacia, mostramos banner de si resultados y retornamos
      if (catsList.isEmpty && !isLoading) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No hay resultados'),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        itemCount: catsList.length,
        itemBuilder: (_, i) {
          var cat = catsList[i];

          return CatBreedCard(
            urlImagen: getImagenUrl(cat),
            nombreRaza: cat.name,
            paisOrigen: cat.origin,
            inteligencia: cat.intelligence.toString(),
            onTap: () {
              // Navegamos a la pagina de detalle
              NavigatorHelper.pushWithSlideTransition(
                  context, DetailPage(catId: cat.referenceImageId!));
            },
          );
        },
      );
    });
  }

  Future fetchCatBreeds() async {
    await landingController.fetchCatBreeds();
    FlutterNativeSplash.remove();
  }

  Widget getSearchSection() {
    if (!isSearchVisible) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onSubmitted: (value) async {
                await landingController.searchCatByBreed(value);
              },
              style: const TextStyle(color: Colors.black87),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () async {
                    await closeSearch();
                  },
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getImagenUrl(Cat cat) {
    if (cat.image == null) {
      return UrlImageHelper.getUrlImagenById(cat.referenceImageId);
    }

    return cat.image!.url;
  }

  Future closeSearch() async {
    setState(() {
      isSearchVisible = false;
    });
    searchController.clear();
    landingController.limpiarData();
    await landingController.fetchCatBreeds();
  }
}
