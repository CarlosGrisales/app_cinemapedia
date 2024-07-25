// Este repositorio es inmutable
import 'package:app_cinemapedia/infraestructure/datasources/actor_moviedb_datasource.dart';
import 'package:app_cinemapedia/infraestructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorRepositoryProvider = Provider((ref) {

  return ActorRepositoryImpl(ActorMovieDbDatasource());

});
