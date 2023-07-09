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

  createExchange(ExchangeModel exchange, CardModel card) async {
    if (exchange.paymentType == paymentMethod.CREDIT_CARD["key"]) {
      exchange.billing =
          await billingRepository.getBillingByDate(card, exchange.date!);
    }

    repository.insertExchange(exchange);
  }

  updateExchange(ExchangeModel exchange) {
    repository.updateExchange(exchange);
  }

  deleteExchange(ExchangeModel exchange) {
    repository.deleteExchange(exchange);
  }
}
