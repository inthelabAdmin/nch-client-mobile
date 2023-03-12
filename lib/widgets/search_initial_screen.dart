import 'package:flutter/material.dart';

class SearchInitialPage extends StatelessWidget {
  const SearchInitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
          child: Image.asset('assets/img/search_background_placeholder.png',
              opacity: const AlwaysStoppedAnimation(.5)),
        ));
  }
}
