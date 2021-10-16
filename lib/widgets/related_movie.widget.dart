import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/pages/details_page.dart';
import 'package:movies/services/movie_service.dart';
import 'package:provider/provider.dart';

class RelatedMovie extends StatelessWidget {
  const RelatedMovie({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;
    final moviesProvider = Provider.of<MovieService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      height: _screen.height * 0.27,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Title(),
          Cards(movie: movie, movieService: moviesProvider),
        ],
      ),
    );
  }
}

// ===============================================================================================================================================================================
// Títulos widget
class Title extends StatelessWidget {
  const Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
      child: Text(
        'Peliculas Relacionadas',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ===============================================================================================================================================================================
class Cards extends StatelessWidget {
  const Cards({Key? key, required this.movie, required this.movieService})
      : super(key: key);

  final MovieService movieService;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: movieService.getRelatedMovies(movie),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          var movies = deleteRelated(snapshot.data!, movie);

          return Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];
                movie.heroId = '${movie.id}-related-movie';

                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 450),
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
                    child: Hero(
                      tag: movie.heroId!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/loading.gif'),
                          image: NetworkImage(movie.getFullPathPoster),
                          fit: BoxFit.cover,
                          height: 180.0,
                          width: 130.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

List<Movie> deleteRelated(List<Movie> movies, Movie movie) {
  List<Movie> listMovies = [];

  for (var related in movies) {
    if (related.id != movie.id) {
      listMovies.add(related);
    }
  }

  return listMovies;
}
