library animatedswitcherbutton;

import 'package:flutter/material.dart';

class AnimatedSwitcherButton extends StatefulWidget {
  final String firstTab;
  final String secondTab;
  final PageController pageController;
  Color backgroundColor;
  Color buttonColor;
  Duration duration;

  AnimatedSwitcherButton({
    Key key,
    this.firstTab = "First Tab",
    this.secondTab = "Second Tab",
    this.pageController,
    this.duration, 
    this.backgroundColor, 
    this.buttonColor,
  }) : super(key: key) {
    this.duration = Duration(milliseconds: 500);
    backgroundColor = Colors.grey.withOpacity(0.5);
    buttonColor = Colors.white.withOpacity(0.8);
  }

  @override
  _AnimatedSwitcherButtonState createState() => _AnimatedSwitcherButtonState();
}

class _AnimatedSwitcherButtonState extends State<AnimatedSwitcherButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _left;
  Animation<double> _right;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    var curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _left = Tween<double>(begin: 0, end: 200).animate(curve);
    _right = Tween<double>(begin: 200, end: 0).animate(curve);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.pageController.addListener(() {
      _controller.value = widget.pageController.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.value == 0) {
          widget.pageController.animateToPage(1,duration: widget.duration, curve: Curves.ease);
          _controller.forward();
        } else {
          widget.pageController.animateToPage(0,duration: widget.duration, curve: Curves.ease);
          _controller.reverse();
        }
      },
      // onHorizontalDragUpdate: (details) {
      //   _controller.value +=
      //       details.primaryDelta / (MediaQuery.of(context).size.width / 2);
      // },
      // onHorizontalDragEnd: (details) {
      //   if (_controller.value > 0.5)
      //     _controller.forward();
      //   else
      //     _controller.reverse();
      // },
      child: Stack(
        children: <Widget>[
          Container(
            height: 60,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: widget.backgroundColor,
            ),
            child: AnimatedBuilder(
              animation: _left,
              child: Expanded(
                flex: 190,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: widget.buttonColor,
                  ),
                ),
              ),
              builder: (context, child) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      flex: _left.value.ceil(),
                      child: Container(),
                    ),
                    child,
                    Expanded(
                      flex: _right.value.ceil(),
                      child: Container(),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(height: 0),
                AnimatedBuilder(
                  animation: _left,
                  builder: (context, child) {
                    return Text(
                      widget.firstTab,
                      style: TextStyle(
                        color: (_controller.value < 0.5)
                            ? Colors.black
                            : Colors.white,
                      ),
                    );
                  },
                ),
                Container(height: 0),
                AnimatedBuilder(
                  animation: _left,
                  builder: (context, child) {
                    return Text(
                      widget.secondTab,
                      style: TextStyle(
                        color: (_controller.value < 0.5)
                            ? Colors.white
                            : Colors.black,
                      ),
                    );
                  },
                ),
                Container(height: 0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
