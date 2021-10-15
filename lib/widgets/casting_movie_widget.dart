import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/models/casting.dart';
import 'package:movies/services/movie_service.dart';
import 'package:provider/provider.dart';

class Casting extends StatelessWidget {
  const Casting({Key? key, required this.movieId}) : super(key: key);

  final int movieId;

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieService>(context, listen: false);
    final _screen = MediaQuery.of(context).size;

    return FutureBuilder(
      future: moviesProvider.getCasting(movieId),
      builder: (BuildContext context, AsyncSnapshot<List<Cast>> snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: _screen.height * 0.30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Title(),
                Cards(casting: snapshot.data!),
              ],
            ),
          );
        } else {
          return SizedBox(
            height: _screen.height * 0.27,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0, bottom: 5.0),
      child: Text(
        'Actores',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    Key? key,
    required this.casting,
  }) : super(key: key);

  final List<Cast> casting;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: casting.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8.0, bottom: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/loading.gif'),
                    image: NetworkImage(casting[index].fullProfilePath),
                    fit: BoxFit.cover,
                    height: 185,
                    width: 130.0,
                  ),
                ),
              ),
              Text(casting[index].originalName)
            ],
          );
        },
      ),
    );
  }
}
