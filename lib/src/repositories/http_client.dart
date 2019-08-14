import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiClient {
  static const baseUrl = 'http://192.168.8.105/API_viensdindin';
  final http.Client httpClient = http.Client();
  Map<String, String> _headers = {
    "Accept-Encoding": "deflate, gzip;q=1.0, *;q=0.5"
  };

  Future<HomePageModel> fetchHomePage() async {
    final homeUrl =
        '$baseUrl/index_episode.php';
    final homeResponse = await this.httpClient.get(homeUrl, headers: _headers);

    if (homeResponse.statusCode != 200) {
      throw Exception("erreur lors de l'obtention des données de la page d'accueil");
    }

    final json = jsonDecode(homeResponse.body);
    return HomePageModel.fromJson(json);
  }

  Future<List<Movie>> fetchRelatedMovies({@required String id}) async {
    final url =
        '$baseUrl/index_video.php';
    final response = await this.httpClient.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("erreur d'obtenir des films liés");
    }

    final movies = (jsonDecode(response.body) as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return movies;
  }

  Future<Movie> fetchMovieDetails({@required String contentId}) async {
    final url =
        '$baseUrl/index_episode.php';
    final response = await this.httpClient.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("erreur lors de l'obtention des détails du film");
    }
    final json = jsonDecode(response.body);

    return Movie.fromJson(json);
  }

  Future<List<Movie>> movieSearch({@required String key}) async {
    final url =
        '$baseUrl/index_video.php';
    final response = await this.httpClient.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception("erreur de recherche de films");
    }
    final json = jsonDecode(response.body);

    var moviesJson = (json['contents'] as Map<String, dynamic>);
    var movies = Map<String, Movie>();
    moviesJson.forEach((k, v) {
      movies[k] = Movie.fromJson(v);
    });

    return movies.values.toList();
  }
}
