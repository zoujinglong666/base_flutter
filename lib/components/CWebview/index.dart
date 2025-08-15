import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebView extends StatefulWidget {
  final String initialUrl;
  final String? pageTitle;
  final bool? showNavBar;
  final bool? showBackIcon;
  final bool? showRef;

  const SimpleWebView({
    super.key,
    required this.initialUrl,
    this.pageTitle,
    this.showNavBar,
    this.showBackIcon,
    this.showRef,
  });

  @override
  State<SimpleWebView> createState() => _SimpleWebViewState();
}

class _SimpleWebViewState extends State<SimpleWebView> {
  late final WebViewController _controller;
  String _currentTitle = '';

  @override
  void initState() {
    super.initState();

    // 设置状态栏沉浸样式（白底黑字）
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // 安卓
        statusBarBrightness: Brightness.light, // iOS
      ),
    );

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..addJavaScriptChannel(
            'FlutterBridge',
            onMessageReceived: (message) {
              _handleJSMessage(message.message);
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) => print('页面开始加载: $url'),
              onPageFinished: (url) {
                print('页面加载完成: $url');
                _getTitle();
              },
              onNavigationRequest: (request) {
                print('导航请求: ${request.url}');
                return NavigationDecision.navigate;
              },
              onWebResourceError: (error) => print('加载出错: $error'),
            ),
          )
          ..loadRequest(Uri.parse(widget.initialUrl));

    // 延迟加载可以避免 build 中 layout 抖动
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse(widget.initialUrl));
    });
  }

  String? _cachedTitle;

  Future<void> _getTitle() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final rawTitle = await _controller.getTitle();
    if (!mounted) return;

    final title = rawTitle?.trim();

    // 如果是 URL 链接或空字符串，则忽略
    final isUrl =
        title != null && RegExp(r'^https?:\/\/[\w\.-]+').hasMatch(title) ||
        title!.contains("/#/");
    final isValidTitle = title != null && title.isNotEmpty && !isUrl;

    final newTitle = isValidTitle ? title : (widget.pageTitle ?? '');

    // 如果标题未变，避免 setState 触发重构
    if (newTitle == _cachedTitle) return;

    setState(() {
      _currentTitle = newTitle!;
      _cachedTitle = newTitle;
    });
  }

  void _handleJSMessage(String message) {
    try {
      final data = jsonDecode(message);
      final action = data['action'];

      if (action == 'openNewWebView') {
        final url = data['url'];
        final title = data['title'];
        final showNavBar = data['showNavBar'];

        if (url != null && url.toString().isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => SimpleWebView(
                    initialUrl: url,
                    pageTitle: title,
                    showNavBar: showNavBar ?? false,
                  ),
            ),
          );
        }
      } else if (action == 'goBack') {
        Navigator.pop(context);
      }
    } catch (e) {
      print('JS消息解析失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final showNav = widget.showNavBar != false;
    final showBackIcon = widget.showBackIcon != false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          showNav
              ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 1,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                  ),
                  leading:
                      showBackIcon
                          ? IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              if (await _controller.canGoBack()) {
                                _controller.goBack();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          )
                          : null,
                  centerTitle: true,
                  title: Text(
                    _currentTitle.isNotEmpty
                        ? _currentTitle
                        : (widget.pageTitle ?? ''),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.black),
                      onPressed: () {
                        _controller.reload();
                      },
                    ),
                  ],
                ),
              )
              : null,
      body: SafeArea(
        top: !showNav, // 防止双 SafeArea 造成留白
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
