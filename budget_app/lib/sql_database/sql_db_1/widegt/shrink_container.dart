import 'package:flutter/material.dart';

class ContainerRotationAnimation extends StatefulWidget {
  @override
  _ContainerRotationAnimationState createState() =>
      _ContainerRotationAnimationState();
}

class _ContainerRotationAnimationState
    extends State<ContainerRotationAnimation> {
  double _containerSize = 200.0;
  double _containerRotation = 0.0;

  void _toggleRotation() {
    setState(() {
      _containerRotation = _containerRotation == 0.0
          ? 0.5
          : (_containerRotation == 0.5 ? -0.5 : 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Container Rotation Animation'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleRotation,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: _containerSize,
            width: _containerSize,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20.0),
            ),
            transform: Matrix4.rotationZ(_containerRotation * 3.14),
            alignment: Alignment.center,
            child: Center(
              child: Text(
                'Tap to rotate',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
