import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiChat extends StatefulWidget {
  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  List<Map<String, String>> messages = []; // Store prompt-response pairs
  TextEditingController _controller = TextEditingController(); // Controller for the TextField

  // Function to call the Gemini API
// Function to call the Gemini API with logging for response structure
// Function to call the Gemini API with the correct response parsing

// Function to clean up the AI response
  String cleanResponse(String response) {
    // Remove Markdown-like formatting characters such as '**' for bold
    return response.replaceAll(RegExp(r'\*\*|[_*]',), '').trim();
  }

// Function to call the Gemini API with the correct response parsing
  Future<void> callGeminiAPI(String prompt) async {
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyDINM_iKvnR4RzkjQ6Rde2IcUIfhLJGn4w'; // Replace with your API Key

    // The request body
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text": prompt // Prompt to be sent to the API
            }
          ]
        }
      ]
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Log the raw response body for debugging
        print('Raw Response: ${response.body}');

        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if 'candidates' exists and has content
        if (responseData.containsKey('candidates') && responseData['candidates'] is List) {
          final candidates = responseData['candidates'];
          if (candidates.isNotEmpty &&
              candidates[0].containsKey('content') &&
              candidates[0]['content'].containsKey('parts')) {
            final rawResponse = candidates[0]['content']['parts'][0]['text'] ?? 'No response';
            final aiResponse = cleanResponse(rawResponse); // Clean up the response

            setState(() {
              messages.add({'user': prompt, 'ai': aiResponse}); // Add prompt and response to the list
            });
          } else {
            setState(() {
              messages.add({'user': prompt, 'ai': 'No valid response from AI'});
            });
          }
        } else {
          setState(() {
            messages.add({'user': prompt, 'ai': 'Invalid response structure'});
          });
        }
      } else {
        setState(() {
          messages.add({'user': prompt, 'ai': 'Error: Failed with status code ${response.statusCode}'});
        });
      }
    } catch (error) {
      setState(() {
        messages.add({'user': prompt, 'ai': 'Error: $error'}); // Handle any errors
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gemini AI Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['user']!,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['ai']!,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your prompt...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final prompt = _controller.text;
                    if (prompt.isNotEmpty) {
                      callGeminiAPI(prompt); // Send the prompt to the API
                      _controller.clear(); // Clear the text field
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
