import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WallPaper extends StatefulWidget {
  const WallPaper({Key? key}) : super(key: key);

  @override
  State<WallPaper> createState() => _WallPaperState();
}

class _WallPaperState extends State<WallPaper> {
  @override
  List images = [];
  int page = 1;

  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
        headers: {
          'Authorization':
              '563492ad6f91700001000001dee1d4a36da148b9a32eb22f8651aea8'
        }).then((value) {
      // print(value.body);
      Map result = jsonDecode(value.body);
      // print(result);
      setState(() {
        images = result['photos'];
      });
      // print(images.length);
      print(images[0]);
    });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), headers: {
      'Authorization':
          '563492ad6f91700001000001dee1d4a36da148b9a32eb22f8651aea8'
    }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Wall Hub',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Container(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  child: Image.network(
                    images[index]['src']['tiny'],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        InkWell(
          onTap: () {
            loadmore();
          },
          child: Container(
            height: 60,
            width: double.infinity,
            color: Colors.black,
            child: Center(
              child: Text(
                "Load More",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
