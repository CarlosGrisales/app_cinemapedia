import 'package:app_cinemapedia/domain/entities/movie.dart';

abstract class MovieDatasources {
  Future<List<Movie>> getNowPlayig({int page = 1});
}
