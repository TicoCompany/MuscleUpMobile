import 'package:muscle_up_mobile/configs/data_base_schema_helper.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source.dart';
import 'package:muscle_up_mobile/domain/entities/login/login_entity.dart';
import 'package:muscle_up_mobile/domain/error/login/login_exception.dart';
import 'package:muscle_up_mobile/domain/entities/login/login_response_entity.dart';
import 'package:muscle_up_mobile/domain/entities/core/http_response_entity.dart';
import 'package:muscle_up_mobile/data/repositories/login/login_repository.dart';

final class FakeLoginRepository implements ILoginRepository {
  final INonRelationalDataSource _nonRelationalDataSource;

  const FakeLoginRepository(this._nonRelationalDataSource);

  @override
  Future<String> authenticationAsync(LoginEntity login) async {
    // Simula delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    // Aqui você pode validar contra um login fixo se quiser simular erro também
    if (login.login == 'teste@muscleup.com' && login.password == '123456') {
      final fakeResponse = LoginResponseEntity(
        token: 'fake_token_abc123',
        userId: 'fake_user_001',
      );

      await _saveCredentialsAsync(fakeResponse);
  
      return fakeResponse.token;
    } else {
      // Simula falha de login
      throw LoginNotFoundException();
    }
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
}
