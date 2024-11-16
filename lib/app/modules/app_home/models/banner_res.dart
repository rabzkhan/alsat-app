// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);



class BannerRes {
    final List<BannerModel>? data;
    final bool? hasMore;

    BannerRes({
        this.data,
        this.hasMore,
    });

    BannerRes copyWith({
        List<BannerModel>? data,
        bool? hasMore,
    }) => 
        BannerRes(
            data: data ?? this.data,
            hasMore: hasMore ?? this.hasMore,
        );

    factory BannerRes.fromJson(Map<String, dynamic> json) => BannerRes(
        data: json["data"] == null ? [] : List<BannerModel>.from(json["data"]!.map((x) => BannerModel.fromJson(x))),
        hasMore: json["has_more"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "has_more": hasMore,
    };
}

class BannerModel {
    final String? id;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final DateTime? accessedAt;
    final String? picture;
    final bool? main;
    final Location? location;
    final String? entityId;
    final String? type;

    BannerModel({
        this.id,
        this.createdAt,
        this.updatedAt,
        this.accessedAt,
        this.picture,
        this.main,
        this.location,
        this.entityId,
        this.type,
    });

    BannerModel copyWith({
        String? id,
        DateTime? createdAt,
        DateTime? updatedAt,
        DateTime? accessedAt,
        String? picture,
        bool? main,
        Location? location,
        String? entityId,
        String? type,
    }) => 
        BannerModel(
            id: id ?? this.id,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            accessedAt: accessedAt ?? this.accessedAt,
            picture: picture ?? this.picture,
            main: main ?? this.main,
            location: location ?? this.location,
            entityId: entityId ?? this.entityId,
            type: type ?? this.type,
        );

    factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        accessedAt: json["accessed_at"] == null ? null : DateTime.parse(json["accessed_at"]),
        picture: json["picture"],
        main: json["main"],
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        entityId: json["entity_id"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "accessed_at": accessedAt?.toIso8601String(),
        "picture": picture,
        "main": main,
        "location": location?.toJson(),
        "entity_id": entityId,
        "type": type,
    };
}

class Location {
    final String? province;
    final String? city;
    final Geo? geo;

    Location({
        this.province,
        this.city,
        this.geo,
    });

    Location copyWith({
        String? province,
        String? city,
        Geo? geo,
    }) => 
        Location(
            province: province ?? this.province,
            city: city ?? this.city,
            geo: geo ?? this.geo,
        );

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        province: json["province"],
        city: json["city"],
        geo: json["geo"] == null ? null : Geo.fromJson(json["geo"]),
    );

    Map<String, dynamic> toJson() => {
        "province": province,
        "city": city,
        "geo": geo?.toJson(),
    };
}

class Geo {
    final String? type;
    final List<int>? coordinates;

    Geo({
        this.type,
        this.coordinates,
    });

    Geo copyWith({
        String? type,
        List<int>? coordinates,
    }) => 
        Geo(
            type: type ?? this.type,
            coordinates: coordinates ?? this.coordinates,
        );

    factory Geo.fromJson(Map<String, dynamic> json) => Geo(
        type: json["Type"],
        coordinates: json["Coordinates"] == null ? [] : List<int>.from(json["Coordinates"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Type": type,
        "Coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
    };
}
