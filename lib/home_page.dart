//  import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:myapp/login_page.dart';
// import 'package:myapp/analysis.dart';
// import 'package:myapp/videocall.dart';

// class HomeScreen extends StatefulWidget {
//   final String userId;

//   const HomeScreen({super.key, required this.userId});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Map<String, dynamic>? userDetails;
//   List<dynamic>? therapists;
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserDetails();
//     _fetchTherapists();
//   }

//   Future<void> _fetchUserDetails() async {
//     final url = 'http://localhost:3000/api/users/${widget.userId}';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         setState(() {
//           userDetails = jsonDecode(response.body);
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load user details';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'An error occurred: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _fetchTherapists() async {
//     const url = 'http://localhost:3000/api/therapists';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         setState(() {
//           therapists = jsonDecode(response.body);
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load therapists';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'An error occurred while fetching therapists: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Text(
//           "MindEase",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Colors.purple),
//             )
//           : errorMessage != null
//               ? Center(
//                   child: Text(
//                     errorMessage!,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 )
//               : _buildHomeContent(context, screenWidth, isSmallScreen),
//       bottomNavigationBar: _BottomNavBar(),
//     );
//   }

//   Widget _buildHomeContent(
//       BuildContext context, double screenWidth, bool isSmallScreen) {
//     final padding = screenWidth * 0.04; // 4% of screen width
//     final cardWidth = isSmallScreen ? screenWidth * 0.35 : 140.0;

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(padding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Welcome User Banner
//           Container(
//             padding: EdgeInsets.all(padding),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Colors.purple, Colors.deepPurpleAccent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Hello, ${userDetails?['username'] ?? 'User'}!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: isSmallScreen ? 18 : 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: padding / 2),
//                 Text(
//                   "Welcome to MindEase! Start tracking your mental health today.",
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: isSmallScreen ? 12 : 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: padding),

//           // Search Bar
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.search, color: Colors.grey),
//                 SizedBox(width: 10),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Search Doctor...",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: padding),

//           // Therapists Section
//           _SectionHeader(
//             title: "Available Therapists",
//             onSeeAll: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AllTherapistsScreen(
//                     therapists: therapists ?? [],
//                     userId: widget.userId,
//                   ),
//                 ),
//               );
//             },
//             isSmallScreen: isSmallScreen,
//           ),
//           SizedBox(height: padding / 2),
//           therapists == null || therapists!.isEmpty
//               ? const Center(
//                   child: Text(
//                     "No therapists available",
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 )
//               : SizedBox(
//                   height: isSmallScreen ? 140 : 160,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: therapists!.length,
//                     itemBuilder: (context, index) {
//                       final therapist = therapists![index];
//                       return Padding(
//                         padding: EdgeInsets.only(right: padding / 2),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => TherapistDetailScreen(
//                                   therapist: therapist,
//                                   userId: widget.userId,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: _DoctorCard(
//                             name: therapist['name'] ?? 'Unknown',
//                             rating: "4.5",
//                             specialty: therapist['specialty'] ?? 'Therapist',
//                             cardWidth: cardWidth,
//                             isSmallScreen: isSmallScreen,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//           SizedBox(height: padding),

//           // Symptoms Section
//           Text(
//             "Your Symptoms",
//             style: TextStyle(
//               fontSize: isSmallScreen ? 14 : 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: padding / 2),
//           Wrap(
//             spacing: 8,
//             children: [
//               _SymptomTag(
//                 label: "Depression",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const DepressionScreen(),
//                     ),
//                   );
//                 },
//                 isSmallScreen: isSmallScreen,
//               ),
//               _SymptomTag(
//                 label: "Anxiety",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AnxietyScreen(),
//                     ),
//                   );
//                 },
//                 isSmallScreen: isSmallScreen,
//               ),
//               _SymptomTag(
//                 label: "Stress",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const StressScreen(),
//                     ),
//                   );
//                 },
//                 isSmallScreen: isSmallScreen,
//               ),
//               _SymptomTag(
//                 label: "Insomnia",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const InsomniaScreen(),
//                     ),
//                   );
//                 },
//                 isSmallScreen: isSmallScreen,
//               ),
//             ],
//           ),
//           SizedBox(height: padding),

//           // Top Doctor Section
//           _SectionHeader(
//             title: "Top Doctors",
//             isSmallScreen: isSmallScreen,
//           ),
//           SizedBox(height: padding / 2),
//           _TopDoctorCard(
//             name: "Dr. Nadia Syed",
//             rating: "4.7",
//             reviews: "7,932 reviews",
//             specialty: "Therapist | Agha Khan Hospital",
//             isSmallScreen: isSmallScreen,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Widget for Symptom Tag
// class _SymptomTag extends StatelessWidget {
//   final String label;
//   final VoidCallback? onTap;
//   final bool isSmallScreen;

//   const _SymptomTag({
//     required this.label,
//     this.onTap,
//     required this.isSmallScreen,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Chip(
//         label: Text(label),
//         backgroundColor: Colors.purple.withOpacity(0.1),
//         labelStyle: TextStyle(
//           color: Colors.purple,
//           fontSize: isSmallScreen ? 12 : 14,
//         ),
//         padding: EdgeInsets.symmetric(
//           horizontal: isSmallScreen ? 8 : 12,
//           vertical: isSmallScreen ? 2 : 4,
//         ),
//       ),
//     );
//   }
// }

// // Widget for Section Header
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback? onSeeAll;
//   final bool isSmallScreen;

//   const _SectionHeader({
//     required this.title,
//     this.onSeeAll,
//     required this.isSmallScreen,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: isSmallScreen ? 14 : 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         GestureDetector(
//           onTap: onSeeAll,
//           child: Text(
//             "See all",
//             style: TextStyle(
//               fontSize: isSmallScreen ? 12 : 14,
//               color: Colors.blue,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Widget for Doctor Card
// class _DoctorCard extends StatelessWidget {
//   final String name;
//   final String rating;
//   final String specialty;
//   final double cardWidth;
//   final bool isSmallScreen;

//   const _DoctorCard({
//     required this.name,
//     required this.rating,
//     required this.specialty,
//     required this.cardWidth,
//     required this.isSmallScreen,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: cardWidth,
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: isSmallScreen ? 25 : 30,
//                 child: Image.asset(
//                   'assets/images/user.png',
//                   width: isSmallScreen ? 40 : 50,
//                   height: isSmallScreen ? 40 : 50,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 name,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: isSmallScreen ? 12 : 14,
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               Text(
//                 specialty,
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 10 : 12,
//                   color: Colors.grey[600],
//                 ),
//                 textAlign: TextAlign.center,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 4),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.star,
//                     color: Colors.amber,
//                     size: isSmallScreen ? 14 : 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     rating,
//                     style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Widget for Top Doctor Card
// class _TopDoctorCard extends StatelessWidget {
//   final String name;
//   final String rating;
//   final String reviews;
//   final String specialty;
//   final bool isSmallScreen;

//   const _TopDoctorCard({
//     required this.name,
//     required this.rating,
//     required this.reviews,
//     required this.specialty,
//     required this.isSmallScreen,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: isSmallScreen ? 25 : 30,
//               child: Image.asset(
//                 'assets/images/girl.png',
//                 width: isSmallScreen ? 40 : 50,
//                 height: isSmallScreen ? 40 : 50,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: isSmallScreen ? 14 : 16,
//                     ),
//                   ),
//                   Text(
//                     specialty,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 10 : 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                         size: isSmallScreen ? 14 : 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         "$rating ($reviews)",
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 10 : 12,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.favorite_border, color: Colors.purple),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // All Therapists Screen
// class AllTherapistsScreen extends StatelessWidget {
//   final List<dynamic> therapists;
//   final String userId;

//   const AllTherapistsScreen({
//     super.key,
//     required this.therapists,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           "All Therapists",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: therapists.isEmpty
//           ? const Center(
//               child: Text(
//                 "No therapists available",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             )
//           : ListView.builder(
//               padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//               itemCount: therapists.length,
//               itemBuilder: (context, index) {
//                 final therapist = therapists[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TherapistDetailScreen(
//                           therapist: therapist,
//                           userId: userId,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     elevation: 4,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: isSmallScreen ? 25 : 30,
//                             child: Image.asset(
//                               'assets/images/user.png',
//                               width: isSmallScreen ? 40 : 50,
//                               height: isSmallScreen ? 40 : 50,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   therapist['name'] ?? 'Unknown',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: isSmallScreen ? 14 : 16,
//                                   ),
//                                 ),
//                                 Text(
//                                   therapist['specialty'] ?? 'Therapist',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 10 : 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                                 Text(
//                                   therapist['location'] ?? 'Unknown Location',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 10 : 12,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Icon(Icons.arrow_forward_ios,
//                               color: Colors.purple),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// // Therapist Detail Screen
// class TherapistDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> therapist;
//   final String userId;

//   const TherapistDetailScreen({
//     super.key,
//     required this.therapist,
//     required this.userId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           therapist['name'] ?? 'Therapist',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Therapist Info Card
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: isSmallScreen ? 30 : 40,
//                       child: Image.asset(
//                         'assets/images/user.png',
//                         width: isSmallScreen ? 50 : 60,
//                         height: isSmallScreen ? 50 : 60,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     SizedBox(width: isSmallScreen ? 8 : 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             therapist['name'] ?? 'Unknown',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 16 : 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: isSmallScreen ? 4 : 8),
//                           Text(
//                             therapist['specialty'] ?? 'Therapist',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 12 : 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: isSmallScreen ? 2 : 4),
//                           Text(
//                             therapist['location'] ?? 'Unknown Location',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 12 : 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: isSmallScreen ? 2 : 4),
//                           Text(
//                             therapist['email'] ?? 'No email provided',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 12 : 14,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),

//             // Booking Options
//             Text(
//               "Book an Appointment",
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 14 : 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 5 : 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         vertical: isSmallScreen ? 12 : 16,
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PhysicalAppointmentScreen(
//                             therapist: therapist,
//                             userId: userId,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Physical Meeting",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: isSmallScreen ? 12 : 14,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: isSmallScreen ? 5 : 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         vertical: isSmallScreen ? 12 : 16,
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => OnlineAppointmentScreen(
//                             therapist: therapist,
//                             userId: userId,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Online Meeting",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: isSmallScreen ? 12 : 14,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Physical Appointment Screen
// class PhysicalAppointmentScreen extends StatefulWidget {
//   final Map<String, dynamic> therapist;
//   final String userId;

//   const PhysicalAppointmentScreen({
//     super.key,
//     required this.therapist,
//     required this.userId,
//   });

//   @override
//   _PhysicalAppointmentScreenState createState() =>
//       _PhysicalAppointmentScreenState();
// }

// class _PhysicalAppointmentScreenState extends State<PhysicalAppointmentScreen> {
//   DateTime? selectedDateTime;
//   int? selectedDuration = 60;
//   final TextEditingController notesController = TextEditingController();
//   bool isLoading = false;
//   String? errorMessage;

//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//       if (pickedTime != null) {
//         setState(() {
//           selectedDateTime = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }

//   Future<void> _bookAppointment() async {
//     if (selectedDateTime == null) {
//       setState(() {
//         errorMessage = 'Please select a date and time';
//       });
//       return;
//     }
//     if (selectedDateTime!.isBefore(DateTime.now())) {
//       setState(() {
//         errorMessage = 'Cannot book appointments in the past';
//       });
//       return;
//     }
//     if (widget.userId.isEmpty) {
//       setState(() {
//         errorMessage = 'User ID is missing';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/api/appointments'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'userId': widget.userId,
//           'therapistId': widget.therapist['_id'],
//           'appointmentDate': selectedDateTime!.toUtc().toIso8601String(),
//           'duration': selectedDuration,
//           'notes': notesController.text,
//         }),
//       );

//       if (response.statusCode == 201) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Physical appointment booked with ${widget.therapist['name']}',
//               ),
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         setState(() {
//           errorMessage = errorData['message'] ?? 'Failed to book appointment';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'An error occurred: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Book Physical Appointment - ${widget.therapist['name']}',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 16 : 20,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Select Date and Time',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () => _selectDateTime(context),
//                       child: Text(
//                         selectedDateTime == null
//                             ? 'Pick Date & Time'
//                             : DateFormat('yyyy-MM-dd HH:mm')
//                                 .format(selectedDateTime!),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: isSmallScreen ? 12 : 14,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 10 : 20),
//                     Text(
//                       'Duration (minutes)',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     DropdownButton<int>(
//                       value: selectedDuration,
//                       items: const [
//                         DropdownMenuItem(value: 30, child: Text('30 minutes')),
//                         DropdownMenuItem(value: 60, child: Text('60 minutes')),
//                         DropdownMenuItem(value: 90, child: Text('90 minutes')),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           selectedDuration = value;
//                         });
//                       },
//                       isExpanded: true,
//                     ),
//                     SizedBox(height: isSmallScreen ? 10 : 20),
//                     Text(
//                       'Notes',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     TextField(
//                       controller: notesController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Any specific concerns or notes...',
//                       ),
//                       maxLines: 4,
//                     ),
//                     SizedBox(height: isSmallScreen ? 10 : 20),
//                     if (errorMessage != null)
//                       Text(
//                         errorMessage!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallScreen ? 12 : 16,
//                         ),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                       onPressed: isLoading ? null : _bookAppointment,
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                               'Book Appointment',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: isSmallScreen ? 12 : 14,
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     notesController.dispose();
//     super.dispose();
//   }
// }

// // Online Appointment Screen
// class OnlineAppointmentScreen extends StatefulWidget {
//   final Map<String, dynamic> therapist;
//   final String userId;

//   const OnlineAppointmentScreen({
//     super.key,
//     required this.therapist,
//     required this.userId,
//   });

//   @override
//   _OnlineAppointmentScreenState createState() =>
//       _OnlineAppointmentScreenState();
// }

// class _OnlineAppointmentScreenState extends State<OnlineAppointmentScreen> {
//   DateTime? selectedDateTime;
//   int? selectedDuration = 60;
//   final TextEditingController notesController = TextEditingController();
//   bool isLoading = false;
//   String? errorMessage;

//   Future<void> _selectDateTime(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );
//       if (pickedTime != null) {
//         setState(() {
//           selectedDateTime = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }

//   Future<void> _bookAppointment() async {
//     if (selectedDateTime == null) {
//       setState(() {
//         errorMessage = 'Please select a date and time';
//       });
//       return;
//     }
//     if (selectedDateTime!.isBefore(DateTime.now())) {
//       setState(() {
//         errorMessage = 'Cannot book appointments in the past';
//       });
//       return;
//     }
//     if (widget.userId.isEmpty) {
//       setState(() {
//         errorMessage = 'User ID is missing';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/api/appointment'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'userId': widget.userId,
//           'therapistId': widget.therapist['_id'],
//           'appointmentDate': selectedDateTime!.toUtc().toIso8601String(),
//           'duration': selectedDuration,
//           'notes': notesController.text,
//         }),
//       );

//       if (response.statusCode == 201) {
//         final appointment = jsonDecode(response.body);
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Online appointment booked with ${widget.therapist['name']}. Meeting link: ${appointment['meetingLink']}',
//               ),
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } else {
//         final errorData = jsonDecode(response.body);
//         setState(() {
//           errorMessage = errorData['message'] ?? 'Failed to book appointment';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'An error occurred: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Book Online Appointment - ${widget.therapist['name']}',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 16 : 20,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Select Date and Time',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () => _selectDateTime(context),
//                       child: Text(
//                         selectedDateTime == null
//                             ? 'Pick Date & Time'
//                             : DateFormat('yyyy-MM-dd HH:mm')
//                                 .format(selectedDateTime!),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: isSmallScreen ? 12 : 14,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 10 : 20),
//                     Text(
//                       'Duration (minutes)',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     DropdownButton<int>(
//                       value: selectedDuration,
//                       items: const [
//                         DropdownMenuItem(value: 30, child: Text('30 minutes')),
//                         DropdownMenuItem(value: 60, child: Text('60 minutes')),
//                         DropdownMenuItem(value: 90, child: Text('90 minutes')),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           selectedDuration = value;
//                         });
//                       },
//                       isExpanded: true,
//                     ),
//                     SizedBox(height: isSmallScreen ? 10 : 20),
//                     Text(
//                       'Notes',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     TextField(
//                       controller: notesController,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Any specific concerns or notes...',
//                       ),
//                       maxLines: 4,
//                     ),
//                     SizedBox(height: isSmallScreen ? 10 : 20),
//                     if (errorMessage != null)
//                       Text(
//                         errorMessage!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallScreen ? 12 : 16,
//                         ),
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                       onPressed: isLoading ? null : _bookAppointment,
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : Text(
//                               'Book Appointment',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: isSmallScreen ? 12 : 14,
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     notesController.dispose();
//     super.dispose();
//   }
// }

// // Depression Screen
// class DepressionScreen extends StatelessWidget {
//   const DepressionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Depression',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Symptoms',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Persistent sadness or low mood\n'
//                       '- Loss of interest in activities\n'
//                       '- Fatigue or low energy\n'
//                       '- Feelings of worthlessness or guilt\n'
//                       '- Difficulty concentrating\n'
//                       '- Changes in appetite or weight\n'
//                       '- Sleep disturbances (insomnia or oversleeping)\n'
//                       '- Thoughts of self-harm or suicide',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Causes',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Biological factors (e.g., chemical imbalances in the brain)\n'
//                       '- Genetic predisposition (family history of depression)\n'
//                       '- Traumatic life events (e.g., loss of a loved one)\n'
//                       '- Chronic stress or abuse\n'
//                       '- Medical conditions (e.g., thyroid disorders)\n'
//                       '- Substance abuse',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Effects',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Impaired relationships and social isolation\n'
//                       '- Decreased work or academic performance\n'
//                       '- Physical health issues (e.g., chronic pain, weakened immune system)\n'
//                       '- Increased risk of substance abuse\n'
//                       '- Higher likelihood of self-harm or suicide\n'
//                       '- Financial difficulties due to reduced productivity',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Anxiety Screen
// class AnxietyScreen extends StatelessWidget {
//   const AnxietyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Anxiety',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Symptoms',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Excessive worry or fear\n'
//                       '- Restlessness or feeling on edge\n'
//                       '- Rapid heartbeat or palpitations\n'
//                       '- Sweating or trembling\n'
//                       '- Difficulty concentrating\n'
//                       '- Muscle tension\n'
//                       '- Sleep disturbances\n'
//                       '- Panic attacks (sudden intense fear)',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Causes',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Genetic factors (family history of anxiety)\n'
//                       '- Brain chemistry imbalances\n'
//                       '- Traumatic or stressful life events\n'
//                       '- Chronic medical conditions\n'
//                       '- Substance use or withdrawal\n'
//                       '- Personality traits (e.g., perfectionism)',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Effects',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Social isolation and strained relationships\n'
//                       '- Reduced productivity at work or school\n'
//                       '- Physical health issues (e.g., headaches, digestive problems)\n'
//                       '- Increased risk of depression\n'
//                       '- Chronic fatigue from poor sleep\n'
//                       '- Avoidance behaviors impacting daily life',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Stress Screen
// class StressScreen extends StatelessWidget {
//   const StressScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Stress',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Symptoms',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Irritability or mood swings\n'
//                       '- Headaches or muscle tension\n'
//                       '- Fatigue or low energy\n'
//                       '- Difficulty sleeping\n'
//                       '- Racing thoughts or feeling overwhelmed\n'
//                       '- Digestive issues (e.g., stomach aches)\n'
//                       '- Changes in appetite\n'
//                       '- Trouble concentrating',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Causes',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Work or academic pressure\n'
//                       '- Financial difficulties\n'
//                       '- Relationship conflicts\n'
//                       '- Major life changes (e.g., moving, job loss)\n'
//                       '- Health problems\n'
//                       '- Lack of work-life balance',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Effects',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Weakened immune system\n'
//                       '- Increased risk of anxiety or depression\n'
//                       '- Burnout or chronic fatigue\n'
//                       '- Strained personal relationships\n'
//                       '- Poor decision-making\n'
//                       '- Physical health issues (e.g., high blood pressure)',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Insomnia Screen
// class InsomniaScreen extends StatelessWidget {
//   const InsomniaScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3F4F6),
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Text(
//           'Insomnia',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: isSmallScreen ? 18 : 22,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Symptoms',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Difficulty falling asleep\n'
//                       '- Waking up frequently during the night\n'
//                       '- Waking up too early\n'
//                       '- Feeling unrefreshed after sleep\n'
//                       '- Daytime fatigue or sleepiness\n'
//                       '- Irritability or mood changes\n'
//                       '- Trouble concentrating',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Causes',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Stress or anxiety\n'
//                       '- Poor sleep habits (e.g., irregular sleep schedule)\n'
//                       '- Medical conditions (e.g., chronic pain, asthma)\n'
//                       '- Medications or substance use (e.g., caffeine, alcohol)\n'
//                       '- Mental health disorders (e.g., depression)\n'
//                       '- Environmental factors (e.g., noise, light)',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 10 : 20),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               elevation: 4,
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Effects',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 16 : 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 5 : 10),
//                     Text(
//                       '- Decreased cognitive function (e.g., memory issues)\n'
//                       '- Increased risk of accidents or injuries\n'
//                       '- Mood disturbances (e.g., irritability, anxiety)\n'
//                       '- Weakened immune system\n'
//                       '- Higher risk of chronic diseases (e.g., diabetes)\n'
//                       '- Reduced quality of life',
//                       style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Bottom Navigation Bar
// class _BottomNavBar extends StatefulWidget {
//   @override
//   _BottomNavBarState createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<_BottomNavBar> {
//   int _currentIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/home');
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/journaling');
//         break;
//       case 2:
//         Navigator.pushNamed(context, '/mood_tracking');
//         break;
//       case 3:
//         Navigator.pushNamed(context, '/analysis');
//         break;
//       case 4:
//         Navigator.pushNamed(context, '/settings');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isSmallScreen = MediaQuery.of(context).size.width < 600;

//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//       onTap: _onItemTapped,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Journal'),
//         BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
//         BottomNavigationBarItem(
//             icon: Icon(Icons.track_changes), label: 'Analysis'),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//       ],
//       selectedItemColor: Colors.purple,
//       unselectedItemColor: Colors.grey,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//       iconSize: isSmallScreen ? 20 : 24,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:myapp/login_page.dart';
import 'package:myapp/therapist_screen.dart';
import 'package:permission_handler/permission_handler.dart';

// Agora App ID (replace with your actual Agora App ID)
// const String appId = '51d04cab7dc84df589c15e084a154c0a';

class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userDetails;
  List<dynamic>? therapists;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchTherapists();
  }

  Future<void> _fetchUserDetails() async {
    final url = 'http://localhost:3000/api/users/${widget.userId}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          userDetails = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load user details';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchTherapists() async {
    const url = 'http://localhost:3000/api/therapists';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          therapists = jsonDecode(response.body);
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load therapists';
        });
      }
    } catch (e) {
      setState() {
        errorMessage = 'An error occurred while fetching therapists: $e';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "MindEase",
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            )
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _buildHomeContent(context, screenWidth, isSmallScreen),
      bottomNavigationBar: _BottomNavBar(),
    );
  }

  Widget _buildHomeContent(
      BuildContext context, double screenWidth, bool isSmallScreen) {
    final padding = screenWidth * 0.04;
    final cardWidth = isSmallScreen ? screenWidth * 0.35 : 140.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello, ${userDetails?['username'] ?? 'User'}!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 18 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: padding / 2),
                Text(
                  "Welcome to MindEase! Start tracking your mental health today.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: padding),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Doctor...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: padding),
          _SectionHeader(
            title: "Available Therapists",
            onSeeAll: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllTherapistsScreen(
                    therapists: therapists ?? [],
                    userId: widget.userId,
                  ),
                ),
              );
            },
            isSmallScreen: isSmallScreen,
          ),
          SizedBox(height: padding / 2),
          therapists == null || therapists!.isEmpty
              ? const Center(
                  child: Text(
                    "No therapists available",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SizedBox(
                  height: isSmallScreen ? 140 : 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: therapists!.length,
                    itemBuilder: (context, index) {
                      final therapist = therapists![index];
                      return Padding(
                        padding: EdgeInsets.only(right: padding / 2),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TherapistDetailScreen(
                                  therapist: therapist,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: _DoctorCard(
                            name: therapist['name'] ?? 'Unknown',
                            rating: "4.5",
                            specialty: therapist['specialty'] ?? 'Therapist',
                            cardWidth: cardWidth,
                            isSmallScreen: isSmallScreen,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          SizedBox(height: padding),
          Text(
            "Your Symptoms",
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: padding / 2),
          Wrap(
            spacing: 8,
            children: [
              _SymptomTag(
                label: "Depression",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DepressionScreen(),
                    ),
                  );
                },
                isSmallScreen: isSmallScreen,
              ),
              _SymptomTag(
                label: "Anxiety",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AnxietyScreen(),
                    ),
                  );
                },
                isSmallScreen: isSmallScreen,
              ),
              _SymptomTag(
                label: "Stress",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StressScreen(),
                    ),
                  );
                },
                isSmallScreen: isSmallScreen,
              ),
              _SymptomTag(
                label: "Insomnia",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InsomniaScreen(),
                    ),
                  );
                },
                isSmallScreen: isSmallScreen,
              ),
            ],
          ),
          SizedBox(height: padding),
          _SectionHeader(
            title: "Top Doctors",
            isSmallScreen: isSmallScreen,
          ),
          SizedBox(height: padding / 2),
          _TopDoctorCard(
            name: "Dr. Nadia Syed",
            rating: "4.7",
            reviews: "7,932 reviews",
            specialty: "Therapist | Agha Khan Hospital",
            isSmallScreen: isSmallScreen,
          ),
        ],
      ),
    );
  }
}

class _SymptomTag extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSmallScreen;

  const _SymptomTag({
    required this.label,
    this.onTap,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.purple.withOpacity(0.1),
        labelStyle: TextStyle(
          color: Colors.purple,
          fontSize: isSmallScreen ? 12 : 14,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8 : 12,
          vertical: isSmallScreen ? 2 : 4,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final bool isSmallScreen;

  const _SectionHeader({
    required this.title,
    this.onSeeAll,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            "See all",
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final String name;
  final String rating;
  final String specialty;
  final double cardWidth;
  final bool isSmallScreen;

  const _DoctorCard({
    required this.name,
    required this.rating,
    required this.specialty,
    required this.cardWidth,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 25 : 30,
                child: Image.asset(
                  'assets/images/user.png',
                  width: isSmallScreen ? 40 : 50,
                  height: isSmallScreen ? 40 : 50,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                specialty,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: isSmallScreen ? 14 : 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating,
                    style: TextStyle(fontSize: isSmallScreen ? 10 : 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopDoctorCard extends StatelessWidget {
  final String name;
  final String rating;
  final String reviews;
  final String specialty;
  final bool isSmallScreen;

  const _TopDoctorCard({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.specialty,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: isSmallScreen ? 25 : 30,
              child: Image.asset(
                'assets/images/girl.png',
                width: isSmallScreen ? 40 : 50,
                height: isSmallScreen ? 40 : 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  Text(
                    specialty,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: isSmallScreen ? 14 : 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$rating ($reviews)",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.favorite_border, color: Colors.purple),
          ],
        ),
      ),
    );
  }
}

class AllTherapistsScreen extends StatelessWidget {
  final List<dynamic> therapists;
  final String userId;

  const AllTherapistsScreen({
    super.key,
    required this.therapists,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "All Therapists",
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: therapists.isEmpty
          ? const Center(
              child: Text(
                "No therapists available",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
              itemCount: therapists.length,
              itemBuilder: (context, index) {
                final therapist = therapists[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TherapistDetailScreen(
                          therapist: therapist,
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: isSmallScreen ? 25 : 30,
                            child: Image.asset(
                              'assets/images/user.png',
                              width: isSmallScreen ? 40 : 50,
                              height: isSmallScreen ? 40 : 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  therapist['name'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                Text(
                                  therapist['specialty'] ?? 'Therapist',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  therapist['location'] ?? 'Unknown Location',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.purple),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class TherapistDetailScreen extends StatelessWidget {
  final Map<String, dynamic> therapist;
  final String userId;

  const TherapistDetailScreen({
    super.key,
    required this.therapist,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          therapist['name'] ?? 'Therapist',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isSmallScreen ? 30 : 40,
                      child: Image.asset(
                        'assets/images/user.png',
                        width: isSmallScreen ? 50 : 60,
                        height: isSmallScreen ? 50 : 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            therapist['name'] ?? 'Unknown',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 8),
                          Text(
                            therapist['specialty'] ?? 'Therapist',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            therapist['location'] ?? 'Unknown Location',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 2 : 4),
                          Text(
                            therapist['email'] ?? 'No email provided',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Text(
              "Book an Appointment",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 5 : 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PhysicalAppointmentScreen(
                            therapist: therapist,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Physical Meeting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 5 : 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 12 : 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnlineAppointmentScreen(
                            therapist: therapist,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Online Meeting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PhysicalAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> therapist;
  final String userId;

  const PhysicalAppointmentScreen({
    super.key,
    required this.therapist,
    required this.userId,
  });

  @override
  _PhysicalAppointmentScreenState createState() =>
      _PhysicalAppointmentScreenState();
}

class _PhysicalAppointmentScreenState extends State<PhysicalAppointmentScreen> {
  DateTime? selectedDateTime;
  int? selectedDuration = 60;
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedDateTime == null) {
      setState(() {
        errorMessage = 'Please select a date and time';
      });
      return;
    }
    if (selectedDateTime!.isBefore(DateTime.now())) {
      setState(() {
        errorMessage = 'Cannot book appointments in the past';
      });
      return;
    }
    if (widget.userId.isEmpty) {
      setState(() {
        errorMessage = 'User ID is missing';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'therapistId': widget.therapist['_id'],
          'appointmentDate': selectedDateTime!.toUtc().toIso8601String(),
          'duration': selectedDuration,
          'notes': notesController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Physical appointment booked with ${widget.therapist['name']}',
              ),
            ),
          );
          Navigator.pop(context);
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          errorMessage = errorData['message'] ?? 'Failed to book appointment';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Book Physical Appointment - ${widget.therapist['name']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 16 : 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date and Time',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _selectDateTime(context),
                      child: Text(
                        selectedDateTime == null
                            ? 'Pick Date & Time'
                            : DateFormat('yyyy-MM-dd HH:mm')
                                .format(selectedDateTime!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      'Duration (minutes)',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    DropdownButton<int>(
                      value: selectedDuration,
                      items: const [
                        DropdownMenuItem(value: 30, child: Text('30 minutes')),
                        DropdownMenuItem(value: 60, child: Text('60 minutes')),
                        DropdownMenuItem(value: 90, child: Text('90 minutes')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value;
                        });
                      },
                      isExpanded: true,
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Any specific concerns or notes...',
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: isLoading ? null : _bookAppointment,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Book Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}

class OnlineAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> therapist;
  final String userId;

  const OnlineAppointmentScreen({
    super.key,
    required this.therapist,
    required this.userId,
  });

  @override
  _OnlineAppointmentScreenState createState() =>
      _OnlineAppointmentScreenState();
}

class _OnlineAppointmentScreenState extends State<OnlineAppointmentScreen> {
  DateTime? selectedDateTime;
  int? selectedDuration = 60;
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedDateTime == null) {
      setState(() {
        errorMessage = 'Please select a date and time';
      });
      return;
    }
    if (selectedDateTime!.isBefore(DateTime.now())) {
      setState(() {
        errorMessage = 'Cannot book appointments in the past';
      });
      return;
    }
    if (widget.userId.isEmpty) {
      setState(() {
        errorMessage = 'User ID is missing';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/appointments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'therapistId': widget.therapist['_id'],
          'appointmentDate': selectedDateTime!.toUtc().toIso8601String(),
          'duration': selectedDuration,
          'notes': notesController.text,
        }),
      );

      if (response.statusCode == 201) {
        final appointment = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Online appointment booked with ${widget.therapist['name']}',
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTherapistPage(
                // title: 'Video Call with ${widget.therapist['name']}',
                // channelName: appointment['channelName'] ?? 'default_channel',
                // token: appointment['token'] ?? 'default_token',
              ),
            ),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          errorMessage = errorData['message'] ?? 'Failed to book appointment';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Book Online Appointment - ${widget.therapist['name']}',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 16 : 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Date and Time',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _selectDateTime(context),
                      child: Text(
                        selectedDateTime == null
                            ? 'Pick Date & Time'
                            : DateFormat('yyyy-MM-dd HH:mm')
                                .format(selectedDateTime!),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      'Duration (minutes)',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    DropdownButton<int>(
                      value: selectedDuration,
                      items: const [
                        DropdownMenuItem(value: 30, child: Text('30 minutes')),
                        DropdownMenuItem(value: 60, child: Text('60 minutes')),
                        DropdownMenuItem(value: 90, child: Text('90 minutes')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value;
                        });
                      },
                      isExpanded: true,
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Any specific concerns or notes...',
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 20),
                    if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 12 : 16,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: isLoading ? null : _bookAppointment,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Book Appointment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }
}

class DepressionScreen extends StatelessWidget {
  const DepressionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Depression',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Persistent sadness or low mood\n'
                      '- Loss of interest in activities\n'
                      '- Fatigue or low energy\n'
                      '- Feelings of worthlessness or guilt\n'
                      '- Difficulty concentrating\n'
                      '- Changes in appetite or weight\n'
                      '- Sleep disturbances (insomnia or oversleeping)\n'
                      '- Thoughts of self-harm or suicide',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Biological factors (e.g., chemical imbalances in the brain)\n'
                      '- Genetic predisposition (family history of depression)\n'
                      '- Traumatic life events (e.g., loss of a loved one)\n'
                      '- Chronic stress or abuse\n'
                      '- Medical conditions (e.g., thyroid disorders)\n'
                      '- Substance abuse',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effects',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Impaired relationships and social isolation\n'
                      '- Decreased work or academic performance\n'
                      '- Physical health issues (e.g., chronic pain, weakened immune system)\n'
                      '- Increased risk of substance abuse\n'
                      '- Higher likelihood of self-harm or suicide\n'
                      '- Financial difficulties due to reduced productivity',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnxietyScreen extends StatelessWidget {
  const AnxietyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Anxiety',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Excessive worry or fear\n'
                      '- Restlessness or feeling on edge\n'
                      '- Rapid heartbeat or palpitations\n'
                      '- Sweating or trembling\n'
                      '- Difficulty concentrating\n'
                      '- Muscle tension\n'
                      '- Sleep disturbances\n'
                      '- Panic attacks (sudden intense fear)',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Genetic factors (family history of anxiety)\n'
                      '- Brain chemistry imbalances\n'
                      '- Traumatic or stressful life events\n'
                      '- Chronic medical conditions\n'
                      '- Substance use or withdrawal\n'
                      '- Personality traits (e.g., perfectionism)',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effects',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Social isolation and strained relationships\n'
                      '- Reduced productivity at work or school\n'
                      '- Physical health issues (e.g., headaches, digestive problems)\n'
                      '- Increased risk of depression\n'
                      '- Chronic fatigue from poor sleep\n'
                      '- Avoidance behaviors impacting daily life',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StressScreen extends StatelessWidget {
  const StressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Stress',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Irritability or mood swings\n'
                      '- Headaches or muscle tension\n'
                      '- Fatigue or low energy\n'
                      '- Difficulty sleeping\n'
                      '- Racing thoughts or feeling overwhelmed\n'
                      '- Digestive issues (e.g., stomach aches)\n'
                      '- Changes in appetite\n'
                      '- Trouble concentrating',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Work or academic pressure\n'
                      '- Financial difficulties\n'
                      '- Relationship conflicts\n'
                      '- Major life changes (e.g., moving, job loss)\n'
                      '- Health problems\n'
                      '- Lack of work-life balance',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effects',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Weakened immune system\n'
                      '- Increased risk of anxiety or depression\n'
                      '- Burnout or chronic fatigue\n'
                      '- Strained personal relationships\n'
                      '- Poor decision-making\n'
                      '- Physical health issues (e.g., high blood pressure)',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InsomniaScreen extends StatelessWidget {
  const InsomniaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'Insomnia',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Difficulty falling asleep\n'
                      '- Waking up frequently during the night\n'
                      '- Waking up too early\n'
                      '- Feeling unrefreshed after sleep\n'
                      '- Daytime fatigue or sleepiness\n'
                      '- Irritability or mood changes\n'
                      '- Trouble concentrating',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Causes',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Stress or anxiety\n'
                      '- Poor sleep habits (e.g., irregular sleep schedule)\n'
                      '- Medical conditions (e.g., chronic pain, asthma)\n'
                      '- Medications or substance use (e.g., caffeine, alcohol)\n'
                      '- Mental health disorders (e.g., depression)\n'
                      '- Environmental factors (e.g., noise, light)',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effects',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 5 : 10),
                    Text(
                      '- Decreased cognitive function (e.g., memory issues)\n'
                      '- Increased risk of accidents or injuries\n'
                      '- Mood disturbances (e.g., irritability, anxiety)\n'
                      '- Weakened immune system\n'
                      '- Higher risk of chronic diseases (e.g., diabetes)\n'
                      '- Reduced quality of life',
                      style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/journaling');
        break;
      case 2:
        Navigator.pushNamed(context, '/mood_tracking');
        break;
      case 3:
        Navigator.pushNamed(context, '/analysis');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Journal'),
        BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
        BottomNavigationBarItem(
            icon: Icon(Icons.track_changes), label: 'Analysis'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: isSmallScreen ? 20 : 24,
    );
  }
}

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Login Page Placeholder'),
//       ),
//     );
//   }
// }

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Analysis Screen Placeholder'),
      ),
    );
  }
}
//
// class VideoCall extends StatefulWidget {
//   const VideoCall({
//     super.key,
//     required this.title,
//     required this.channelName,
//     required this.token,
//   });
//
//   final String title;
//   final String channelName;
//   final String token;
//
//   @override
//   State<VideoCall> createState() => _VideoCallState();
// }
//
// class _VideoCallState extends State<VideoCall> {
//   late RtcEngine _engine;
//   int? _remoteUid;
//   bool localUserJoined = false;
//
//   @override
//   void initState() {
//     initAgora();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _dispose();
//     super.dispose();
//   }
//
//   Future<void> initAgora() async {
//     await [Permission.microphone, Permission.camera].request();
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(const RtcEngineContext(
//       appId: appId,
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));
//     await _engine.enableVideo();
//     await _engine.startPreview();
//     await _engine.joinChannel(
//       token: widget.token,
//       channelId: widget.channelName,
//       options: const ChannelMediaOptions(
//         autoSubscribeVideo: true,
//         autoSubscribeAudio: true,
//         publishCameraTrack: true,
//         publishMicrophoneTrack: true,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       ),
//       uid: 0,
//     );
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint("local user ${connection.localUid} joined");
//           setState(() {
//             localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint("remote user $remoteUid joined");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint("remote user $remoteUid left channel");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );
//   }
//
//   Future<void> _dispose() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }
//
//   Widget _remoteVideo() {
//     if (_remoteUid != null) {
//       return AgoraVideoView(
//         controller: VideoViewController.remote(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: _remoteUid),
//           connection: RtcConnection(channelId: widget.channelName),
//         ),
//       );
//     } else {
//       return const Text(
//         'Please wait for remote user to join',
//         textAlign: TextAlign.center,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _remoteVideo(),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: SizedBox(
//               width: 100,
//               height: 150,
//               child: Center(
//                 child: localUserJoined
//                     ? AgoraVideoView(
//                         controller: VideoViewController(
//                           rtcEngine: _engine,
//                           canvas: const VideoCanvas(uid: 0),
//                         ),
//                       )
//                     : const CircularProgressIndicator(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }