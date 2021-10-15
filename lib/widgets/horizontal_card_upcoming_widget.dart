import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/pages/details_page.dart';

class HorizontalCardUpcoming extends StatefulWidget {
  const HorizontalCardUpcoming({
    Key? key,
    required this.movies,
    required this.title,
    required this.nextPage,
  }) : super(key: key);

  final List<Movie> movies;
  final String title;
  final Function nextPage;

  @override
  State<HorizontalCardUpcoming> createState() => _HorizontalCardState();
}

class _HorizontalCardState extends State<HorizontalCardUpcoming> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels + 250 >
          scrollController.position.maxScrollExtent) {
        widget.nextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screen = MediaQuery.of(context).size;

    if (widget.movies.isEmpty) {
      return SizedBox(
        height: _screen.height * 0.27,
        child: Container(),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      height: _screen.height * 0.27,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            child: Text(
              widget.title,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = widget.movies[index];
                movie.heroId = '${movie.id}-horizontal-card-upcoming';

                return GestureDetector(
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
                  child: Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    child: Hero(
                      tag: movie.heroId!,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/images/loading.gif'),
                          image: NetworkImage(movie.getFullPathPoster),
                          fit: BoxFit.cover,
                          height: 400,
                          width: 130.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
