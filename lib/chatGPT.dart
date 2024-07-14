import 'dart:convert';

import 'package:chatbot/API%20Key.dart';
import 'package:chatbot/ChatGPTKey.dart';
import 'package:chatbot/GroqKey.dart';
import 'package:http/http.dart' as http;

class Chatgpt{
  Future<String> getResponse(String message) async{
    final List<Map<String, String>> messages = [];
    messages.add({
      "role": "user",
      "content": message,
    });
    try{
      final response = await http.post(Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $GroqAPIKey',
        },
        body: jsonEncode({
          "model": "llama3-8b-8192",
          "messages": messages,
        })
      );

      if (response.statusCode == 200){
        print("RESPONSE GENERATED SUCCESFULLY\n");
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          "role": "assistant",
          "content": content,
        });

        return content;
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e){
      return e.toString();
    }

  }

}