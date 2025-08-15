import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/KeyboardDismissOnTap.dart';
import '../about/index.dart';
import '../setting/index.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  void _handleCellTap(BuildContext context, String title) {
    switch (title.trim()) {
      case '关于我们':
        Navigator.push(context, CupertinoPageRoute(builder: (_) => AboutPage()));
        break;
      case '设置':
        Navigator.push(context, CupertinoPageRoute(builder: (_) => SettingsPage()));
        break;
      case '清空缓存':
        _clearWebViewCache(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('未实现页面：$title')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCardSection(context, [
                    {
                      'icon': Icons.shopping_bag,
                      'title': '我的订单',
                      'subtitle': '查看全部订单',
                    },
                    {
                      'icon': Icons.favorite,
                      'title': '我的收藏',
                      'subtitle': '商品、文章等',
                    },
                  ]),
                  _buildCardSection(context, [
                    {
                      'icon': Icons.account_circle,
                      'title': '账号与安全',
                    },
                    {
                      'icon': Icons.settings,
                      'title': '设置',
                    },
                    {
                      'icon': Icons.info_outline,
                      'title': '关于我们',
                    },
                    {
                      'icon': Icons.info_outline,
                      'title': '清空缓存',
                    },
                    {
                      'icon': Icons.logout,
                      'title': '退出登录',
                      'showArrow': false,
                      'onTap': (BuildContext context) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已退出登录')),
                        );
                      },
                    },
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundImage: NetworkImage(
              'https://p26-passport.byteacctimg.com/img/user-avatar/49b6ee1f2a9d309ff1aa46cf5adde96a~130x130.awebp',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '昵称：Flutter开发者',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '签名：用代码改变世界',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (_) => SettingsPage()));
            },
            child: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(BuildContext context, List<Map<String, dynamic>> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const Divider(height: 0.5, indent: 16, endIndent: 16);
          }
          final item = items[index ~/ 2];
          return _buildCell(
            context: context,
            icon: item['icon'],
            title: item['title'],
            subtitle: item['subtitle'],
            showArrow: item['showArrow'] ?? true,
            onTap: item['onTap'] != null
                ? () => item['onTap']!(context)
                : () => _handleCellTap(context, item['title']),
          );
        }),
      ),
    );
  }

  Widget _buildCell({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      )
          : null,
      trailing: showArrow
          ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
          : null,
    );
  }


  Future<void> _clearWebViewCache(BuildContext context) async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();

    final controller = WebViewController();
    await controller.clearCache();

    // 使用 JS 清理 localStorage 和 sessionStorage
    try {
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.loadHtmlString('<html><body></body></html>'); // 先加载空白页
      await controller.runJavaScript('''
      localStorage.clear();
      sessionStorage.clear();
    ''');
    } catch (e) {
      debugPrint('清除 localStorage 失败: $e');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WebView 缓存与本地存储已清除'),
        duration: Duration(milliseconds: 300),
      ),
    );
  }

}
