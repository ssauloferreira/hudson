import 'dart:ffi';

class AccountModel {
  late int? id;
  late String? name;
  late BankModel? bank;
  late num? total;
  late AccountTypeModel? type;

  AccountModel({this.id, this.name, this.bank, this.total, this.type});

  AccountModel clone() {
    return AccountModel(
        id: id, name: name, bank: bank, total: total, type: type);
  }

  static AccountModel fromMap(Map<String, dynamic> account) {
    return AccountModel(
      id: account["id"],
      name: account["name"],
      bank: BankModel(
          id: account["bank_id"],
          name: account["bank_name"],
          imageUrl: account["bank_image"]),
      total: account["total"],
      type:
          AccountTypeModel(id: account["type_id"], name: account["type_name"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "bank_id": bank?.id,
      "account_type_id": type?.id,
    };
  }
}

class AccountTypeModel {
  late int id;
  late String? name;

  AccountTypeModel({required this.id, this.name});

  static AccountTypeModel fromMap(Map<String, dynamic> accountType) {
    return AccountTypeModel(id: accountType["id"], name: accountType["name"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is AccountTypeModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}

class BankModel {
  late int id;
  late String? name;
  late String? imageUrl;

  BankModel({required this.id, this.name, this.imageUrl});

  static BankModel fromMap(Map<String, dynamic> bank) {
    return BankModel(
        id: bank["id"], name: bank["name"], imageUrl: bank["image_url"]);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "image_url": imageUrl};
  }

  @override
  bool operator ==(Object other) {
    return other is BankModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
