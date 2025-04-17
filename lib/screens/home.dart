import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../screens/comments.dart';
import '../services/googleapi_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Center(child: Text("This is the HOME PAGE!"));

    return Center(
      child: FutureBuilder(
        future: GoogleAPIService().fetchPotterBooks(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.map((b) => BookTile(book: b)).toList(),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  const BookTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    String thumbnail =
        book.thumbnailUrl ?? ""; // could use some default url image
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(thumbnail)),
      title: Text(book.title),
      subtitle: Text('${book.bookId} ${' - '} ${book.author}'),
      //   onTap: () => _navigateToDetailsPage(book, context),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CommentsPage(book: book)),
        );
      },
    );
  }
}
