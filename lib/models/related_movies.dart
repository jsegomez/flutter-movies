import 'dart:convert';
import 'package:movies/models/movie.dart';

class RelatedMovies {
  RelatedMovies({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory RelatedMovies.fromJson(String str) =>
      RelatedMovies.fromMap(json.decode(str));

  factory RelatedMovies.fromMap(Map<String, dynamic> json) => RelatedMovies(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
