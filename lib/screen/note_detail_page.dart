import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/database/database.dart';
import 'package:note_keeper/util/color_picker.dart';
import 'package:note_keeper/util/priority_picker.dart';
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
  int priorityLevel = 0;
  int colorLevel = 0;
  @override
  void initState() {
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
    titleEditingController.text = widget.noteCompanion.title.value;
    descriptionEditingController.text = widget.noteCompanion.description.value;
    priorityLevel = widget.noteCompanion.priority.value!;
    colorLevel = widget.noteCompanion.color.value!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appDatabase = Provider.of<AppDatabase>(context);
    return Scaffold(
      backgroundColor: colors[colorLevel],
      appBar: _getDetailAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            PriorityPicker(
              index: priorityLevel,
              onTap: (selectedIndex) {
                priorityLevel = selectedIndex;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ColorPicker(
              index: colorLevel,
              onTap: (selectedColor) {
                colorLevel = selectedColor;
                setState(() {});
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: titleEditingController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter Title'),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: descriptionEditingController,
              maxLength: 255,
              minLines: 7,
              maxLines: 8,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  hintText: 'Enter Title'),
            ),
          ],
        ),
      ),
    );
  }

  _getDetailAppBar() {
    return AppBar(
      backgroundColor: colors[colorLevel],
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
          onPressed: () {
            _saveToDb();
          },
          icon: const Icon(
            Icons.save,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            _deleteNotes();
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  void _saveToDb() {
    if (widget.noteCompanion.id.present) {
      appDatabase
          .updateNote(NoteData(
              id: widget.noteCompanion.id.value,
              title: titleEditingController.text,
              description: descriptionEditingController.text,
              color: colorLevel,
              priority: priorityLevel,
              date: DateFormat.yMMMd().format(DateTime.now())))
          .then((value) {
        Navigator.pop(context, true);
      });
    } else {
      appDatabase
          .insertNote(NoteCompanion(
              title: dr.Value(titleEditingController.text),
              description: dr.Value(descriptionEditingController.text),
              color: dr.Value(colorLevel),
              priority: dr.Value(priorityLevel),
              date: dr.Value(DateFormat.yMMMd().format(DateTime.now()))))
          .then((value) {
        Navigator.pop(context, true);
      });
    }
  }

  void _deleteNotes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note?'),
          content: Text('Do you really want to delete this note'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                appDatabase
                    .deleteNote(NoteData(
                        id: widget.noteCompanion.id.value,
                        title: widget.noteCompanion.title.value,
                        description: widget.noteCompanion.description.value,
                        date: DateFormat.yMMMd().format(DateTime.now())))
                    .then((value) {
                  Navigator.pop(context, true);
                });
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
