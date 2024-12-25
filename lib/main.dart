import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MacOSDock());
}

class MacOSDock extends StatelessWidget {
  const MacOSDock({super.key});

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
        body: Stack(
            children: [
              Align(alignment: Alignment.bottomCenter, child: Dock(), ),
            ],
          )
        
      ),
    );
  }
}


class Dock extends StatefulWidget {
  const Dock({super.key});

  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> {
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

  void minimizeApp(String app) {
    setState(() {
      minimizedApps.add(app);
    });
  }

  void restoreApp(String app) {
    setState(() {
      minimizedApps.remove(app);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minimized Apps Section
        if (minimizedApps.isNotEmpty && !isMinimized)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: minimizedApps.map((app) {
                return GestureDetector(
                  onTap: () => restoreApp(app),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      app,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        // Dock Section
        AnimatedContainer(
          duration: Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
          width: isMinimized ? 60 : null,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: isMinimized ? 10 : 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                            Colors.white.withAlpha(51), // 0.2 * 255 = 51
                            Colors.white.withAlpha(13), // 0.05 * 255 = 13
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withAlpha(76),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        // BoxShadow(color: Colors.black26, blurRadius: 10),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: isMinimized
                          ? Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24,
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(icons.length, (index) {
                                return DragTarget<Map<String, dynamic>>(
                                  onAccept: (data) {
                                    setState(() {
                                      icons.remove(data);
                                      icons.insert(index, data);
                                      draggedIndex = -1;
                                    });
                                  },
                                  onWillAccept: (data) {
                                    setState(() => draggedIndex = index);
                                    return true;
                                  },
                                  builder: (context, candidateData, rejectedData) {
                                    return AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      margin: draggedIndex == index
                                          ? EdgeInsets.symmetric(horizontal: 20.0)
                                          : EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Draggable<Map<String, dynamic>>(
                                        data: icons[index],
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: Icon(
                                            icons[index]['icon'],
                                            size: 48,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.5,
                                          child: Icon(
                                            icons[index]['icon'],
                                            size: 48,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onDragStarted: () => setState(() => draggedIndex = index),
                                        onDragEnd: (_) => setState(() => draggedIndex = -1),
                                        child: MouseRegion(
                                          onEnter: (_) {
                                            if (draggedIndex == -1) {
                                              setState(() => hoveredIndex = index);
                                            }
                                          },
                                          onExit: (_) {
                                            if (draggedIndex == -1) {
                                              setState(() => hoveredIndex = -1);
                                            }
                                          },
                                          child: TweenAnimationBuilder<double>(
                                            duration: Duration(milliseconds: 200),
                                            tween: Tween<double>(
                                              begin: 48,
                                              end: hoveredIndex == index ? 64 : 48,
                                            ),
                                            builder: (context, size, child) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    icons[index]['icon'],
                                                    size: size,
                                                    color: Colors.white,
                                                  ),
                                                  if (hoveredIndex == index)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 5.0),
                                                      child: Text(
                                                        icons[index]['label']!,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                    ),
                  ),
                ),
              ),
              // Minimize Button
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => setState(() => isMinimized = !isMinimized),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isMinimized ? Icons.chevron_right : Icons.chevron_left,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



