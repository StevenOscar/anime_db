import 'package:anime_db/models/anime_model.dart';
import 'package:anime_db/providers/character_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AnimeDetailScreen extends StatelessWidget {
  final AnimeModel animeData;
  const AnimeDetailScreen({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        toolbarHeight: 70,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: animeData.url));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        "Anime link copied successfully",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.share))
        ],
        title: Text(
          "Anime Detail",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return WebView(animeData: animeData);
            } else {
              return MobileView(animeData: animeData);
            }
          },
        ),
      ),
    );
  }
}

class WebView extends StatelessWidget {
  final AnimeModel animeData;
  const WebView({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 850;
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.red)),
                imageUrl: animeData.images["jpg"]?.largeImageUrl ?? "",
                fit: BoxFit.cover,
                width: isDesktop ? 400 : screenWidth * 0.3,
                errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        animeData.title ?? "No Title",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isDesktop ? 36 : 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: animeData.genres?.map((genre) {
                        return Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red[900],
                          label: Text(
                            genre.name!,
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        );
                      }).toList() ?? [],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !isDesktop ? 
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      animeData.score == -1 ? "No rating" : animeData.score.toString(),
                                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Type: ${animeData.type ?? "Unclassified"}",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              )
                            ],
                          ) : SizedBox.shrink(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${animeData.season ?? ""} ${animeData.aired?.from.substring(0, 4) ?? "No date"}",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              isDesktop ?
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        animeData.score == -1 ? "No rating" : animeData.score.toString(),
                                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ) : SizedBox.shrink()
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Duration: ${animeData.duration ?? "Unknown"}",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              isDesktop ?
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Type: ${animeData.type ?? "Unclassified"}",
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ) : SizedBox.shrink()
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Studio: ${animeData.studios!.first.name}",
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Synopsis",
                      style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      animeData.synopsis ?? "(No Synopsis)",
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Characters",
                      style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Consumer<CharacterProvider>(
                      builder: (context, characterProvider, child) {
                        if (characterProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator(color: Colors.red, strokeWidth: 3));
                        } else if (characterProvider.characterList.isNotEmpty) {
                          return isDesktop
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 3 / 4,
                                  ),
                                  itemCount: characterProvider.characterList.length,
                                  itemBuilder: (context, index) {
                                    return CachedNetworkImage(
                                      imageUrl: characterProvider.characterList[index].character!.images!.jpg!.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : SizedBox(
                                  height: 260,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: characterProvider.characterList.length,
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                        imageUrl: characterProvider.characterList[index].character!.images!.jpg!.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                                      );
                                    },
                                  ),
                                );
                        }
                        return Center(child: Text("No characters found!", style: const TextStyle(color: Colors.red, fontSize: 20)));
                      },
                    ),
                    const SizedBox(height: 70),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class MobileView extends StatelessWidget {
  final AnimeModel animeData;
  const MobileView({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Colors.red)),
            imageUrl: animeData.images["jpg"]?.largeImageUrl ?? "",
            fit: BoxFit.cover,
            width: screenWidth * 0.6,
            errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              animeData.title ?? "No Title",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: animeData.genres?.map((genre) {
              return Chip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.red[900],
                label: Text(
                  genre.name!,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }).toList() ?? [],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        "${animeData.season ?? ""} ${animeData.aired?.from.substring(0, 4) ?? "No date"}",
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
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            animeData.score == -1 ? "No rating" : animeData.score.toString(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        "Duration : ${animeData.duration ?? "Unknown"}",
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
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        "Type : ${animeData.type ?? "Unclassified"}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    "Studio : ${animeData.studios!.first.name}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Synopsis",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(animeData.synopsis ?? "(No Synopsis)"),
          SizedBox(height: 30),
          Text(
            "Characters",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Consumer<CharacterProvider>(
            builder: (context, characterProvider, child) {
              return characterProvider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        strokeWidth: 3,
                      ),
                    )
                  : characterProvider.characterList.isNotEmpty
                      ? SizedBox(
                          height: 260,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: characterProvider.characterList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 0.5,
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 200,
                                height: 260,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(color: Colors.red),
                                          ),
                                          imageUrl: characterProvider.characterList[index].character!.images!.jpg!.imageUrl!,
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: double.infinity,
                                          errorWidget: (context, url, error) => Icon(Icons.image_not_supported),
                                        ),
                                      ),
                                      Text(
                                        characterProvider.characterList[index].character!.name ?? "",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : characterProvider.errorMessage == null
                          ? Center(
                              child: Text(
                                "No characters found!",
                                style: TextStyle(color: Colors.red, fontSize: 30),
                              ),
                            )
                          : Center(
                              child: Column(
                                children: [
                                  Text(
                                    characterProvider.errorMessage!,
                                    style: TextStyle(color: Colors.red, fontSize: 30),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () async {
                                      characterProvider.getCharacterByAnime(animeId: animeData.malId);
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
                            );
            },
          ),
          SizedBox(height: 70),
        ],
      ),
    );
  }
}
