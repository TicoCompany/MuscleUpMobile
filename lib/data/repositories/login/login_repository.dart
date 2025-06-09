import 'dart:convert';

import 'package:muscle_up_mobile/configs/data_base_schema_helper.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source.dart';
import 'package:muscle_up_mobile/domain/entities/core/http_response_entity.dart';
import 'package:muscle_up_mobile/core/library/extensions.dart';
import 'package:muscle_up_mobile/domain/entities/login/login_entity.dart';
import 'package:muscle_up_mobile/domain/error/login/login_exception.dart';
import 'package:muscle_up_mobile/domain/entities/login/login_response_entity.dart';

abstract interface class ILoginRepository {
  Future<String>? authenticationAsync(LoginEntity login);
}

final class LoginRepository implements ILoginRepository {
  final IRemoteDataSource _remoteDataSource;
  final INonRelationalDataSource _nonRelationalDataSource;

  const LoginRepository(this._remoteDataSource, this._nonRelationalDataSource);

  @override
Future<String> authenticationAsync(LoginEntity login) async {
  final HttpResponseEntity? httpResponse = await _remoteDataSource.post(
    _urlAuthentication,
    jsonEncode(login.toMap()),
  );

  if (httpResponse == null || !httpResponse.toBool() || httpResponse.data == null) {
    throw LoginNotFoundException();
  }

  final responseMap = httpResponse.data as Map<String, dynamic>;
  final loginResponse = LoginResponseEntity.fromMap(responseMap);

  await _saveCredentialsAsync(loginResponse);

  return loginResponse.token;
}

Future<void> _saveCredentialsAsync(LoginResponseEntity loginResponse) async {
  await _nonRelationalDataSource.saveString(
    DataBaseNoSqlSchemaHelper.kUserToken,
    loginResponse.token,
  );

  await _nonRelationalDataSource.saveString(
    DataBaseNoSqlSchemaHelper.kUserId,
    loginResponse.userId,
  );
}

  String get _urlAuthentication =>
      _remoteDataSource.environment?.urlAuthentication ?? '';
}
