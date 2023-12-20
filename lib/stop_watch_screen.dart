import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  Timer? _timer;

  int _time = 0; // 경과 시간을 저장하는 변수
  bool _isRunning = false; // 스톱워치가 동작 중인지 나타내는 변수

  final List<String> _lapTimes = []; // 랩 타임을 저장하는 리스트

  void _clickButton() {
    _isRunning = !_isRunning;

    if (_isRunning) {
      _start(); // 스톱워치 시작
    } else {
      _pause(); // 스톱워치 일시 정지
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++; // 0.01초마다 경과 시간 1 증가
      });
    });
  }

  void _pause() {
    _timer?.cancel(); // 타이머 취소
  }

  void _reset() {
    _isRunning = false;
    _timer?.cancel();
    _lapTimes.clear(); // 랩 타임 초기화
    _time = 0; // 경과 시간 초기화
  }

  void _recordLapTime(String time) {
    _lapTimes.insert(0, '${_lapTimes.length + 1}등 $time'); // 랩 타임 리스트에 추가
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int sec = _time ~/ 100; // 초 단위 계산
    String hundredth = '${_time % 100}'.padLeft(2, '0'); // 1/100초 단위 계산

    return Scaffold(
      appBar: AppBar(
        title: const Text('스톱워치'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sec', // 초 단위 출력
                style: const TextStyle(fontSize: 50),
              ),
              Text(
                hundredth, // 1/100초 단위 출력
              ),
            ],
          ),
          SizedBox(
            width: 100,
            height: 200,
            child: ListView(
              children: _lapTimes
                  .map((time) => Center(child: Text(time)))
                  .toList(), // 랩 타임 리스트를 출력
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  setState(() {
                    _reset(); // 스톱워치 초기화
                  });
                },
                child: const Icon(Icons.refresh),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _clickButton(); // 스톱워치 시작 또는 일시 정지
                  });
                },
                child: _isRunning
                    ? const Icon(Icons.pause) // 스톱워치가 동작 중이면 일시 정지 아이콘 출력
                    : const Icon(Icons.play_arrow), // 스톱워치가 일시 정지 상태면 시작 아이콘 출력
              ),
              FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: () {
                  setState(() {
                    print('$sec.$hundredth');
                    _recordLapTime('$sec.$hundredth'); // 현재 경과 시간을 랩 타임에 추가
                  });
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
