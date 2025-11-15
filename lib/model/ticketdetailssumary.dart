import 'dart:convert';

// ----------------------------
// Main Converters
// ----------------------------
TicketSumaryModel ticketSumaryModelFromJson(String str) =>
    TicketSumaryModel.fromJson(json.decode(str));

String ticketSumaryModelToJson(TicketSumaryModel data) =>
    json.encode(data.toJson());

// ----------------------------
// Root Model
// ----------------------------
class TicketSumaryModel {
  final YSummary activatedBySummary;
  final YSummary todaySummary;

  TicketSumaryModel({
    required this.activatedBySummary,
    required this.todaySummary,
  });

  factory TicketSumaryModel.fromJson(Map<String, dynamic> json) =>
      TicketSumaryModel(
        activatedBySummary: YSummary.fromJson(json["activatedBySummary"]),
        todaySummary: YSummary.fromJson(json["todaySummary"]),
      );

  Map<String, dynamic> toJson() => {
    "activatedBySummary": activatedBySummary.toJson(),
    "todaySummary": todaySummary.toJson(),
  };
}

// ----------------------------
// Summary Item Model
// ----------------------------
class YSummary {
  final int?
  activatedBy; // nullable because activatedBySummary may not include it
  final int totalTickets;
  final double totalAmount;
  final List<TicketTypeBreakdown> ticketTypeBreakdown;
  final DateTime? date; // nullable because activatedBySummary has no date

  YSummary({
    required this.activatedBy,
    required this.totalTickets,
    required this.totalAmount,
    required this.ticketTypeBreakdown,
    required this.date,
  });

  factory YSummary.fromJson(Map<String, dynamic> json) => YSummary(
    activatedBy: json["activatedBy"], // may be null
    totalTickets: json["totalTickets"] ?? 0,
    totalAmount: (json["totalAmount"] as num).toDouble(),
    ticketTypeBreakdown: List<TicketTypeBreakdown>.from(
      json["ticketTypeBreakdown"].map((x) => TicketTypeBreakdown.fromJson(x)),
    ),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "activatedBy": activatedBy,
    "totalTickets": totalTickets,
    "totalAmount": totalAmount,
    "ticketTypeBreakdown": List<dynamic>.from(
      ticketTypeBreakdown.map((x) => x.toJson()),
    ),
    "date": date?.toIso8601String(),
  };
}

// ----------------------------
// Ticket Type Breakdown
// ----------------------------
class TicketTypeBreakdown {
  final int ticketTypeId;
  final int count;
  final double amount;

  TicketTypeBreakdown({
    required this.ticketTypeId,
    required this.count,
    required this.amount,
  });

  factory TicketTypeBreakdown.fromJson(Map<String, dynamic> json) =>
      TicketTypeBreakdown(
        ticketTypeId: json["ticketTypeId"],
        count: json["count"],
        amount: (json["amount"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "ticketTypeId": ticketTypeId,
    "count": count,
    "amount": amount,
  };
}
