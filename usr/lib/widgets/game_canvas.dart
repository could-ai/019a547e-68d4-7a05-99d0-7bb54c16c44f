import 'package:flutter/material.dart';
import '../models/vehicle.dart';

class GameCanvas extends StatelessWidget {
  final Vehicle playerVehicle;
  final List<Vehicle> trafficVehicles;
  final double roadOffset;
  final double laneWidth;
  
  const GameCanvas({
    super.key,
    required this.playerVehicle,
    required this.trafficVehicles,
    required this.roadOffset,
    required this.laneWidth,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final roadWidth = laneWidth * 3;
    final roadLeft = (screenWidth - roadWidth) / 2;
    
    return Container(
      width: screenWidth,
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade100,
            Colors.green.shade200,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Road background
          Positioned(
            left: roadLeft,
            top: 0,
            child: Container(
              width: roadWidth,
              height: screenHeight,
              color: Colors.grey.shade800,
            ),
          ),
          
          // Road lane markings (animated)
          ...List.generate(8, (index) {
            final y = (index * 100.0) - roadOffset;
            return Positioned(
              left: roadLeft + laneWidth - 2,
              top: y,
              child: Container(
                width: 4,
                height: 60,
                color: Colors.white,
              ),
            );
          }),
          
          ...List.generate(8, (index) {
            final y = (index * 100.0) - roadOffset;
            return Positioned(
              left: roadLeft + (laneWidth * 2) - 2,
              top: y,
              child: Container(
                width: 4,
                height: 60,
                color: Colors.white,
              ),
            );
          }),
          
          // Road edges
          Positioned(
            left: roadLeft - 5,
            top: 0,
            child: Container(
              width: 5,
              height: screenHeight,
              color: Colors.yellow.shade700,
            ),
          ),
          
          Positioned(
            left: roadLeft + roadWidth,
            top: 0,
            child: Container(
              width: 5,
              height: screenHeight,
              color: Colors.yellow.shade700,
            ),
          ),
          
          // Traffic vehicles
          ...trafficVehicles.map((vehicle) {
            final xPosition = roadLeft + (vehicle.lane * laneWidth) + (laneWidth / 2) - (vehicle.width / 2);
            return Positioned(
              left: xPosition,
              top: vehicle.yPosition,
              child: _buildVehicleWidget(vehicle),
            );
          }),
          
          // Player vehicle
          Positioned(
            left: roadLeft + (playerVehicle.lane * laneWidth) + (laneWidth / 2) - (playerVehicle.width / 2),
            top: playerVehicle.yPosition,
            child: _buildVehicleWidget(playerVehicle),
          ),
          
          // Side decorations (trees/buildings)
          ...List.generate(5, (index) {
            final y = index * 150.0;
            return Positioned(
              left: 20,
              top: y,
              child: const Text(
                '🌳',
                style: TextStyle(fontSize: 40),
              ),
            );
          }),
          
          ...List.generate(5, (index) {
            final y = index * 150.0 + 75;
            return Positioned(
              right: 20,
              top: y,
              child: const Text(
                '🏢',
                style: TextStyle(fontSize: 40),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildVehicleWidget(Vehicle vehicle) {
    return Container(
      width: vehicle.width,
      height: vehicle.height,
      decoration: BoxDecoration(
        color: vehicle.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          vehicle.emoji,
          style: const TextStyle(
            fontSize: 36,
          ),
        ),
      ),
    );
  }
}
