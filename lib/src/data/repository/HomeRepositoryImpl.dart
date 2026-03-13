import 'package:sismmun/src/data/dataSource/remote/services/HomeService.dart';
import 'package:sismmun/src/domain/models/SolicitudesResponse.dart';
import 'package:sismmun/src/domain/repository/HomeRepository.dart';
import 'package:sismmun/src/domain/utils/Resource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService homeService;

  HomeRepositoryImpl(this.homeService);

  @override
  Future<Resource<SolicitudesResponse>> getSolicitudes() async {
    try {
      final result = await homeService.getSolicitudes();
      return result;
    } catch (e) {
      return Error<SolicitudesResponse>('Error al obtener Solicituds: $e');
    }
  }
}
