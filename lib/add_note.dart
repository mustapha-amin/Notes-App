import 'package:flutter/material.dart';
import 'package:hive_demo/note_model.dart';
import 'package:hive_flutter/adapters.dart';

class NoteEditor extends StatefulWidget {
  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late Box<NoteModel> noteBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteBox = Hive.box<NoteModel>('notes');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _contentController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Add a note",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            onPressed: () {
              if (_titleController.text.isEmpty &&
                  _contentController.text.isEmpty) {
                Navigator.pop(context);
              } else {
                final String title = _titleController.text;
                final String content = _contentController.text;
                NoteModel newNote = NoteModel(
                  title: title,
                  content: content,
                  createdTime: DateTime.now(),
                  checked: false,
                );
                noteBox.add(newNote);
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              controller: _titleController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  hintText: "Title",
                  hintStyle: TextStyle(
                    fontSize: 30,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TextField(
              style: TextStyle(fontSize: 16, color: Colors.white),
              maxLines: null,
              controller: _contentController,
              decoration: InputDecoration(
                  hintText: "Write something",
                  hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              keyboardType: TextInputType.multiline,
            ),
          ),
        ]),
      ),
    );
  }
}
