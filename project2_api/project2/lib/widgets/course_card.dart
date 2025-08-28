// import 'package:flutter/material.dart';
// import '../models/course1_model.dart';
// import '../screens/Degree details.dart';

// class CourseCard extends StatelessWidget {
//   final Course1 course;

//   const CourseCard({Key? key, required this.course, required Null Function() onTap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         title: Text(
//           course.name,
//           style: TextStyle(fontSize: screenWidth * 0.045),
//         ),
//         subtitle: Text(
//           'مجال الدورة: ${course.category}\nدرجة الدورة: ${course.grade}',
//           style: TextStyle(fontSize: screenWidth * 0.04),
//         ),
//         leading: Container(
//           width: screenWidth * 0.12,
//           height: screenWidth * 0.12,
//           decoration: BoxDecoration(
//             color: Colors.blue.shade100,
//             borderRadius: BorderRadius.circular(screenWidth * 0.06),
//             border: Border.all(color: Colors.blue, width: 2),
//           ),
//           child: Center(
//             child: Text(
//               course.id,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade800,
//                 fontSize: screenWidth * 0.03,
//               ),
//             ),
//           ),
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DegreeDetails(course: course),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
