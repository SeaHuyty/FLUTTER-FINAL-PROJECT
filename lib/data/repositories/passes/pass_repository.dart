import 'package:velo_toulouse_redesign/models/pass_model.dart';

abstract class PassRepository {
  Future<List<PassModel>> getAvailablePasses();

  Future<PassModel?> getPassById(String passId);

}