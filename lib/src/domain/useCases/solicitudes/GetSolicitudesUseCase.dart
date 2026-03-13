import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/repository/HomeRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

class GetSolicitudesUseCase {
  final HomeRepository repository;

  GetSolicitudesUseCase(this.repository);

  Future<Resource<SolicitudesResponse>> run() async {
    return await repository.getSolicitudes();
  }
}
