import 'package:anime_db/providers/anime_provider.dart';
import 'package:anime_db/models/callback_model.dart';
import 'package:anime_db/providers/character_provider.dart';
import 'package:anime_db/screens/anime_detail_screen.dart';
import 'package:anime_db/screens/current_anime_screen.dart';
import 'package:anime_db/screens/search_result_screen.dart';
import 'package:anime_db/screens/top_anime_screen.dart';
import 'package:anime_db/widgets/text_form_field_search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> selectedGenre = [];
  int? selectedStartYear;
  int? selectedEndYear;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currSeasonAnimeProvider = context.read<CurrentSeasonAnimeProvider>();
      final topAnimeProvider = context.read<TopAnimeProvider>();
      currSeasonAnimeProvider.getAnimeCurrentSeasonList();
      topAnimeProvider.getTopAnime();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentwidth = MediaQuery.of(context).size.width;
    SearchAnimeProvider searchAnimeProvider = context.read<SearchAnimeProvider>();
    CharacterProvider characterProvider = context.watch<CharacterProvider>();

    return Scaffold(
      appBar: currentwidth >= 600
          ?
          // Appbar web
          AppBar(
              leading: Icon(Icons.abc),
              toolbarHeight: 70,
              title: Text(
                "AniDB",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                SizedBox(
                  width: currentwidth * 0.6,
                  child: Padding(
                    padding: EdgeInsets.only(right: currentwidth * 0.05),
                    child: TextFormFieldSearch(
                      controller: searchController,
                      selectedGenre: selectedGenre,
                      selectedStartYear: selectedStartYear,
                      selectedEndYear: selectedEndYear,
                      onSubmitted: (value) async {
                        await searchAnimeProvider.clearProvider();
                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultScreen(
                              searchedTitle: searchController.text,
                              selectedGenre: selectedGenre,
                              selectedStartYear: selectedStartYear,
                              selectedEndYear: selectedEndYear,
                            ),
                          ),
                        );
                        await searchAnimeProvider.getAnimeSearch(
                          title: searchController.text,
                          genres: selectedGenre,
                          startYear: selectedStartYear,
                          endYear: selectedEndYear,
                        );
                        setState(() {
                          searchController.clear();
                          selectedGenre = [];
                          selectedStartYear = null;
                          selectedEndYear = null;
                        });
                      },
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
                Icon(Icons.search)
              ],
              backgroundColor: Colors.red,
            )
          :
          // Appbar mobile
          AppBar(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
              bottom: PreferredSize(
                preferredSize: Size(10, 60),
                child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: TextFormFieldSearch(
                        controller: searchController,
                        selectedGenre: selectedGenre,
                        selectedStartYear: selectedStartYear,
                        selectedEndYear: selectedEndYear,
                        onSubmitted: (value) async {
                          await searchAnimeProvider.clearProvider();
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultScreen(
                                searchedTitle: searchController.text,
                                selectedGenre: selectedGenre,
                                selectedStartYear: selectedStartYear,
                                selectedEndYear: selectedEndYear,
                              ),
                            ),
                          );
                          await searchAnimeProvider.getAnimeSearch(
                            title: searchController.text,
                            genres: selectedGenre,
                            startYear: selectedStartYear,
                            endYear: selectedEndYear,
                          );
                          setState(() {
                            searchController.clear();
                            selectedGenre = [];
                            selectedStartYear = null;
                            selectedEndYear = null;
                          });
                        },
                        callback: (CallbackModel val) {
                          setState(() {
                            selectedGenre = List.from(val.selectedGenre);
                            selectedStartYear = val.selectedStartYear;
                            selectedEndYear = val.selectedEndYear;
                          });
                        },
                      ),
                    )),
              ),
              backgroundColor: Colors.red,
              centerTitle: true,
              title: Text(
                "AniDB",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
      body: SingleChildScrollView(
        child: Consumer2<CurrentSeasonAnimeProvider, TopAnimeProvider>(
          builder: (_, currSeasonAnimeProvider, topAnimeProvider, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Currently Airing",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26),
                      ),
                      TextButton(
                          onPressed: () async {
                            await currSeasonAnimeProvider.clearProvider();
                            currSeasonAnimeProvider.getAnimeCurrentSeasonList();
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CurrentAnimeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "See More",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ),
                currSeasonAnimeProvider.animeList.isNotEmpty
                    ? SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: currSeasonAnimeProvider.animeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                characterProvider.getCharacterByAnime(animeId: currSeasonAnimeProvider.animeList[index].malId);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimeDetailScreen(animeData: currSeasonAnimeProvider.animeList[index]),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: 180,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(color: Colors.red),
                                        ),
                                        imageUrl: currSeasonAnimeProvider.animeList[index].images["jpg"]!.imageUrl!,
                                        fit: BoxFit.fitWidth,
                                        errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withAlpha(0),
                                              Colors.black12,
                                              Colors.black26,
                                              Colors.black,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [
                                              0.0,
                                              0.5,
                                              0.6,
                                              0.9,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 165,
                                        child: SizedBox(
                                          width: 160,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.star, color: Colors.amber, size: 20),
                                                    Text(
                                                      currSeasonAnimeProvider.animeList[index].score == -1 ? "No rating" : currSeasonAnimeProvider.animeList[index].score.toString(),
                                                      style: TextStyle(color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                child: Text(
                                                  currSeasonAnimeProvider.animeList[index].title ?? "Test",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Top Anime",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            await topAnimeProvider.clearProvider();
                            topAnimeProvider.getTopAnime();
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TopAnimeScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "See More",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ),
                topAnimeProvider.animeList.isNotEmpty
                    ? SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: topAnimeProvider.animeList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                characterProvider.getCharacterByAnime(animeId: topAnimeProvider.animeList[index].malId);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimeDetailScreen(animeData: topAnimeProvider.animeList[index]),
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: 180,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: 180,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(color: Colors.red),
                                            ),
                                            imageUrl: topAnimeProvider.animeList[index].images["jpg"]!.imageUrl!,
                                            fit: BoxFit.fitWidth,
                                            errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withAlpha(0),
                                              Colors.black12,
                                              Colors.black26,
                                              Colors.black,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [
                                              0.0,
                                              0.5,
                                              0.6,
                                              0.9,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 165,
                                        child: SizedBox(
                                          width: 160,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.star, color: Colors.amber, size: 20),
                                                    Text(
                                                      topAnimeProvider.animeList[index].score == -1 ? "No rating" : topAnimeProvider.animeList[index].score.toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                child: Text(
                                                  topAnimeProvider.animeList[index].title ?? "Test",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.black.withAlpha(200), borderRadius: BorderRadius.only(bottomRight: Radius.circular(10))),
                                          child: Text(
                                            "#${(index + 1)}",
                                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                SizedBox(height: 80)
              ],
            );
          },
        ),
      ),
    );
  }
}
