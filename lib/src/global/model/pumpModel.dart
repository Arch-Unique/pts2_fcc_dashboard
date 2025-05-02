class PumpModel {
  final int pump;
  final String state;
  final int nozzleUp;
  final int nozzle;
  final String request;
  final int lastNozzle;
  final double lastVolume;
  final int lastPrice;
  final double lastAmount;
  final int lastTransaction;
  final int lastFuelGradeId;
  final String lastFuelGradeName;
  final double lastTotalVolume;
  final double lastTotalAmount;
  final DateTime lastDateTimeStart;
  final DateTime lastDateTime;
  final String lastUser;
  final String user;

  String get stateRaw => state.replaceFirst("Pump","").replaceFirst("Status","").toLowerCase();

  PumpModel({
    required this.pump,
    required this.state,
    required this.nozzleUp,
    required this.nozzle,
    required this.request,
    required this.lastNozzle,
    required this.lastVolume,
    required this.lastPrice,
    required this.lastAmount,
    required this.lastTransaction,
    required this.lastFuelGradeId,
    required this.lastFuelGradeName,
    required this.lastTotalVolume,
    required this.lastTotalAmount,
    required this.lastDateTimeStart,
    required this.lastDateTime,
    required this.lastUser,
    required this.user,
  });

  // Factory constructor to create a Pump instance from JSON
  factory PumpModel.fromJson(Map<String, dynamic> json) {
    return PumpModel(
      pump: json["Data"]['Pump'] ?? 0,
      state: json['Type'] ?? '',
      nozzleUp: json["Data"]['NozzleUp'] ?? 0,
      nozzle: json["Data"]['Nozzle'] ?? 0,
      request: json["Data"]['Request'] ?? '',
      lastNozzle: json["Data"]['LastNozzle'] ?? json["Data"]['Nozzle'] ?? 0,
      lastVolume: cparseDouble(json["Data"]['LastVolume'] ?? json["Data"]['Volume']),
      lastPrice: json["Data"]['LastPrice'] ?? json["Data"]['Price'] ?? 0,
      lastAmount: cparseDouble(json["Data"]['LastAmount'] ?? json["Data"]['Amount']),
      lastTransaction: json["Data"]['LastTransaction'] ?? json["Data"]['Transaction'] ?? 0,
      lastFuelGradeId: json["Data"]['LastFuelGradeId'] ?? json["Data"]['FuelGradeId'] ?? 0,
      lastFuelGradeName: json["Data"]['LastFuelGradeName'] ?? json["Data"]['FuelGradeName'] ?? '',
      lastTotalVolume: cparseDouble(json["Data"]['LastTotalVolume']),
      lastTotalAmount: cparseDouble(json["Data"]['LastTotalAmount']),
      lastDateTimeStart: cparseDateTime(json["Data"]['LastDateTimeStart']),
      lastDateTime: cparseDateTime(json["Data"]['LastDateTime']),
      lastUser: json["Data"]['LastUser'] ?? '',
      user: json["Data"]['User'] ?? '',
    );
  }

  // Method to convert a Pump instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Pump': pump,
      'State': state,
      'NozzleUp': nozzleUp,
      'Nozzle': nozzle,
      'Request': request,
      'LastNozzle': lastNozzle,
      'LastVolume': lastVolume,
      'LastPrice': lastPrice,
      'LastAmount': lastAmount,
      'LastTransaction': lastTransaction,
      'LastFuelGradeId': lastFuelGradeId,
      'LastFuelGradeName': lastFuelGradeName,
      'LastTotalVolume': lastTotalVolume,
      'LastTotalAmount': lastTotalAmount,
      'LastDateTimeStart': lastDateTimeStart.toIso8601String(),
      'LastDateTime': lastDateTime.toIso8601String(),
      'LastUser': lastUser,
      'User': user,
    };
  }

  @override
  String toString() {
    return 'Pump $pump: $state, Last Transaction: $lastTransaction, '
        'LastVolume: $lastVolume, LastAmount: $lastAmount, '
        'Fuel: $lastFuelGradeName';
  }
}

final allDemoPumps = {
  "Protocol": "jsonPTS",
  "Packets": [
    {
      "Id": 1,
      "Type": "PumpIdleStatus",
      "Data": {
        "Pump": 1,
        "NozzleUp": 0,
        "Nozzle": 0,
        "Request": "",
        "NozzlePrices": [1130, 0, 0, 0, 0, 0],
        "LastNozzle": 1,
        "LastVolume": 10.0,
        "LastPrice": 1130,
        "LastAmount": 11300.0,
        "LastTransaction": 333,
        "LastFuelGradeId": 1,
        "LastFuelGradeName": "AGO",
        "LastTotalVolume": 52102.09,
        "LastTotalAmount": 57641792.0,
        "LastDateTimeStart": "2025-03-18T22:49:26",
        "LastDateTime": "2025-03-18T22:50:28",
        "LastUser": "PTS",
        "User": ""
      }
    },
    {
      "Id": 2,
      "Type": "PumpIdleStatus",
      "Data": {
        "Pump": 2,
        "NozzleUp": 0,
        "Nozzle": 0,
        "Request": "",
        "NozzlePrices": [1130, 0, 0, 0, 0, 0],
        "LastNozzle": 1,
        "LastVolume": 0.0,
        "LastPrice": 1130,
        "LastAmount": 0.0,
        "LastTransaction": 8,
        "LastFuelGradeId": 1,
        "LastFuelGradeName": "AGO",
        "LastTotalVolume": 798.81,
        "LastTotalAmount": 117805.0,
        "LastDateTimeStart": "2025-03-06T18:10:02",
        "LastDateTime": "2025-03-06T18:10:14",
        "LastUser": "PTS",
        "User": ""
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

  // Helper method to parse double values safely
  double cparseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper method to parse DateTime values safely
  DateTime cparseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }