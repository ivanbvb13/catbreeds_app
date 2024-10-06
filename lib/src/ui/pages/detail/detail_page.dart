import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds_app/locator.dart';
import 'package:catbreeds_app/src/domain/models/cat_detail.dart';
import 'package:catbreeds_app/src/ui/controllers/detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  final String catId;

  const DetailPage({
    super.key,
    required this.catId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // controllers
  var detailController = Get.put(locator<DetailController>());

  var scrollController = ScrollController();

  @override
  void initState() {
    fetchCatById(widget.catId);
    super.initState();
  }

  @override
  void dispose() {
    detailController.limpiarData();
    super.dispose();
  }

  Future fetchCatById(String catId) async {
    await detailController.fetchCatById(catId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          var cat = detailController.catRx.value;

          return Text(cat?.breeds[0].name ?? '');
        }),
        centerTitle: true,
      ),
      body: Obx(() {
        var isLoading = detailController.isLoadingRx.value;
        var cat = detailController.catRx.value;

        if (isLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.black,
          ));
        }

        if (!isLoading && cat == null) {
          return const Center(
            child: Text('No se encontró información del gato'),
          );
        }

        return Column(
          children: [
            // seccion de imagen de gato
            getImagen(),
            // seccion de detalles del gato
            getInformacionGato(),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  Widget getImagen() {
    return Obx(() {
      var cat = detailController.catRx.value;

      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.48,
        child: Stack(
          children: [
            // fondo
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: CachedNetworkImage(
                    imageUrl: cat!.url,
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.3),
                    colorBlendMode: BlendMode.darken,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            // Imagen
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: cat.url,
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget getInformacionGato() {
    return Obx(() {
      var cat = detailController.catRx.value;
      var breeds = getBreeds(cat);

      if (breeds == null) {
        return const Center(
          child: Text('No se encontró información del gato'),
        );
      }

      return Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Descripción
                getInfo("Descripción", breeds.description),

                // Origen
                getInfo("Origen", breeds.origin),

                // Temperamento
                getInfo("Temperamento", breeds.temperament),

                // Esperanza de vida
                getInfo("Esperanza de vida", "${breeds.lifeSpan} años"),

                // Nivel de energía
                getInfo("Nivel de energía", breeds.energyLevel.toString()),

                // Nivel de afecto
                getInfo("Nivel de afecto", breeds.affectionLevel.toString()),

                // Amigable con niños
                getInfo("Amigable con niños", breeds.childFriendly.toString()),

                // Amigable con perros
                getInfo("Amigable con perros", breeds.dogFriendly.toString()),

                // Nivel de inteligencia
                getInfo(
                    "Nivel de inteligencia", breeds.intelligence.toString()),

                // Nivel de desprendimiento de pelo
                getInfo(
                    "Desprendimiento de pelo", breeds.sheddingLevel.toString()),

                // Nivel de vocalización
                getInfo("Vocalización", breeds.vocalisation.toString()),

                // Enlaces externos
                getInfo("Wikipedia", breeds.wikipediaUrl),
              ],
            ),
          ),
        ),
      );
    });
  }

  Column getInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(value),
        const SizedBox(height: 10),
      ],
    );
  }

  Breed? getBreeds(CatDetail? cat) {
    if (cat == null || cat.breeds.isEmpty) {
      return null;
    }
    return cat.breeds.first;
  }
}
