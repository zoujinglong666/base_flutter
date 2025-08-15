import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../database/notes_database.dart';


class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _controller = TextEditingController();
  final List<File> _images = [];
  final picker = ImagePicker();
  void _saveNote() async {
    final text = _controller.text.trim();
    final images = _images.map((file) => file.path).toList();

    // 判空逻辑：内容或图片必须至少一个有值
    if (text.isEmpty && images.isEmpty) {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('请输入内容或选择至少一张图片')),
      );
      return;
    }

    await NotesDatabase.insertNote(text, images);

    debugPrint('保存成功: 内容=$text, 图片数=${images.length}');
    Navigator.pop(context as BuildContext);
  }

  // 简单模拟的表情列表
  final List<String> _emojis = ['😊', '❤️', '🎉', '👍', '🔥'];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(selection.start, selection.end, emoji);
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + emoji.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加笔记'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 多行文本输入
            TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: '写点什么吧...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // 已选择的图片列表
            if (_images.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Image.file(
                            _images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            // 工具栏：图片 / 表情
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) {
                        return GridView.count(
                          padding: const EdgeInsets.all(16),
                          crossAxisCount: 5,
                          shrinkWrap: true,
                          children:
                              _emojis.map((e) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _insertEmoji(e);
                                  },
                                  child: Center(
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
