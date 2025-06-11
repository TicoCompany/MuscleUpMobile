import 'package:muscle_up_mobile/configs/factory_viewmodel.dart';
import 'package:muscle_up_mobile/data/datasources/core/data_source_factory.dart';
import 'package:muscle_up_mobile/data/repositories/login/login_repository.dart';
import 'package:muscle_up_mobile/data/repositories/login/fake_login_repository.dart';
import 'package:muscle_up_mobile/ui/login/view_models/login_viewmodel.dart';

final class LoginFactoryViewModel implements IFactoryViewModel<LoginViewModel> {
  @override
  LoginViewModel create(BuildContext context) {
    final IRemoteDataSource remoteDataSource =
        RemoteFactoryDataSource().create();
    final INonRelationalDataSource nonRelationalDataSource =
        NonRelationalFactoryDataSource().create();
   /* final ILoginRepository loginRepository = LoginRepository(
      remoteDataSource,
      nonRelationalDataSource,
    );*/

    final ILoginRepository loginRepository = FakeLoginRepository(nonRelationalDataSource);

    return LoginViewModel(loginRepository);
  }

  @override
  void dispose(BuildContext context, LoginViewModel viewModel) {
    viewModel.close();
  }
}
