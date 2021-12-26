import 'package:drift/drift.dart' as dr;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/database/database.dart';
import 'package:note_keeper/screen/note_detail_page.dart';
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
        onPressed: () {
          _navigateToDetail(
              'Add Note',
              const NoteCompanion(
                  title: dr.Value(''),
                  description: dr.Value(''),
                  color: dr.Value(1),
                  priority: dr.Value(1)));
        },
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        backgroundColor: Colors.white,
        child: const Icon(
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
    return StaggeredGridView.countBuilder(
      itemCount: noteList.length,
      crossAxisCount: 4,
      itemBuilder: (context, index) {
        NoteData noteData = noteList[index];
        return InkWell(
          onTap: () {
            _navigateToDetail(
              'Edit Note',
              NoteCompanion(
                  id: dr.Value(noteData.id),
                  title: dr.Value(noteData.title),
                  description: dr.Value(noteData.description),
                  priority: dr.Value(noteData.priority),
                  color: dr.Value(noteData.color)),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(noteData.title),
                    Text(_getPriority(noteData.priority!))
                  ],
                ),
                Text(noteData.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '12/12/2021',
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
    );
  }

  _navigateToDetail(String title, NoteCompanion noteCompanion) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(
          title: title,
          noteCompanion: noteCompanion,
        ),
      ),
    );
    if (res != null && res == true) {
      setState(() {});
    }
  }

  String _getPriority(int p) {
    switch (p) {
      case 1:
        return '!!!';
      case 2:
        return '!!';
      default:
        return '!';
    }
  }
}
