class HelpFaqResponse {
  final bool status;
  final String? message;
  // final HelpFaq? data;
  final List<HelpFaq>? faqs;

  HelpFaqResponse({this.message, required this.status, this.faqs});
  // , required this.data

  factory HelpFaqResponse.fromJson(Map<String, dynamic> json) {
    List<HelpFaq> _faqs = List.empty();
    if (json['data'] != null) {
      _faqs = (json['data'] as Map<String, dynamic>)
          .entries
          .map((e) => HelpFaq(
              title: e.key,
              faqs: e.value is Iterable
                  ? (e.value as Iterable).map((e2) => Faq.fromJson(e2)).toList()
                  : List.empty()))
          .toList();
    }
    return HelpFaqResponse(
        status: json['success'], message: json['message'], faqs: _faqs);
  }
}

class HelpFaq {
  final String title;
  final List<Faq>? faqs;

  HelpFaq({required this.title, this.faqs});
}

class Faq {
  final String question, answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
