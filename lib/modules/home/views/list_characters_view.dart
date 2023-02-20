import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marvel_app/core/base/base_view.dart';
import 'package:marvel_app/core/model/general_view_model_list.dart';
import 'package:marvel_app/core/values/app_assets.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'package:marvel_app/core/values/app_values.dart';
import 'package:marvel_app/core/widgets/custom_app_bar.dart';
import 'package:marvel_app/modules/home/controllers/home_controller.dart';
import 'package:marvel_app/modules/home/widgets/item_character_widget.dart';
import 'package:marvel_app/modules/home/widgets/load_more_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

/// Esta clase es una vista que extiende la clase BaseView y utiliza el HomeController, y muestra una lista de caracteres y m
// ignore: must_be_immutable
class ListCharactersView extends BaseView<HomeController> {
  late RefreshController _refreshController;
  late String searchTerm = "";

  ListCharactersView({super.key}) {
    _refreshController = RefreshController(initialRefresh: false);

    controller.getCharactersList("", true);
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      appBarTitleText: 'Lista de personajes de marvel',
    );
  }

  @override
  Widget body(BuildContext context) {
    return Stack(
      children: [_listViewGeneral(), _headerList(), _progressBar()],
    );
  }

  /// Si el loadingData del controlador es true, muestra una barra de progreso, en caso contrario muestra un contenedor vacío
  ///
  /// Devuelve:
  /// Un widget.
  Widget _progressBar() {
    return Obx(() => controller.loadingData
        ? const LinearProgressIndicator(
            backgroundColor: Colors.red,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          )
        : Container());
  }

  /// _headerList() devuelve un widget que se sitúa en la parte superior de la pantalla, y contiene una barra de búsqueda
  /// y un widget de información de búsqueda
  ///
  /// Devuelve:
  /// Un widget.
  Widget _headerList() {
    return GetBuilder<HomeController>(builder: (value) {
      return Positioned(
        left: AppValues.padding,
        right: AppValues.padding,
        top: AppValues.paddingInfoTop,
        child: Column(
          children: [
            _widgetSearch(!value.loadingData),
            const SizedBox(
              height: AppValues.padding15,
            ),
            _searchInfo(value),
          ],
        ),
      );
    });
  }

  /// _listViewGeneral() contiene una definicion de una lista con paginacion
  /// Returns:
  ///   A Widget.
  Padding _listViewGeneral() {
    return Padding(
        padding: const EdgeInsets.only(
            bottom: AppValues.padding,
            left: AppValues.padding,
            right: AppValues.padding,
            top: AppValues.paddingSearchTop),
        child: GetBuilder<HomeController>(
            init: controller,
            builder: (_) {
              if (_.charactersList.status == StatusViewModel.error) {
                _refreshController.loadFailed();
              } else {
                _refreshController.refreshToIdle();
              }

              if (_.charactersList.list.isEmpty) {
                if (_.charactersList.status == StatusViewModel.error) {
                  return _emptyListWidget("Hubo error al cargar los datos");
                }
                return _emptyListWidget("No hay elementos");
              }

              return RefreshConfiguration.copyAncestor(
                  context: Get.context!,
                  enableBallisticLoad: false,
                  footerTriggerDistance: -20,
                  maxUnderScrollExtent: 20,
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    footer: CustomFooter(builder: (context, mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text("Cargar mas elementos");
                      } else if (mode == LoadStatus.loading) {
                        body = const LoadMoreWidget();
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("La carga falló");
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text("Cargar mas elementos");
                      } else {
                        body = const Text("No hay mas elementos que cargar");
                      }
                      return Center(
                        child: SizedBox(
                          height: 55.0,
                          child: Center(child: body),
                        ),
                      );
                    }),
                    child: ListView.separated(
                      itemBuilder: (c, index) {
                        if (_.charactersList.list.isEmpty) {
                          return Container();
                        }
                        var model = _.charactersList.list[index];
                        return ItemCharacter(
                          dataModel: model,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Padding(
                        padding: EdgeInsets.only(bottom: AppValues.bottonMargin),
                        child: SizedBox(height: AppValues.smallMargin),
                      ),
                      itemCount: _.charactersList.list.length,
                    ),
                  ));
            }));
  }

  /// _searchInfo() es una función que devuelve un widget Fila que contiene dos widgets Texto
  ///
  /// Args:
  ///   value (HomeController): HomeController

  Widget _searchInfo(HomeController value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("Total de personajes ${value.charactersList.totalRows}"),
        Text("Total cargados ${value.charactersList.list.length}")
      ],
    );
  }

  /// _widgetSearch(bool enabled) establece un widget con texto de búsqueda
  ///
  /// Args:
  ///   enabled (bool),
  ///
  /// Returns:
  ///   A TextField widget.

  Widget _widgetSearch(bool enabled) {
    return TextField(
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        autofocus: false,
        enabled: enabled,
        readOnly: !enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.colorSearch,
          ),
          hintTextDirection: TextDirection.ltr,
          hintMaxLines: 1,
          hintText: "Buscar por nombre",
          hintStyle: TextStyle(fontSize: 13, color: AppColors.colorSearch),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          filled: true,
          contentPadding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 6),
          fillColor: Colors.white,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) async {
          searchTerm = value;
          await controller.getCharactersList(value, true);
        });
  }

  /// Devuelve un widget que muestra un mensaje y una imagen
  ///
  /// Args:
  /// mensaje (Cadena): El mensaje que se mostrará en el centro de la pantalla.
  ///
  /// Returns:
  ///   A widget.
  Widget _emptyListWidget(String message) {
    return Center(
        child: ListView(
      children: <Widget>[
        Container(
          height: Get.height / 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 150,
            width: 150,
            child: Image.asset(AppAssets.emptyList, fit: BoxFit.fitHeight),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    ));
  }

  /// _onRefresh() es una función que se llama cuando el usuario tira hacia abajo de la lista para refrescarla. Llama a
  /// la función getCharactersList() en el controlador, que es la función que hace la llamada a la API
  Future _onRefresh() async {
    await controller.getCharactersList(searchTerm, false);

    _refreshController.refreshCompleted();
  }

  /// _onLoading() es llamada cuando el usuario se desplaza al final de la lista. Llama a la función
  /// getCharactersList() en el controlador, que realiza una llamada de red a la API y devuelve una
  /// lista de caracteres
  void _onLoading() async {
    await controller.getCharactersList(searchTerm, false);

    _refreshController.loadComplete();
  }
}
