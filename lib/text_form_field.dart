import 'package:anime_db/genres.dart';
import 'package:flutter/material.dart';

class TextFormFieldSearchAnime extends StatefulWidget {
  final Function(String) onSubmitted;
  final TextEditingController controller;
  List<String>? selectedGenre;

  TextFormFieldSearchAnime({ 
      super.key,
      required this.onSubmitted,
      required this.controller,
      this.selectedGenre,
  });

  @override
  State<TextFormFieldSearchAnime> createState() =>
      _TextFormFieldSearchAnimeState();
}

class _TextFormFieldSearchAnimeState extends State<TextFormFieldSearchAnime> {
  @override
  Widget build(BuildContext context) {
    if(widget.selectedGenre != null){
      List<String> selectedGenre = widget.selectedGenre!;
    }
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      decoration: InputDecoration(
        fillColor: Colors.red[800],
        filled: true,
        prefixIcon: Icon(Icons.search),
        hintText: "Search Anime",
        suffixIcon: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.black),
                        )),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text("Save Filter",
                            style: TextStyle(color: Colors.white)))
                  ],
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 3,
                          alignment: WrapAlignment.center,
                          children: [
                            for (int i = 0; i < Genres.genresMap.length; i++)
                              GestureDetector(
                                onTap: () {},
                                child: Chip(
                                  label:
                                      Text(Genres.genresMap.keys.elementAt(i)),
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.tune_rounded),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onFieldSubmitted: (value) {
        widget.onSubmitted(value);
      },
    );
  }
}
