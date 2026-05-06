import 'dart:convert';

class TarotReading {
  final List<TarotCard> cards;
  final String finalAudioUrl;
  final String finalInterpretation;
  final List<CardInterpretation> interpretations;
  final String question;
  final bool success;

  TarotReading({
    required this.cards,
    required this.finalAudioUrl,
    required this.finalInterpretation,
    required this.interpretations,
    required this.question,
    required this.success,
  });

  // Derived from actual cards list length
  int get cardCount => cards.length;

  factory TarotReading.fromJson(Map<String, dynamic> json) {
    return TarotReading(
      cards: (json['cards'] as List)
          .map((card) => TarotCard.fromJson(card))
          .toList(),
      // API returns relative path like "/static/audio/speech_xxx.mp3?t=..."
      // Need to prepend base URL
      finalAudioUrl: json['final_audio_url'] as String? ?? '',
      finalInterpretation: json['final_interpretation'] as String? ??
          json['unified_reading'] as String? ?? '',
      interpretations: (json['interpretations'] as List)
          .map((interp) => CardInterpretation.fromJson(interp))
          .toList(),
      question: json['question'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cards': cards.map((card) => card.toJson()).toList(),
      'final_audio_url': finalAudioUrl,
      'final_interpretation': finalInterpretation,
      'interpretations': interpretations.map((interp) => interp.toJson()).toList(),
      'question': question,
      'success': success,
    };
  }

  static TarotReading fromJsonString(String jsonString) {
    return TarotReading.fromJson(json.decode(jsonString));
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}

class TarotCard {
  final String arcana;
  final int id;
  final String image;
  final List<String> keywords;
  final String meaning;
  final String name;
  final String? suit;

  TarotCard({
    required this.arcana,
    required this.id,
    required this.image,
    required this.keywords,
    required this.meaning,
    required this.name,
    this.suit,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      arcana: json['arcana'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      image: json['image'] as String? ?? '',
      keywords: (json['keywords'] as List?)
          ?.map((k) => k as String)
          .toList() ??
          [],
      meaning: json['meaning'] as String? ?? '',
      name: json['name'] as String? ?? '',
      suit: json['suit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arcana': arcana,
      'id': id,
      'image': image,
      'keywords': keywords,
      'meaning': meaning,
      'name': name,
      if (suit != null) 'suit': suit,
    };
  }

  bool get isMajorArcana => arcana == 'major';
  bool get isMinorArcana => arcana == 'minor';

  String getImageUrl(String baseUrl) {
    if (image.startsWith('http')) {
      return image;
    }
    return '$baseUrl$image';
  }
}

class CardInterpretation {
  final int index;       // present in API response
  final TarotCard card;
  final String interpretation;
  final String position;
  final String symbol;

  // No audio_url in API response — this is derived if needed
  CardInterpretation({
    required this.index,
    required this.card,
    required this.interpretation,
    required this.position,
    required this.symbol,
  });

  // Convenience getter — keeps RevealController compatible without changes
  String get audioUrl => '';

  factory CardInterpretation.fromJson(Map<String, dynamic> json) {
    return CardInterpretation(
      index: json['index'] as int? ?? 0,
      card: TarotCard.fromJson(json['card']),
      interpretation: json['interpretation'] as String? ?? '',
      position: json['position'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'card': card.toJson(),
      'interpretation': interpretation,
      'position': position,
      'symbol': symbol,
    };
  }
}