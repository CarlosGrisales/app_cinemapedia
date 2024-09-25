import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/movie.dart';
import '../providers/providers.dart';

/// **Pantalla de Película individual (`MovieScreen`).**
///
/// Esta pantalla muestra la información detallada de una película, incluyendo su título, descripción,
/// actores y otros detalles relevantes.
///
/// **Propiedades:**
/// - `movieId`: Identificador de la película que se va a mostrar.
///
/// **Métodos:**
/// - `createState`: Crea el estado asociado con esta pantalla.
///
/// **Atributos del Estado:**
/// - `initState`: Método llamado al inicializar el estado para cargar la información de la película y los actores.
/// - `build`: Construye la interfaz de usuario de la pantalla.
///
/// **Widget Adicionales Utilizados:**
/// - `CustomSliverAppBar`: Widget personalizado que muestra una barra de aplicaciones con la imagen de fondo de la película.
/// - `MovieDetails`: Widget que muestra los detalles de la película.
/// - `ActorByMovie`: Widget que muestra una lista horizontal de actores para una película.

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    if (movie == null) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ));
    }
    return Scaffold(
      backgroundColor: Colors.black87,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => MovieDetails(movie: movie),
                childCount: 1),
          )
        ],
      ),
    );
  }
}

/// **Detalles de la Película (`MovieDetails`).**
///
/// Este widget muestra información detallada sobre una película específica, incluyendo
/// una breve descripción, el botón para ver ahora, la puntuación, y otros detalles específicos.
///
/// **Propiedades:**
/// - `movie`: La película cuyas detalles se mostrarán.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario para mostrar los detalles de la película.

class MovieDetails extends StatelessWidget {
  final Movie movie;

  const MovieDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    /// final size = MediaQuery.of(context).size;
    //final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                onPressed: () {},
                child: const Text('WHATCHE NOW'),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.star_half_outlined,
                    color: Colors.yellow.shade800,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    movie.voteCount.toString(),
                    style: TextStyle(
                        color: Colors.yellow.shade800,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            movie.overview,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ActorByMovie(movieId: movie.id.toString()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRow(
                  title: 'Studio',
                  subtitle: movie.productionCompanies,
                ),
                CustomRow(
                  title: 'Genero',
                  subtitle: movie.genreIds,
                ),
                CustomRow(
                    title: 'Release', subtitle: movie.releaseDate.toString())
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// **Actores por Película (`ActorByMovie`).**
///
/// Este widget muestra una lista horizontal de actores que aparecen en una película específica.
///
/// **Propiedades:**
/// - `movieId`: Identificador de la película cuyas actores se van a mostrar.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario para mostrar la lista de actores.
///
class ActorByMovie extends ConsumerWidget {
  final String movieId;
  const ActorByMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }
    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];

            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 135,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(
                      actor.profilePath,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    actor.name,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

/// **Fila Personalizada (`CustomRow`).**
///
/// Este widget muestra una fila de información de descripcion de la pelicula con un título y un subtítulo.
///
/// **Propiedades:**
/// - `title`: Título de la información.
/// - `subtitle`: Subtítulo de la información, que puede ser una cadena o una lista de cadenas.
///
/// **Métodos:**
/// - `formatSubtitle`: Formatea el subtítulo basado en su tipo.
/// - `extractYear`: Extrae el año de una fecha en formato de cadena.
/// - `build`: Construye la interfaz de usuario para mostrar la fila de información.

class CustomRow extends StatelessWidget {
  final String title;
  final dynamic subtitle;

  const CustomRow({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  String formatSubtitle(dynamic subtitle) {
    if (subtitle is List<String>) {
      return subtitle.join(', ');
    } else if (subtitle is String) {
      return subtitle;
    } else {
      throw ArgumentError('Subtitle must be a String or List<String>');
    }
  }

  String extractYear(String date) {
    return date.split('-').first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              formatSubtitle(
                  subtitle is String ? extractYear(subtitle) : subtitle),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}

/// **Barra de Aplicaciones Personalizada (`CustomSliverAppBar`).**
///
/// Este widget muestra una barra de aplicaciones personalizada con una imagen de fondo de la película.
///
/// **Propiedades:**
/// - `movie`: La película cuyas detalles se mostrarán en la barra de aplicaciones.
///
/// **Métodos:**
/// - `build`: Construye la interfaz de usuario para mostrar la barra de aplicaciones.
///
final isFavoriteProvider =
    FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageReposy = ref.watch(localStorageRepositoryProvider);
  return localStorageReposy.isMovieFavorite(movieId);
});

class CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const CustomSliverAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      actions: [
        IconButton(
            onPressed: () {
              ref.watch(localStorageRepositoryProvider).toggleFavorite(movie);
              ref.invalidate(isFavoriteProvider(movie.id));
            },
            icon: isFavoriteFuture.when(
                loading: () => const CircularProgressIndicator(strokeWidth: 2),
                data: (isFavorite) => isFavorite
                    ? const Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_border_rounded),
                error: (_, __) => throw UnimplementedError()))
      ],
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.4,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const _CustomGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.0, 0.2],
              colors: [
                Colors.black87,
                Colors.transparent,
              ],
            ),
            const _CustomGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.7, 1.0],
              colors: [
                Colors.transparent,
                Colors.black87,
              ],
            ),
            const _CustomGradient(
              begin: Alignment.topLeft,
              stops: [0.0, 0.3],
              colors: [Colors.black87, Colors.transparent],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: begin, end: end, stops: stops, colors: colors),
        ),
      ),
    );
  }
}
