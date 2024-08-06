class ItemModel {
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? title;
  String? type;
  String? categoryId;
  String? description;
  List<Media>? media;
  IndividualInfo? individualInfo;
  PriceInfo? priceInfo;
  CarInfo? carInfo;

  ItemModel(
      {this.sId,
      this.createdAt,
      this.updatedAt,
      this.accessedAt,
      this.title,
      this.type,
      this.categoryId,
      this.description,
      this.media,
      this.individualInfo,
      this.priceInfo,
      this.carInfo});

  ItemModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessedAt = json['accessed_at'];
    title = json['title'];
    type = json['type'];
    categoryId = json['category_id'];
    description = json['description'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
    individualInfo = json['individual_info'] != null ? IndividualInfo.fromJson(json['individual_info']) : null;
    priceInfo = json['price_info'] != null ? PriceInfo.fromJson(json['price_info']) : null;
    carInfo = json['car_info'] != null ? CarInfo.fromJson(json['car_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['accessed_at'] = accessedAt;
    data['title'] = title;
    data['type'] = type;
    data['category_id'] = categoryId;
    data['description'] = description;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    if (individualInfo != null) {
      data['individual_info'] = individualInfo!.toJson();
    }
    if (priceInfo != null) {
      data['price_info'] = priceInfo!.toJson();
    }
    if (carInfo != null) {
      data['car_info'] = carInfo!.toJson();
    }
    return data;
  }
}

class Media {
  String? sId;
  String? createdAt;
  String? updatedAt;
  String? accessedAt;
  String? name;
  String? type;
  int? size;
  String? hash;

  Media({this.sId, this.createdAt, this.updatedAt, this.accessedAt, this.name, this.type, this.size, this.hash});

  Media.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessedAt = json['accessed_at'];
    name = json['name'];
    type = json['type'];
    size = json['size'];
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['accessed_at'] = accessedAt;
    data['name'] = name;
    data['type'] = type;
    data['size'] = size;
    data['hash'] = hash;
    return data;
  }
}

class IndividualInfo {
  String? location;
  String? phoneNumber;
  String? freeToCallFrom;
  String? freeToCallTo;
  bool? allowToCall;
  bool? contactOnlyInChat;

  IndividualInfo(
      {this.location,
      this.phoneNumber,
      this.freeToCallFrom,
      this.freeToCallTo,
      this.allowToCall,
      this.contactOnlyInChat});

  IndividualInfo.fromJson(Map<String, dynamic> json) {
    location = json['location'];
    phoneNumber = json['phone_number'];
    freeToCallFrom = json['free_to_call_from'];
    freeToCallTo = json['free_to_call_to'];
    allowToCall = json['allow_to_call'];
    contactOnlyInChat = json['contact_only_in_chat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['phone_number'] = phoneNumber;
    data['free_to_call_from'] = freeToCallFrom;
    data['free_to_call_to'] = freeToCallTo;
    data['allow_to_call'] = allowToCall;
    data['contact_only_in_chat'] = contactOnlyInChat;
    return data;
  }
}

class PriceInfo {
  dynamic price;
  bool? possibleExchange;
  bool? credit;

  PriceInfo({this.price, this.possibleExchange, this.credit});

  PriceInfo.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    possibleExchange = json['possible_exchange'];
    credit = json['credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['possible_exchange'] = possibleExchange;
    data['credit'] = credit;
    return data;
  }
}

class CarInfo {
  String? condition;
  String? brand;
  String? model;
  String? bodyType;
  String? transmission;
  String? engineType;
  int? passedKm;
  int? year;
  String? color;
  String? vinCode;

  CarInfo(
      {this.condition,
      this.brand,
      this.model,
      this.bodyType,
      this.transmission,
      this.engineType,
      this.passedKm,
      this.year,
      this.color,
      this.vinCode});

  CarInfo.fromJson(Map<String, dynamic> json) {
    condition = json['condition'];
    brand = json['brand'];
    model = json['model'];
    bodyType = json['body_type'];
    transmission = json['transmission'];
    engineType = json['engine_type'];
    passedKm = json['passed_km'];
    year = json['year'];
    color = json['color'];
    vinCode = json['vin_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['condition'] = condition;
    data['brand'] = brand;
    data['model'] = model;
    data['body_type'] = bodyType;
    data['transmission'] = transmission;
    data['engine_type'] = engineType;
    data['passed_km'] = passedKm;
    data['year'] = year;
    data['color'] = color;
    data['vin_code'] = vinCode;
    return data;
  }
}
