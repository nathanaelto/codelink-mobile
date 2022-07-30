import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color(0xFF0A0A36),
        // The search area here
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(color: Color(0xFF0A0A36), fontSize: 25),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5) ),
            child: Center(
              child: TextField(
                key: const Key("tf_search"),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        /* Clear the search field */
                      },
                    ),
                    hintText: 'Search...',
                    border: const UnderlineInputBorder()),
              ),
            ),
          )),
    );
  }
}