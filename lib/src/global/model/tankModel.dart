import 'pumpModel.dart';

class TankModel {
  final int probe;
  final DateTime dateTime;
  final int fuelGradeId;
  final String fuelGradeName;
  final String status;
  final double productHeight;
  final double waterHeight;
  final double temperature;
  final int productVolume;
  final int waterVolume;
  final int productUllage;
  final int tankFillingPercentage;
  final bool inTankDeliveryDetected;

  int get totalCapacity => productUllage+productVolume+waterVolume;

  TankModel({
    required this.probe,
    required this.dateTime,
    required this.fuelGradeId,
    required this.fuelGradeName,
    required this.status,
    required this.productHeight,
    required this.waterHeight,
    required this.temperature,
    required this.productVolume,
    required this.waterVolume,
    required this.productUllage,
    required this.tankFillingPercentage,
    required this.inTankDeliveryDetected,
  });

  // Factory constructor to create a TankModel instance from JSON
  factory TankModel.fromJson(Map<String, dynamic> json) {
    return TankModel(
      probe: json['Probe'] ?? 0,
      dateTime: cparseDateTime(json['DateTime']),
      fuelGradeId: json['FuelGradeId'] ?? 0,
      fuelGradeName: json['FuelGradeName'] ?? '',
      status: json['Status'] ?? '',
      productHeight: cparseDouble(json['ProductHeight']),
      waterHeight: cparseDouble(json['WaterHeight']),
      temperature: cparseDouble(json['Temperature']),
      productVolume: json['ProductVolume'] ?? 0,
      waterVolume: json['WaterVolume'] ?? 0,
      productUllage: json['ProductUllage'] ?? 0,
      tankFillingPercentage: json['TankFillingPercentage'] ?? 0,
      inTankDeliveryDetected: json['InTankDeliveryDetected'] ?? false,
    );
  }

  // Method to convert a TankModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Probe': probe,
      'DateTime': dateTime.toIso8601String(),
      'FuelGradeId': fuelGradeId,
      'FuelGradeName': fuelGradeName,
      'Status': status,
      'ProductHeight': productHeight,
      'WaterHeight': waterHeight,
      'Temperature': temperature,
      'ProductVolume': productVolume,
      'WaterVolume': waterVolume,
      'ProductUllage': productUllage,
      'TankFillingPercentage': tankFillingPercentage,
      'InTankDeliveryDetected': inTankDeliveryDetected,
    };
  }

  @override
  String toString() {
    return 'Probe: $probe, Status: $status, Fuel: $fuelGradeName, '
        'Fill: $tankFillingPercentage%, '
        'Product Height: $productHeight, Product Volume: $productVolume';
  }
}

final allDemoTanks = {
  "Protocol": "jsonPTS",
  "Packets": [
    {
      "Id": 1,
      "Type": "ProbeMeasurements",
      "Data": {
        "Probe": 1,
        "DateTime": "2025-03-19T20:15:26",
        "FuelGradeId": 1,
        "FuelGradeName": "AGO",
        "Status": "OK",
        "ProductHeight": 1488.4,
        "WaterHeight": 15.3,
        "Temperature": 29.0,
        "ProductVolume": 31399,
        "WaterVolume": 113,
        "ProductUllage": 19988,
        "TankFillingPercentage": 61,
        "InTankDeliveryDetected": false
      }
    },
    {
      "Id": 2,
      "Type": "ProbeMeasurements",
      "Data": {
        "Probe": 2,
        "DateTime": "2025-03-19T20:15:25",
        "FuelGradeId": 1,
        "FuelGradeName": "AGO",
        "Status": "OK",
        "ProductHeight": 158.2,
        "WaterHeight": 14.4,
        "Temperature": 32.4,
        "ProductVolume": 353,
        "WaterVolume": 588,
        "ProductUllage": 22284,
        "TankFillingPercentage": 4,
        "InTankDeliveryDetected": false
      }
    },
    {
      "Id": 3,
      "Type": "ConfigurationIdentifier",
      "Data": {
        "Id": "2e6a180"
      }
    }
  ]
};
