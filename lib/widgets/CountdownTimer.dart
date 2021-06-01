import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final ValueChanged<String> onCountDown;
  final VoidCallback onFinish;
  _CountdownTimerWidgetState _state;

  CountdownTimerWidget({this.onCountDown, this.onFinish});

  @override
  _CountdownTimerWidgetState createState() {
    _state = _CountdownTimerWidgetState();
    return _state;
  }

  void start(int timeout) {
    _state.startTimer(timeout);
  }

  void stop() {
    _state.cancelTimer();
  }
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer _timer;
  int timeInMS = 1000 * 120;
  String _countDownString = "02:00";

  void startTimer(int timeout) {
    if (_timer != null && _timer.isActive) return;

    timeInMS = timeout;
    setState(() {
      _countDownString = _prepareString(Duration(milliseconds: timeout));
    });

    _timer = Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      timeInMS -= 1000;
      if (timeInMS < 0) cancelTimer();

      Duration duration = Duration(milliseconds: timeInMS);

      var countDownString = _prepareString(duration);

      if (widget.onCountDown != null) widget.onCountDown(_countDownString);

      setState(() {
        timeInMS = timeInMS;
        _countDownString = countDownString;
      });

      if (duration.inSeconds == 0) {
        timer.cancel();
        if (widget.onFinish != null) widget.onFinish();
      }
    });
  }

  String _prepareString(Duration duration) {
    var countDownString = "";

    if (duration.inSeconds % 60 == 0) {
      countDownString = "0${duration.inMinutes}:00";
    } else {
      int seconds = duration.inSeconds % 60;
      String secondsInString = seconds.toString();
      if (seconds < 10) {
        secondsInString = "0$seconds";
      }
      countDownString = "0${duration.inMinutes}:$secondsInString";
    }

    return countDownString;
  }

  void cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _countDownString,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
