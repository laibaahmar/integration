import 'package:flutter/material.dart';
import 'package:pet/constants/colors.dart';
import 'package:pet/features/home/care%20screen/illness_and_injuries/illness_and_injuries.dart';
import 'package:pet/features/home/care%20screen/vaccination/vaccinescreen.dart';

import '../../../constants/images.dart';

class ConsultSection extends StatelessWidget {
  const ConsultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        children: [
          // First Card for Consultation
          ConsultCard(
            imagePath: doctor, // Replace with your image path
            title: 'Want an \nappointment',
            buttonText: 'Consult',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VaccinationScreen())),
          ),

          const SizedBox(width: 10), // Space between cards

          // Second Card for Emergency Booking
          ConsultCard(
            imagePath: ambulance, // Replace with your image path
            title: 'Emergency Booking',
            buttonText: 'Book now',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IllnessAndInjuries())),
          ),
        ],
      ),
    );
  }
}

class ConsultCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String buttonText;
  final VoidCallback onTap;

  const ConsultCard({super.key, 
    required this.imagePath,
    required this.title,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: logoPurple,
        borderRadius: BorderRadius.circular(12.0),
      ),
      width: MediaQuery.of(context).size.width * 0.8, // Adjust width to 80% of screen for better scroll experience
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Image.asset(
              imagePath,
              height: 100, // Image size
              width: 100,
            ),
          ),
          const SizedBox(width: 20), // Space between image and text column
          Flexible(
            flex: 3, // Allows text column to expand
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, // Text size
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                // Button
                OutlinedButton(
                  onPressed: onTap,
                  child: SizedBox(width: double.infinity, child: Center(child: Text(buttonText))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
