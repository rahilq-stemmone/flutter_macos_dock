import 'dart:ui';

import 'package:flutter/material.dart';

class Dock extends StatefulWidget {
  const Dock({super.key});

  @override
  _DockState createState() => _DockState();
}

class _DockState extends State<Dock> with SingleTickerProviderStateMixin {
  int hoveredIndex = -1;
  int draggedIndex = -1;
  List<String> minimizedApps = [];
  bool isMinimized = false;

  Map<String, dynamic> tempRemovedIcon = {};

  late AnimationController iconControllerAfterRelease;
  late Animation<Offset> iconAfterReleaseAnimation;

  Offset iconAfterRealseOffsetEnd = Offset(0, 0);
  Offset iconAfterRealseOffsetBegin = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    iconControllerAfterRelease = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    iconAfterReleaseAnimation = Tween<Offset>(
      begin: iconAfterRealseOffsetBegin,
      end:
          iconAfterRealseOffsetEnd, // Offset values in multiples of container size
    ).animate(CurvedAnimation(
        parent: iconControllerAfterRelease, curve: Curves.easeInOut));
  }

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

  final List<Map<String, dynamic>> icons = [
    {'icon': Icons.home, 'label': 'Home'},
    // {},
    {'icon': Icons.search, 'label': 'Search'},
    // {},
    {'icon': Icons.settings, 'label': 'Settings'},
    // {},
    {'icon': Icons.info, 'label': 'Info'},
    // {},
    {'icon': Icons.file_copy, 'label': 'file_copy'},
    // {},
    {'icon': Icons.camera_alt, 'label': 'camera_alt'},
    // {},
    {'icon': Icons.phone, 'label': 'phone'},
    // {},
    {'icon': Icons.mail, 'label': 'mail'},
    // {},
    {'icon': Icons.movie, 'label': 'movie'},
    // {},
    {'icon': Icons.games, 'label': 'games'},
    // {},
    {'icon': Icons.book, 'label': 'book'},
    // {},
    {'icon': Icons.chat, 'label': 'chat'},
    // {},
    {'icon': Icons.map, 'label': 'map'},
  ];

  List<GlobalKey> keys = [];

  bool isInsideDock = false;

  getEndSize(int index) {
    // print("-----------------");
    // print("getEndSize $index");
    // print("hoveredIndex $hoveredIndex");
    // print("draggedIndex $draggedIndex");
    //   print("-----------------");
    if (hoveredIndex == -1) {
      return isInsideDock ? 34 : 30;
    }
    if (hoveredIndex == index) {
      return 50;
    } else if (index == hoveredIndex - 1 || index == hoveredIndex + 1) {
      return 40;
    } else if (index == hoveredIndex - 2 || index == hoveredIndex + 2) {
      return 35;
    } else if (draggedIndex == index) {
      return 48;
    } else {
      return 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("isInsideDock $isInsideDock");
    return MouseRegion(
      onExit: (_) {
        setState(() {
          hoveredIndex = -1;
          isInsideDock = false;
        });
      },
      onEnter: (event) {
        print("onEnter ${event.position}");

        setState(() {
          isInsideDock = false;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minimized Apps Section
          if (minimizedApps.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: minimizedApps.map((String app) {
                  return GestureDetector(
                    onTap: () => restoreApp(app),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: Text(
                        app,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Dock Section
          Stack(
            children: [
              MouseRegion(
                onEnter: (_) {
                  setState(() {
                    isInsideDock = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    isInsideDock = false;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      height: 105,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: isMinimized ? 10 : 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withAlpha(51),
                            Colors.white.withAlpha(13),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withAlpha(76),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(icons.length, (index) {
                            return Tooltip(
                              preferBelow: false,
                              margin: const EdgeInsets.only(bottom: 50.0),
                              // padding: const EdgeInsets.only(bottom: 500.0),
                                message: icons[index]['label'],
                                // decoration: ,
                              child: DragTarget<Map<String, dynamic>>(
                                onAcceptWithDetails: (details) {
                                  print("${details.offset} onAcceptWithDetails");
                                  print("onAcceptWithDetails ${details.data}");
                                  print("onAcceptWithDetails ${details}");
                                  setState(() {
                                    bool isGettingPlacedOnTheRightSide = false;
                                    if (icons.indexOf(details.data) < index) {
                                      isGettingPlacedOnTheRightSide = true;
                                    }
                                    icons.remove(details.data);
                              
                                    icons.insert(
                                        isGettingPlacedOnTheRightSide
                                            ? index - 1
                                            : index,
                                        details.data);
                                    draggedIndex = -1;
                              
                                    print(
                                        "isGettingPlacedOnRightSide ${isGettingPlacedOnTheRightSide}");
                                  });
                                },
                                onWillAcceptWithDetails: (data) {
                                  print("onWillAcceptWithDetails ${data.data}");
                                  setState(() {
                                    draggedIndex = index;
                                    hoveredIndex = index;
                                  });
                              
                                  return true;
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: EdgeInsets.only(
                                        bottom: getBottomPadding(index)),
                                    margin: draggedIndex == index
                                        ? EdgeInsets.only(
                                            left: !isInsideDock
                                                ? 0.0
                                                : icons.indexOf(icons.last) ==
                                                        index
                                                    ? 5.0
                                                    : 75.0,
                                            right:
                                                icons.indexOf(icons.last) == index
                                                    ? 75.0
                                                    : 5.0)
                                        : const EdgeInsets.symmetric(
                                            horizontal: 5),
                                    child:
                                        LongPressDraggable<Map<String, dynamic>>(
                                      data: icons[index],
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: Tooltip(
                                          message: icons[index]['label'],
                                          child: Container(
                                            key: GlobalKey(
                                                debugLabel:
                                                    "keyOF${icons[index]['label']}"),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10.0),
                                            decoration: BoxDecoration(
                                              color: hoveredIndex == index
                                                  ? Colors.blue
                                                  : Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  8.0, 8.0, 8.0, 8.0),
                                              child: Icon(
                                                icons[index]['icon'],
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      childWhenDragging: SizedBox.shrink(),
                                      onDragStarted: () {
                                        setState(() {
                                          
                                          tempRemovedIcon = icons[index];
                                          // icons.remove(icons[index]);
                                          draggedIndex = index;
                                        });
                                      },
                                      delay: Duration(milliseconds: 100),
                                      // dragAnchorStrategy:
                                      //     (draggable, context, position) {
                                      //   return position;
                                      // },
                                      onDragEnd: (details) {
                                        print("${details.offset}onDragEnd");
                                        setState(() => draggedIndex = -1);
                                      },
                                      child: GestureDetector(
                                        onTap: () {
                                          final appLabel = icons[index]['label'];
                                          if (minimizedApps.contains(appLabel)) {
                                            restoreApp(appLabel);
                                          } else {
                                            minimizeApp(appLabel);
                                          }
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) async {
                                            await onMouseEnterFromIcon(index);
                                          },
                                          onExit: (_) async {
                                            await onMouseExitFromIcon();
                                          },
                                          child: TweenAnimationBuilder<double>(
                                            duration:
                                                const Duration(milliseconds: 300),
                                            tween: Tween<double>(
                                              begin: 30,
                                              end: getEndSize(index),
                                              //  hoveredIndex == index ? 48 : 30,
                                            ),
                                            builder: (context, size, child) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: hoveredIndex == index
                                                          ? Colors.blue
                                                          : Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          8.0, 8.0, 8.0, 8.0),
                                                      child: Icon(
                                                        icons[index]['icon'],
                                                        size: size,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  if (minimizedApps.contains(
                                                      icons[index]['label']))
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 5,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double getBottomPadding(int index) {
    double bottomPadding = 0.0;

    if (hoveredIndex == index) {
      bottomPadding = 5.0;
    } else if (hoveredIndex == index - 1 || hoveredIndex == index + 1) {
      bottomPadding = 5.0;
    } else if (hoveredIndex == index - 2 || hoveredIndex == index + 2) {
      bottomPadding = 5.0;
    }

    return bottomPadding;
  }

  onMouseExitFromIcon() async {
    // await Future.delayed(Duration(milliseconds: 100));
    //  if (draggedIndex == -1) {
    setState(() {
      hoveredIndex = -1;
      // isInsideDock = false;
    });

    // }
  }

  onMouseEnterFromIcon(int index) async {
    // await Future.delayed(Duration(milliseconds: 400));
    //  if (draggedIndex == -1) {
    setState(() {
      hoveredIndex = index;
      isInsideDock = true;
    });
    // }
  }
}
