import 'package:animate_do/animate_do.dart';
import 'package:app_cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

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

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //* imagen
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
                return FadeIn(child: child);
              },
            ),
          ),
        ),
        const SizedBox(width: 5),
        //* Title
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
              Icons.star,
              color: Colors.yellow.shade800,
            ),
            Icon(
              Icons.star,
              color: Colors.yellow.shade800,
            ),
            Icon(
              Icons.star,
              color: Colors.yellow.shade800,
            ),
            Icon(
              Icons.star_half_outlined,
              color: Colors.yellow.shade800,
            )
          ],
        ),
      ]),
    );
  }
}

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
