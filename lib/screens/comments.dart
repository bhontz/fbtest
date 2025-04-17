import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/book_model.dart';
import '../services/firebase_service.dart';

class CommentsPage extends StatelessWidget {
  final Book book;
  final User? user =
      FirebaseAuth.instance.currentUser; // part of the database key

  CommentsPage({super.key, required this.book});

  final TextEditingController commentController = TextEditingController();
  // final database = FirestoreDatabase(bookId: bookId);

  @override
  Widget build(BuildContext context) {
    var database = FirestoreDatabase(bookId: book.bookId);
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [Text('Comments for:'), Text(book.title)]),
      ), // was ${book.title}
      body: Column(
        children: [
          StreamBuilder(
            stream: database.getComments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final commentList = snapshot.data!.docs;
              if (snapshot.data == null || commentList.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No comments yet!"),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: commentList.length,
                  itemBuilder: (context, index) {
                    final comment = commentList[index];
                    return ListTile(
                      title: Column(
                        children: [
                          Text(comment['userId']),
                          SizedBox(width: 5),
                          Text(
                            comment['comment'],
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          if (user?.email == comment['userId']) {
                            database.deleteComment(comment['messageId']);
                          } else {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(
                                      'You can only delete your own comments!',
                                    ),
                                  ),
                            );
                          }
                        },
                        // () => database.deleteComment(comment['messageId']),
                      ),
                      // title: Text(comment['comment']),
                      // subtitle: Text(comment['userId']),
                    );
                  },
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Leave a comment ...'),
            ),
            trailing: FloatingActionButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  database.addComment(commentController.text);
                  commentController.clear();
                }
              },
              tooltip: 'Post',
              child: const Icon(Icons.add),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ],
      ),
    );
  }
}
