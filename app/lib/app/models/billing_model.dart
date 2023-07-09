import 'package:app/app/models/account_model.dart';
import 'package:app/app/models/card_model.dart';

class BillingModel {
  late int? id;
  late int? month;
  late int? year;
  late CardModel? card;
  late bool? paid;
  late int? billingDueDay;
  late int? billingStartDay;

  BillingModel(
      {this.id,
      this.month,
      this.year,
      this.card,
      this.paid,
      this.billingDueDay,
      this.billingStartDay});

  BillingModel clone() {
    return BillingModel(
        id: id,
        month: month,
        year: year,
        card: card,
        paid: paid,
        billingDueDay: billingDueDay,
        billingStartDay: billingStartDay);
  }

  static BillingModel fromMap(Map<String, dynamic> billing) {
    return BillingModel(
      id: billing["id"],
      month: billing["month"],
      year: billing["year"],
      paid: billing["paid"] == 1,
      billingDueDay: billing["billing_due_day"],
      billingStartDay: billing["billing_start_day"],
      card: billing["card_id"] != null
          ? CardModel(
              id: billing["card_id"],
              name: billing["card_name"],
              bank: billing["bank_id"] != null
                  ? BankModel(
                      id: billing["bank_id"],
                      name: billing["bank_name"],
                      imageUrl: billing["bank_image"])
                  : null,
              brand: billing["brand_id"] != null
                  ? BrandModel(
                      id: billing["brand_id"],
                      name: billing["brand_name"],
                      imageUrl: billing["brand_image"])
                  : null,
              creditLimit: billing["credit_limit"],
              billingDueDay: billing["billing_due_day"],
              billingStartDay: billing["billing_start_day"],
              availableLimit: billing["available_limit"])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "month": month,
      "year": year,
      "card_id": card?.id,
      "paid": paid == true ? 1 : 0,
      "billing_due_day": billingDueDay,
      "billing_start_day": billingStartDay,
    };
  }
}
