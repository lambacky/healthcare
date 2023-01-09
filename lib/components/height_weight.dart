import 'package:flutter/material.dart';

class HeightWeight extends StatefulWidget {
  final Function(int) onChange;
  final String title;
  final String unit;
  final int initValue;
  final double maxValue;

  const HeightWeight(
      {Key? key,
      required this.onChange,
      required this.title,
      required this.unit,
      required this.initValue,
      required this.maxValue})
      : super(key: key);

  @override
  State<HeightWeight> createState() => _HeightWeightState();
}

class _HeightWeightState extends State<HeightWeight> {
  int _initvalue = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initvalue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 25, color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _initvalue.toString(),
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.unit,
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  )
                ],
              ),
              Slider(
                min: 0,
                max: widget.maxValue,
                value: _initvalue.toDouble(),
                thumbColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _initvalue = value.toInt();
                  });
                  widget.onChange(_initvalue);
                },
              )
            ],
          )),
    );
  }
}
