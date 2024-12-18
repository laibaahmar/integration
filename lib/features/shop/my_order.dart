import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet/common/widgets/loaders/loaders.dart';
import 'package:pet/constants/colors.dart';
import 'package:pet/utils/popups/full_screen_loader.dart';

import '../../../../constants/images.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Orders',
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: textColor,
          elevation: 1,
          bottom: const TabBar(
            labelColor: textColor,
            indicatorColor: textColor,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrdersList(status: 'Pending'),
            OrdersList(status: 'Completed'),
          ],
        ),
      ),
    );
  }
}

// class OrdersList extends StatelessWidget {
//   final String status;
//
//   const OrdersList({Key? key, required this.status}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collectionGroup('orders')
//           .where('orderBy', isEqualTo: currentUserEmail)
//           .where('status', isEqualTo: status)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Text(
//               'No $status Orders Found',
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           );
//         }
//
//         final orders = snapshot.data!.docs;
//
//         return ListView.builder(
//           itemCount: orders.length,
//           itemBuilder: (context, index) {
//             final order = orders[index];
//             final productTitle = order['title'] ?? 'Unknown';
//             final productImage = order['image'] ?? '';
//             final quantity = order['quantity'] ?? 0;
//             final totalPrice = order['total_price'] ?? 0.0;
//             final paymentMethod = order['payment_method'] ?? 'Unknown';
//
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               elevation: 2,
//               child: ListTile(
//                 leading: Container(
//                   height: 60,
//                   width: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(50),
//                     image: DecorationImage(
//                       image: NetworkImage(productImage),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 title: Text(productTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Quantity: $quantity'),
//                     Text('Total: Rs. ${totalPrice.toStringAsFixed(2)}'),
//                     Text('Payment: $paymentMethod'),
//                   ],
//                 ),
//                 trailing: status == 'Pending'
//                     ? const Icon(Icons.check_circle, color: Colors.grey)
//                     : const Icon(Icons.check_circle, color: Colors.green),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
class OrdersList extends StatelessWidget {
  final String status;

  const OrdersList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collectionGroup('orders')
          .where('orderBy', isEqualTo: currentUserEmail)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No $status Orders Found',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final productTitle = order['title'] ?? 'Unknown';
            final productImage = order['image'] ?? '';
            final quantity = order['quantity'] ?? 0;
            final totalPrice = order['total_price'] ?? 0.0;
            final paymentMethod = order['payment_method'] ?? 'Unknown';
            final productId = order['productId'] ?? 'Unknown';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  if (status == 'Completed') {
                    // Navigate to the ReviewScreen and pass order details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewScreen(productId: productId),
                      ),
                    );
                  }
                },
                child: ListTile(
                  leading: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: NetworkImage(productImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(productTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: $quantity'),
                      Text('Total: Rs. ${totalPrice.toStringAsFixed(2)}'),
                      Text('Payment: $paymentMethod'),
                    ],
                  ),
                  trailing: status == 'Pending'
                      ? const Icon(Icons.check_circle, color: Colors.grey)
                      : const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ReviewScreen extends StatefulWidget {
  final String productId;
  const ReviewScreen({super.key, required this.productId, });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  final TextEditingController _reviewController = TextEditingController();
  double _currentRating = 0.0;

  @override
  Widget _buildReviewInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Write a Review',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15,),
        Center(
          child: RatingBar.builder(
            initialRating: _currentRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _currentRating = rating;
              });
            },
          ),
        ),
        SizedBox(height: 15,),
        TextField(
          controller: _reviewController,
          decoration: const InputDecoration(
            hintText: 'Share your experience with this product',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _submitReview,
          child: const Text('Submit Review'),
        ),
      ],
    );
  }

  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Loaders.errorSnackBar(title: "Error", message: "You need to be logged in to submit a review.");
      return;
    }

    if (_reviewController.text.isEmpty || _currentRating == 0.0) {
      Loaders.warningSnackBar(title: "Error", message: "Please provide a rating and a review.");
      return;
    }

    try {
      FullScreenLoader.openLoadingDialogue("Submitting Review...", loader);
      // Fetch user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      // Add the review to Firestore
      final reviewData = {
        'userId': user.uid,
        'Username': userDoc['Username'] ?? user.displayName ?? 'Anonymous', // Add Username
        'rating': _currentRating,
        'review': _reviewController.text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .collection('reviews')
          .add(reviewData);

      // Clear the review controller and reset the rating
      _reviewController.clear();
      setState(() {
        _currentRating = 0.0;
      });

      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(title: "Success", message: "Review Submitted Successfully");
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: "Error", message: "Error submitting review");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order', style: TextStyle(color: textColor, fontWeight: FontWeight.w500),),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: textColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildReviewInput(),
      ),
    );

  }
}




