import 'package:anime_db/models/callback_model.dart';
import 'package:anime_db/constants/genres.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFormFieldSearch extends StatefulWidget {
  final Function(String) onSubmitted;
  final TextEditingController controller;
  final List<String>? selectedGenre;
  final int? selectedStartYear;
  final int? selectedEndYear;
  void Function(CallbackModel val) callback;

  TextFormFieldSearch({
    super.key,
    required this.onSubmitted,
    required this.controller,
    this.selectedGenre,
    this.selectedStartYear,
    this.selectedEndYear,
    required this.callback,
  });

  @override
  State<TextFormFieldSearch> createState() => _TextFormFieldSearchState();
}

class _TextFormFieldSearchState extends State<TextFormFieldSearch> {
  List<String> selectedGenre = [];
  int? selectedStartYear;
  int? selectedEndYear;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    selectedGenre = List.from(widget.selectedGenre ?? []);
    selectedStartYear = widget.selectedStartYear;
    selectedEndYear = widget.selectedEndYear;
    return TextFormField(
      controller: widget.controller,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      onTap: () {
        setState(() {
          focusNode.requestFocus();
        });
      },
      onTapOutside: (event) {
        setState(() {
          focusNode.unfocus();
        });
      },
      style: TextStyle(color: focusNode.hasFocus ? Colors.black : Colors.grey[400]),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 0.2), borderRadius: BorderRadius.circular(20)),
        focusColor: const Color.fromARGB(255, 149, 40, 32),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: const Color.fromARGB(255, 88, 11, 5), width: 3), borderRadius: BorderRadius.circular(20)),
        fillColor: focusNode.hasFocus ? const Color.fromARGB(255, 251, 251, 251) : Colors.red[900],
        filled: true,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Icon(
            Icons.search,
            color: focusNode.hasFocus ? Colors.black : Colors.grey[400],
          ),
        ),
        hintText: "Search Anime",
        suffixIcon: IconButton(
          onPressed: () {
            List<String> temporarySelectedGenre = List.from(selectedGenre);
            int? temporarySelectedStartYear = selectedStartYear;
            int? temporarySelectedEndYear = selectedEndYear;
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  var currentwidth = MediaQuery.of(context).size.width;
                  return AlertDialog(
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.black),
                          )),
                      ElevatedButton(
                          onPressed: ((temporarySelectedStartYear ?? 0) <= (temporarySelectedEndYear ?? 10000))
                              ? () {
                                  setState(() {
                                    selectedGenre = temporarySelectedGenre;
                                    selectedStartYear = temporarySelectedStartYear;
                                    selectedEndYear = temporarySelectedEndYear;
                                    widget.callback(CallbackModel(
                                      selectedGenre: List.from(selectedGenre),
                                      selectedStartYear: selectedStartYear,
                                      selectedEndYear: selectedEndYear,
                                    ));
                                  });
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Center(
                                        child: Text(
                                          "Please submit after applying filter",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: Text("Save Filter", style: TextStyle(color: Colors.white)))
                    ],
                    content: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Center(
                                  child: Text(
                                    "Airing",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    initialValue: temporarySelectedStartYear != null ? temporarySelectedStartYear.toString() : "",
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                    onChanged: (year) {
                                      if (year.isEmpty) {
                                        temporarySelectedStartYear = null;
                                      } else {
                                        temporarySelectedStartYear = int.parse(year);
                                      }
                                    },
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.red, width: 1.2)),
                                      hintText: "Start Year",
                                      hintStyle: TextStyle(color: Colors.white),
                                      fillColor: Colors.red,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.red, width: 1.2)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  width: 20,
                                  height: 2,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 110,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    initialValue: temporarySelectedEndYear != null ? temporarySelectedEndYear.toString() : "",
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                                    onChanged: (year) {
                                      setState(() {
                                        if (year.isEmpty) {
                                          temporarySelectedEndYear = null;
                                        } else {
                                          temporarySelectedEndYear = int.parse(year);
                                        }
                                      });
                                    },
                                    cursorColor: Colors.white,
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.red, width: 1.2)),
                                      hintText: "End Year",
                                      hintStyle: TextStyle(color: Colors.white),
                                      fillColor: Colors.red,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(color: Colors.red, width: 1.2)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ((temporarySelectedStartYear ?? 0) <= (temporarySelectedEndYear ?? 10000))
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      "Start year must be higher than end year",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                            Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 8),
                                child: Center(
                                  child: Text(
                                    "Genres",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                )),
                            SizedBox(
                              child: SizedBox(
                                height: 300,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing: currentwidth / 100,
                                    runSpacing: currentwidth / 100,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      for (int i = 0; i < Genres.genresMap.length; i++)
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              temporarySelectedGenre.contains(Genres.genresMap.keys.elementAt(i)) ? temporarySelectedGenre.remove(Genres.genresMap.keys.elementAt(i)) : temporarySelectedGenre.add(Genres.genresMap.keys.elementAt(i));
                                            });
                                          },
                                          child: Chip(
                                            color: WidgetStatePropertyAll(
                                              temporarySelectedGenre.contains(Genres.genresMap.keys.elementAt(i)) ? Colors.red : Colors.white,
                                            ),
                                            label: Text(Genres.genresMap.keys.elementAt(i), style: TextStyle(color: temporarySelectedGenre.contains(Genres.genresMap.keys.elementAt(i)) ? Colors.white : Colors.black)),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            );
          },
          icon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.tune_rounded,
              color: focusNode.hasFocus ? Colors.black : Colors.grey[400],
            ),
          ),
        ),
      ),
      onFieldSubmitted: (value) async {
        await widget.onSubmitted(value);
      },
    );
  }
}
