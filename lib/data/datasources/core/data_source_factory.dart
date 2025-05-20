import 'package:muscle_up_mobile/configs/environment_helper.dart';
import 'package:muscle_up_mobile/configs/injection_conteiner.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source.dart';
import 'package:muscle_up_mobile/data/datasources/core/non_relational_datasource.dart';
import 'package:muscle_up_mobile/data/datasources/core/relational_datasource.dart';
import 'package:muscle_up_mobile/data/datasources/core/remote_datasource.dart';
import 'package:muscle_up_mobile/core/service/clock_helper.dart';
import 'package:muscle_up_mobile/core/service/http_service.dart';
import 'package:muscle_up_mobile/core/service/storage_service.dart';

final class NonRelationalFactoryDataSource {
  INonRelationalDataSource create() {
    final IStorageService storageService = getIt<IStorageService>();
    final IClockHelper clockHelper = ClockHelper();

    return NonRelationalDataSource(storageService, clockHelper);
  }
}

final class RelationalFactoryDataSource {
  IRelationalDataSource create() {
    final IStorageService storageService = getIt<IStorageService>();
    final IClockHelper clockHelper = ClockHelper();

    return RelationalDataSource(storageService, clockHelper);
  }
}

final class RemoteFactoryDataSource {
  IRemoteDataSource create() {
    final IHttpService httpService = HttpServiceFactory().create();
    final IEnvironmentHelper environmentHelper = getIt<IEnvironmentHelper>();
    final IClockHelper clockHelper = ClockHelper();
    return RemoteDataSource(httpService, environmentHelper, clockHelper);
  }
}
