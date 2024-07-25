import 'package:app_cinemapedia/domain/entities/actor.dart';

abstract class ActorDataSource {
  Future<List<Actor>> getActorsByMovie(String movieid);
}
