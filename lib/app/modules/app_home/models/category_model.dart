class CategoriesModel {
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? name;
  String? filter;
  bool? multipleSelection;
  String? icon;
  List<SubCategories>? subCategories;

  CategoriesModel(
      {this.sId,
      this.createdAt,
      this.updatedAt,
      this.accessedAt,
      this.name,
      this.filter,
      this.multipleSelection,
      this.icon,
      this.subCategories});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessedAt = json['accessed_at'];
    name = json['name'];
    filter = json['filter'];
    multipleSelection = json['multiple_selection'];
    icon = json['icon'];
    if (json['sub_categories'] != null) {
      subCategories = <SubCategories>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['accessed_at'] = accessedAt;
    data['name'] = name;
    data['filter'] = filter;
    data['multiple_selection'] = multipleSelection;
    data['icon'] = icon;
    if (subCategories != null) {
      data['sub_categories'] = subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? name;
  String? filter;
  String? icon;

  SubCategories({this.sId, this.createdAt, this.updatedAt, this.accessedAt, this.name, this.filter, this.icon});

  SubCategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessedAt = json['accessed_at'];
    name = json['name'];
    filter = json['filter'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['accessed_at'] = accessedAt;
    data['name'] = name;
    data['filter'] = filter;
    data['icon'] = icon;
    return data;
  }
}
