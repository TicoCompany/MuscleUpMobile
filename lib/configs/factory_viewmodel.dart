import 'package:flutter/material.dart';

export 'package:flutter/material.dart';
export 'package:muscle_up_mobile/configs/environment_helper.dart';
export 'package:muscle_up_mobile/configs/injection_conteiner.dart';
export 'package:muscle_up_mobile/data/datasources/core/data_source.dart';
export 'package:muscle_up_mobile/data/datasources/core/non_relational_datasource.dart';
export 'package:muscle_up_mobile/data/datasources/core/relational_datasource.dart';
export 'package:muscle_up_mobile/core/service/app_service.dart';
export 'package:muscle_up_mobile/core/service/clock_helper.dart';
export 'package:muscle_up_mobile/core/service/storage_service.dart';

abstract interface class IFactoryViewModel<T> {
  T create(BuildContext context);
  void dispose(BuildContext context, T viewModel);
}
