import 'package:flutter/material.dart';

class CardModel {
  late String name;
  late String bank;
  late double limit;
  late int billingDueDay;
  late int billingStartDay;

  CardModel(
      {required this.name,
      required this.bank,
      required this.limit,
      required this.billingDueDay,
      required this.billingStartDay});

  static List<CardModel> getCards() {
    return <CardModel>[
      CardModel(
          name: "Way",
          bank: "Santander",
          limit: 1000,
          billingDueDay: 5,
          billingStartDay: 28),
      CardModel(
          name: "Elite",
          bank: "Santander",
          limit: 15000,
          billingDueDay: 17,
          billingStartDay: 10),
    ];
  }
}
