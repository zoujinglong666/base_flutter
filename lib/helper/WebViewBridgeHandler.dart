import 'dart:convert';
import 'package:flutter/material.dart';

import '../components/CWebview/index.dart';


class WebViewBridgeHandler {
  /// 统一处理 JS 发送来的消息
  static void handle(BuildContext context, String message) {
    print('接收到 JS 消息: $message');

    try {
      final data = jsonDecode(message);
      final action = data['action'];

      switch (action) {
        case 'openNewWebView':
          _openNewWebView(context, data);
          break;

        case 'closePage':
          Navigator.of(context).maybePop();
          break;

        case 'showToast':
          _showToast(context, data['message'] ?? '提示');
          break;
        case 'goBack':
          Navigator.pop(context);
          break;
        default:
          print('未处理的 action: $action');
      }
    } catch (e) {
      print('解析 JS 消息失败: $e');
    }
  }

  /// 打开一个新的 WebView 页面
  static void _openNewWebView(BuildContext context, Map<String, dynamic> data) {
    final url = data['url'];
    final title = data['title'];

    if (url != null && url.toString().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SimpleWebView(
            initialUrl: url,
            pageTitle: title,
          ),
        ),
      );
    } else {
      _showToast(context, 'URL 无效');
    }
  }

  /// 显示一个提示
  static void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
