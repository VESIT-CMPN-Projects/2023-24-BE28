import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  // Initialize Firebase
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Save feedback to Firestore
  Future<void> _submitFeedback() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String feedback = _feedbackController.text;

    // Validate input
    if (name.isEmpty || feedback.isEmpty || email.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation Error'),
            content: const Text('Please enter your name , Email and feedback.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Save feedback to Firestore
    final CollectionReference feedbacks =
    FirebaseFirestore.instance.collection('feedbacks');
    await feedbacks.add({
      'name': name,
      'email': email,
      'feedback': feedback,
      'timestamp': DateTime.now(),
    });

    // Show success message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Thank you for your feedback!\nWe will get in touch with you soon'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // Clear input fields
    _nameController.clear();
    _emailController.clear();
    _feedbackController.clear();
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
      Color(0xFFB7F6B9),
      Color(0xFFFDFDFD),
      ],
      ),
      ),
      child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(

            ),
            // App logo and name
            Image.asset('images/agriguru_logo.png',
              fit: BoxFit.fitWidth,
              height: 120 , width: 300,),

            const SizedBox(height: 16),

            // Feedback form
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Feedback',
              ),
              maxLines: 5,
            ),

            const SizedBox(height: 16),

            // Submit button
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Developed by: Agriguru Tech ltd',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Email: agriguru@gmail.com',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Contact No: +91 7756894208',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      );

  }
}