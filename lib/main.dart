import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:macos_dock/dock.dart';

void main() {
  runApp(const MacOSDock());
}

  int hoveredIndex = -1;
  int draggedIndex = -1;
  List<String> minimizedApps = [];
  bool isMinimized = false;

  final List<Map<String, dynamic>> icons = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.search, 'label': 'Search'},
    {'icon': Icons.settings, 'label': 'Settings'},
    {'icon': Icons.info, 'label': 'Info'},
  ];

class MacOSDock extends StatefulWidget {
  const MacOSDock({super.key});

  @override
  State<MacOSDock> createState() => _MacOSDockState();
}

class _MacOSDockState extends State<MacOSDock> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mac OS Dock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),      
      home:  Scaffold(
          backgroundColor: const Color.fromARGB(255, 114, 195, 230),
        body:Stack(
              children: [
                Align(alignment: Alignment.bottomCenter, child: Dock(), ),
              ],
            ),
        )
     
    );
  }
}

// class Dock extends StatefulWidget {
//   const Dock({super.key});

//   @override
//   _DockState createState() => _DockState();
// }

// class _DockState extends State<Dock> {

//   void minimizeApp(String app) {
//     setState(() {
//       minimizedApps.add(app);
//     });
//   }

//   void restoreApp(String app) {
//     setState(() {
//       minimizedApps.remove(app);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Minimized Apps Section
//         if (minimizedApps.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 10.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: minimizedApps.map((String app) {
//                 return GestureDetector(
//                   onTap: () => restoreApp(app),
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(color: Colors.black26, blurRadius: 4),
//                       ],
//                     ),
//                     child: Text(
//                       app,
//                       style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),

//         // Dock Section
//         AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           width: isMinimized ? 60 : null,
//           child: Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 20),
//                     padding: EdgeInsets.symmetric(
//                       vertical: 10,
//                       horizontal: isMinimized ? 10 : 20,
//                     ),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           Colors.white.withAlpha(51),
//                           Colors.white.withAlpha(13),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       border: Border.all(
//                         color: Colors.white.withAlpha(76),
//                         width: 1.5,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 300),
//                       child: isMinimized
//                           ? const Icon(
//                               Icons.more_vert,
//                               color: Colors.white,
//                               size: 24,
//                             )
//                           : Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: List.generate(icons.length, (index) {
//                                 return DragTarget<Map<String, dynamic>>(
//                                   onAcceptWithDetails: (details) {
//                                     setState(() {
//                                       icons.remove(details.data);
//                                       icons.insert(index, details.data);
//                                       draggedIndex = -1;
//                                     });
//                                   },
//                                   onWillAcceptWithDetails: (data) {
//                                     setState(() => draggedIndex = index);
//                                     return true;
//                                   },
//                                   builder: (context, candidateData, rejectedData) {
//                                     return AnimatedContainer(
//                                       duration: const Duration(milliseconds: 100),
//                                       curve: Curves.easeInOut,
//                                       margin: draggedIndex == index
//                                           ? const EdgeInsets.symmetric(horizontal: 20.0)
//                                           : const EdgeInsets.symmetric(horizontal: 8.0),
//                                       child: LongPressDraggable<Map<String, dynamic>>(
//                                         data: icons[index],
//                                         feedback: Material(
//                                           color: Colors.transparent,
//                                           child: Icon(
//                                             icons[index]['icon'],
//                                             size: 48,
//                                             color: Colors.white.withOpacity(0.8),
//                                           ),
//                                         ),
//                                         childWhenDragging: Opacity(
//                                           opacity: 0.0,
//                                           child: Icon(
//                                             icons[index]['icon'],
//                                             size: 48,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                         onDragStarted: () => setState(()  {
//                                           // icons.remove(icons[index]);
//                                           draggedIndex = index;
                                          


                                          
//                                           }),


//                                         onDragEnd: (_) => setState(() => draggedIndex = -1),
//                                         child: GestureDetector(
//                                           onDoubleTap: () {
//                                             final appLabel = icons[index]['label'];
//                                             if (minimizedApps.contains(appLabel)) {
//                                               restoreApp(appLabel);
//                                             } else {
//                                               minimizeApp(appLabel);
//                                             }
//                                           },
//                                           child: MouseRegion(
//                                             onEnter: (_) {
//                                               if (draggedIndex == -1) {
//                                                 setState(() => hoveredIndex = index);
//                                               }
//                                             },
//                                             onExit: (_) {
//                                               if (draggedIndex == -1) {
//                                                 setState(() => hoveredIndex = -1);
//                                               }
//                                             },
//                                             child: TweenAnimationBuilder<double>(
//                                               duration: const Duration(milliseconds: 300),
//                                               tween: Tween<double>(
//                                                 begin: 48,
//                                                 end: hoveredIndex == index ? 64 : 48,
//                                               ),
//                                               builder: (context, size, child) {
//                                                 return Column(
//                                                   mainAxisSize: MainAxisSize.min,
//                                                   children: [
//                                                     Icon(
//                                                       icons[index]['icon'],
//                                                       size: size,
//                                                       color: Colors.white,
//                                                     ),
//                                                     if (hoveredIndex == index)
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(top: 5.0),
//                                                         child: Text(
//                                                           icons[index]['label'],
//                                                           style: const TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 12,
//                                                           ),
//                                                         ),
//                                                       )
//                                                   ],
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               }),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }



