import 'dart:async';
import 'dart:convert';
import 'dart:developer'
    as log_dev; // provide a print() debug function to the debug console
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class GoogleAPIService {
  final String url =
      'https://www.googleapis.com/books/v1/volumes?q=inauthor:arthur+c+clarke&maxResults=35';

  Future<List<Book>> fetchPotterBooks() async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return _parseBookJson(res.body);
    } else {
      throw Exception('Error: ${res.statusCode}');
    }
  }

  List<Book> _parseBookJson(String jsonStr) {
    final jsonMap = json.decode(jsonStr);
    final jsonList = (jsonMap['items'] as List);
    // log_dev.log(jsonList.length.toString());  // here's how you log something!
    return jsonList
        .map(
          (jsonBook) => Book(
            bookId: jsonBook['id'],
            title: jsonBook['volumeInfo']['title'],
            author: (jsonBook['volumeInfo']['authors'] as List).join(', '),
            thumbnailUrl:
                'https://res.cloudinary.com/dpeqsj31d/image/upload/v1707263739/avatar_2_2.png',
            // jsonBook['volumeInfo']['imageLinks']['smallThumbnail'],
          ),
        )
        .toList();
  }
}
