import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/pages/details_page.dart';
import 'package:movies/services/movie_service.dart';
import 'package:provider/provider.dart';

class MovieSearchDelagate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final moviesProvider = Provider.of<MovieService>(context, listen: false);

    if (query.isNotEmpty) {
      return ListMovies(
        moviesProvider: moviesProvider,
        query: query,
      );
    } else {
      return const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          size: 96.0,
        ),
      );
    }
  }
}

// ========================================================================================================================================
class ListMovies extends StatelessWidget {
  const ListMovies({
    Key? key,
    required this.moviesProvider,
    required this.query,
  }) : super(key: key);

  final MovieService moviesProvider;
  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data!;

          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.cancel,
                    size: 100,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text('Sin resultados para la busqueda')
                ],
              ),
            );
          } else {
            return CustomRow(movies: movies);
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

// ========================================================================================================================================
class CustomRow extends StatelessWidget {
  const CustomRow({
    Key? key,
    required this.movies,
  }) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
        itemCount: movies.length,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          movie.heroId = '${movie.id}-search-movie';

          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                reverseTransitionDuration: const Duration(milliseconds: 450),
                pageBuilder: (context, animation, _) {
                  return FadeTransition(
                    opacity: animation,
                    child: DetailsMovie(
                      movie: movie,
                    ),
                  );
                },
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ImageMovie(movie: movie, screen: screen),
                  TitlesMovie(screen: screen, movie: movie),
                  VotesMovie(screen: screen, movie: movie)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Imagen de la película
class ImageMovie extends StatelessWidget {
  const ImageMovie({
    Key? key,
    required this.movie,
    required this.screen,
  }) : super(key: key);

  final Movie movie;
  final Size screen;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(movie.getFullPathPoster),
          fit: BoxFit.cover,
          width: screen.width * 0.3,
          height: 170.0,
        ),
      ),
    );
  }
}

// Titulos de la tarjeta
class TitlesMovie extends StatelessWidget {
  const TitlesMovie({
    Key? key,
    required this.screen,
    required this.movie,
  }) : super(key: key);

  final Size screen;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screen.width * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            movie.originalTitle,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

// Votos de la película
class VotesMovie extends StatelessWidget {
  const VotesMovie({
    Key? key,
    required this.screen,
    required this.movie,
  }) : super(key: key);

  final Size screen;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screen.width * 0.10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star),
          const SizedBox(
            height: 5.0,
          ),
          Text(movie.voteAverage.toString())
        ],
      ),
    );
  }
}
