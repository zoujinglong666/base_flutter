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
  late PageController pageController;
  String searchWord = '搜点什么···';

  List<Widget> pageviews = [
    NodePage(),
    SimpleWebView(initialUrl: 'https://juejin.cn/'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pageController = PageController(initialPage: 0);
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
          _buildTap(context),
          Expanded(
            // 使用 Expanded 包裹 PageView
            child: PageView(
              controller: pageController, // 绑定 TabController
              onPageChanged: (index) {
                setState(() {
                  tabController.animateTo(index);
                });
              },
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
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => AddNotePage()),
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

  Widget _buildTap(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: TabBar(
        tabs: [Tab(text: '笔记'), Tab(text: '精选')],
        controller: tabController,
        indicatorColor: Theme.of(context).colorScheme.onSurface,
        indicatorWeight: 2,
        labelColor: Theme.of(context).colorScheme.onSurface,
        unselectedLabelColor: Colors.grey,
        // 去除下划线
        dividerColor: Colors.transparent,
        onTap: (index) {
          setState(() {
            pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
