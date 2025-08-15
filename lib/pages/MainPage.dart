
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/tabbar/find.dart';
import 'package:flutter_app/pages/tabbar/home.dart';
import 'package:flutter_app/pages/tabbar/msg.dart';
import 'package:flutter_app/pages/tabbar/my.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const FindPage(),
    const MessagePage(),
    const MyPage(),
  ];

  void changeTabbar(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: selectIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectIndex,
        onTap: changeTabbar,
        type: BottomNavigationBarType.fixed,
        // 超过3个需要固定模式
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
