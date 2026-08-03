
const String imageBase = 'https://api.soulgatelight.com/tarot/static/images/cards';


class TarotCard {
  final int id;
  final String name;
  final String arcana; // 'major' | 'minor'
  final String? suit;  // null for Major Arcana
  final String image;
  final List<String> keywords;
  final String meaning;

  const TarotCard({
    required this.id,
    required this.name,
    required this.arcana,
    this.suit,
    required this.image,
    required this.keywords,
    required this.meaning,
  });
}

class OracleQuestion {
  final int id;
  final String category;
  final String question;

  const OracleQuestion({
    required this.id,
    required this.category,
    required this.question,
  });
}

// ---------------------------------------------------------------------------
// Tarot Cards
// ---------------------------------------------------------------------------

const List<TarotCard> tarotCards = [
  // ── Major Arcana (0-21) ──────────────────────────────────────────────────
  TarotCard(
    id: 0,
    name: 'The Fool',
    arcana: 'major',
    image: '$imageBase/0_the_fool.jpg',

    keywords: ['beginnings', 'innocence', 'spontaneity', 'free spirit'],
    meaning:
        'The Fool represents new beginnings, having faith in the future, being inexperienced, not knowing what to expect, having beginner\'s luck, improvisation and believing in the universe.',
  ),
  TarotCard(
    id: 1,
    name: 'The Magician',
    arcana: 'major',
    image: '$imageBase/1_the_magician.jpg',
    keywords: ['manifestation', 'resourcefulness', 'power', 'inspired action'],
    meaning:
        'The Magician represents willpower, creation, and manifestation. You have the power and resources to make your dreams a reality through focused intention and action.',
  ),
  TarotCard(
    id: 2,
    name: 'The High Priestess',
    arcana: 'major',
    image: '$imageBase/2_the_high_priestess.jpg',
    keywords: ['intuition', 'sacred knowledge', 'divine feminine', 'subconscious mind'],
    meaning:
        'The High Priestess represents intuition, mystery, and inner knowledge. Trust your instincts and look beyond the obvious to find hidden truths.',
  ),
  TarotCard(
    id: 3,
    name: 'The Empress',
    arcana: 'major',
    image: '$imageBase/3_the_empress.jpg',
    keywords: ['femininity', 'beauty', 'nature', 'nurturing', 'abundance'],
    meaning:
        'The Empress represents fertility, abundance, and maternal care. A time of creativity, sensuality, and connection with nature and the divine feminine.',
  ),
  TarotCard(
    id: 4,
    name: 'The Emperor',
    arcana: 'major',
    image: '$imageBase/4_the_emperor.jpg',
    keywords: ['authority', 'structure', 'control', 'fatherhood'],
    meaning:
        'The Emperor represents authority, structure, and leadership. Establish order and take control of your situation through discipline and strategic thinking.',
  ),
  TarotCard(
    id: 5,
    name: 'The Hierophant',
    arcana: 'major',
    image: '$imageBase/5_the_hierophant.jpg',
    keywords: ['spiritual wisdom', 'tradition', 'conformity', 'morality'],
    meaning:
        'The Hierophant represents tradition, spiritual guidance, and conformity. Seek wisdom from established institutions or mentors.',
  ),
  TarotCard(
    id: 6,
    name: 'The Lovers',
    arcana: 'major',
    image: '$imageBase/6_the_lovers.jpg',
    keywords: ['love', 'harmony', 'relationships', 'values alignment', 'choices'],
    meaning:
        'The Lovers represents love, harmony, and important choices. A significant relationship or decision that aligns with your core values.',
  ),
  TarotCard(
    id: 7,
    name: 'The Chariot',
    arcana: 'major',
    image: '$imageBase/7_the_chariot.jpg',
    keywords: ['control', 'willpower', 'success', 'determination'],
    meaning:
        'The Chariot represents victory through determination and willpower. Overcome obstacles by staying focused and asserting your will.',
  ),
  TarotCard(
    id: 8,
    name: 'Strength',
    arcana: 'major',
    image: '$imageBase/8_strength.jpg',
    keywords: ['courage', 'patience', 'control', 'compassion'],
    meaning:
        'Strength represents inner power, courage, and compassion. Tame your inner beasts through patience and gentle control rather than force.',
  ),
  TarotCard(
    id: 9,
    name: 'The Hermit',
    arcana: 'major',
    image: '$imageBase/9_the_hermit.jpg',
    keywords: ['soul searching', 'introspection', 'being alone', 'inner guidance'],
    meaning:
        'The Hermit represents contemplation, introspection, and solitude. Take time for self-reflection and seek inner wisdom.',
  ),
  TarotCard(
    id: 10,
    name: 'Wheel of Fortune',
    arcana: 'major',
    image: '$imageBase/10_wheel_of_fortune.jpg',
    keywords: ['good luck', 'karma', 'life cycles', 'destiny', 'turning point'],
    meaning:
        'The Wheel of Fortune represents cycles, fate, and turning points. Accept the constant change of life and trust in the natural order.',
  ),
  TarotCard(
    id: 11,
    name: 'Justice',
    arcana: 'major',
    image: '$imageBase/11_justice.jpg',
    keywords: ['fairness', 'truth', 'cause and effect', 'law'],
    meaning:
        'Justice represents fairness, truth, and the law of cause and effect. Take responsibility for your actions and seek balanced outcomes.',
  ),
  TarotCard(
    id: 12,
    name: 'The Hanged Man',
    arcana: 'major',
    image: '$imageBase/12_the_hanged_man.jpg',
    keywords: ['pause', 'surrender', 'letting go', 'new perspectives'],
    meaning:
        'The Hanged Man represents suspension, sacrifice, and new perspectives. Sometimes you must let go and see things differently.',
  ),
  TarotCard(
    id: 13,
    name: 'Death',
    arcana: 'major',
    image: '$imageBase/13_death.jpg',
    keywords: ['endings', 'change', 'transformation', 'transition'],
    meaning:
        'Death represents transformation, endings, and new beginnings. Something must end for something new to begin.',
  ),
  TarotCard(
    id: 14,
    name: 'Temperance',
    arcana: 'major',
    image: '$imageBase/14_temperance.jpg',
    keywords: ['balance', 'moderation', 'patience', 'purpose'],
    meaning:
        'Temperance represents balance, moderation, and patience. Find middle ground and practice the art of patience.',
  ),
  TarotCard(
    id: 15,
    name: 'The Devil',
    arcana: 'major',
    image: '$imageBase/15_the_devil.jpg',
    keywords: ['shadow self', 'attachment', 'addiction', 'restriction'],
    meaning:
        'The Devil represents bondage, materialism, and shadow aspects. Recognize what holds you back and reclaim your power.',
  ),
  TarotCard(
    id: 16,
    name: 'The Tower',
    arcana: 'major',
    image: '$imageBase/16_the_tower.jpg',
    keywords: ['sudden change', 'upheaval', 'chaos', 'revelation', 'awakening'],
    meaning:
        'The Tower represents sudden upheaval, revelation, and breakthrough. Destruction of the old makes way for the new.',
  ),
  TarotCard(
    id: 17,
    name: 'The Star',
    arcana: 'major',
    image: '$imageBase/17_the_star.jpg',
    keywords: ['hope', 'faith', 'purpose', 'renewal', 'spirituality'],
    meaning:
        'The Star represents hope, inspiration, and spiritual connection. After darkness comes light and renewed faith.',
  ),
  TarotCard(
    id: 18,
    name: 'The Moon',
    arcana: 'major',
    image: '$imageBase/18_the_moon.jpg',
    keywords: ['illusion', 'fear', 'anxiety', 'subconscious', 'intuition'],
    meaning:
        'The Moon represents illusion, intuition, and the subconscious. Things may not be as they seem; trust your deeper knowing.',
  ),
  TarotCard(
    id: 19,
    name: 'The Sun',
    arcana: 'major',
    image: '$imageBase/19_the_sun.jpg',
    keywords: ['positivity', 'fun', 'warmth', 'success', 'vitality'],
    meaning:
        'The Sun represents joy, success, and vitality. Radiate positivity and embrace the warmth of life\'s blessings.',
  ),
  TarotCard(
    id: 20,
    name: 'Judgement',
    arcana: 'major',
    image: '$imageBase/20_judgement.jpg',
    keywords: ['reflection', 'reckoning', 'awakening', 'rebirth'],
    meaning:
        'Judgement represents reflection, evaluation, and spiritual awakening. Answer a higher calling and embrace transformation.',
  ),
  TarotCard(
    id: 21,
    name: 'The World',
    arcana: 'major',
    image: '$imageBase/21_the_world.jpg',
    keywords: ['completion', 'integration', 'accomplishment', 'travel'],
    meaning:
        'The World represents completion, fulfillment, and achievement. A cycle is complete, and you have achieved wholeness.',
  ),

  // ── Minor Arcana – Wands (22-35) ─────────────────────────────────────────
  TarotCard(
    id: 22,
    name: 'Ace of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/22_ace_of_wands.jpg',
    keywords: ['inspiration', 'new opportunities', 'growth', 'potential'],
    meaning:
        'A spark of inspiration and new creative energy. The beginning of a passionate endeavor or spiritual journey.',
  ),
  TarotCard(
    id: 23,
    name: 'Two of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/23_two_of_wands.jpg',
    keywords: ['future planning', 'progress', 'decisions', 'discovery'],
    meaning:
        'Planning and looking ahead. You have the world in your hands and are making important decisions about your path.',
  ),
  TarotCard(
    id: 24,
    name: 'Three of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/24_three_of_wands.jpg',
    keywords: ['progress', 'expansion', 'foresight', 'overseas opportunities'],
    meaning:
        'Your plans are taking shape. Expansion and growth are on the horizon as your efforts begin to pay off.',
  ),
  TarotCard(
    id: 25,
    name: 'Four of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/25_four_of_wands.jpg',
    keywords: ['celebration', 'harmony', 'marriage', 'home', 'community'],
    meaning: 'Celebration and harmony. A time of joy, community, and marking important milestones.',
  ),
  TarotCard(
    id: 26,
    name: 'Five of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/26_five_of_wands.jpg',
    keywords: ['conflict', 'disagreements', 'competition', 'tension'],
    meaning:
        'Conflict and competition. Diverse opinions clash, creating tension but also opportunity for growth.',
  ),
  TarotCard(
    id: 27,
    name: 'Six of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/27_six_of_wands.jpg',
    keywords: ['success', 'recognition', 'progress', 'self-confidence'],
    meaning:
        'Victory and public recognition. Your efforts are celebrated, and you receive the acknowledgment you deserve.',
  ),
  TarotCard(
    id: 28,
    name: 'Seven of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/28_seven_of_wands.jpg',
    keywords: ['challenge', 'competition', 'perseverance', 'defense'],
    meaning:
        'Defending your position against challenges. Stand your ground and maintain your convictions.',
  ),
  TarotCard(
    id: 29,
    name: 'Eight of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/29_eight_of_wands.jpg',
    keywords: ['movement', 'fast paced change', 'action', 'alignment'],
    meaning: 'Swift action and rapid progress. Things are moving quickly, and obstacles are clearing.',
  ),
  TarotCard(
    id: 30,
    name: 'Nine of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/30_nine_of_wands.jpg',
    keywords: ['resilience', 'courage', 'persistence', 'test of faith'],
    meaning:
        'Resilience in the face of adversity. You are battle-worn but not defeated. Keep going.',
  ),
  TarotCard(
    id: 31,
    name: 'Ten of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/31_ten_of_wands.jpg',
    keywords: ['burden', 'responsibility', 'hard work', 'stress'],
    meaning:
        'Carrying a heavy burden. You have taken on too much and need to delegate or prioritize.',
  ),
  TarotCard(
    id: 32,
    name: 'Page of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/32_page_of_wands.jpg',
    keywords: ['exploration', 'excitement', 'freedom', 'adventure'],
    meaning:
        'A free spirit with a thirst for discovery. New ideas and opportunities for adventure await.',
  ),
  TarotCard(
    id: 33,
    name: 'Knight of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/33_knight_of_wands.jpg',
    keywords: ['energy', 'passion', 'adventure', 'impulsiveness'],
    meaning:
        'Passionate pursuit of goals with adventurous spirit. Act with courage but avoid recklessness.',
  ),
  TarotCard(
    id: 34,
    name: 'Queen of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/34_queen_of_wands.jpg',
    keywords: ['courage', 'confidence', 'independence', 'social butterfly'],
    meaning: 'Confident and charismatic leadership. Embrace your inner fire and inspire others.',
  ),
  TarotCard(
    id: 35,
    name: 'King of Wands',
    arcana: 'minor',
    suit: 'wands',
    image: '$imageBase/35_king_of_wands.jpg',
    keywords: ['natural-born leader', 'vision', 'entrepreneur', 'honour'],
    meaning:
        'Visionary leadership with honor. Lead with passion and inspire others to follow your vision.',
  ),

  // ── Minor Arcana – Cups (36-49) ──────────────────────────────────────────
  TarotCard(
    id: 36,
    name: 'Ace of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/36_ace_of_cups.jpg',
    keywords: ['love', 'new feelings', 'emotional awakening', 'creativity'],
    meaning:
        'New emotional beginnings and spiritual abundance. Open your heart to love and creative inspiration.',
  ),
  TarotCard(
    id: 37,
    name: 'Two of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/37_two_of_cups.jpg',
    keywords: ['unified love', 'partnership', 'mutual attraction'],
    meaning:
        'Deep connection and partnership. A beautiful balance of give and take in relationships.',
  ),
  TarotCard(
    id: 38,
    name: 'Three of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/38_three_of_cups.jpg',
    keywords: ['celebration', 'friendship', 'creativity', 'community'],
    meaning:
        'Celebration with friends and community. Joy in shared experiences and creative collaboration.',
  ),
  TarotCard(
    id: 39,
    name: 'Four of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/39_four_of_cups.jpg',
    keywords: ['meditation', 'contemplation', 'apathy', 'reevaluation'],
    meaning:
        'Contemplation and reassessment. Take time to reflect, but don\'t miss new opportunities.',
  ),
  TarotCard(
    id: 40,
    name: 'Five of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/40_five_of_cups.jpg',
    keywords: ['regret', 'failure', 'disappointment', 'pessimism'],
    meaning: 'Grieving loss and disappointment. Acknowledge the pain but remember what remains.',
  ),
  TarotCard(
    id: 41,
    name: 'Six of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/41_six_of_cups.jpg',
    keywords: ['revisiting the past', 'childhood memories', 'innocence', 'joy'],
    meaning:
        'Nostalgia and childhood memories. Reconnect with your inner child and simpler times.',
  ),
  TarotCard(
    id: 42,
    name: 'Seven of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/42_seven_of_cups.jpg',
    keywords: ['opportunities', 'choices', 'wishful thinking', 'illusion'],
    meaning: 'Many options and possibilities. Be careful of wishful thinking and choose wisely.',
  ),
  TarotCard(
    id: 43,
    name: 'Eight of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/43_eight_of_cups.jpg',
    keywords: ['disappointment', 'abandonment', 'withdrawal', 'escapism'],
    meaning:
        'Walking away from what no longer serves you. Courage to seek deeper fulfillment.',
  ),
  TarotCard(
    id: 44,
    name: 'Nine of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/44_nine_of_cups.jpg',
    keywords: ['contentment', 'satisfaction', 'gratitude', 'wish come true'],
    meaning:
        'Emotional fulfillment and wishes granted. A time of deep satisfaction and gratitude.',
  ),
  TarotCard(
    id: 45,
    name: 'Ten of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/45_ten_of_cups.jpg',
    keywords: ['divine love', 'harmony', 'alignment', 'family'],
    meaning:
        'Ultimate emotional fulfillment and family harmony. The happily ever after you seek.',
  ),
  TarotCard(
    id: 46,
    name: 'Page of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/46_page_of_cups.jpg',
    keywords: ['creative opportunities', 'intuitive messages', 'curiosity'],
    meaning:
        'Creative inspiration and intuitive messages. Embrace your imaginative and sensitive side.',
  ),
  TarotCard(
    id: 47,
    name: 'Knight of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/47_knight_of_cups.jpg',
    keywords: ['creativity', 'romance', 'charm', 'imagination'],
    meaning:
        'A romantic and creative soul following their heart. Act on your emotions with grace.',
  ),
  TarotCard(
    id: 48,
    name: 'Queen of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/48_queen_of_cups.jpg',
    keywords: ['compassion', 'calm', 'comfort', 'intuition'],
    meaning:
        'Deep emotional intelligence and nurturing care. Trust your intuition and offer compassion.',
  ),
  TarotCard(
    id: 49,
    name: 'King of Cups',
    arcana: 'minor',
    suit: 'cups',
    image: '$imageBase/49_king_of_cups.jpg',
    keywords: ['emotional balance', 'control', 'generosity'],
    meaning:
        'Mastery of emotions with wisdom and compassion. Lead with emotional intelligence.',
  ),

  // ── Minor Arcana – Swords (50-63) ────────────────────────────────────────
  TarotCard(
    id: 50,
    name: 'Ace of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/50_ace_of_swords.jpg',
    keywords: ['breakthroughs', 'new ideas', 'mental clarity', 'success'],
    meaning:
        'Mental clarity and breakthrough thinking. A new perspective that cuts through confusion.',
  ),
  TarotCard(
    id: 51,
    name: 'Two of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/51_two_of_swords.jpg',
    keywords: ['difficult decisions', 'weighing options', 'stalemate'],
    meaning:
        'A difficult decision requiring balance of heart and mind. Remove the blindfold to see clearly.',
  ),
  TarotCard(
    id: 52,
    name: 'Three of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/52_three_of_swords.jpg',
    keywords: ['heartbreak', 'emotional pain', 'sorrow', 'grief'],
    meaning:
        'Heartbreak and emotional pain. Accept and process the grief to heal and move forward.',
  ),
  TarotCard(
    id: 53,
    name: 'Four of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/53_four_of_swords.jpg',
    keywords: ['rest', 'relaxation', 'meditation', 'contemplation'],
    meaning: 'Rest and recovery. Take a break to restore your mental and physical energy.',
  ),
  TarotCard(
    id: 54,
    name: 'Five of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/54_five_of_swords.jpg',
    keywords: ['conflict', 'disagreements', 'competition', 'defeat'],
    meaning: 'Conflict where no one truly wins. Consider if the battle is worth the cost.',
  ),
  TarotCard(
    id: 55,
    name: 'Six of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/55_six_of_swords.jpg',
    keywords: ['transition', 'change', 'rite of passage', 'releasing baggage'],
    meaning:
        'Moving on from difficulties toward calmer waters. A necessary journey of transition.',
  ),
  TarotCard(
    id: 56,
    name: 'Seven of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/56_seven_of_swords.jpg',
    keywords: ['deception', 'trickery', 'strategy', 'sneakiness'],
    meaning:
        'Strategic thinking or deception. Be aware of those who may not have your best interests at heart.',
  ),
  TarotCard(
    id: 57,
    name: 'Eight of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/57_eight_of_swords.jpg',
    keywords: ['negative thoughts', 'self-imposed restriction', 'imprisonment'],
    meaning:
        'Feeling trapped by your own thoughts. The restrictions are often self-imposed.',
  ),
  TarotCard(
    id: 58,
    name: 'Nine of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/58_nine_of_swords.jpg',
    keywords: ['anxiety', 'worry', 'fear', 'depression', 'nightmares'],
    meaning: 'Anxiety and mental anguish keeping you awake. Face your fears and seek support.',
  ),
  TarotCard(
    id: 59,
    name: 'Ten of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/59_ten_of_swords.jpg',
    keywords: ['painful endings', 'deep wounds', 'betrayal', 'rock bottom'],
    meaning:
        'A painful ending or betrayal. The darkest hour is just before dawn; recovery begins.',
  ),
  TarotCard(
    id: 60,
    name: 'Page of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/60_page_of_swords.jpg',
    keywords: ['new ideas', 'curiosity', 'thirst for knowledge'],
    meaning:
        'Curious and eager to learn. Speak your truth but consider others\' feelings.',
  ),
  TarotCard(
    id: 61,
    name: 'Knight of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/61_knight_of_swords.jpg',
    keywords: ['ambition', 'action-oriented', 'driven', 'fast thinking'],
    meaning:
        'Swift action and determination. Charge ahead but don\'t leave destruction in your wake.',
  ),
  TarotCard(
    id: 62,
    name: 'Queen of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/62_queen_of_swords.jpg',
    keywords: ['independent', 'unbiased judgement', 'clear boundaries'],
    meaning: 'Clear thinking and honest communication. Set boundaries with compassion.',
  ),
  TarotCard(
    id: 63,
    name: 'King of Swords',
    arcana: 'minor',
    suit: 'swords',
    image: '$imageBase/63_king_of_swords.jpg',
    keywords: ['mental clarity', 'intellectual power', 'authority', 'truth'],
    meaning:
        'Mastery of the mind with clear, logical thinking. Lead with truth and integrity.',
  ),

  // ── Minor Arcana – Pentacles (64-77) ─────────────────────────────────────
  TarotCard(
    id: 64,
    name: 'Ace of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/64_ace_of_pentacles.jpg',
    keywords: ['new financial opportunity', 'manifestation', 'prosperity'],
    meaning: 'New financial or material opportunity. Plant seeds for future abundance.',
  ),
  TarotCard(
    id: 65,
    name: 'Two of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/65_two_of_pentacles.jpg',
    keywords: ['balance', 'adaptability', 'time management', 'prioritisation'],
    meaning: 'Juggling multiple priorities. Find balance and go with the flow of change.',
  ),
  TarotCard(
    id: 66,
    name: 'Three of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/66_three_of_pentacles.jpg',
    keywords: ['teamwork', 'collaboration', 'learning', 'implementation'],
    meaning: 'Skilled collaboration and teamwork. Your expertise is valued; work with others.',
  ),
  TarotCard(
    id: 67,
    name: 'Four of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/67_four_of_pentacles.jpg',
    keywords: ['saving money', 'security', 'conservatism', 'scarcity'],
    meaning:
        'Financial security and stability. Be mindful of the balance between saving and hoarding.',
  ),
  TarotCard(
    id: 68,
    name: 'Five of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/68_five_of_pentacles.jpg',
    keywords: ['financial loss', 'poverty', 'lack mindset', 'isolation'],
    meaning: 'Financial hardship or feeling left out. Help is available; don\'t suffer alone.',
  ),
  TarotCard(
    id: 69,
    name: 'Six of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/69_six_of_pentacles.jpg',
    keywords: ['giving', 'receiving', 'sharing wealth', 'generosity'],
    meaning: 'Generosity and fair exchange. Give and receive with gratitude and balance.',
  ),
  TarotCard(
    id: 70,
    name: 'Seven of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/70_seven_of_pentacles.jpg',
    keywords: ['long-term view', 'sustainable results', 'perseverance'],
    meaning: 'Patience and long-term investment. Your efforts will bear fruit in time.',
  ),
  TarotCard(
    id: 71,
    name: 'Eight of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/71_eight_of_pentacles.jpg',
    keywords: ['apprenticeship', 'repetitive tasks', 'mastery', 'skill development'],
    meaning:
        'Dedication to mastering your craft. Focus on quality and continuous improvement.',
  ),
  TarotCard(
    id: 72,
    name: 'Nine of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/72_nine_of_pentacles.jpg',
    keywords: ['abundance', 'luxury', 'self-sufficiency', 'financial independence'],
    meaning: 'Enjoying the fruits of your labor. Independence and material success achieved.',
  ),
  TarotCard(
    id: 73,
    name: 'Ten of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/73_ten_of_pentacles.jpg',
    keywords: ['wealth', 'financial security', 'family', 'long-term success'],
    meaning: 'Lasting wealth and family legacy. Long-term financial and emotional security.',
  ),
  TarotCard(
    id: 74,
    name: 'Page of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/74_page_of_pentacles.jpg',
    keywords: ['ambition', 'desire to learn', 'new financial opportunity'],
    meaning:
        'A studious approach to new opportunities. Stay grounded while pursuing your goals.',
  ),
  TarotCard(
    id: 75,
    name: 'Knight of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/75_knight_of_pentacles.jpg',
    keywords: ['hard work', 'productivity', 'routine', 'conservatism'],
    meaning: 'Steady, methodical progress toward goals. Reliable and hardworking approach.',
  ),
  TarotCard(
    id: 76,
    name: 'Queen of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/76_queen_of_pentacles.jpg',
    keywords: ['nurturing', 'practical', 'providing financially', 'working parent'],
    meaning:
        'Nurturing abundance and practical wisdom. Create a comfortable, secure environment.',
  ),
  TarotCard(
    id: 77,
    name: 'King of Pentacles',
    arcana: 'minor',
    suit: 'pentacles',
    image: '$imageBase/77_king_of_pentacles.jpg',
    keywords: ['wealth', 'business', 'leadership', 'security', 'discipline'],
    meaning:
        'Mastery of the material world. Wise leadership in business and financial matters.',
  ),
];

// ---------------------------------------------------------------------------
// Oracle Questions
// ---------------------------------------------------------------------------

const List<OracleQuestion> oracleQuestions = [
  OracleQuestion(
    id: 1,
    category: 'love',
    question:
        'What truth do you need to see today about your love life or an important relationship?',
  ),
  OracleQuestion(
    id: 2,
    category: 'finance',
    question:
        'What do you need to understand about your financial situation or your relationship with money?',
  ),
  OracleQuestion(
    id: 3,
    category: 'purpose',
    question: 'In what area of your life purpose do you need greater clarity or direction?',
  ),
  OracleQuestion(
    id: 4,
    category: 'emotional',
    question:
        'Which part of your emotional world is asking for light and balance at this moment?',
  ),
  OracleQuestion(
    id: 5,
    category: 'decision',
    question: 'Which pending decision needs clarity, perspective, or confirmation?',
  ),
  OracleQuestion(
    id: 6,
    category: 'family',
    question:
        'What do you need to understand about a family dynamic or a meaningful connection?',
  ),
  OracleQuestion(
    id: 7,
    category: 'work',
    question:
        'Which aspect of your work or project requires guidance or a strategic adjustment?',
  ),
  OracleQuestion(
    id: 8,
    category: 'spiritual',
    question:
        'What message are your guides trying to give you today about your spiritual growth?',
  ),
  OracleQuestion(
    id: 9,
    category: 'blockage',
    question:
        'What blockage do you need to identify in order to move forward with greater strength and authenticity?',
  ),
  OracleQuestion(
    id: 10,
    category: 'future',
    question:
        'What is the most important thing you need to know about the next 30 days of your life?',
  ),
  OracleQuestion(
    id: 11,
    category: 'direction',
    question: 'What direction is life encouraging me to move toward next?',
  ),
];

const Map<String, String> suitSymbols = {
  'wands': '🜂',
  'cups': '🜄',
  'swords': '🜁',
  'pentacles': '🜃',
};

/// Returns the display symbol for a given [card].
String getCardSymbol(TarotCard card) {
  if (card.arcana == 'major') return '✦';
  return suitSymbols[card.suit] ?? '✧';
}
