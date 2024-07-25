import 'package:app_cinemapedia/domain/entities/actor.dart';
import 'package:app_cinemapedia/domain/entities/movie.dart';
import 'package:app_cinemapedia/presentation/screens/movies/movie_screen.dart';
import 'package:app_cinemapedia/presentation/screens/providers/actors/actors_by_movie_provider.dart';
import 'package:app_cinemapedia/presentation/screens/providers/movies/movie_info_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockMovieInfoProvider extends Mock implements MovieMapNotifier {}

class MockActorByMovieProvider extends Mock implements ActorByMovieNotifier {}

// Proveedores para las pruebas
final movieInfoProvider =
    StateNotifierProvider<MockMovieInfoProvider, Map<String, Movie>>(
  (ref) => MockMovieInfoProvider(),
);

final actorByMovieProvider =
    StateNotifierProvider<MockActorByMovieProvider, Map<String, List<Actor>>>(
  (ref) => MockActorByMovieProvider(),
);

void main() {

  group('CustomRow Widget Tests', () {
    testWidgets('CustomRow displays correct title and subtitle',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CustomRow(
            title: 'Studio',
            subtitle: 'Studio Name',
          ),
        ),
      ));

      expect(find.text('Studio'), findsOneWidget);
      expect(find.text('Studio Name'), findsOneWidget);
    });

    testWidgets('CustomRow handles List<String> subtitle',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CustomRow(
            title: 'Genres',
            subtitle: ['Action', 'Drama'],
          ),
        ),
      ));

      expect(find.text('Genres'), findsOneWidget);
      expect(find.text('Action, Drama'), findsOneWidget);
    });
  });

  group('MovieDetails Widget Tests', () {
    late MockMovieInfoProvider mockMovie;
    late MockActorByMovieProvider mockActor;

    setUp(() {
      mockMovie = MockMovieInfoProvider();
      mockActor = MockActorByMovieProvider();
    });
    testWidgets('MovieDetails displays movie information',
        (WidgetTester tester) async {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'This is a test movie.',
        voteCount: 123,
        productionCompanies: ['Company1'],
        genreIds: ['Action', 'Drama'],
        releaseDate: DateTime.parse('2024-01-01'),
        posterPath: 'https://example.com/poster.jpg',
        adult: true,
        backdropPath: '',
        originalLanguage: '',
        originalTitle: '',
        popularity: 1.2,
        video: false,
        voteAverage: 1.0,
      );
      final actors = [
        Actor(
          id: 1,
          name: 'Actor One',
          profilePath: 'https://example.com/actor1.jpg',
          character: '',
        ),
        Actor(
          id: 2,
          name: 'Actor Two',
          profilePath: 'https://example.com/actor2.jpg',
          character: '',
        ),
      ];

      when(() => mockMovie.state).thenReturn({'1': movie});
      when(() => mockActor.state).thenReturn({'1': actors});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            movieInfoProvider.overrideWith(
              (ref) => mockMovie,
            ),
            actorByMovieProvider.overrideWith(
              (ref) => mockActor,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MovieDetails(movie: movie),
            ),
          ),
        ),
      );

      expect(find.text('This is a test movie.'), findsOneWidget);
      expect(find.text('123'), findsOneWidget);
      expect(find.text('Company1'), findsOneWidget);
      expect(find.text('Action, Drama'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
    });
  });

  group('MovieScreen Widget Tests', () {
    late MockMovieInfoProvider mockMovie;
    late MockActorByMovieProvider mockActor;
    final movie = Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'This is a test movie.',
      voteCount: 123,
      productionCompanies: ['Company1'],
      genreIds: ['Action', 'Drama'],
      releaseDate: DateTime.parse('2024-01-01'),
      posterPath: 'https://example.com/poster.jpg',
      adult: true,
      backdropPath: '',
      originalLanguage: '',
      originalTitle: '',
      popularity: 1.2,
      video: false,
      voteAverage: 1.0,
    );

  
    setUp(() {
      mockMovie = MockMovieInfoProvider();
      mockActor = MockActorByMovieProvider();

      when(() => mockMovie.state).thenReturn({'1': movie});
      when(() => mockActor.state).thenReturn({});
    });

    testWidgets('MovieScreen shows loading indicator while fetching movie info',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          movieInfoProvider.overrideWith(
            (ref) => mockMovie,
          ),
          actorByMovieProvider.overrideWith(
            (ref) => mockActor,
          ),
        ],
        child: MaterialApp(
          home: MovieScreen(movieId: '1'),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('MovieScreen displays movie details when movie info is loaded',
        (WidgetTester tester) async {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'This is a test movie.',
        voteCount: 123,
        productionCompanies: ['Company1'],
        genreIds: ['Action', 'Drama'],
        releaseDate: DateTime.parse('2024-01-01'),
        posterPath: 'https://example.com/poster.jpg',
        adult: true,
        backdropPath: '',
        originalLanguage: '',
        originalTitle: '',
        popularity: 1.2,
        video: false,
        voteAverage: 1.0,
      );

      final actors = [
        Actor(
          id: 1,
          name: 'Actor One',
          profilePath: 'https://example.com/actor1.jpg',
          character: '',
        ),
        Actor(
          id: 2,
          name: 'Actor Two',
          profilePath: 'https://example.com/actor2.jpg',
          character: '',
        ),
      ];

      when(() => mockMovie.state).thenReturn({'1': movie});
      when(() => mockActor.state).thenReturn({'1': actors});

      await tester.pumpWidget(ProviderScope(
        overrides: [
          movieInfoProvider.overrideWith(
            (ref) => mockMovie,
          ),
          actorByMovieProvider.overrideWith(
            (ref) => mockActor,
          ),
        ],
        child: MaterialApp(
          home: MovieScreen(movieId: '1'),
        ),
      ));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('This is a test movie.'), findsOneWidget);
      expect(find.text('123'), findsOneWidget);
    });
  });

  group('ActorByMovie Widget Tests', () {
    late MockActorByMovieProvider mockActor;

    setUp(() {
      mockActor = MockActorByMovieProvider();
      when(() => mockActor.state).thenReturn({});
    });

    testWidgets(
        'ActorByMovie shows CircularProgressIndicator when no actors are available',
        (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          actorByMovieProvider.overrideWith(
            (ref) => mockActor,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ActorByMovie(movieId: '1'),
          ),
        ),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('ActorByMovie displays list of actors when data is available',
        (WidgetTester tester) async {
      final actors = [
        Actor(
          id: 1,
          name: 'Actor One',
          profilePath: 'https://example.com/actor1.jpg',
          character: '',
        ),
        Actor(
          id: 2,
          name: 'Actor Two',
          profilePath: 'https://example.com/actor2.jpg',
          character: '',
        ),
      ];

      when(() => mockActor.state).thenReturn({'1': actors});

      await tester.pumpWidget(ProviderScope(
        overrides: [
          actorByMovieProvider.overrideWith(
            (ref) => mockActor,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ActorByMovie(movieId: '1'),
          ),
        ),
      ));

      expect(find.text('Actor One'), findsOneWidget);
      expect(find.text('Actor Two'), findsOneWidget);
      expect(
          find.byType(Image),
          findsNWidgets(
              2)); // Verifica que se muestran las imágenes de los actores
    });
  });
}
