import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:hive/hive.dart';
import 'package:tembird_app/constant/Common.dart';
import 'package:tembird_app/constant/StyledFont.dart';
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
      accessToken ??= Hive.box(Common.session).get(Common.accessTokenHeader);
      if (accessToken == null) return request;
      request.headers[Common.accessTokenHeader] = accessToken!;
      return request;
    });

    httpClient.addAuthenticator((Request request) async {
      String? refreshToken = await Hive.box(Common.session).get(Common.refreshTokenHeader);
      if (refreshToken == null || accessToken == null) return request;

      final response = await post('/user/refresh', null, headers: {
        Common.accessTokenHeader: accessToken!,
        Common.refreshTokenHeader: refreshToken,
      });
      if (response.hasError) {
        if (response.statusCode == 403) {
          showErrorDialog(message: '다시 로그인해주세요');
          await Future.delayed(const Duration(seconds: 1));
          SessionService.to.quitSession();
          accessToken = null;
        } else {
          errorHandler(response);
        }
      }
      String? tempAccessToken = response.headers![Common.accessTokenHeader];

      if (tempAccessToken != null) {
        accessToken = tempAccessToken;
        await Hive.box(Common.session).put(Common.accessTokenHeader, tempAccessToken);
      }
      return request;
    });

    httpClient.maxAuthRetries = 1;
  }

  void errorHandler(Response response) {
    // TODO : Check Details for Error Handling
    switch (response.statusCode) {
      case 400: // Client Error : Bad Request
        showErrorDialog(message: response.body["message"]);
        throw ArgumentError(response.body["message"]);
      case 401:
        return;
      case 403:
        // Client Error : Not Authorization
        accessToken = null;
        showErrorDialog(message: response.body["message"]);
        throw ArgumentError(response.body["message"]);
      case 404:
        // Client Error : Not Found
        showErrorDialog(message: response.body["message"]);
        throw ArgumentError(response.body["message"]);
      case 409:
        // Client Error : Conflict
        showErrorDialog(message: response.body["message"]);
        throw ArgumentError(response.body["message"]);
      case 500:
        // throw "Server Error pls retry later";
        showErrorDialog(message: "서버에 문제가 있어요");
        throw ArgumentError(response.body["message"]);
      case 503:
        showErrorDialog(message: "요청 시간이 초과되었습니다");
        throw ArgumentError(response.body["message"]);
      default:
        showErrorDialog(message: "현재 상황을 개발자 피드백에 남겨주시면 더 좋은 서비스로 보답하겠습니다");
        throw ArgumentError('알 수 없는 에러');
    }
  }

  void showErrorDialog({required String message}) {
    Get.dialog(
      AlertDialog(
        content: Text(
          message,
          style: StyledFont.FOOTNOTE,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void showAlertSnackbar({required String message}) {
    Get.snackbar(
      'Tembird',
      message,
      instantInit: false,
      snackPosition: SnackPosition.TOP,
      backgroundColor: StyledPalette.GRAY,
      duration: const Duration(seconds: 2),
      onTap: (_) => Get.closeCurrentSnackbar(),
    );
  }
}
