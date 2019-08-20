//Can probably look at this https://stackoverflow.com/questions/55493003/using-gcloud-speech-api-for-real-time-speech-recognition-in-dart-flutter
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";
  String stateText = "";
  String tempText = "";

  bool completed = false;

  Container textContainer;

  @override
  void initState() {
    super.initState();
    initSpeedRecognizer();
  }

  void initSpeedRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
        (bool result) => setState(() => _isAvailable = true));

    _speechRecognition.setRecognitionStartedHandler(
        () => setState(() => {_isListening = true, stateText = "isListening"}));

    _speechRecognition.setRecognitionResultHandler(
        (String speech) => setState(() => resultText = speech));

    _speechRecognition.setRecognitionCompleteHandler(() => setState(() => {
          if (completed == false)
            {
              _isListening = false,
              _isAvailable = true,
              stateText = "isNotListening",
              tempText = resultText + "\n\n" + tempText,
              completed = true
            }
        }));

    _speechRecognition
        .activate()
        .then((result) => setState(() => _isAvailable = result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          //padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
                  alignment: AlignmentDirectional.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Text(stateText,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black.withOpacity(0.05)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FloatingActionButton(
                    child: Icon(Icons.cancel),
                    mini: true,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      if (_isListening)
                        _speechRecognition
                            .cancel()
                            .then((result) => setState(() {
                                  _isListening = result;
                                  resultText = "";
                                  stateText = result.toString();
                                }))
                            .catchError((onError) => setState(
                                () => {resultText = "", stateText = onError}));
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.mic),
                    backgroundColor: Colors.pink,
                    onPressed: () {
                      if (_isAvailable && !_isListening) {
                        completed = false;
                        _speechRecognition.listen(locale: "en_US").then(
                            (result) => {
                                  print('$result'),
                                  setState(() => stateText = result.toString())
                                });
                      }
                    },
                  ),
                  FloatingActionButton(
                    child: Icon(Icons.stop),
                    mini: true,
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      if (_isListening)
                        _speechRecognition
                            .stop()
                            .then((result) => setState(() => {
                                  _isListening = result,
                                  stateText = result.toString()
                                }))
                            .catchError((onError) => setState(() => {
                                  //resultText = "",
                                  stateText = onError
                                }));
                      else {
                        resultText = "";
                        tempText = "";
                        _isAvailable = true;
                      }
                    },
                  )
                ],
              ),
              ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 5.0,
                    minWidth: MediaQuery.of(context).size.width * 0.8,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: SingleChildScrollView(
                      //width: MediaQuery.of(context).size.width * 0.8,
                      //decoration: BoxDecoration(
                      //color: Colors.lightBlue.withOpacity(0.4),
                      //borderRadius: BorderRadius.circular(6.0)),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      //margin: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(tempText, style: TextStyle(fontSize: 24.0))))
            ],
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
