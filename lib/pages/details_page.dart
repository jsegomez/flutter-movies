import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/widgets/casting_movie_widget.dart';
import 'package:movies/widgets/related_movie.widget.dart';

class DetailsMovie extends StatelessWidget {
  const DetailsMovie({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        CustomAppBar(movie: movie),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Body(
                movie: movie,
              ),
              TextOverview(movie: movie),
              Casting(movieId: movie.id),
              RelatedMovie(movie: movie),
              const SizedBox(height: 15.0)
            ],
          ),
        )
      ]),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    return SizedBox(
      height: _screen.height * 0.335,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            PosterMovie(
              movie: movie,
            ),
            MovieTitles(movie: movie),
          ],
        ),
      ),
    );
  }
}

// ====================================================================================================================================================================================================
// Títulos de la película
class MovieTitles extends StatelessWidget {
  const MovieTitles({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            movie.originalTitle,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6.0),
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_border),
              const SizedBox(
                width: 5.0,
              ),
              Text('${movie.voteAverage} / 10',
                  style: Theme.of(context).textTheme.caption)
            ],
          )
        ],
      ),
    );
  }
}

// ====================================================================================================================================================================================================
// Poster de la película
class PosterMovie extends StatelessWidget {
  const PosterMovie({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 240,
      child: Hero(
        tag: movie.heroId!,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image(
            image: NetworkImage(movie.getFullPathPoster),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// ====================================================================================================================================================================================
// AppBar de la aplicación
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black38,
          child: Text(movie.title, textAlign: TextAlign.center),
        ),
        titlePadding: EdgeInsets.zero,
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(movie.getFullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ====================================================================================================================================================================================================
// Reseña de la pelicula
class TextOverview extends StatelessWidget {
  const TextOverview({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Text(
        movie.overview,
        style: const TextStyle(fontSize: 16.0),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
