import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:hive/hive.dart';
import 'package:tembird_app/constant/Common.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import '../service/SessionService.dart';

class RootRepository extends GetConnect {
  static String? accessToken;

  void initialization() {
    httpClient.baseUrl = FlutterConfig.get('API');
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(milliseconds: 3000);

    httpClient.addResponseModifier<dynamic>((request, response) async {
      String? tempAccessToken = response.headers![Common.accessTokenHeader];
      String? tempRefreshToken = response.headers![Common.refreshTokenHeader];

      if (tempAccessToken != null) {
        accessToken = tempAccessToken;
        await Hive.box(Common.session).put(Common.accessTokenHeader, tempAccessToken);
      }

      if (tempRefreshToken != null) {
        await Hive.box(Common.session).put(Common.refreshTokenHeader, tempRefreshToken);
      }

      return response;
    });

    httpClient.addRequestModifier((Request request) async {
      if (accessToken != null) {
        request.headers[Common.accessTokenHeader] = accessToken!;
      }
      return request;
    });

    httpClient.addAuthenticator((Request request) async {
      String? refreshToken = Hive.box(Common.session).get(Common.refreshTokenHeader);
      if (refreshToken != null) {
        // request.headers[Common.refreshTokenHeader] = refreshToken;
        // final response = await post('/user/refresh',null);
        // if(response.hasError) {
        //   errorHandler(response);
        // }
      }
      return request;
    });

    httpClient.maxAuthRetries = 1;
  }

  void errorHandler(Response response) {
    // TODO : Check Details for Error Handling
    switch (response.statusCode) {
      case 400: // Client Error : Bad Request
        showErrorSnackbar(message: response.body["message"]);
        throw Error();
      case 401: // Client Error : Unauthenticated
        accessToken = null;
        SessionService.to.quitSession();
        showErrorSnackbar(message: response.body["message"]);
        throw Error();
      case 403:
        // Client Error : Forbidden
        showErrorSnackbar(message: response.body["message"]);
        throw Error();
      case 404:
        // Client Error : Not Found
        showErrorSnackbar(message: response.body["message"]);
        throw Error();
      case 409:
        // Client Error : Conflict
        showErrorSnackbar(message: response.body["message"]);
        throw Error();
      case 500:
        // throw "Server Error pls retry later";
        showErrorSnackbar(message: "서버에 문제가 있어요");
        throw Error();
      case 503:
        showErrorSnackbar(message: "요청 시간이 초과되었습니다");
        throw Error();
      default:
        showErrorSnackbar(message: "현재 상황을 개발자 피드백에 남겨주시면 더 좋은 서비스로 보답하겠습니다");
        throw Error();
    }
  }

  void showErrorSnackbar({required String message}) {
    Get.snackbar(
      'Tembird',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: StyledPalette.STATUS_NEGATIVE,
      colorText: StyledPalette.WHITE,
      duration: const Duration(seconds: 2),
      onTap: (_) => Get.closeCurrentSnackbar(),
    );
  }

  void showAlertSnackbar({required String message}) {
    Get.snackbar(
      'Tembird',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: StyledPalette.GRAY,
      duration: const Duration(seconds: 2),
      onTap: (_) => Get.closeCurrentSnackbar(),
    );
  }
}
