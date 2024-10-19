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
  final ScrollController scrollController=ScrollController();
  late final ChatSession chatSession;
bool loading=false;
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
                Expanded(child: TextField(autofocus: true,focusNode: focusNode,decoration: inputDecoration(),controller:textEditingController ,onSubmitted: sendChatMessage,)),
                const SizedBox(height: 15,),
              ],
            ),
          )
        ],
      )
    );
  }
  InputDecoration inputDecoration (){
    return InputDecoration(
      contentPadding: EdgeInsets.all(15),
      hintText: "Enter a prompt ...",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),

      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary
        )
      ),

    );
  }
  Future<void>sendChatMessage(String message)async{
    setState(() {
      loading=true;

    });
try{
  final response=await chatSession.sendMessage(Content.text(message));
  final text=response.text;
  if(text==null){
    showError('No response from ApI.');
    return ;
  }else{
    setState(() {
       loading=false;
       scrollDown();
    });
  }
}catch(e){
  showError(e.toString());
  setState(() {
    loading=false;
  });
}finally{
  textEditingController.clear();
  setState(() {
    loading=false;
    focusNode.requestFocus();
  });
}
  }
  void scrollDown(){
    WidgetsBinding.instance.addPostFrameCallback((_) =>scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 750), curve: Curves.easeOutCirc));
  }
void showError(String message){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Something went wrong"),
        content: SingleChildScrollView(
          child: SelectableText(message),

        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("OK"))
        ],
      );
    });
}
}
