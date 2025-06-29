import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entities/campsite.dart';
import '../repositories/campsite_repository.dart';
import '../../data/repositories/campsite_repository_impl.dart';

part 'get_campsite_by_id_usecase.g.dart';

class GetCampsiteByIdUseCase {
  final CampsiteRepository repository;

  GetCampsiteByIdUseCase(this.repository);

  Future<Campsite?> call(String id) async {
    return await repository.getCampsiteById(id);
  }
}

@riverpod
GetCampsiteByIdUseCase getCampsiteByIdUseCase(GetCampsiteByIdUseCaseRef ref) {
  final repository = ref.watch(campsiteRepositoryProvider);
  return GetCampsiteByIdUseCase(repository);
} 