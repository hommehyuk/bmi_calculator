import 'package:bmi_calculator/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _dobController = TextEditingController();
  String _selectedGender = '남성';

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('height', double.parse(_heightController.text));
    await prefs.setDouble('weight', double.parse(_weightController.text));
    await prefs.setString('dob', _dobController.text);
    await prefs.setString('gender', _selectedGender);
  }

  Future load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double? height = prefs.getDouble('height');
    final double? weight = prefs.getDouble('weight');
    final String? dob = prefs.getString('dob');
    final String? gender = prefs.getString('gender');

    if (height != null && weight != null && dob != null && gender != null) {
      _heightController.text = '$height';
      _weightController.text = '$weight';
      _dobController.text = dob;
      _selectedGender = gender;
      print('키: $height, 몸무게: $weight, 생년월일: $dob, 성별: $gender');
    }
  }

  void clearResults() {
    _formKey.currentState?.reset();
    _heightController.clear();
    _weightController.clear();
    _dobController.clear();
    _selectedGender = '남성';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비만도 계산기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '키 (cm)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '키를 입력하세요',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '키를 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '몸무게 (kg)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '몸무게를 입력하세요',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '몸무게를 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '생년월일',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '생년월일을 입력하세요 (YYYY-MM-DD)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '생년월일을 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '성별',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    }
                  },
                  items: ['남성', '여성']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == false) {
                          return;
                        }

                        save();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              height: double.parse(_heightController.text),
                              weight: double.parse(_weightController.text),
                              dob: DateTime.parse(_dobController.text),
                              gender: _selectedGender,
                            ),
                          ),
                        );
                      },
                      child: const Text('결과 보기'),
                    ),
                    SizedBox(width: 200),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clearResults();
                        });
                      },
                      child: Text('삭제'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
