import 'package:hudson/app/models/account_model.dart';
import 'package:hudson/app/models/billing_model.dart';
import 'package:hudson/app/models/card_model.dart';

class ExchangeModel {
  late int? id;
  late String? description;
  late DateTime? date;
  late double? value;
  late String? paymentType;
  late int? movementType;
  late BillingModel? billing;
  late AccountModel? account;

  ExchangeModel(
      {this.id,
      this.description,
      this.date,
      this.value,
      this.paymentType,
      this.movementType,
      this.billing,
      this.account});

  ExchangeModel clone() {
    return ExchangeModel(
        id: id,
        description: description,
        date: date,
        value: value,
        paymentType: paymentType,
        movementType: movementType,
        billing: billing,
        account: account);
  }

  static ExchangeModel fromMap(Map<String, dynamic> exchange) {
    return ExchangeModel(
      id: exchange["id"],
      description: exchange["description"],
      date: DateTime.fromMillisecondsSinceEpoch(exchange["date"]),
      value: exchange["value"],
      paymentType: exchange["payment_type"],
      movementType: exchange["movement_type"],
      billing: exchange["billing_id"] != null
          ? BillingModel(
              id: exchange["billing_id"],
              month: exchange["billing_month"],
              year: exchange["billing_year"],
              paid: exchange["billing_paid"] == 1,
              billingDueDay: exchange["billing_due_day"],
              billingStartDay: exchange["billing_start_day"],
              card: exchange["card_id"] != null
                  ? CardModel(
                      id: exchange["card_id"],
                      name: exchange["card_name"],
                      bank: exchange["bank_id"] != null
                          ? BankModel(
                              id: exchange["bank_id"], name: exchange["bank_name"], imageUrl: exchange["bank_image"])
                          : null,
                      brand: BrandModel(
                          id: exchange["brand_id"], name: exchange["brand_name"], imageUrl: exchange["brand_image"]),
                      creditLimit: exchange["credit_limit"],
                      billingDueDay: exchange["billing_due_day"],
                      billingStartDay: exchange["billing_start_day"],
                      availableLimit: exchange["available_limit"])
                  : null)
          : null,
      account: exchange["account_id"] != null
          ? AccountModel(
              id: exchange["account_id"],
              name: exchange["account_name"],
              bank: exchange["bank_id"] != null
                  ? BankModel(id: exchange["bank_id"], name: exchange["bank_name"], imageUrl: exchange["bank_image"])
                  : null,
              balance: exchange["balance"],
              type: exchange["account_type"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "date": date!.millisecondsSinceEpoch,
      "value": value,
      "payment_type": paymentType,
      "movement_type": movementType,
      "billing_id": billing?.id,
      "account_id": account?.id,
    };
  }
}

class PaymentMethodModel {
  // ignore: non_constant_identifier_names
  late final Map CREDIT_CARD = {"key": "CREDIT", "value": "Cartão de Crédito"};
  // ignore: non_constant_identifier_names
  late final Map DEBIT_CARD = {"key": "DEBIT", "value": "Cartão de Débito"};
}

class MovementTypeModel {
  // ignore: non_constant_identifier_names
  late final int INCOME = 1;
  // ignore: non_constant_identifier_names
  late final int EXPENSE = -1;
}
