import 'package:flutter/material.dart';

class YuhuTableLayout extends StatelessWidget {
  final double startWidth;
  final double endWidth;
  final double actualScrollWidth;
  final double totalCenterWidth;
  final double totalTableWidth;
  final Widget centerTable;
  final Widget? leftPinnedTable;
  final Widget? rightPinnedTable;
  final ScrollController horizontalScrollController;
  final BoxDecoration decoration;

  const YuhuTableLayout({
    super.key,
    required this.startWidth,
    required this.endWidth,
    required this.actualScrollWidth,
    required this.totalCenterWidth,
    required this.totalTableWidth,
    required this.centerTable,
    required this.horizontalScrollController,
    required this.decoration,
    this.leftPinnedTable,
    this.rightPinnedTable,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: decoration,
        child: SizedBox(
          width: totalTableWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: startWidth,
                  right: endWidth,
                ),
                child: SizedBox(
                  width: actualScrollWidth,
                  child: Scrollbar(
                    controller: horizontalScrollController,
                    interactive: true,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: SizedBox(
                        width: totalCenterWidth,
                        child: centerTable,
                      ),
                    ),
                  ),
                ),
              ),
              if (leftPinnedTable != null)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: startWidth,
                  child: leftPinnedTable!,
                ),
              if (rightPinnedTable != null)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: endWidth,
                  child: rightPinnedTable!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
