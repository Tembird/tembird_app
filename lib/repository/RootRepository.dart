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
        // TODO : Connect API to Get New Authenticator with RefreshToken
      }
      return request;
    });

    httpClient.maxAuthRetries = 1;
  }

  void errorHandler(Response response) {
    // TODO : Check Details for Error Handling
    switch (response.statusCode) {
      case 400: // Client Error : Bad Request
        showSnackbar(title: '잘못된 요청', message: response.body["message"]);
        throw Error();
      case 401: // Client Error : Unauthenticated
        accessToken = null;
        SessionService.to.quitSession();
        showSnackbar(title: '잘못된 요청', message: response.body["message"]);
        throw Error();
      case 403:
      // Client Error : Forbidden
        showSnackbar(title: '잘못된 요청', message: response.body["message"]);
        throw Error();
      case 409:
      // Client Error : Conflict
        throw Error();
      case 500:
      // throw "Server Error pls retry later";
        showSnackbar(title: '서버 오류', message: "서버에 문제가 있어요");
        throw Error();
      case 503:
        showSnackbar(title: '처리 실패', message: "요청 시간이 초과되었습니다");
        throw Error();
      default:
        showSnackbar(title: '서버 오류', message: "현재 상황을 개발자 피드백에 남겨주시면 더 좋은 서비스로 보답하겠습니다");
        throw Error();
    }
  }

  void showSnackbar({required String title, required String message}) {
    Get.snackbar(title, message, snackPosition: SnackPosition.TOP,
        backgroundColor: StyledPalette.STATUS_NEGATIVE,
        colorText: StyledPalette.WHITE,
        duration: const Duration(seconds: 2),
        onTap: (_) => Get.closeCurrentSnackbar(),
    );
  }
}