import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marvel_app/core/base/base_controller.dart';
import 'package:marvel_app/core/model/page_state.dart';
import 'package:marvel_app/core/values/app_colors.dart';
import 'package:marvel_app/core/widgets/loading_widget.dart';

/// BaseView es una clase abstracta que extiende de la clase GetView de la librería get para Flutter.
/// La clase BaseView está diseñada para ser utilizada como clase base para todas las vistas de la aplicación Flutter.
abstract class BaseView<Controller extends BaseController> extends GetView<Controller> {
  ///globalKey es una variable que guarda una clave para un Scaffold, un widget de Flutter que proporciona una estructura visual básica para una pantalla.
  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  BaseView({super.key});

  /// body es un método abstracto que debe ser implementado por cualquier clase que extienda BaseView. Este método devuelve el contenido principal de la vista.
  Widget body(BuildContext context);

  /// appBar es un método abstracto que debe ser implementado por cualquier clase que extienda BaseView. Este método devuelve la barra de aplicación superior de la vista.
  PreferredSizeWidget? appBar(BuildContext context);

  /// Construye y retorna un Widget que representa la pantalla.
  ///
  /// [context]: El contexto actual de la pantalla.
  ///
  /// Retorna un Widget que define la interfaz de usuario de la pantalla.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          annotatedRegion(context),
          Obx(() {
            return controller.pageState == PageState.loading ? _showLoading() : Container();
          }),
          Obx(() {
            return controller.errorMessage.isNotEmpty ? showErrorSnackBar(controller.errorMessage) : Container();
          }),
          Container(),
        ],
      ),
    );
  }

  /// Retorna un Widget AnnotatedRegion que define el estilo de la barra de estado para la pantalla.
  ///
  /// [context]: El contexto actual de la pantalla.
  ///
  /// Retorna un Widget que contiene un Widget AnnotatedRegion que define el estilo de la barra de estado y un Widget Material que contiene el resto de la interfaz de usuario de la pantalla.
  Widget annotatedRegion(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        //Status bar color for android
        statusBarColor: statusBarColor(),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Material(
        color: Colors.transparent,
        child: pageScaffold(context),
      ),
    );
  }

  /// Devuelve un Scaffold que se utiliza como página principal de la vista.
  /// Define el color de fondo y la AppBar, y luego define el cuerpo
  /// con la función pageContent().
  ///
  /// [context]: El contexto actual de la aplicación.
  Widget pageScaffold(BuildContext context) {
    return Scaffold(
      //sets ios status bar color
      backgroundColor: pageBackgroundColor(),
      key: globalKey,
      appBar: appBar(context),
      body: pageContent(context),
    );
  }

  /// Devuelve un SafeArea que contiene el cuerpo de la página. El cuerpo se define
  /// utilizando la función `body()`.
  ///
  /// [context]: El contexto actual de la aplicación
  Widget pageContent(BuildContext context) {
    return SafeArea(
      child: body(context),
    );
  }

  /// Muestra una Snackbar con un mensaje de error.
  ///
  /// [message]: El mensaje que se mostrará en la Snackbar.
  Widget showErrorSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.snackbar("Error", message,
          colorText: AppColors.appBarTextColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.colorError);
    });

    return Container();
  }

  /// Devuelve el color de fondo de la página actual.
  Color pageBackgroundColor() {
    return AppColors.pageBackground;
  }

  /// Devuelve el color de la barra de estado de la página actual.
  Color statusBarColor() {
    return AppColors.pageBackground;
  }

  /// Devuelve un widget de carga que se muestra cuando el estado de la página
  /// es 'loading'.
  Widget _showLoading() {
    return const LoadingWidget();
  }
}
