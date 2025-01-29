import 'package:anime_db/text_form_field.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  final TextEditingController searchController;
  final List<String> selectedGenre;

  const SearchResultScreen({
    super.key,
    required this.searchController,
    required this.selectedGenre,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 87,
        leading: IconButton(
            padding: EdgeInsets.only(left: 12),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 28,
            )),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        backgroundColor: Colors.red,
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: TextFormFieldSearchAnime(
            controller: widget.searchController,
            onSubmitted: (value) {},
            selectedGenre: widget.selectedGenre,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.selectedGenre.length,
              itemBuilder: (context, index) {
                return Text(widget.selectedGenre[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
