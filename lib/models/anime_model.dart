import 'dart:convert';

AnimeModel animeModelFromJson(String str) =>
    AnimeModel.fromJson(json.decode(str));

String animeModelToJson(AnimeModel data) => json.encode(data.toJson());

class AnimeModel {
  int malId;
  String url;
  Map<String, Image> images;
  Trailer? trailer;
  bool? approved;
  List<Title>? titles;
  String? title;
  String? titleEnglish;
  String? titleJapanese;
  List<String>? titleSynonyms;
  String? type;
  String? source;
  int? episodes;
  String? status;
  bool? airing;
  Aired? aired;
  String? duration;
  String? rating;
  double? score;
  int? scoredBy;
  int? rank;
  int? popularity;
  int? members;
  int? favorites;
  String? synopsis;
  String? background;
  String? season;
  int? year;
  Broadcast? broadcast;
  List<Entity>? producers;
  List<Entity>? licensors;
  List<Entity>? studios;
  List<Entity>? genres;
  List<Entity>? explicitGenres;
  List<Entity>? themes;
  List<Entity>? demographics;

  AnimeModel({
    required this.malId,
    required this.url,
    required this.images,
    this.trailer,
    this.approved,
    this.titles,
    this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.titleSynonyms,
    this.type,
    this.source,
    this.episodes,
    this.status,
    this.airing,
    this.aired,
    this.duration,
    this.rating,
    this.score,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.broadcast,
    this.producers,
    this.licensors,
    this.studios,
    this.genres,
    this.explicitGenres,
    this.themes,
    this.demographics,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) => AnimeModel(
        malId: json["mal_id"],
        url: json["url"],
        images: Map.from(json["images"]!)
            .map((k, v) => MapEntry<String, Image>(k, Image.fromJson(v))),
        trailer:
            json["trailer"] == null ? null : Trailer.fromJson(json["trailer"]),
        approved: json["approved"],
        titles: json["titles"] == null
            ? []
            : List<Title>.from(json["titles"]!.map((x) => Title.fromJson(x))),
        title: json["title"],
        titleEnglish: json["title_english"],
        titleJapanese: json["title_japanese"],
        titleSynonyms: json["title_synonyms"] == null
            ? []
            : List<String>.from(json["title_synonyms"]!.map((x) => x)),
        type: json["type"],
        source: json["source"],
        episodes: json["episodes"],
        status: json["status"],
        airing: json["airing"],
        aired: json["aired"] == null ? null : Aired.fromJson(json["aired"]),
        duration: json["duration"],
        rating: json["rating"],
        score:
            json["score"] == null ? -1 : double.parse(json["score"].toString()),
        scoredBy: json["scored_by"],
        rank: json["rank"],
        popularity: json["popularity"],
        members: json["members"],
        favorites: json["favorites"],
        synopsis: json["synopsis"],
        background: json["background"],
        season: json["season"],
        year: json["year"],
        broadcast: json["broadcast"] == null
            ? null
            : Broadcast.fromJson(json["broadcast"]),
        producers: json["producers"] == null
            ? []
            : List<Entity>.from(
                json["producers"]!.map((x) => Entity.fromJson(x))),
        licensors: json["licensors"] == null
            ? []
            : List<Entity>.from(
                json["licensors"]!.map((x) => Entity.fromJson(x))),
        studios: json["studios"] == null
            ? []
            : List<Entity>.from(
                json["studios"]!.map((x) => Entity.fromJson(x))),
        genres: json["genres"] == null
            ? []
            : List<Entity>.from(json["genres"]!.map((x) => Entity.fromJson(x))),
        explicitGenres: json["explicit_genres"] == null
            ? []
            : List<Entity>.from(
                json["explicit_genres"]!.map((x) => Entity.fromJson(x))),
        themes: json["themes"] == null
            ? []
            : List<Entity>.from(json["themes"]!.map((x) => Entity.fromJson(x))),
        demographics: json["demographics"] == null
            ? []
            : List<Entity>.from(
                json["demographics"]!.map((x) => Entity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": Map.from(images)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "trailer": trailer?.toJson(),
        "approved": approved,
        "titles": titles == null
            ? []
            : List<dynamic>.from(titles!.map((x) => x.toJson())),
        "title": title,
        "title_english": titleEnglish,
        "title_japanese": titleJapanese,
        "title_synonyms": titleSynonyms == null
            ? []
            : List<dynamic>.from(titleSynonyms!.map((x) => x)),
        "type": type,
        "source": source,
        "episodes": episodes,
        "status": status,
        "airing": airing,
        "aired": aired?.toJson(),
        "duration": duration,
        "rating": rating,
        "score": score,
        "scored_by": scoredBy,
        "rank": rank,
        "popularity": popularity,
        "members": members,
        "favorites": favorites,
        "synopsis": synopsis,
        "background": background,
        "season": season,
        "year": year,
        "broadcast": broadcast?.toJson(),
        "producers": producers == null
            ? []
            : List<dynamic>.from(producers!.map((x) => x.toJson())),
        "licensors": licensors == null
            ? []
            : List<dynamic>.from(licensors!.map((x) => x.toJson())),
        "studios": studios == null
            ? []
            : List<dynamic>.from(studios!.map((x) => x.toJson())),
        "genres": genres == null
            ? []
            : List<dynamic>.from(genres!.map((x) => x.toJson())),
        "explicit_genres": explicitGenres == null
            ? []
            : List<dynamic>.from(explicitGenres!.map((x) => x.toJson())),
        "themes": themes == null
            ? []
            : List<dynamic>.from(themes!.map((x) => x.toJson())),
        "demographics": demographics == null
            ? []
            : List<dynamic>.from(demographics!.map((x) => x.toJson())),
      };
}

class Aired {
  String from;
  String? to;
  Prop? prop;

  Aired({
    required this.from,
    this.to,
    this.prop,
  });

  factory Aired.fromJson(Map<String, dynamic> json) => Aired(
        from: json["from"] ?? "    ",
        to: json["to"],
        prop: json["prop"] == null ? null : Prop.fromJson(json["prop"]),
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "prop": prop?.toJson(),
      };
}

class Prop {
  From? from;
  From? to;
  String? string;

  Prop({
    this.from,
    this.to,
    this.string,
  });

  factory Prop.fromJson(Map<String, dynamic> json) => Prop(
        from: json["from"] == null ? null : From.fromJson(json["from"]),
        to: json["to"] == null ? null : From.fromJson(json["to"]),
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "from": from?.toJson(),
        "to": to?.toJson(),
        "string": string,
      };
}

class From {
  int? day;
  int? month;
  int? year;

  From({
    this.day,
    this.month,
    this.year,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        day: json["day"],
        month: json["month"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
      };
}

class Broadcast {
  String? day;
  String? time;
  String? timezone;
  String? string;

  Broadcast({
    this.day,
    this.time,
    this.timezone,
    this.string,
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) => Broadcast(
        day: json["day"],
        time: json["time"],
        timezone: json["timezone"],
        string: json["string"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
        "timezone": timezone,
        "string": string,
      };
}

class Entity {
  int? malId;
  String? type;
  String? name;
  String? url;

  Entity({
    this.malId,
    this.type,
    this.name,
    this.url,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => Entity(
        malId: json["mal_id"],
        type: json["type"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "type": type,
        "name": name,
        "url": url,
      };
}

class Image {
  String? imageUrl;
  String? smallImageUrl;
  String? largeImageUrl;

  Image({
    this.imageUrl,
    this.smallImageUrl,
    this.largeImageUrl,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
        largeImageUrl: json["large_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
        "large_image_url": largeImageUrl,
      };
}

class Title {
  String? type;
  String? title;

  Title({
    this.type,
    this.title,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        type: json["type"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
      };
}

class Trailer {
  String? youtubeId;
  String? url;
  String? embedUrl;

  Trailer({
    this.youtubeId,
    this.url,
    this.embedUrl,
  });

  factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
        youtubeId: json["youtube_id"],
        url: json["url"],
        embedUrl: json["embed_url"],
      );

  Map<String, dynamic> toJson() => {
        "youtube_id": youtubeId,
        "url": url,
        "embed_url": embedUrl,
      };
}
