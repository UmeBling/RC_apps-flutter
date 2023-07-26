import 'dart:math';
import 'package:flutter/material.dart';

class Joypad extends StatefulWidget {
  final void Function(Offset) onChange;
  const Joypad({super.key, required this.onChange});

  @override
  State<Joypad> createState() => _JoypadState();
}

class _JoypadState extends State<Joypad> {
  Offset delta = Offset.zero;

  void updateDelta(Offset newDelta) {
    widget.onChange(newDelta);
    setState(() {
      delta = newDelta;
    });
  }

  void calculateDelta(Offset offset) {
    Offset newDelta = offset - const Offset(60, 60);
    updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(30, newDelta.distance),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
        ),
        child: GestureDetector(
          onPanDown: onDragDown,
          onPanUpdate: onDragUpdate,
          onPanEnd: onDragEnd,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x88ffffff),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Transform.translate(
                offset: delta,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xccffffff),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDragDown(DragDownDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragUpdate(DragUpdateDetails d) {
    calculateDelta(d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    updateDelta(Offset.zero);
  }
}
