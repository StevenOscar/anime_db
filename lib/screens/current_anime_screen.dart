import 'package:anime_db/providers/anime_provider.dart';
import 'package:anime_db/providers/character_provider.dart';
import 'package:anime_db/screens/anime_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentAnimeScreen extends StatefulWidget {
  const CurrentAnimeScreen({
    super.key,
  });

  @override
  State<CurrentAnimeScreen> createState() => _CurrentAnimeScreenState();
}

class _CurrentAnimeScreenState extends State<CurrentAnimeScreen> {
  @override
  Widget build(BuildContext context) {
    var currentwidth = MediaQuery.of(context).size.width;
    CharacterProvider characterProvider = context.watch<CharacterProvider>();
    CurrentSeasonAnimeProvider currSeasonAnimeProvider = context.watch<CurrentSeasonAnimeProvider>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        currSeasonAnimeProvider.clearProvider();
        currSeasonAnimeProvider.getAnimeCurrentSeasonList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Currently Airing",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        ),
        body: SingleChildScrollView(
          child: Consumer<CurrentSeasonAnimeProvider>(
            builder: (_, currSeasonAnimeProvider, __) {
              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  currSeasonAnimeProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 3,
                          ),
                        )
                      : currSeasonAnimeProvider.animeList.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: currSeasonAnimeProvider.animeList.length,
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
                                    characterProvider.getCharacterByAnime(animeId: currSeasonAnimeProvider.animeList[index].malId);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnimeDetailScreen(animeData: currSeasonAnimeProvider.animeList[index]),
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
                                              imageUrl: currSeasonAnimeProvider.animeList[index].images["jpg"] == null ? "" : currSeasonAnimeProvider.animeList[index].images["jpg"]!.largeImageUrl ?? "",
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
                                                    currSeasonAnimeProvider.animeList[index].title ?? "No Title",
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
                                                        itemCount: currSeasonAnimeProvider.animeList[index].genres == null ? 0 : currSeasonAnimeProvider.animeList[index].genres!.length,
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
                                                                currSeasonAnimeProvider.animeList[index].genres![genreIndex].name!,
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
                                                    child: Text(currSeasonAnimeProvider.animeList[index].synopsis ?? "(No Synopsis)", style: TextStyle(color: Colors.white)),
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
                                                          currSeasonAnimeProvider.animeList[index].aired != null ? currSeasonAnimeProvider.animeList[index].aired!.from.substring(0, 4) : "No date",
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
                                                              currSeasonAnimeProvider.animeList[index].score == -1 ? "No rating" : currSeasonAnimeProvider.animeList[index].score.toString(),
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
                          : currSeasonAnimeProvider.errorMessage == null
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
                                        currSeasonAnimeProvider.errorMessage!,
                                        style: TextStyle(color: Colors.red, fontSize: 30),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        onPressed: () async {
                                          await currSeasonAnimeProvider.clearProvider();
                                          await currSeasonAnimeProvider.getAnimeCurrentSeasonList();
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
                  currSeasonAnimeProvider.isLoading
                      ? SizedBox.shrink()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: currSeasonAnimeProvider.currentPage != 1
                                  ? () async {
                                      await currSeasonAnimeProvider.decrementPage();
                                      await currSeasonAnimeProvider.getAnimeCurrentSeasonList();
                                    }
                                  : null,
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                size: 40,
                                color: currSeasonAnimeProvider.currentPage != 1 ? Colors.red : Colors.grey,
                              ),
                            ),
                            Text(
                              currSeasonAnimeProvider.currentPage.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              onPressed: currSeasonAnimeProvider.hasNextPage
                                  ? () async {
                                      await currSeasonAnimeProvider.incrementPage();
                                      await currSeasonAnimeProvider.getAnimeCurrentSeasonList();
                                    }
                                  : null,
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                size: 40,
                                color: currSeasonAnimeProvider.hasNextPage ? Colors.red : Colors.grey,
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
      ),
    );
  }
}
