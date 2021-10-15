import 'package:flutter/material.dart';
import 'package:movies/search/search_delegate.dart';
import 'package:movies/services/movie_service.dart';
import 'package:movies/widgets/card_header_widget.dart';
import 'package:movies/widgets/horizontal_card_top_widget.dart';
import 'package:movies/widgets/horizontal_card_upcoming_widget.dart';
import 'package:movies/widgets/horizontal_card_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cine'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelagate(),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardHeader(movies: moviesProvider.onDisplayMovies),
            HorizontalCard(
              movies: moviesProvider.popularMovies,
              title: 'Películas Populares',
              nextPage: moviesProvider.getPopulasMovies,
            ),
            HorizontalCardTop(
              movies: moviesProvider.topRated,
              title: 'Más Votadas',
              nextPage: moviesProvider.getTopRated,
            ),
            HorizontalCardUpcoming(
              movies: moviesProvider.upcoming,
              title: 'Próximamente',
              nextPage: moviesProvider.getUpcoming,
            ),
            const SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }
}
