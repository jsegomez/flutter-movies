import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/casting.dart';
import 'package:movies/models/movie.dart';
import 'package:movies/models/now_playing_response.dart';

class MovieService extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '636fc5531b530d22d014e0153533c084';
  final String _language = 'es';
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> topRated = [];
  List<Movie> upcoming = [];
  List<Movie> related = [];

  int _popularPage = 0;
  int _topRatedPage = 0;
  int _upcomingPage = 0;

  bool loadingPopular = true;
  bool loadingTopRated = true;
  bool loadingUpcoming = true;
  bool loadingRelated = true;

  Map<int, List<Cast>> movieCast = {};

  MovieService() {
    getOnDisplayMovies();
    getPopulasMovies();
    getTopRated();
    getUpcoming();
  }

  getOnDisplayMovies() async {
    final newData = await formatDataMovie('/3/movie/now_playing', 1);
    onDisplayMovies = [...onDisplayMovies, ...newData];
    notifyListeners();
  }

  getPopulasMovies() async {
    if (loadingPopular) {
      _popularPage++;
      loadingPopular = false;
      final newData = await formatDataMovie('/3/movie/popular', _popularPage);
      popularMovies = [...popularMovies, ...newData];
      notifyListeners();
      loadingPopular = true;
    }
  }

  getTopRated() async {
    if (loadingTopRated) {
      _topRatedPage++;
      loadingTopRated = false;
      final newData =
          await formatDataMovie('/3/movie/top_rated', _topRatedPage);
      topRated = [...topRated, ...newData];

      notifyListeners();
      loadingTopRated = true;
    }
  }

  getUpcoming() async {
    if (loadingUpcoming) {
      loadingUpcoming = false;
      _upcomingPage++;
      final newData = await formatDataMovie('/3/movie/upcoming', _upcomingPage);
      upcoming = [...upcoming, ...newData];

      notifyListeners();
      loadingUpcoming = true;
    }
  }

  Future<List<Movie>> getRelatedMovies(Movie movie) async {
    return await formatDataMovie('/3/movie/${movie.id}/similar', 1);
  }

  Future<List<Cast>> getCasting(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    var url = Uri.https(_baseUrl, '/3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });

    final data = await http.get(url);
    final response = Casting.fromJson(data.body);
    movieCast[movieId] = response.cast;

    return response.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    var url = Uri.https(_baseUrl, '/3/search/movie', {
      'api_key': _apiKey,
      'page': '1',
      'language': _language,
      'query': query,
    });

    final data = await http.get(url);
    final response = NowPlayingResponse.fromJson(data.body);
    return response.results;
  }

  Future<List<Movie>> formatDataMovie(String request, int page) async {
    var url = Uri.https(_baseUrl, request, {
      'api_key': _apiKey,
      'page': '$page',
      'language': _language,
    });

    final data = await http.get(url);
    final response = NowPlayingResponse.fromJson(data.body);
    return response.results;
  }
}
