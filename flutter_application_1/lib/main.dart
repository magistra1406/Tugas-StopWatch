import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatelessWidget {
  const TimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late TextEditingController _controller;
  double _seconds = 0;
  double _durationInMinutes = 0;
  bool _isActive = false;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _seconds = _durationInMinutes * 60;
      _isActive = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          _isActive = false;
        }
      });
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isActive = false;
      _remainingSeconds = _seconds.toInt();
    });
  }

  void _resumeTimer() {
    setState(() {
      _isActive = true;
      _seconds = _remainingSeconds.toDouble();
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _timer.cancel();
          _isActive = false;
        }
      });
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _seconds = 0;
      _isActive = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'StopWatch',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 143, 80, 80),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ), // Adjust border radius as needed
              ),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: AssetImage('image/back.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _seconds > 0
                            ? '${(_seconds ~/ 60).toInt()} m : ${(_seconds % 60).toInt()} s'
                            : _isActive
                                ? 'Time\'s Up!'
                                : 'StopWatch',
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          color: _seconds > 0
                              ? Color.fromARGB(255, 255, 236, 236)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Minutes',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white), // Border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Colors.white), // Border color when focused
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white), // Set text color to white
                        onChanged: (value) {
                          setState(() {
                            _durationInMinutes = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (_isActive) {
                                _pauseTimer();
                              } else if (_seconds == 0) {
                                _startTimer();
                              } else {
                                _resumeTimer();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isActive
                                  ? Color.fromARGB(255, 219, 225, 255)
                                  : const Color.fromARGB(255, 255, 255, 255),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                            ),
                            child: Text(_isActive
                                ? 'Pause'
                                : _seconds == 0
                                    ? 'Start'
                                    : 'Resume'),
                          ),
                          ElevatedButton(
                            onPressed: _resetTimer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                            ),
                            child: Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color.fromARGB(255, 180, 180, 180).withOpacity(0.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Moh Magistra Jahfal 222410102048',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      // Add additional content here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
