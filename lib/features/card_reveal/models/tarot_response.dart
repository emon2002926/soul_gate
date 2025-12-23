import 'dart:convert';

/// Main tarot reading response model
class TarotReading {
  final int cardCount;
  final List<TarotCard> cards;
  final String finalAudioUrl;
  final String finalInterpretation;
  final List<CardInterpretation> interpretations;
  final String question;
  final bool success;

  TarotReading({
    required this.cardCount,
    required this.cards,
    required this.finalAudioUrl,
    required this.finalInterpretation,
    required this.interpretations,
    required this.question,
    required this.success,
  });

  factory TarotReading.fromJson(Map<String, dynamic> json) {
    return TarotReading(
      cardCount: json['card_count'] as int,
      cards: (json['cards'] as List)
          .map((card) => TarotCard.fromJson(card))
          .toList(),
      finalAudioUrl: json['final_audio_url'] as String? ?? '',
      finalInterpretation: json['final_interpretation'] as String? ?? '',
      interpretations: (json['interpretations'] as List)
          .map((interp) => CardInterpretation.fromJson(interp))
          .toList(),
      question: json['question'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'card_count': cardCount,
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

/// Tarot card model
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
      keywords: (json['keywords'] as List?)?.map((k) => k as String).toList() ?? [],
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

  /// Get image URL with base URL
  String getImageUrl(String baseUrl) {
    if (image.startsWith('http')) {
      return image;
    }
    return '$baseUrl$image';
  }
}

/// Card interpretation model
class CardInterpretation {
  final String audioUrl;
  final TarotCard card;
  final String interpretation;
  final String position;
  final String symbol;

  CardInterpretation({
    required this.audioUrl,
    required this.card,
    required this.interpretation,
    required this.position,
    required this.symbol,
  });

  factory CardInterpretation.fromJson(Map<String, dynamic> json) {
    return CardInterpretation(
      audioUrl: json['audio_url'] as String? ?? '',
      card: TarotCard.fromJson(json['card']),
      interpretation: json['interpretation'] as String? ?? '',
      position: json['position'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audio_url': audioUrl,
      'card': card.toJson(),
      'interpretation': interpretation,
      'position': position,
      'symbol': symbol,
    };
  }

  /// Get audio URL with base URL
  String getAudioUrl(String baseUrl) {
    if (audioUrl.startsWith('http')) {
      return audioUrl;
    }
    return '$baseUrl$audioUrl';
  }
}