import 'package:flutter/material.dart';

class MyStepperWidget extends StatefulWidget {
  const MyStepperWidget({Key? key}) : super(key: key);

  @override
  State<MyStepperWidget> createState() => _MyStepperWidgetState();
}

class _MyStepperWidgetState extends State<MyStepperWidget> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Stepper Widget'),
        ),
        body: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.deepPurple,
              ),
            ),
            child: Stepper(
              // type: StepperType.horizontal,
              currentStep: currentStep,
              onStepTapped: (index) {
                setState(() => currentStep = index);
              },
              onStepContinue: () {
                if (currentStep != 2) {
                  setState(() => currentStep++);
                }
              },
              onStepCancel: () {
                if (currentStep != 0) {
                  setState(() => currentStep--);
                }
              },
              steps: [
                Step(
                    isActive: currentStep >= 0,
                    title: Text('Step 1'),
                    content: Text('Content for Step 1')),
                Step(
                    isActive: currentStep >= 1,
                    title: Text('Step 2'),
                    content: Text('Content for Step 2')),
                Step(
                    isActive: currentStep >= 2,
                    title: Text('Step 3'),
                    content: Text('Content for Step 3')),
              ],
            ),
          ),
        ),
      );
}
