import '../../components/CWebview/index.dart';
import 'package:flutter/material.dart';

class FindPage extends StatelessWidget {
  const FindPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SimpleWebView(
        initialUrl: 'http://10.9.17.97:8890/#/about',
        pageTitle: '关于我们',
        showBackIcon: false,
      ),
    );
  }
}
