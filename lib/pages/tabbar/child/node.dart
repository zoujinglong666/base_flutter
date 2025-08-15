import 'package:flutter/material.dart';

import '../../../database/notes_database.dart';

class NodePage extends StatefulWidget {
  const NodePage({super.key});

  @override
  State<NodePage> createState() => _NodePageState();
}

class _NodePageState extends State<NodePage> with TickerProviderStateMixin {
  bool isShow = true;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final notes = await NotesDatabase.getAllNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
        surfaceTintColor: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final double itemSize = (MediaQuery
        .of(context)
        .size
        .width - 8 * 3 - 16) / 4;
    // 屏幕宽 - 横向间距总和 - padding（左右各8）
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 8, // 水平方向间距
        runSpacing: 12, // 垂直方向间距
        children: List.generate(
          8,
              (index) =>
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () {

                },
                child: Container(
                  width: itemSize,
                  height: itemSize,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Image.asset(
                    'lib/assets/icon/${index + 1}.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
        ),
      ),
    );
  }




}
