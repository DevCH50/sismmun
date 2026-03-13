import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

abstract class HomeRepository {
  Future<Resource<SolicitudesResponse>> getSolicitudes();
}
