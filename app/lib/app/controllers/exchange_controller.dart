import 'package:app/app/models/card_model.dart';
import 'package:app/app/models/exchange_model.dart';
import 'package:app/app/repositories/billing_repository.dart';
import 'package:app/app/repositories/exchange_repository.dart';

class ExchangeController {
  late ExchangeRepository repository;
  final PaymentMethodModel paymentMethod = PaymentMethodModel();
  late BillingRepository billingRepository;

  ExchangeController() {
    repository = ExchangeRepository();
    billingRepository = BillingRepository();
  }

  Future<List<ExchangeModel>> getExchanges() {
    return repository.getExchanges();
  }

  createExchange(ExchangeModel exchange, CardModel? card) async {
    if (exchange.paymentType == paymentMethod.CREDIT_CARD["key"]) {
      exchange.billing = await billingRepository.getBillingByDate(card!, exchange.date!);
    }

    repository.insertExchange(exchange);
  }

  updateExchange(ExchangeModel exchange) {
    repository.updateExchange(exchange);
  }

  deleteExchange(ExchangeModel exchange) {
    repository.deleteExchange(exchange);
  }

  Future<Map<String, dynamic>> getGroupedExchangesByMonth(int month, int year) async {
    String where = "date >= ? AND date < ?";
    List<dynamic> whereArgs = [
      DateTime(year, month, 1).millisecondsSinceEpoch,
      DateTime(year, month + 1, 0).millisecondsSinceEpoch
    ];

    List<ExchangeModel> exchanges = await repository.getExchangesByFilters(where, whereArgs);

    Map<String, dynamic> groupedExchanges = {};
    for (var element in exchanges) {
      String key = element.date!.toString();
      if (groupedExchanges[key] == null) {
        groupedExchanges[key] = {"date": element.date, "income": 0, "expense": 0};
      }
      if (element.movementType == 1) {
        groupedExchanges[key]["income"] += element.value!;
      } else {
        groupedExchanges[key]["expense"] += element.value!;
      }
    }

    return groupedExchanges;
  }
}
