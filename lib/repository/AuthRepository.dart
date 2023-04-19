import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tembird_app/constant/Common.dart';

import '../model/User.dart';
import 'RootRepository.dart';

class AuthRepository extends RootRepository {
  static AuthRepository to = Get.find();

  AuthRepository() {
    initialization();
  }

  Future<User> getUserInfo() async {
    final response = await get('/user');
    if (response.hasError) {
      errorHandler(response);
    }
    User result = User.fromJson(response.body['body']);
    return result;
  }

  Future<void> requestVerificationEmail({required String email}) async {
    Map<String, dynamic> data = {
      'email': email,
    };

    final response = await post('/verification/send', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> checkVerificationCode({required String email, required String code}) async {
    Map<String, dynamic> data = {
      'email': email,
      'code': int.parse(code),
    };

    final response = await post('/verification/check', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> signup({required String email, required String password}) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final Response response = await post('/user/sign-up', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> resetPassword({required String email, required String password}) async {
    Map<String, dynamic> data = {'email': email, 'password': password};

    final Response response = await put('/user/reset-password', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> updatePasswordWithCurrentPassword({required String currentPassword, required String newPassword}) async {
    Map<String, dynamic> data = {
      'password': currentPassword,
      'newPassword': newPassword,
    };

    final Response response = await put('/user/update-password', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> updateUsername({required String username}) async {
    Map<String, dynamic> data = {'username': username};

    final Response response = await put('/user/username', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> login({required String email, required String password}) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final Response response = await post('/user/login', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> signOut() async {
    await Hive.box(Common.session).delete(Common.accessTokenHeader);
    await Hive.box(Common.session).delete(Common.refreshTokenHeader);
  }

  Future<void> removeAccount({required String password}) async {
    Map<String, dynamic> data = {'password': password};

    final Response response = await put('/user/remove', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }

  Future<void> updateUserHistory({required String platform, required String platformVersion, required int buildNum}) async {
    Map<String, dynamic> data = {
      'platform': platform,
      'platformVersion': platformVersion,
      'buildNum': buildNum,
    };

    final Response response = await put('/user/device', jsonEncode(data));
    if (response.hasError) {
      errorHandler(response);
    }
  }


}
