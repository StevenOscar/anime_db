//Model di generate menggunakan app.quicktype.io

import 'dart:convert';

ResponseModel responseModelFromJson(String str, Function(Map<String, dynamic>) fromJsonT) => ResponseModel.fromJson(json.decode(str), fromJsonT);

class ResponseModel<T> {
  final List<T>? data;
  final Pagination? pagination;

  ResponseModel({
    required this.data,
    required this.pagination,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT
  ) => ResponseModel(
      pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
      data: json["data"] == null ? [] 
        : json["data"] is List ? 
          List<T>.from(json["data"]!.map((x) => fromJsonT(x)))
        : [fromJsonT(json["data"]!)]
  );
}

class Pagination {
    int? lastVisiblePage;
    bool? hasNextPage;
    int? currentPage;
    Items? items;

    Pagination({
        this.lastVisiblePage,
        this.hasNextPage,
        this.currentPage,
        this.items,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        lastVisiblePage: json["last_visible_page"],
        hasNextPage: json["has_next_page"],
        currentPage: json["current_page"],
        items: json["items"] == null ? null : Items.fromJson(json["items"]),
    );

    Map<String, dynamic> toJson() => {
        "last_visible_page": lastVisiblePage,
        "has_next_page": hasNextPage,
        "current_page": currentPage,
        "items": items?.toJson(),
    };
}

class Items {
    int? count;
    int? total;
    int? perPage;

    Items({
        this.count,
        this.total,
        this.perPage,
    });

    factory Items.fromJson(Map<String, dynamic> json) => Items(
        count: json["count"],
        total: json["total"],
        perPage: json["per_page"],
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "total": total,
        "per_page": perPage,
    };
}
