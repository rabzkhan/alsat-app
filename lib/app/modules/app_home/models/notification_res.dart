class NotificationRes {
  List<NotificationData>? data;
  bool? hasMore;

  NotificationRes({this.data, this.hasMore});

  NotificationRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['has_more'] = hasMore;
    return data;
  }
}

class NotificationData {
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? title;
  String? body;
  String? picture;

  NotificationData({this.sId, this.createdAt, this.updatedAt, this.accessedAt, this.title, this.body, this.picture});

  NotificationData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessedAt = json['accessed_at'];
    title = json['title'];
    body = json['body'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['accessed_at'] = accessedAt;
    data['title'] = title;
    data['body'] = body;
    data['picture'] = picture;
    return data;
  }
}
