import 'package:finance_firebase/models/api_response.model.dart';
import 'package:finance_firebase/models/profile.model.dart';

abstract class ProfileRepository {
  Future<APIResponse<Profile>> get();
  Future<APIResponse<Profile>> update(Profile newProfile);
}
