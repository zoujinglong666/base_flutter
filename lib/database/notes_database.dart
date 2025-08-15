import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// 定义笔记模型（可选）
class Note {
  final int id;
  final String content;
  final List<String> images;

  Note({
    required this.id,
    required this.content,
    required this.images,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      content: map['content'],
      images: map['images']?.toString().isNotEmpty == true
          ? map['images'].split(',')
          : [],
    );
  }
}
class NotesDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('notes.db');
    return _db!;
  }

  static Future<Database> _initDB(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT,
            images TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertNote(String content, List<String> images) async {
    final db = await database;
    await db.insert(
      'notes',
      {
        'content': content,
        'images': images.join(','), // 用逗号连接图片路径
      },
    );
  }

  static Future<List<Note>> getAllNotes() async {
    final db = await database;
    final result = await db.query('notes', orderBy: 'id DESC');

    return result.map((row) => Note.fromMap(row)).toList();
  }
}