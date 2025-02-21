import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stories_for_flutter/stories_for_flutter.dart';

class FullPageView extends StatefulWidget {
  final List<StoryItem>? storiesMapList;
  final int? storyNumber;
  final TextStyle? fullPagetitleStyle;

  /// Choose whether progress has to be shown
  final bool? displayProgress;

  /// Color for visited region in progress indicator
  final Color? fullpageVisitedColor;

  /// Color for non visited region in progress indicator
  final Color? fullpageUnvisitedColor;

  /// Whether image has to be show on top left of the page
  final bool? showThumbnailOnFullPage;

  /// Size of the top left image
  final double? fullpageThumbnailSize;

  /// Whether image has to be show on top left of the page
  final bool? showStoryNameOnFullPage;

  /// Status bar color in full view of story
  final Color? storyStatusBarColor;

  /// Function to run when page changes
  final Function? onPageChanged;

  /// Duration after which next story is displayed
  /// Default value is infinite.
  final Duration? autoPlayDuration;

  ///

  const FullPageView({
    super.key,
    required this.storiesMapList,
    required this.storyNumber,
    this.fullPagetitleStyle,
    this.displayProgress,
    this.fullpageVisitedColor,
    this.fullpageUnvisitedColor,
    this.showThumbnailOnFullPage,
    this.fullpageThumbnailSize,
    this.showStoryNameOnFullPage,
    this.storyStatusBarColor,
    this.onPageChanged,
    this.autoPlayDuration,
  });
  @override
  FullPageViewState createState() => FullPageViewState();
}

class FullPageViewState extends State<FullPageView> {
  List<StoryItem>? storiesMapList;
  int? storyNumber;
  late List<Widget> combinedList;
  late List listLengths;
  int? selectedIndex;
  PageController? _pageController;
  late bool displayProgress;
  Color? fullpageVisitedColor;
  Color? fullpageUnvisitedColor;
  bool? showThumbnailOnFullPage;
  double? fullpageThumbnailSize;
  late bool showStoryNameOnFullPage;
  Color? storyStatusBarColor;
  Timer? changePageTimer;

  nextPage(index) {
    if (changePageTimer != null) {
      changePageTimer!.cancel();
    }
    if (index == combinedList.length - 1) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      selectedIndex = index + 1;
    });

    _pageController!
        .animateToPage(selectedIndex!, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    initPageChangeTimer();
  }

  prevPage(index) {
    if (changePageTimer != null) {
      changePageTimer!.cancel();
    }
    if (index == 0) return;
    setState(() {
      selectedIndex = index - 1;
    });
    _pageController!
        .animateToPage(selectedIndex!, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    initPageChangeTimer();
  }

  initPageChangeTimer() {
    if (widget.autoPlayDuration != null) {
      changePageTimer = Timer.periodic(widget.autoPlayDuration!, (timer) {
        log("Timer called");
        nextPage(selectedIndex);
      });
    }
  }

  @override
  void initState() {
    storiesMapList = widget.storiesMapList;
    storyNumber = widget.storyNumber;

    combinedList = getStoryList(storiesMapList!);
    listLengths = getStoryLengths(storiesMapList!);
    selectedIndex = getInitialIndex(storyNumber!, storiesMapList);

    displayProgress = widget.displayProgress ?? true;
    fullpageVisitedColor = widget.fullpageVisitedColor;
    fullpageUnvisitedColor = widget.fullpageUnvisitedColor;
    showThumbnailOnFullPage = widget.showThumbnailOnFullPage;
    fullpageThumbnailSize = widget.fullpageThumbnailSize;
    showStoryNameOnFullPage = widget.showStoryNameOnFullPage ?? true;
    storyStatusBarColor = widget.storyStatusBarColor;
    if (((combinedList[selectedIndex ?? 0] as Scaffold).body as Center).child.toString() == "StoryVideoPlayer") {
      changePageTimer?.cancel();
      log("Timer canceled");
    } else {
      initPageChangeTimer();
    }

    super.initState();
  }

  @override
  void dispose() {
    if (changePageTimer != null) changePageTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: selectedIndex!);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: <Widget>[
          // Overlay to detect taps for next page & previous page
          PageView(
            onPageChanged: (page) {
              setState(() {
                selectedIndex = page;
              });
              // Running on pageChanged
              if (widget.onPageChanged != null) widget.onPageChanged!();

              if (((combinedList[page] as Scaffold).body as Center).child.toString() == "StoryVideoPlayer") {
                changePageTimer!.cancel();
                log("Timer canceled");
              }
            },
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: List.generate(
              combinedList.length,
              (index) => Stack(
                children: <Widget>[
                  Scaffold(
                    body: combinedList[index],
                  ),

                  // Overlay to detect taps for next page & previous page
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            prevPage(index);
                          },
                          child: const Center(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            nextPage(index);
                          },
                          child: const Center(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // The progress of story indicator
          Column(
            children: <Widget>[
              Container(
                color: storyStatusBarColor ?? Colors.black,
                child: const SafeArea(
                  child: Center(),
                ),
              ),
              displayProgress
                  ? Row(
                      children: List.generate(
                            numOfCompleted(listLengths as List<int>, selectedIndex!),
                            (index) => Expanded(
                              child: index + 1 == numOfCompleted(listLengths as List<int>, selectedIndex!) &&
                                      widget.autoPlayDuration != null
                                  ? AnimatedProgressBar(
                                      duration: widget.autoPlayDuration!,
                                      endColor: fullpageVisitedColor!,
                                      startColor: fullpageUnvisitedColor!,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(2),
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: fullpageVisitedColor ?? const Color(0xff444444),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                            ),
                          ) +
                          List.generate(
                            getCurrentLength(listLengths as List<int>, selectedIndex!) -
                                numOfCompleted(listLengths as List<int>, selectedIndex!) as int,
                            (index) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                height: 3,
                                decoration: BoxDecoration(
                                  color: widget.fullpageUnvisitedColor ?? Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                    )
                  : const Center(),
              const SizedBox(height: 5),
              // Story name
              InkWell(
                onTap: () {
                  if (widget.onPageChanged != null) {
                    String userId = storiesMapList![getStoryIndex(listLengths as List<int>, selectedIndex!)].userId;
                    widget.onPageChanged!(userId);
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: (showThumbnailOnFullPage == null || showThumbnailOnFullPage!)
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                fit: BoxFit.cover,
                                width: fullpageThumbnailSize ?? 40,
                                height: fullpageThumbnailSize ?? 40,
                                image:
                                    storiesMapList![getStoryIndex(listLengths as List<int>, selectedIndex!)].thumbnail,
                              ),
                            )
                          : const Center(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            showStoryNameOnFullPage
                                ? storiesMapList![getStoryIndex(listLengths as List<int>, selectedIndex!)].name
                                : "",
                            style: widget.fullPagetitleStyle ??
                                const TextStyle(
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.grey,
                                    ),
                                  ],
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //show Time
        ],
      ),
    );
  }
}

List<Widget> getStoryList(List<StoryItem> storiesMapList) {
  List<Widget> imagesList = [];
  for (int i = 0; i < storiesMapList.length; i++) {
    for (int j = 0; j < storiesMapList[i].stories.length; j++) {
      imagesList.add(storiesMapList[i].stories[j]);
    }
  }
  return imagesList;
}

List<int> getStoryLengths(List<StoryItem> storiesMapList) {
  List<int> intList = [];
  int count = 0;
  for (int i = 0; i < storiesMapList.length; i++) {
    count = count + storiesMapList[i].stories.length;
    intList.add(count);
  }
  return intList;
}

int getCurrentLength(List<int> listLengths, int index) {
  index = index + 1;
  int val = listLengths[0];
  for (int i = 0; i < listLengths.length; i++) {
    val = i == 0 ? listLengths[0] : listLengths[i] - listLengths[i - 1];
    if (listLengths[i] >= index) break;
  }
  return val;
}

numOfCompleted(List<int> listLengths, int index) {
  index = index + 1;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    val = listLengths[i];
  }
  return (index - val);
}

getInitialIndex(int storyNumber, List<StoryItem>? storiesMapList) {
  int total = 0;
  for (int i = 0; i < storyNumber; i++) {
    total += storiesMapList![i].stories.length;
  }
  return total;
}

int getStoryIndex(List<int> listLengths, int index) {
  index = index + 1;
  int temp = 0;
  int val = 0;
  for (int i = 0; i < listLengths.length; i++) {
    if (listLengths[i] >= index) break;
    if (temp != listLengths[i]) val += 1;
    temp = listLengths[i];
  }
  return val;
}

class AnimatedProgressBar extends StatefulWidget {
  final Color startColor;
  final Color endColor;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    this.startColor = Colors.white,
    this.endColor = Colors.blue,
    this.duration = const Duration(seconds: 20), // Dynamic duration
  });

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> {
  double progress = 0.0;
  Timer? timer;
  int updateInterval = 100; // Update every 100ms

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  void startProgress() {
    // Total updates needed to complete progress
    int totalUpdates = (widget.duration.inMilliseconds / updateInterval).round();

    timer = Timer.periodic(Duration(milliseconds: updateInterval), (timer) {
      if (progress >= 1.0) {
        timer.cancel();
      } else {
        setState(() {
          progress += 1 / totalUpdates; // Dynamically calculated increment
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background (unvisited part)
        Container(
          margin: const EdgeInsets.all(2),
          height: 3,
          width: MediaQuery.of(context).size.width, // Full width background
          decoration: BoxDecoration(
            color: widget.startColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        // Foreground (animated progress part)
        AnimatedContainer(
          duration: Duration(milliseconds: updateInterval),
          margin: const EdgeInsets.all(2),
          height: 3,
          width: MediaQuery.of(context).size.width * progress, // Expands width
          decoration: BoxDecoration(
            color: widget.endColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
