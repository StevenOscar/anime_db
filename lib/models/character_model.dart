// ignore_for_file: constant_identifier_names

class CharacterModel {
  Character? character;
  Role? role;
  int? favorites;
  List<VoiceActor>? voiceActors;

  CharacterModel({
    this.character,
    this.role,
    this.favorites,
    this.voiceActors,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
        character: json["character"] != null ? Character.fromJson(json["character"]) : null,
        role: json["role"] != null ? roleValues.map[json["role"]] : null,
        favorites: json["favorites"],
        voiceActors: json["voice_actors"] != null
            ? List<VoiceActor>.from(json["voice_actors"].map((x) => VoiceActor.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "character": character?.toJson(),
        "role": roleValues.reverse[role],
        "favorites": favorites,
        "voice_actors": voiceActors != null ? List<dynamic>.from(voiceActors!.map((x) => x.toJson())) : null,
      };
}

class Character {
  int? malId;
  String? url;
  CharacterImages? images;
  String? name;

  Character({
    this.malId,
    this.url,
    this.images,
    this.name,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        malId: json["mal_id"],
        url: json["url"],
        images: json["images"] != null ? CharacterImages.fromJson(json["images"]) : null,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": images?.toJson(),
        "name": name,
      };
}

class CharacterImages {
  Jpg? jpg;
  Webp? webp;

  CharacterImages({
    this.jpg,
    this.webp,
  });

  factory CharacterImages.fromJson(Map<String, dynamic> json) => CharacterImages(
        jpg: json["jpg"] != null ? Jpg.fromJson(json["jpg"]) : null,
        webp: json["webp"] != null ? Webp.fromJson(json["webp"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "jpg": jpg?.toJson(),
        "webp": webp?.toJson(),
      };
}

class Jpg {
  String? imageUrl;

  Jpg({
    this.imageUrl,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) => Jpg(
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
      };
}

class Webp {
  String? imageUrl;
  String? smallImageUrl;

  Webp({
    this.imageUrl,
    this.smallImageUrl,
  });

  factory Webp.fromJson(Map<String, dynamic> json) => Webp(
        imageUrl: json["image_url"],
        smallImageUrl: json["small_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "small_image_url": smallImageUrl,
      };
}

enum Role {MAIN,SUPPORTING}

final roleValues = EnumValues({
  "Main": Role.MAIN,
  "Supporting": Role.SUPPORTING,
});

class VoiceActor {
  Person? person;
  Language? language;

  VoiceActor({
    this.person,
    this.language,
  });

  factory VoiceActor.fromJson(Map<String, dynamic> json) => VoiceActor(
        person: json["person"] != null ? Person.fromJson(json["person"]) : null,
        language: json["language"] != null ? languageValues.map[json["language"]] : null,
      );

  Map<String, dynamic> toJson() => {
        "person": person?.toJson(),
        "language": languageValues.reverse[language],
      };
}

enum Language { ENGLISH, FRENCH, JAPANESE, KOREAN, PORTUGUESE_BR }

final languageValues = EnumValues({
  "English": Language.ENGLISH,
  "French": Language.FRENCH,
  "Japanese": Language.JAPANESE,
  "Korean": Language.KOREAN,
  "Portuguese (BR)": Language.PORTUGUESE_BR,
});

class Person {
  int? malId;
  String? url;
  PersonImages? images;
  String? name;

  Person({
    this.malId,
    this.url,
    this.images,
    this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        malId: json["mal_id"],
        url: json["url"],
        images: json["images"] != null ? PersonImages.fromJson(json["images"]) : null,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "url": url,
        "images": images?.toJson(),
        "name": name,
      };
}

class PersonImages {
  Jpg? jpg;

  PersonImages({
    this.jpg,
  });

  factory PersonImages.fromJson(Map<String, dynamic> json) => PersonImages(
        jpg: json["jpg"] != null ? Jpg.fromJson(json["jpg"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "jpg": jpg?.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
