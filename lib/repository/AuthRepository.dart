import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tembird_app/constant/Common.dart';

import 'RootRepository.dart';

class AuthRepository extends RootRepository {
  static AuthRepository to = Get.find();

  AuthRepository() {
    initialization();
  }

  Future<void> sendVerificationEmail({required String email}) async {
    Map<String, dynamic> data = {
      'email': email,
    };

    // final response = await post('/users/send-verification-code', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<bool> checkVerificationCode({required String email, required String code}) async {
    Map<String, dynamic> data = {
      'email': email,
      'code': code,
    };

    // final response = await post('/users/check-verification-code', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    //   return false;
    // }
    return true;
  }

  Future<void> signup({required String email, required String password}) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    // final Response response = await post('/users/signup', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<void> updatePassword({required String email, required String password}) async {
    Map<String, dynamic> data = {'email': email, 'password': password};

    // final Response response = await patch('/users/update-password', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<void> updatePasswordWithCurrentPassword({required String email, required String currentPassword, required String newPassword}) async {
    Map<String, dynamic> data = {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    // final Response response = await patch('/users/update-password', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<void> updateId({required String userId}) async {
    Map<String, dynamic> data = {'userId': userId};

    // final Response response = await patch('/users/update-password', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<bool> checkPossibleId({required String userId}) async {
    Map<String, dynamic> data = {'userId': userId};

    return false;

    // final Response response = await patch('/users/update-password', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<void> login({required String email, required String password}) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    // final Response response = await post('/users/login', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }

  Future<void> signOut() async {
    await Hive.box(Common.session).delete(Common.accessTokenHeader);
    await Hive.box(Common.session).delete(Common.refreshTokenHeader);
  }

  Future<void> removeAccount({required String email, required String password}) async {
    Map<String, dynamic> data = {'email': email, 'password': password};

    // final Response response = await patch('/users/update-password', jsonEncode(data));
    // if (response.hasError) {
    //   errorHandler(response);
    // }
  }
}
