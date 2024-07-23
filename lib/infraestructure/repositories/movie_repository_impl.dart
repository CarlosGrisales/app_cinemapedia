import 'package:app_cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:app_cinemapedia/domain/entities/movie.dart';
import 'package:app_cinemapedia/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDatasources datasources;
  MovieRepositoryImpl(this.datasources);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasources.getNowPlaying(page: page);
  }
}
