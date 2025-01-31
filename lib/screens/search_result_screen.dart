import 'package:anime_db/providers/anime_provider.dart';
import 'package:anime_db/models/callback_model.dart';
import 'package:anime_db/providers/character_provider.dart';
import 'package:anime_db/screens/anime_detail_screen.dart';
import 'package:anime_db/widgets/text_form_field_search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String? searchedTitle;
  final List<String> selectedGenre;
  final int? selectedStartYear;
  final int? selectedEndYear;

  const SearchResultScreen({
    super.key,
    required this.searchedTitle,
    required this.selectedGenre,
    this.selectedStartYear,
    this.selectedEndYear,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late List<String> selectedGenre;
  late int? selectedStartYear;
  late int? selectedEndYear;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    selectedGenre = List.from(widget.selectedGenre);
    selectedStartYear = widget.selectedStartYear;
    selectedEndYear = widget.selectedEndYear;
    searchController = TextEditingController(text: widget.searchedTitle);
  }

  @override
  Widget build(BuildContext context) {
    var currentwidth = MediaQuery.of(context).size.width;
    SearchAnimeProvider searchAnimeProvider = context.read<SearchAnimeProvider>();
    CharacterProvider characterProvider = context.watch<CharacterProvider>();
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
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.red,
        title: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: TextFormFieldSearch(
            controller: searchController,
            onSubmitted: (value) async {
              await searchAnimeProvider.clearProvider();
              await searchAnimeProvider.getAnimeSearch(
                title: searchController.text,
                genres: selectedGenre,
                startYear: selectedStartYear,
                endYear: selectedEndYear,
              );
            },
            selectedGenre: selectedGenre,
            selectedStartYear: selectedStartYear,
            selectedEndYear: selectedEndYear,
            callback: (CallbackModel val) {
              setState(() {
                selectedGenre = List.from(val.selectedGenre);
                selectedStartYear = val.selectedStartYear;
                selectedEndYear = val.selectedEndYear;
              });
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<SearchAnimeProvider>(
          builder: (_, searchAnimeProvider, __) {
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                searchAnimeProvider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                          strokeWidth: 3,
                        ),
                      )
                    : searchAnimeProvider.animeList.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: searchAnimeProvider.animeList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: (currentwidth / 650).ceil().toInt(),
                              childAspectRatio: 8 / 7,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 15,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  characterProvider.getCharacterByAnime(animeId: searchAnimeProvider.animeList[index].malId);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AnimeDetailScreen(animeData: searchAnimeProvider.animeList[index]),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 330,
                                  child: Card(
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.5,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: double.infinity,
                                          width: 170,
                                          child: CachedNetworkImage(
                                            alignment: Alignment.center,
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(color: Colors.white),
                                            ),
                                            imageUrl: searchAnimeProvider.animeList[index].images["jpg"] == null ? "" : searchAnimeProvider.animeList[index].images["jpg"]!.largeImageUrl ?? "",
                                            fit: BoxFit.fill,
                                            errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 12,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  searchAnimeProvider.animeList[index].title ?? "No Title",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                                                ),
                                                SizedBox(height: 5),
                                                Divider(
                                                  color: Colors.white,
                                                  thickness: 2,
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                  child: ScrollConfiguration(
                                                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                                    child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      physics: AlwaysScrollableScrollPhysics(),
                                                      itemCount: searchAnimeProvider.animeList[index].genres == null ? 0 : searchAnimeProvider.animeList[index].genres!.length,
                                                      itemBuilder: (context, genreIndex) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(right: 5),
                                                          child: Chip(
                                                            shape: RoundedRectangleBorder(
                                                              side: BorderSide(
                                                                width: 0,
                                                                color: Colors.black,
                                                              ),
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            color: WidgetStatePropertyAll(Colors.red[900]),
                                                            label: Text(
                                                              searchAnimeProvider.animeList[index].genres![genreIndex].name!,
                                                              style: TextStyle(color: Colors.white),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Expanded(
                                                  child: Text(searchAnimeProvider.animeList[index].synopsis ?? "(No Synopsis)", style: TextStyle(color: Colors.white)),
                                                ),
                                                SizedBox(height: 3),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                      child: Text(
                                                        searchAnimeProvider.animeList[index].aired != null ? searchAnimeProvider.animeList[index].aired!.from.substring(0, 4) : "No date",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.2,
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 20,
                                                          ),
                                                          Text(
                                                            searchAnimeProvider.animeList[index].score == -1 ? "No rating" : searchAnimeProvider.animeList[index].score.toString(),
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : searchAnimeProvider.errorMessage == null
                            ? Center(
                                child: Text(
                                  "No anime found!",
                                  style: TextStyle(color: Colors.red, fontSize: 30),
                                ),
                              )
                            : Center(
                                child: Column(
                                  children: [
                                    Text(
                                      searchAnimeProvider.errorMessage!,
                                      style: TextStyle(color: Colors.red, fontSize: 30),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () async {
                                        await searchAnimeProvider.getAnimeSearch(
                                          title: searchController.text,
                                          genres: selectedGenre,
                                          startYear: selectedStartYear,
                                          endYear: selectedEndYear,
                                        );
                                      },
                                      child: Text(
                                        "Reload",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                SizedBox(
                  height: 20,
                ),
                searchAnimeProvider.isLoading
                    ? SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: searchAnimeProvider.currentPage != 1
                                ? () async {
                                    await searchAnimeProvider.decrementPage();
                                    await searchAnimeProvider.getAnimeSearch(
                                      title: searchController.text,
                                      genres: selectedGenre,
                                      startYear: selectedStartYear,
                                      endYear: selectedEndYear,
                                    );
                                  }
                                : null,
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              size: 40,
                              color: searchAnimeProvider.currentPage != 1 ? Colors.red : Colors.grey,
                            ),
                          ),
                          Text(
                            searchAnimeProvider.currentPage.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: searchAnimeProvider.hasNextPage
                                ? () async {
                                    await searchAnimeProvider.incrementPage();
                                    await searchAnimeProvider.getAnimeSearch(
                                      title: searchController.text,
                                      genres: selectedGenre,
                                      startYear: selectedStartYear,
                                      endYear: selectedEndYear,
                                    );
                                  }
                                : null,
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 40,
                              color: searchAnimeProvider.hasNextPage ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 100)
              ],
            );
          },
        ),
      ),
    );
  }
}
