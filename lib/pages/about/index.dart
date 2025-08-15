import '../../components/CWebview/index.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SimpleWebView(initialUrl: 'http://10.9.17.62:3000/#/about'),
    );
  }
}
