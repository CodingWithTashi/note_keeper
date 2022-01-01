import 'package:flutter/material.dart';
import 'package:note_keeper/database/database.dart';
import 'package:provider/provider.dart';

class NoteDetailPage extends StatefulWidget {
  final String title;
  final NoteCompanion noteCompanion;
  const NoteDetailPage(
      {Key? key, required this.title, required this.noteCompanion})
      : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late AppDatabase appDatabase;
  late TextEditingController titleEditingController;
  late TextEditingController descriptionEditingController;
  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    titleEditingController.text = widget.noteCompanion.title.value;
    descriptionEditingController.text = widget.noteCompanion.description.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: _getDetailAppBar(),
      body: Container(),
    );
  }

  _getDetailAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_outlined,
          color: Colors.black,
        ),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.save,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
