import 'package:flutter/material.dart';
import 'package:hive_demo/main.dart';
import 'package:hive_demo/note_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteDetail extends StatefulWidget {
  NoteModel note;
  int index;

  NoteDetail({required this.note, required this.index});
  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late Box<NoteModel> noteBox;
  bool _readOnly = true;
  Color fabColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteBox = Hive.box<NoteModel>('notes');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController =
        TextEditingController(text: widget.note.title);
    TextEditingController _contentController =
        TextEditingController(text: widget.note.content);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _readOnly = false;
              });
            },
            icon: Icon(Icons.edit,
                color: _readOnly == true ? Colors.white : Colors.black),
          ),
          IconButton(
              splashColor: Colors.black,
              onPressed: () {
                if (_readOnly == false) {
                  final String title = _titleController.text;
                  final String content = _contentController.text;
                  NoteModel newNote = NoteModel(
                      title: title,
                      content: content,
                      createdTime: DateTime.now(),
                      checked: false);
                  box.putAt(widget.index, newNote);
                  Navigator.pop(context);
                } else {
                  null;
                }
              },
              icon: Icon(Icons.check,
                  color: _readOnly == true ? Colors.black : Colors.white))
        ],
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          readOnly: _readOnly,
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          controller: _titleController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(borderSide: BorderSide.none)),
        ),
            ),
            Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          readOnly: _readOnly,
          style: TextStyle(fontSize: 16, color: Colors.white),
          maxLines: null,
          controller: _contentController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(borderSide: BorderSide.none)),
          keyboardType: TextInputType.multiline,
        ),
            ),
            SizedBox(
        height: 60,
            ),
            Padding(
          padding: EdgeInsets.all(20),
          child: Text(
              _readOnly
                  ? 'Created: ${widget.note.createdTime!.toIso8601String().substring(0, 10)}, ${widget.note.createdTime!.toIso8601String().substring(11, 16)} '
                  : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )))
          ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor:
              _readOnly == true ? Colors.white : Colors.transparent,
          child: Icon(
            Icons.delete,
            color: _readOnly == true ? Colors.black : Colors.transparent,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Are you sure you want to delete this note?",
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                    actions: [
                      TextButton(
                          onPressed: () {
                            box.deleteAt(widget.index);
                            Navigator.of(context).pop(false);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black))),
                    ],
                  );
                });
          }),
    );
  }
}
