import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/pages/details_page.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({Key? key, required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        height: _screen.height * 0.4,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      height: _screen.height * 0.4,
      width: double.infinity,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          movie.heroId = '${movie.id}-header-card';

          return Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/loading.gif'),
                image: NetworkImage(movie.getFullPathPoster),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        itemWidth: 210.0,
        itemCount: movies.length,
        viewportFraction: 0.55,
        scale: 0.8,
        layout: SwiperLayout.STACK,
        onTap: (index) => Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            reverseTransitionDuration: const Duration(milliseconds: 450),
            pageBuilder: (context, animation, _) {
              return FadeTransition(
                opacity: animation,
                child: DetailsMovie(
                  movie: movies[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
