import 'package:flutter/material.dart';
import 'package:gemini_ai_app/message_widget.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GenerativeModel generativeModel;
  final FocusNode focusNode=FocusNode();
  final TextEditingController textEditingController=TextEditingController();
  late final ChatSession chatSession;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generativeModel = GenerativeModel(
        model: "gemini-pro",
        apiKey:
            String.fromEnvironment("AIzaSyBgV695z-ckb6s23P0pDebgBOzCAkmrZ2Q"));
    chatSession=generativeModel.startChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("build with gemini"),
      ),
      body:Column(
        children: [
          Expanded(child: ListView.builder(itemBuilder: (context,index){
            final  Content content=chatSession.history.toList()[index];
            final text=content.parts.whereType().map((e) => e.text).join('');
            return MessageWidget(text: text, isFromUser: content.role=="user");
          })),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
            child: Row(
              children: [
                Expanded(child: TextField(autofocus: true,focusNode: ,decoration: ,controller: ,onSubmitted: ,,)),
                const SizedBox(height: 15,),
              ],
            ),
          )
        ],
      )
    );
  }
}
