import 'package:app_cinemapedia/config/constants/environment.dart';
import 'package:app_cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:app_cinemapedia/domain/entities/movie.dart';
import 'package:app_cinemapedia/infraestructure/mappers/movie_mapper.dart';
import 'package:app_cinemapedia/infraestructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MoviesDatasources {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.theMovieDbKey,
        'language': 'es-MX'
      }));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDbResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBtoEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');
     return _jsonToMovies(response.data);
  }

   @override
  Future<List<Movie>> getToprated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated');
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular');
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming');
    return _jsonToMovies(response.data);
  }
}
