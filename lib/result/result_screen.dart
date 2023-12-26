import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double height;
  final double weight;
  final DateTime dob;
  final String gender;

  const ResultScreen({
    required this.height,
    required this.weight,
    required this.dob,
    required this.gender,
    Key? key,
  }) : super(key: key);

  String _calcBmi(double bmi) {
    String result = '저체중';
    if (bmi >= 35) {
      result = '고도 비만';
    } else if (bmi >= 30) {
      result = '2단계 비만';
    } else if (bmi >= 25) {
      result = '1단계 비만';
    } else if (bmi >= 23) {
      result = '과체중';
    } else if (bmi >= 18.5) {
      result = '정상';
    }

    return result;
  }

  Widget _buildIcon(double bmi) {
    Icon icon = const Icon(
      Icons.sentiment_dissatisfied,
      color: Colors.green,
      size: 100,
    );
    if (bmi >= 23) {
      icon = const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.green,
        size: 100,
      );
    } else if (bmi >= 18.5) {
      icon = const Icon(
        Icons.sentiment_satisfied,
        color: Colors.green,
        size: 100,
      );
    }
    return icon;
  }

  Widget _buildGenderText() {
    String genderText = '성별: ';
    if (gender == '여성') {
      genderText += '여성';
    } else {
      genderText += '남성';
    }

    return Text(
      genderText,
      style: const TextStyle(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bmi = weight / ((height / 100) * (height / 100));
    String result = '정상';

    return Scaffold(
      appBar: AppBar(
        title: const Text('결과'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              _calcBmi(bmi),
              style: const TextStyle(fontSize: 36),
            ),
            _buildIcon(bmi),
            const SizedBox(height: 16),
            Text(
              '생년월일: ${dob.year}-${dob.month < 10 ? '0${dob.month}' : dob.month}-${dob.day < 10 ? '0${dob.day}' : dob.day}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            _buildGenderText(),
          ],
        ),
      ),
    );
  }
}
