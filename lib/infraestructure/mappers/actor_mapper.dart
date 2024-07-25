import 'package:app_cinemapedia/domain/entities/actor.dart';
import 'package:app_cinemapedia/infraestructure/models/moviedb/credits_responsive.dart';

class ActorMapper{
  static Actor castToentity(Cast cast)=>
   Actor(id: cast.id,
   name: cast.name,
    profilePath: cast.profilePath != null
    ?'https://image.tmdb.org/t/p/w500${cast.profilePath}'
    :'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
     character: cast.character
     );
}