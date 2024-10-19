import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GenerativeModel generativeModel;
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
      body: SizedBox(),
    );
  }
}
