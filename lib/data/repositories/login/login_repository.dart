import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:muscle_up_mobile/configs/data_base_schema_helper.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source.dart';
import 'package:muscle_up_mobile/domain/entities/core/http_response_entity.dart';
import 'package:muscle_up_mobile/core/library/extensions.dart';
import 'package:muscle_up_mobile/domain/entities/login/login_entity.dart';
import 'package:muscle_up_mobile/domain/error/login/login_exception.dart';

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
    debugPrint('antes');
    if (httpResponse == null) throw LoginNotFoundException();

    if (!httpResponse.toBool()) throw LoginNotFoundException();

    if (httpResponse.data == null) throw LoginNotFoundException();
    final String token = httpResponse.data as String;

    await _saveTokenAsync(token);

    return token;
  }

  Future<bool> _saveTokenAsync(String token) async {
    final result = await _nonRelationalDataSource.saveString(
      DataBaseNoSqlSchemaHelper.kUserToken,
      token,
    );

    return result ?? false;
  }

  String get _urlAuthentication =>
      _remoteDataSource.environment?.urlAuthentication ?? '';
}
