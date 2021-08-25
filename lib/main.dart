import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

final appTheme = ThemeData(
  primarySwatch: Colors.red,
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List<bool> selected = [true, false, false, false, false];

class _MyAppState extends State<MyApp> {
  List<IconData> icon = [
    Feather.user,
    Feather.folder,
    Feather.monitor,
    Feather.lock,
    Feather.mail,
  ];

  void select(int n) {
    for (int i = 0; i < 5; i++) {
      if (i == n) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenInfo=MediaQuery.of(context);
    final double screenHeight=screenInfo.size.height;
    final double screenWidth=screenInfo.size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(bottom: screenHeight*0.10,left: screenWidth*0.005,right: screenWidth*0.005,top: screenHeight*0.12),
            height: screenHeight*0.70,
            width: 75.0,
            decoration: BoxDecoration(
              color: Color(0xff332A7C),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: screenHeight*0.09,
                  child: Column(
                    children: icon
                        .map(
                          (e) => NavBarItem(
                            icon: e,
                            selected: selected[icon.indexOf(e)],
                            onTap: () {
                              setState(() {
                                select(icon.indexOf(e));
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final Function onTap;
  final bool selected;
  NavBarItem({
    required this.icon,
    required this.onTap,
    required this.selected,
  });
  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  late Animation<double> _anim1;
  late Animation<double> _anim2;
  late Animation<double> _anim3;
  late Animation<Color?> _color;

  bool hovered = false;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 225),
    );

    _anim1 = Tween(begin: 101.0, end: 60.0).animate(_controller1);
    _anim2 = Tween(begin: 101.0, end: 10.0).animate(_controller2);
    _anim3 = Tween(begin: 101.0, end: 35.0).animate(_controller2);
    _color = ColorTween(end: Color(0xff332a7c),begin: Colors.white).animate(_controller2);

    

    _controller1.addListener(() {
      setState(() {});
    });
    _controller2.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.selected) {
      Future.delayed(Duration(milliseconds: 10), () {
        //_controller1.reverse();
      });
      _controller1.reverse();
      _controller2.reverse();
    } else {
      _controller1.forward();
      _controller2.forward();
      Future.delayed(Duration(milliseconds: 10), () {
        //_controller2.forward();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: MouseRegion(
        onEnter: (value) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (value) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width*0.5,
          color: hovered && !widget.selected ? Colors.white12 : Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  child: CustomPaint(
                    painter: CurvePainter(
                      value1: 0,
                      animValue1: _anim3.value,
                      animValue2: _anim2.value,
                      animValue3: _anim1.value,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                width: 75 ,
                child: Center(
                  child: Icon(
                    widget.icon,
                    color:  _color.value,
                    size: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value1; // 200
  final double animValue1; // static value1 = 50.0
  final double animValue2; //static value1 = 75.0
  final double animValue3; //static value1 = 75.0

  CurvePainter({
    required this.value1,
    required this.animValue1,
    required this.animValue2,
    required this.animValue3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.moveTo(101, value1);
    path.quadraticBezierTo(101, value1 + 20, animValue3,
        value1 + 20); // have to use animValue3 for x2
    path.lineTo(animValue1, value1 + 20); // have to use animValue1 for x
    path.quadraticBezierTo(animValue2, value1 + 20, animValue2,
        value1 + 40); // animValue2 = 25 // have to use animValue2 for both x
    path.lineTo(101, value1 + 40);
    // path.quadraticBezierTo(25, value1 + 60, 50, value1 + 60);
    // path.lineTo(75, value1 + 60);
    // path.quadraticBezierTo(101, value1 + 60, 101, value1 + 80);
    path.close();

    path.moveTo(101, value1 + 80);
    path.quadraticBezierTo(101, value1 + 60, animValue3, value1 + 60);
    path.lineTo(animValue1, value1 + 60);
    path.quadraticBezierTo(animValue2, value1 + 60, animValue2, value1 + 40);
    path.lineTo(101, value1 + 40);
    path.close();

    paint.color = Colors.white;
    paint.strokeWidth = 101.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}