import 'package:app_cinemapedia/domain/entities/actor.dart';
import 'package:app_cinemapedia/presentation/screens/providers/actors/actors_respository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final actorByMovieProvider =  StateNotifierProvider<ActorByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final actorRepository = ref.watch(actorRepositoryProvider);
  return ActorByMovieNotifier(getActors: actorRepository.getActorsByMovie);
});


typedef GetActorsCallback = Future<List<Actor>>Function(String movieId);

class ActorByMovieNotifier extends StateNotifier<Map<String,List<Actor>>> {
  final GetActorsCallback getActors;

  ActorByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;
    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
