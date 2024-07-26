import 'package:animate_do/animate_do.dart';
import 'package:app_cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// **Lista Horizontal de Películas (`MovieHorizontalListview`).**
///
/// Este widget muestra una lista horizontal de películas. También incluye un título y un subtítulo opcionales.
///
/// **Propiedades:**
/// - `movies`: Lista de objetos de tipo `Movie` que se mostrarán.
/// - `title`: Título opcional de la lista.
/// - `subTitle`: Subtítulo opcional de la lista.
/// - `loadNextPage`: Callback opcional para cargar la siguiente página de películas.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario de la lista horizontal de películas.
///
/// **Clases Internas:**
/// - `_Slide`: Widget que representa una película individual en la lista.
/// - `_Title`: Widget que muestra el título y el subtítulo de la lista.

class MovieHorizontalListview extends StatelessWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subTitle,
      this.loadNextPage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 350,
        child: Column(
          children: [
            _Title(
              title: title,
              subTitle: subTitle,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _Slide(
                    movie: movies[index],
                  );
                },
              ),
            )
          ],
        ));
  }
}

/// **Slide de Película (`_Slide`).**
///
/// Widget interno que representa una película individual en la lista horizontal.
///
/// **Propiedades:**
/// - `movie`: Objeto de tipo `Movie` que representa la película a mostrar.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario para una película individual.

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //* Imagen
        SizedBox(
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              movie.posterPath,
              fit: BoxFit.cover,
              width: 150,
              loadingBuilder: (context, child, loadingProgess) {
                if (loadingProgess != null) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () => context.push(
                    '/movie/${movie.id}',
                  ),
                  child: FadeIn(child: child),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 5),
        //* Título
        SizedBox(
          width: 150,
          child: Text(
            movie.title,
            maxLines: 2,
            style: textStyle.titleSmall,
          ),
        ),

        //* Rating
        Row(
          children: [
            Icon(
              Icons.star_half_outlined,
              color: Colors.yellow.shade800,
            ),
            const SizedBox(width: 2,),
            Text(movie.voteCount.toString(), style: TextStyle(color: Colors.yellow.shade800, fontWeight: FontWeight.bold),)
          ],
        ),
      ]),
    );
  }
}

/// **Título de la Lista (`_Title`).**
///
/// Widget interno que muestra el título y el subtítulo de la lista de películas.
///
/// **Propiedades:**
/// - `title`: Título opcional de la lista.
/// - `subTitle`: Subtítulo opcional de la lista.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario para el título y subtítulo de la lista.

class _Title extends StatelessWidget {
  final String? title;
  final String? subTitle;
  const _Title({this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Text(
          title!,
        ),
        const Spacer(),
        TextButton(
            onPressed: () {},
            child: Text(
              subTitle!,
              style: const TextStyle(color: Colors.grey),
            ))
      ]),
    );
  }
}
