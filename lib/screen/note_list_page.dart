import 'package:flutter/material.dart';
import 'package:note_keeper/database/database.dart';
import 'package:provider/provider.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({Key? key}) : super(key: key);

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late AppDatabase database;
  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      body: FutureBuilder<List<NoteData>>(
        future: _getNoteFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<NoteData>? noteList = snapshot.data;
            if (noteList != null) {
              if (noteList.isEmpty) {
                return Center(
                  child: Text(
                    'No Notes Found, Click on add button to add new note',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                );
              } else {
                return noteListUI(noteList);
              }
            }
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
              snapshot.error.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            ));
          }
          return Center(
            child: Text(
              'Click on add button to add new note',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<List<NoteData>> _getNoteFromDatabase() async {
    return await database.getNoteList();
  }

  Widget noteListUI(List<NoteData> noteList) {
    return Container();
  }
}
