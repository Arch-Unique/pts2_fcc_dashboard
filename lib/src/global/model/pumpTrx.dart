import 'barrel.dart';

class PumpTrx {
  final int pump;
  final int nozzle;
  final double volume;
  final int price;
  final double amount;
  final int transaction;
  final int fuelGradeId;
  final String fuelGradeName;
  final double totalVolume;
  final double totalAmount;
  final DateTime dateTimeStart;
  final DateTime dateTime;
  final String user;

  PumpTrx({
    required this.pump,
    required this.nozzle,
    required this.volume,
    required this.price,
    required this.amount,
    required this.transaction,
    required this.fuelGradeId,
    required this.fuelGradeName,
    required this.totalVolume,
    required this.totalAmount,
    required this.dateTimeStart,
    required this.dateTime,
    required this.user,
  });

  // Factory constructor to create a Pump instance from JSON
  factory PumpTrx.fromJson(Map<String, dynamic> json) {
    return PumpTrx(
      pump: json['Pump'] ?? 0,
      nozzle: json['Nozzle'] ?? 0,
      volume: cparseDouble(json['Volume']),
      price: json['Price'] ?? 0,
      amount: cparseDouble(json['Amount']),
      transaction: json['Transaction'] ?? 0,
      fuelGradeId: json['FuelGradeId'] ?? 0,
      fuelGradeName: json['FuelGradeName'] ?? '',
      totalVolume: cparseDouble(json['TotalVolume']),
      totalAmount: cparseDouble(json['TotalAmount']),
      dateTimeStart: cparseDateTime(json['DateTimeStart']),
      dateTime: cparseDateTime(json['DateTime']),
      user: json['User'] ?? '',
    );
  }

  // Method to convert a Pump instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Pump': pump,
      'Nozzle': nozzle,
      'Volume': volume,
      'Price': price,
      'Amount': amount,
      'Transaction': transaction,
      'FuelGradeId': fuelGradeId,
      'FuelGradeName': fuelGradeName,
      'TotalVolume': totalVolume,
      'TotalAmount': totalAmount,
      'DateTimeStart': dateTimeStart.toIso8601String(),
      'DateTime': dateTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Pump $pump,  Transaction: $transaction, '
        'Volume: $volume, Amount: $amount, '
        'Fuel: $fuelGradeName';
  }
}