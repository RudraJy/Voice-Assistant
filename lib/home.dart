import 'package:chatbot/chatGPT.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  Map data = {};
  FlutterTts flutterTts = FlutterTts();
  final Chatgpt chatgpt = Chatgpt();
  String? _response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
    _initTextToSpeech();
  }

  Future<void> _initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  /// This has to happen only once per app
  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      appBar: AppBar(
        title: Text(
          'My Voice Assistant',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
            Icons.menu,
            color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),

      body: SingleChildScrollView(
        child: Column(
          children : [
            //chatbot image
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    backgroundImage: AssetImage('assets/images/chatbot.png'),
                    radius: 55,
                  ),
                ),
              ),
        
            //chatbot welcome message
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                _response == null ? 'Hey there! How can I help you today?' : _response!,
                style: TextStyle(
                  fontSize: _response == null ? 20 : 18,
                  fontFamily: 'RobotoCondensed',
                  color: Colors.black,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        
            //divider
            Container(
              margin: EdgeInsets.symmetric(vertical: 20), // Adjust vertical margin as needed
              child: Divider(
                color: Colors.grey, // Change the color to suit your design
                thickness: 2, // Adjust thickness as needed
              ),
            ),
        
            //message recommendations
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(150, 0, 0, 20),
              child: Text(
                'Here are some things you can ask me:',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'IndieFlower',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
        
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'What are the coordinates of Delhi?',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
        
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    'Give me a random fun fact about space and the planets.',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
        
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    "Translate the sentence \'Good Morning! How are you?'\ into French, German, and Italian.",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
        
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Text(
                    "What are some major attractions in Berlin, Germany?",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RobotoCondensed',
                      color: Colors.black,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
        
          ],
        ),
      ),

      //mic button
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if (await _speechToText.hasPermission && _speechToText.isNotListening) {
            await _startListening();
          }
            else if (_speechToText.isListening) {
              final resp = await chatgpt.getResponse(_lastWords);
              print(resp);
              print('\n');
              _response = resp;
              setState(() {});
              await _speak(resp);
              await _stopListening();
          } else {
            print('Permission not granted');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Speech recognition permission not granted.'),
              ),
            );
          }
        },
        child: Icon(
          Icons.mic,
        ),
        backgroundColor: Colors.blue[200],
      ),
    );
  }
}