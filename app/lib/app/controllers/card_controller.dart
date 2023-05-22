import 'package:app/app/models/card_model.dart';
import 'package:app/app/repositories/card_repository.dart';

class CardController {
  late CardRepository repository;

  CardController() {
    repository = CardRepository();
  }

  Future<List<CardModel>> getCards() {
    return repository.getCards();
  }

  Future<List<BrandModel>> getBrands() {
    return repository.getBrands();
  }

  createCard(CardModel card) {
    repository.insertCard(card);
  }

  updateCard(CardModel card) {
    repository.updateCard(card);
  }

  deleteCard(CardModel card) {
    repository.deleteCard(card);
  }
}
