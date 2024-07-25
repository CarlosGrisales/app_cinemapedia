import 'package:app_cinemapedia/config/constants/environment.dart';
import 'package:app_cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:app_cinemapedia/domain/entities/actor.dart';
import 'package:app_cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:app_cinemapedia/infraestructure/models/moviedb/credits_responsive.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDataSource {
   final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.theMovieDbKey,
        'language': 'es-MX'
      }));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
     final castResponse = CreditsResponse.fromJson(response.data);
    final List<Actor> actors = castResponse.cast.map
    ((cast) => ActorMapper.castToentity(cast)).toList();

    return actors;
  }
}
