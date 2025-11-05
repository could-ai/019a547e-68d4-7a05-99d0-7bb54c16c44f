import 'package:flutter/material.dart';

enum VehicleType {
  car,
  truck,
  autoRickshaw,
  bus,
  motorcycle,
}

class Vehicle {
  int lane;
  double yPosition;
  bool isPlayer;
  VehicleType vehicleType;
  
  Vehicle({
    required this.lane,
    required this.yPosition,
    required this.isPlayer,
    required this.vehicleType,
  });
  
  Color get color {
    if (isPlayer) {
      return Colors.blue.shade700;
    }
    
    switch (vehicleType) {
      case VehicleType.car:
        return Colors.red.shade600;
      case VehicleType.truck:
        return Colors.brown.shade700;
      case VehicleType.autoRickshaw:
        return Colors.yellow.shade700;
      case VehicleType.bus:
        return Colors.orange.shade700;
      case VehicleType.motorcycle:
        return Colors.green.shade600;
    }
  }
  
  String get emoji {
    if (isPlayer) {
      return '🚗';
    }
    
    switch (vehicleType) {
      case VehicleType.car:
        return '🚙';
      case VehicleType.truck:
        return '🚚';
      case VehicleType.autoRickshaw:
        return '🛺';
      case VehicleType.bus:
        return '🚌';
      case VehicleType.motorcycle:
        return '🏍️';
    }
  }
  
  double get width {
    switch (vehicleType) {
      case VehicleType.motorcycle:
        return 50.0;
      case VehicleType.autoRickshaw:
        return 60.0;
      case VehicleType.car:
        return 70.0;
      case VehicleType.truck:
        return 75.0;
      case VehicleType.bus:
        return 80.0;
    }
  }
  
  double get height {
    switch (vehicleType) {
      case VehicleType.motorcycle:
        return 60.0;
      case VehicleType.autoRickshaw:
        return 70.0;
      case VehicleType.car:
        return 80.0;
      case VehicleType.bus:
        return 100.0;
      case VehicleType.truck:
        return 90.0;
    }
  }
}
