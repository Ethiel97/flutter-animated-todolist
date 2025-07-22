import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_app/count_up.dart';
import 'package:flutter_app/health_summary.dart';

import 'task_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const minimumDragSize = 0.43;
const maximumDragSize = 1.0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: ThemeMode.light,
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  _HomeScreenState();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  final DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  var headerMainDarkColor = Colors.white;

  var headerSecondaryDarkColor = Colors.white70;

  var headerMainLightColor = Colors.black;
  var headerSecondaryLightColor = Colors.black54;

  double dragHandleVerticalOffset = 12;

  bool shouldShowDragHandle = true;

  var draggableSheetSize = minimumDragSize;

  var statusBarBrightness = Brightness.dark;

  bool isExpanded = false;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: statusBarBrightness,
      ),
    );

    _draggableScrollableController.addListener(() {
      draggableSheetSize = _draggableScrollableController.size;
      if (_draggableScrollableController.size >= .8) {
        setState(() {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
          );

          headerMainDarkColor = Colors.black;
          headerSecondaryDarkColor = Colors.black54;
          dragHandleVerticalOffset = 50;

          shouldShowDragHandle = false;

          if (_draggableScrollableController.size >= .95) {
            if (!isExpanded) {
              isExpanded = true;
            }
          }
        });
      } else if (_draggableScrollableController.size < .85) {
        setState(() {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
            ),
          );

          headerMainDarkColor = Colors.white;
          headerSecondaryDarkColor = Colors.white70;
          dragHandleVerticalOffset = 6;

          shouldShowDragHandle = true;
        });

        if (_draggableScrollableController.size <= minimumDragSize) {
          setState(() {
            if (isExpanded) {
              isExpanded = false;
            }
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0.0,
                end: /*(minimumDragSize * 1.2 < draggableSheetSize &&
                        draggableSheetSize < maximumDragSize)
                    ? 10.0
                    : 0.0,*/
                    draggableSheetSize > minimumDragSize * 1.5 ? 10.0 : 0.0,
              ),
              duration: .35.seconds,
              curve: Curves.linearToEaseOut,
              builder: (context, sigma, child) => ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: sigma,
                  sigmaY: sigma,
                ),
                child: child,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TasksSummary(
                    taskCount: 3,
                    meetingCount: 2,
                    habitCount: 1,
                    shouldAnimate:
                        isExpanded && draggableSheetSize >= minimumDragSize,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: const HealthSummary(),
                  ),
                ],
              ),
            ),
            DraggableScrollableSheet(
              snap: true,
              controller: _draggableScrollableController,
              initialChildSize: minimumDragSize,
              minChildSize: minimumDragSize,
              maxChildSize: maximumDragSize,
              builder: (context, scrollController) => Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: AnimatedList(
                      physics: BouncingScrollPhysics(),
                      key: _listKey,
                      controller: scrollController,
                      initialItemCount: tasks.length + 1,
                      itemBuilder: (context, index, animation) {
                        if (index == 0) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: _DragHandle(
                              verticalOffset: dragHandleVerticalOffset,
                              isVisible: shouldShowDragHandle,
                            ),
                          );
                        }
                        return SizeTransition(
                          sizeFactor: animation,
                          child: tasks[index - 1],
                        );
                      },
                    ),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linearToEaseOut,
                    right: MediaQuery.of(context).size.width / 3,
                    bottom: shouldShowDragHandle ? -200 : 24,
                    left: MediaQuery.of(context).size.width / 3,
                    child: FloatingActionButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: Color(0xffe9e9e9),
                      elevation: 0,
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _TopHeader(
              headerMainColor: headerMainDarkColor,
              headerSecondaryColor: headerSecondaryDarkColor,
            ),
          ],
        ),
      );
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.headerMainColor,
    required this.headerSecondaryColor,
  });

  final Color headerMainColor;
  final Color headerSecondaryColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 60.0, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  curve: Curves.linearToEaseOut,
                  duration: Duration(milliseconds: 300),
                  style: TextStyle(
                    color: headerMainColor,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                  child: const Text("09"),
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                ),
                Spacer(),
                AnimatedDefaultTextStyle(
                  curve: Curves.linearToEaseOut,
                  style: TextStyle(
                    color: headerSecondaryColor,
                    fontSize: 20,
                  ),
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  child: Text.rich(
                    textAlign: TextAlign.end,
                    TextSpan(
                      text: "Sep' 30\n",
                      children: [
                        TextSpan(
                          text: "Tuesday",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _TasksSummary extends StatelessWidget {
  const _TasksSummary({
    required this.taskCount,
    required this.meetingCount,
    required this.habitCount,
    this.shouldAnimate = false,
  });

  final double taskCount;
  final double meetingCount;
  final double habitCount;
  final bool shouldAnimate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32.0,
        right: 32.0,
        top: 200.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Good morning,",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Image.asset(
                'assets/img/ethiel.png',
                width: 28,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Ethiel.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text.rich(
            TextSpan(
              text: "You have ",
              style: TextStyle(
                color: Colors.white60,
                height: 36 / 20,
                fontSize: 24,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: CountUpText(
                    emoji: "📅",
                    value: meetingCount,
                    label: "meetings",
                    shouldAnimate: shouldAnimate,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: CountUpText(
                    emoji: "✅",
                    value: taskCount,
                    label: "tasks ",
                    shouldAnimate: shouldAnimate,
                  ),
                ),
                TextSpan(
                  text: "and ",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 24,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.top,
                  child: CountUpText(
                    emoji: "🥋",
                    value: habitCount,
                    label: "habits ",
                    shouldAnimate: shouldAnimate,
                  ),
                ),
                TextSpan(
                  text: "today. You're ",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 24,
                  ),
                ),
                TextSpan(
                  text: "mostly free ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "after 4PM.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({
    required this.verticalOffset,
    required this.isVisible,
  });

  final double verticalOffset;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        curve: Curves.linearToEaseOut,
        duration: Duration(milliseconds: 400),
        margin: EdgeInsets.symmetric(
          vertical: verticalOffset,
        ),
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: isVisible ? Colors.grey.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
