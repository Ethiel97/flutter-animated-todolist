import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CountUpText extends StatelessWidget {
  final String emoji;
  final double value;
  final String label;

  final bool shouldAnimate;

  const CountUpText({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    this.shouldAnimate = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseValueText = Text(
      softWrap: true,
      "${value.round()}",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          emoji,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        SizedBox(
          height: 23,
          child: shouldAnimate
              ? Animate(
                  onPlay: (controller) {
                    controller.reset();
                    controller.forward(from: 0);
                  },
                )
                  .custom(
                    delay: .35.seconds,
                    curve: Curves.easeInToLinear,
                    duration: 1.2.seconds,
                    begin: 0,
                    end: value,
                    builder: (_, value, __) => Text(
                      softWrap: true,
                      "${value.round()}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                  .fadeIn()
                  .slideY(begin: -.5)
                  .swap(
                    builder: (context, widget) => Text(
                      softWrap: true,
                      "${value.round()}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
              : baseValueText,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
