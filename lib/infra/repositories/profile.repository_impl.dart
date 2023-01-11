import 'package:finance_firebase/infra/repositories/profile.repository.dart';
import 'package:finance_firebase/infra/services/profile.service.dart';
import 'package:finance_firebase/models/profile.model.dart';
import 'package:finance_firebase/models/api_response.model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _service;

  ProfileRepositoryImpl(this._service);

  @override
  Future<APIResponse<Profile>> get() async {
    final documentSnapshot = await _service.get();
    final profile =
        Profile.fromFirestore(documentSnapshot.data() as Map<String, dynamic>);
    return APIResponse.success(profile);
  }

  @override
  Future<APIResponse<Profile>> update(Profile newProfile) async {
    final result = await _service.update(newProfile.toMap());
    if (result) {
      return APIResponse.success(newProfile);
    } else {
      return APIResponse.error("Falha na atualização");
    }
  }
}
