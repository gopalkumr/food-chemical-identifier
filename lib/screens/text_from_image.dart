import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/providers/gemini_provider.dart';
import 'package:flutter_gemini/providers/media_provider.dart';
import 'package:provider/provider.dart';

class TextFromImage extends StatelessWidget {
  const TextFromImage({super.key});

  static final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final geminiProvider = Provider.of<GeminiProvider>(context);
    final mediaProvider = Provider.of<MediaProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        mediaProvider.reset();
        geminiProvider.reset();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload your image✨'),
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  mediaProvider.bytes == null
                      ? IconButton(
                          onPressed: () {
                            mediaProvider.setImage();
                          },
                          icon: const Icon(CupertinoIcons.photo_on_rectangle),
                          iconSize: 40,
                          tooltip: 'Add from album',
                        )
                      : Image.memory(
                          mediaProvider.bytes!,
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(height: 16),
                  IconButton(
                    onPressed: () {
                      mediaProvider.setImageFromCamera();
                    },
                    icon: const Icon(CupertinoIcons.camera),
                    iconSize: 40,
                    tooltip: 'Take a photo',
                  ),

                  /*
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your prompt here...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  */

                  const SizedBox(height: 16),
                  if (mediaProvider.bytes != null)
                    ElevatedButton(
                      onPressed: () {
                        geminiProvider.generateContentFromImage(
                          //  prompt: _textController.text,
                          prompt:
                              'give me insight about this food, the harmful chemical used in this food, the dieseas can cause if we consume excessively, the alternative we can use to make the food all in detailed with bullet point',
                          bytes: mediaProvider.bytes!,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Generate'),
                    ),
                  const SizedBox(height: 16),
                  geminiProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(geminiProvider.response ?? ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
