import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
class Statistics extends StatelessWidget {
  const Statistics({
    super.key,
    required this.createdTasks,
    required this.completedTasks,
    required this.precent,
  });
  final double createdTasks;
  final double completedTasks;
  final double precent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TaskCompleted',
                    style: TextStyle(
                      fontFamily: 'UbuntuB',
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      '$completedTasks/${createdTasks+completedTasks} ${'completed'}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                      DateFormat('yyyy-MM-dd h:mm a')
                      .format(DateTime.now()),
                    style: TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                animationEnabled: true,
                angleRange: 360,
                startAngle: 270,
                size: 70,
                infoProperties: InfoProperties(
                  modifier: (percentage) {
                    return createdTasks != 0 ? '${precent.toStringAsFixed(0)}%' : '0%';
                  },
                  mainLabelStyle:
                  TextStyle(fontSize: 18),
                ),
                customColors: CustomSliderColors(
                  progressBarColors: <Color>[
                    Colors.blueAccent,
                    Colors.greenAccent,
                  ],
                  trackColor: Colors.grey.shade300,
                ),
                customWidths: CustomSliderWidths(
                  progressBarWidth: 7,
                  trackWidth: 3,
                  handlerSize: 0,
                  shadowWidth: 0,
                ),
              ),
              min: 0,
              max: (createdTasks+completedTasks) != 0 ? (createdTasks+completedTasks).toDouble() : 1,
              initialValue: completedTasks.toDouble(),
            ),
          ],
        ),
      ),
    );
  }
}