import 'package:hudson/app/models/account_model.dart';

class CardModel {
  late int? id;
  late String? name;
  late BankModel? bank;
  late BrandModel? brand;
  late num? creditLimit;
  late num? availableLimit;
  late int? billingDueDay;
  late int? billingStartDay;

  CardModel(
      {this.id,
      this.name,
      this.bank,
      this.brand,
      this.creditLimit,
      this.availableLimit,
      this.billingDueDay,
      this.billingStartDay});

  CardModel clone() {
    return CardModel(
        id: id,
        name: name,
        bank: bank,
        brand: brand,
        creditLimit: creditLimit,
        availableLimit: availableLimit,
        billingDueDay: billingDueDay,
        billingStartDay: billingStartDay);
  }

  static CardModel fromMap(Map<String, dynamic> card) {
    return CardModel(
        id: card["id"],
        name: card["name"],
        bank: card["bank_id"] != null
            ? BankModel(id: card["bank_id"], name: card["bank_name"], imageUrl: card["bank_image"])
            : null,
        brand: BrandModel(id: card["brand_id"], name: card["brand_name"], imageUrl: card["brand_image"]),
        creditLimit: card["credit_limit"],
        billingDueDay: card["billing_due_day"],
        billingStartDay: card["billing_start_day"],
        availableLimit: card["available_limit"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "bank_id": bank?.id,
      "brand_id": brand?.id,
      "credit_limit": creditLimit,
      "billing_due_day": billingDueDay,
      "billing_start_day": billingStartDay,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is CardModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}

class BrandModel {
  late int id;
  late String? name;
  late String? imageUrl;

  BrandModel({required this.id, this.name, this.imageUrl});

  static BrandModel fromMap(Map<String, dynamic> bank) {
    return BrandModel(id: bank["id"], name: bank["name"], imageUrl: bank["image_url"]);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "image_url": imageUrl};
  }

  @override
  bool operator ==(Object other) {
    return other is BrandModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
