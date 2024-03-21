import 'package:flutter/material.dart';
import 'dart:math';

class Game {
  final Color hiddenCard = Colors.red;
  List<Color>? gameColors;
  List<String>? gameImg;
  List<Color> cards = [
    Colors.green,
    Colors.yellow,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.blue,
  ];
  final String hiddenCardpath = "assets/images/hidden.png";
  List<String> cards_list = [
    "images/apple.png",
    "images/banana.png",
    "images/apple.png",
    "images/grapes.png",
    "images/Mango.png",
    "images/banana.png",
    "images/Mango.png",
    "images/grapes.png",
  ];
  final int cardCount = 8;
  List<Map<int, String>> matchCheck = [];

  //methods
  void initGame() {
    gameColors = List.generate(cardCount, (index) => hiddenCard);
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
    shuffleCards();
  }

  void shuffleCards() {
    cards_list.shuffle(Random());
  }
}
