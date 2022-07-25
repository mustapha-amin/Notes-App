import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_demo/note_detail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'note_model.dart';
import 'add_note.dart';

late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  box = await Hive.openBox<NoteModel>('notes');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NoteScreen(),
  ));
}

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool longPressed = false;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endFloat;

  _onLocationChanged(FloatingActionButtonLocation value) {
    setState(() {
      _fabLocation = value;
    });
  }

  _refreshNotes() {
    setState(() {
      _onLocationChanged(FloatingActionButtonLocation.endFloat);
      longPressed = false;
      checkedNotes.clear();
      box.keys.forEach((key) {
        NoteModel note = box.getAt(key);
        note.checked = false;
      });
    });
  }

  Set<int> checkedNotes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          TextButton(
            style: ButtonStyle(splashFactory: NoSplash.splashFactory),
            onPressed: () {
              _onLocationChanged(FloatingActionButtonLocation.endFloat);
              setState(() {
                longPressed = false;
                _refreshNotes();
              });
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: longPressed ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
        elevation: 0,
        title: Text("My Notes",
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ValueListenableBuilder<Box<NoteModel>>(
        valueListenable: Hive.box<NoteModel>('notes').listenable(),
        builder: (context, box, _) {
          return Padding(
            padding: EdgeInsets.all(8),
            child: box.isEmpty
                ? Center(
                    child: Text("No notes yet",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)))
                : ListView.builder(
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      int reversedIndex = box.values.length - 1 - index;
                      final NoteModel? note = box.getAt(reversedIndex);
                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _onLocationChanged(
                                FloatingActionButtonLocation.centerFloat);
                            longPressed = true;
                            note!.checked = true;
                          });
                        },
                        child: Hero(
                          tag: 'note ${note!.key}',
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                            color: Colors.grey[900],
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(9),
                              child: ListTile(
                                selectedTileColor: null,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoteDetail(
                                        note: NoteModel(
                                            title: note.title,
                                            content: note.content,
                                            createdTime: note.createdTime,
                                            checked: note.checked),
                                        index: reversedIndex,
                                      ),
                                    ),
                                  );
                                  //
                                },
                                title: Text(
                                  note.title.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(note.content.toString(),
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white)),
                                trailing: longPressed
                                    ? Checkbox(
                                        activeColor: Colors.green,
                                        value: note.checked,
                                        shape: CircleBorder(),
                                        onChanged: (val) {
                                          setState(() {
                                            note.checked = val as bool;
                                            if (note.checked == true) {
                                              checkedNotes.add(note.key);
                                            } else {
                                              checkedNotes.remove(note.key);
                                            }
                                          });
                                        })
                                    : SizedBox(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButtonLocation: _fabLocation,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: longPressed ? Colors.grey : Colors.white,
        child: Icon(
          longPressed ? Icons.delete : Icons.edit_outlined,
          size: 25,
          color: Colors.black,
        ),
        onPressed: () {
          if (longPressed == true) {
            if (checkedNotes.isEmpty) {
              null;
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      titlePadding: EdgeInsets.all(20),
                      title: Text("Are you sure you want to delete?",
                          style: TextStyle(fontSize: 15)),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _refreshNotes();
                          },
                          child: Text("No"),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                checkedNotes.forEach((key) {
                                  box.delete(key);
                                });
                                _refreshNotes();
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              "yes, delete",
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    );
                  });
            }
          }
          // });
          else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NoteEditor()));
          }
        },
      ),
    );
  }
}
