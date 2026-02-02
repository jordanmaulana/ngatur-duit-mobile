import 'package:ngatur_duit_mobile/api/dio_client.dart';
import 'package:ngatur_duit_mobile/apps/auth/repo/auth_repo.dart';
import 'package:ngatur_duit_mobile/apps/profile/repo/profile_repo.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  GetStorage,
  DioClient,

  /// Add objects to be mocked here.
  ProfileRepo,
  AuthRepo,
])
void main() {}
