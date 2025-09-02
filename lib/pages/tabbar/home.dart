import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/CWebview/index.dart';
import '../addNode/index.dart';
import 'child/node.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController tabController;
  String searchWord = '搜点什么···';

  final List<Widget> pageviews = [
    const NodePage(),
    const SimpleWebView(initialUrl: 'https://juejin.cn/'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        surfaceTintColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          _buildHeader(context),
          _buildTab(context),
          Expanded(
            child: IndexedStack(
              index: tabController.index,
              children: pageviews,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Row(
      children: [
        Image.asset('lib/assets/images/icon.png', width: 30, height: 30),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: searchWord,
                hintStyle:
                const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const AddNotePage()),
            );
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28,
          ),
        ),
      ],
    ),
  );

  Widget _buildTab(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: TabBar(
        tabs: const [Tab(text: '笔记'), Tab(text: '精选')],
        controller: tabController,
        indicatorColor: Theme.of(context).colorScheme.onSurface,
        indicatorWeight: 2,
        labelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelColor: Colors.grey,
        dividerColor: Colors.transparent,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
