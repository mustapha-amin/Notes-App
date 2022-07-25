import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? content;
  @HiveField(2)
  DateTime? createdTime;
  @HiveField(3)
  bool? checked;

  NoteModel({this.title, this.content, this.createdTime, this.checked});
}
