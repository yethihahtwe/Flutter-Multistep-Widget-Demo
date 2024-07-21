import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        // remove debug banner
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}

// home widget
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // initial step value
  int currentStep = 0;

  // set default completed state
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-step Form Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isCompleted
          ? buildCompletedWidget()
          : Theme(
              // theme color of the stepper
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(primary: Colors.blueAccent)),
              child: Stepper(
                steps: formSteps(),
                currentStep: currentStep,
                // what happens on continue button
                onStepContinue: () {
                  // let the stepper know whether the last step
                  final lastStep = currentStep == formSteps().length - 1;
                  if (lastStep) {
                    // completed is set to true
                    setState(() {
                      isCompleted = true;
                    });
                    // save the data to database
                  } else {
                    setState(() {
                      currentStep += 1;
                    });
                  }
                },
                // what happens on cancel button
                onStepCancel: currentStep == 0
                    ? null
                    : () {
                        setState(() {
                          currentStep -= 1;
                        });
                      },
                // what happens when the user taps each step
                onStepTapped: (value) {
                  setState(() {
                    currentStep = value;
                  });
                },
                // customize buttons
                controlsBuilder: (context, details) {
                  bool lastStep = currentStep == formSteps().length - 1;
                  return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: Text(lastStep ? 'Complete' : 'Next'),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // make the cancel button disapper on first step
                          if (currentStep != 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: Text('Back'),
                              ),
                            ),
                        ],
                      ));
                },
              ),
            ),
    );
  }

  List<Step> formSteps() {
    return [
      Step(
        // switch step icon
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        // tell the stepper current step value
        isActive: currentStep >= 0,
        title: Text('Step-1'),
        content: TextFormField(),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: Text('Step-2'),
        content: TextFormField(),
      ),
      Step(
        isActive: currentStep >= 2,
        title: Text('Step-3'),
        content: TextFormField(),
      ),
    ];
  }

  Widget buildCompletedWidget() {
    return Center(
        child: Container(
      margin: EdgeInsetsDirectional.all(20),
      child: Column(
        children: [
          Icon(Icons.check),
          Text('Your data entry is completed!'),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  // back to the first step
                  currentStep = 0;

                  // back to the stepper and the form
                  isCompleted = false;
                });
              },
              child: Text('Enter new record'))
        ],
      ),
    ));
  }
}
