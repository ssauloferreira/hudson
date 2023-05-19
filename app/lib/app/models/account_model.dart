import 'dart:ffi';

class AccountModel {
  late int? id;
  late String? name;
  late BankModel? bank;
  late double? total;
  late AccountTypeModel? type;

  AccountModel({this.id, this.name, this.bank, this.total, this.type});

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
}
  // static List<AccountModel> getAccounts() {
  //   return <AccountModel>[
  //     AccountModel(
  //       name: "Nubank PF",
  //       bank: "Nubank",
  //       total: 178.53,
  //       type: "Conta-Corrente",
  //       image:
  //           "https://cdn4.vectorstock.com/i/1000x1000/32/23/bank-chalk-white-icon-on-black-background-vector-32173223.jpg",
  //     ),
  //     AccountModel(
  //       name: "Nubank PJ",
  //       bank: "Nubank",
  //       total: 29871.51,
  //       type: "Conta-Corrente",
  //       image:
  //           "https://cdn4.vectorstock.com/i/1000x1000/32/23/bank-chalk-white-icon-on-black-background-vector-32173223.jpg",
  //     ),
  //     AccountModel(
  //       name: "Santander",
  //       bank: "Santander",
  //       total: 200.15,
  //       type: "Conta-Corrente",
  //       image:
  //           "https://cdn4.vectorstock.com/i/1000x1000/32/23/bank-chalk-white-icon-on-black-background-vector-32173223.jpg",
  //     ),
  //     AccountModel(
  //       name: "Poupança",
  //       bank: "Santander",
  //       total: 111.32,
  //       type: "Conta-Poupança",
  //       image:
  //           "https://cdn4.vectorstock.com/i/1000x1000/32/23/bank-chalk-white-icon-on-black-background-vector-32173223.jpg",
  //     ),
  //   ];
  // }
