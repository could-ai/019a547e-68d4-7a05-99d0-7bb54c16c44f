import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/vehicle.dart';
import '../widgets/game_canvas.dart';
import '../widgets/game_controls.dart';
import '../widgets/game_over_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int roadLanes = 3;
  static const double laneWidth = 100.0;
  
  // Player vehicle
  Vehicle playerVehicle = Vehicle(
    lane: 1,
    yPosition: 500,
    isPlayer: true,
    vehicleType: VehicleType.car,
  );
  
  // Traffic vehicles
  List<Vehicle> trafficVehicles = [];
  
  // Game state
  int score = 0;
  int highScore = 0;
  bool isGameOver = false;
  bool isPaused = false;
  
  // Game loop
  Timer? gameTimer;
  Timer? spawnTimer;
  
  // Road animation
  double roadOffset = 0;
  
  @override
  void initState() {
    super.initState();
    startGame();
  }
  
  void startGame() {
    setState(() {
      score = 0;
      isGameOver = false;
      isPaused = false;
      trafficVehicles.clear();
      playerVehicle = Vehicle(
        lane: 1,
        yPosition: 500,
        isPlayer: true,
        vehicleType: VehicleType.car,
      );
    });
    
    // Main game loop - runs at ~60 FPS
    gameTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!isPaused && !isGameOver) {
        updateGame();
      }
    });
    
    // Spawn traffic vehicles periodically
    spawnTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (!isPaused && !isGameOver) {
        spawnTrafficVehicle();
      }
    });
  }
  
  void updateGame() {
    setState(() {
      // Update road animation
      roadOffset += 8;
      if (roadOffset >= 100) {
        roadOffset = 0;
      }
      
      // Move traffic vehicles down
      for (var vehicle in trafficVehicles) {
        vehicle.yPosition += 5;
      }
      
      // Remove vehicles that are off screen
      trafficVehicles.removeWhere((vehicle) => vehicle.yPosition > 700);
      
      // Check collisions
      checkCollisions();
      
      // Increase score based on survived time
      score += 1;
    });
  }
  
  void spawnTrafficVehicle() {
    final random = Random();
    final lane = random.nextInt(roadLanes);
    final vehicleTypes = VehicleType.values;
    final vehicleType = vehicleTypes[random.nextInt(vehicleTypes.length)];
    
    // Don't spawn if there's already a vehicle in that lane close to the top
    bool canSpawn = !trafficVehicles.any(
      (v) => v.lane == lane && v.yPosition < 100,
    );
    
    if (canSpawn) {
      trafficVehicles.add(Vehicle(
        lane: lane,
        yPosition: -100,
        isPlayer: false,
        vehicleType: vehicleType,
      ));
    }
  }
  
  void checkCollisions() {
    const collisionThreshold = 80.0;
    
    for (var vehicle in trafficVehicles) {
      if (vehicle.lane == playerVehicle.lane) {
        final distance = (vehicle.yPosition - playerVehicle.yPosition).abs();
        if (distance < collisionThreshold) {
          gameOver();
          break;
        }
      }
    }
  }
  
  void gameOver() {
    setState(() {
      isGameOver = true;
      if (score > highScore) {
        highScore = score;
      }
    });
    
    gameTimer?.cancel();
    spawnTimer?.cancel();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GameOverDialog(
        score: score,
        highScore: highScore,
        onRestart: () {
          Navigator.pop(context);
          startGame();
        },
        onHome: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }
  
  void movePlayer(int direction) {
    if (!isGameOver && !isPaused) {
      setState(() {
        int newLane = playerVehicle.lane + direction;
        if (newLane >= 0 && newLane < roadLanes) {
          playerVehicle.lane = newLane;
        }
      });
    }
  }
  
  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }
  
  @override
  void dispose() {
    gameTimer?.cancel();
    spawnTimer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game canvas
          GameCanvas(
            playerVehicle: playerVehicle,
            trafficVehicles: trafficVehicles,
            roadOffset: roadOffset,
            laneWidth: laneWidth,
          ),
          
          // Score display
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'High: $highScore',
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pause button
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                isPaused ? Icons.play_arrow : Icons.pause,
                color: Colors.white,
                size: 36,
              ),
              onPressed: togglePause,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          
          // Pause overlay
          if (isPaused)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Text(
                  'PAUSED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          // Game controls
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: GameControls(
              onMoveLeft: () => movePlayer(-1),
              onMoveRight: () => movePlayer(1),
            ),
          ),
        ],
      ),
    );
  }
}
