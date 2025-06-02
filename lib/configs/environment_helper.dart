abstract interface class IEnvironmentHelper {
  String? get urlAuthentication;
  String? get urlWorkout;
}

final class EnvironmentHelper implements IEnvironmentHelper {
  const EnvironmentHelper();

  String get _urlBase => 'https://localhost:8080';

  @override
  String? get urlAuthentication => '$_urlBase/authentication';

  @override
  String? get urlWorkout => '$_urlBase/workout';
}
