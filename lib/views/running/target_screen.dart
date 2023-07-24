import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthcare/components/running_target_card.dart';
import 'package:healthcare/view-models/target_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/submit_button.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({Key? key}) : super(key: key);

  void deleteRunningTarget(index, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete this target ?'),
        content: const Text('The target will be removed permanently'),
        actions: <Widget>[
          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TargetViewModel>().deleteRunningTarget(index);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void openDatePicker(DateTime date, String type, BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: date,
            firstDate: date,
            lastDate: DateTime(2100))
        .then((value) {
      if (value != null && value != date) {
        context.read<TargetViewModel>().updateDate(value, type);
      }
    });
  }

  void openTargetDialog(BuildContext context) {
    final targetViewModel = context.read<TargetViewModel>();
    targetViewModel.getRunningTarget(targetViewModel.targets.length);
    final distanceController = TextEditingController(
        text: targetViewModel.target.targetDistance.toString());
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final targetViewModel = context.watch<TargetViewModel>();
        return Dialog(
          child: Container(
            height: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text("Target distance:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: TextField(
                      controller: distanceController,
                      onChanged: (value) {
                        targetViewModel.updateDistance(value.toString());
                      },
                      textAlign: TextAlign.center,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,1}'))
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text("km",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 30),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Start date",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: DateFormat('dd/MM/yyyy').format(
                                        targetViewModel.target.startDate)),
                                onTap: () {
                                  openDatePicker(
                                      targetViewModel.target.startDate,
                                      'start',
                                      context);
                                },
                              ),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("End date",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: DateFormat('dd/MM/yyyy').format(
                                        targetViewModel.target.endDate)),
                                onTap: () {
                                  openDatePicker(targetViewModel.target.endDate,
                                      'end', context);
                                },
                              ),
                            )
                          ])
                    ]),
                const SizedBox(height: 30),
                Align(
                    alignment: Alignment.center,
                    child: SubmitButton(
                        text: 'Save new target',
                        onPressed: !targetViewModel.isEnabled
                            ? null
                            : () {
                                targetViewModel.updateRunningTarget();
                                Navigator.pop(context);
                              })),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Targets"),
      ),
      body:
          Consumer<TargetViewModel>(builder: (context, targetViewModel, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(children: [
                const SizedBox(width: 20),
                const Text('In Progress',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    openTargetDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Colors.blueGrey, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              ]),
              targetViewModel.progress == 0
                  ? Container(
                      margin: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                          child: Text(
                              "There are currently no targets in progress",
                              style: TextStyle(color: Colors.grey))))
                  : ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: targetViewModel.targets.length,
                      itemBuilder: (context, index) {
                        if (targetViewModel.targets[index].status ==
                            'progress') {
                          return RunningTargetCard(
                              index: index, deleteAction: deleteRunningTarget);
                        }
                        return const SizedBox();
                      },
                    ),
              const SizedBox(height: 20),
              Row(children: [
                const SizedBox(width: 20),
                const Text('Finished',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                const SizedBox(width: 20),
                // GestureDetector(
                //   onTap: () {},
                //   child: Container(
                //     padding: const EdgeInsets.all(3),
                //     decoration: const BoxDecoration(
                //         color: Colors.blueGrey, shape: BoxShape.circle),
                //     child: const Icon(Icons.add, color: Colors.white),
                //   ),
                // )
              ]),
              targetViewModel.progress == targetViewModel.targets.length
                  ? Container(
                      margin: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                          child: Text("There are currently no finished targets",
                              style: TextStyle(color: Colors.grey))))
                  : ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      reverse: true,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: targetViewModel.targets.length,
                      itemBuilder: (context, index) {
                        if (targetViewModel.targets[index].status ==
                            'finished') {
                          return RunningTargetCard(
                              index: index, deleteAction: deleteRunningTarget);
                        }
                        return const SizedBox();
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }
}
