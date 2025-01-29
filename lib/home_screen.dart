import 'package:anime_db/anime_provider.dart';
import 'package:anime_db/search_result_screen.dart';
import 'package:anime_db/text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currSeasonAnimeProvider =
          context.read<CurrentSeasonAnimeProvider>();
      final topAnimeProvider = context.read<TopAnimeProvider>();
      currSeasonAnimeProvider.getAnimeCurrentSeasonList();
      topAnimeProvider.getTopAnime();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentwidth = MediaQuery.of(context).size.width;
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: currentwidth >= 600
          ?
          // Appbar web
          AppBar(
              leading: Icon(Icons.abc),
              title: Text(
                "AniDB",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 7),
                  width: currentwidth * 0.6,
                  child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        fillColor: Colors.red[800],
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Icon(Icons.search)
              ],
              backgroundColor: Colors.red,
            )
          :
          // Appbar mobile
          AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              bottom: PreferredSize(
                preferredSize: Size(10, 60),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: TextFormFieldSearchAnime(
                        controller: searchController,
                        onSubmitted: (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResultScreen(
                                      searchController: searchController,
                                      selectedGenre: ["Action", "Romance"],
                                    )),
                          );
                        },
                      ),
                    )),
              ),
              backgroundColor: Colors.red,
              centerTitle: true,
              title: Text(
                "AniDB",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return WebView();
            } else {
              return MobileView();
            }
          },
        ),
      ),
    );
  }
}

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CurrentSeasonAnimeProvider, TopAnimeProvider>(
      builder: (_, currSeasonAnimeProvider, topAnimeProvider, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Currently Airing",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
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
                        return SizedBox(
                          width: 180,
                          child: Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red),
                                  ),
                                  imageUrl: currSeasonAnimeProvider
                                      .animeList[index]
                                      .images["jpg"]!
                                      .imageUrl!,
                                  fit: BoxFit.fitWidth,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.image_not_supported),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 20),
                                              Text(
                                                currSeasonAnimeProvider
                                                            .animeList[index]
                                                            .score ==
                                                        -1
                                                    ? "No rating"
                                                    : currSeasonAnimeProvider
                                                        .animeList[index].score
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          child: Text(
                                            currSeasonAnimeProvider
                                                    .animeList[index].title ??
                                                "Test",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 3,
                    ),
                  ),
            //TODO : REvisi pemisah
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Top Anime",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
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
                        return SizedBox(
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
                                        child: CircularProgressIndicator(
                                            color: Colors.red),
                                      ),
                                      imageUrl: topAnimeProvider
                                          .animeList[index]
                                          .images["jpg"]!
                                          .imageUrl!,
                                      fit: BoxFit.fitWidth,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.image_not_supported),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 20),
                                              Text(
                                                topAnimeProvider
                                                            .animeList[index]
                                                            .score ==
                                                        -1
                                                    ? "No rating"
                                                    : topAnimeProvider
                                                        .animeList[index].score
                                                        .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          child: Text(
                                            topAnimeProvider
                                                    .animeList[index].title ??
                                                "Test",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(200),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10))),
                                    child: Text(
                                      "#${(index + 1)}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 3,
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
