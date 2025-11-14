// To parse this JSON data, do
//
//     final offlineticketModel = offlineticketModelFromJson(jsonString);

import 'dart:convert';

OfflineticketModel offlineticketModelFromJson(String str) => OfflineticketModel.fromJson(json.decode(str));

String offlineticketModelToJson(OfflineticketModel data) => json.encode(data.toJson());

class OfflineticketModel {
    final int offlineTicketId;
    final String barcode;
    final int ticketTypeId;
    final DateTime ticketDate;
    final int price;
    final String status;
    final DateTime saleAt;
    final DateTime generateAt;

    OfflineticketModel({
        required this.offlineTicketId,
        required this.barcode,
        required this.ticketTypeId,
        required this.ticketDate,
        required this.price,
        required this.status,
        required this.saleAt,
        required this.generateAt,
    });

    factory OfflineticketModel.fromJson(Map<String, dynamic> json) => OfflineticketModel(
        offlineTicketId: json["offlineTicketId"],
        barcode: json["barcode"],
        ticketTypeId: json["ticketTypeId"],
        ticketDate: DateTime.parse(json["ticketDate"]),
        price: json["price"],
        status: json["status"],
        saleAt: DateTime.parse(json["saleAt"]),
        generateAt: DateTime.parse(json["generateAt"]),
    );

    Map<String, dynamic> toJson() => {
        "offlineTicketId": offlineTicketId,
        "barcode": barcode,
        "ticketTypeId": ticketTypeId,
        "ticketDate": ticketDate.toIso8601String(),
        "price": price,
        "status": status,
        "saleAt": saleAt.toIso8601String(),
        "generateAt": generateAt.toIso8601String(),
    };
}
