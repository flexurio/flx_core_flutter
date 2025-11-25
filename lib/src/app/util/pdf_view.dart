import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:printing/printing.dart';

Future<void> showDialogViewPDF({
  required BuildContext context,
  required Uint8List pdfData,
  required List<Widget> actions,
  required String fileName,
}) async {
  final viewerController = PdfViewerController();

  final textSearcher = PdfTextSearcher(viewerController);
  final searchTextController = TextEditingController();

  var showSearchBar = false;
  var searchListenerAttached = false;

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    useRootNavigator: true,
    builder: (BuildContext dialogContext) {
      final size = MediaQuery.of(dialogContext).size;

      return StatefulBuilder(
        builder: (context, setState) {
          if (!searchListenerAttached) {
            textSearcher.addListener(() {
              setState(() {});
            });
            searchListenerAttached = true;
          }

          Future<void> doSearch() async {
            final query = searchTextController.text.trim();
            if (query.isEmpty) {
              textSearcher.resetTextSearch();
              return;
            }
            textSearcher.startTextSearch(
              query,
              caseInsensitive: true,
              goToFirstMatch: true,
            );
          }

          Future<void> onDownloadPressed() async {
            await Printing.sharePdf(bytes: pdfData, filename: '$fileName.pdf');
          }

          Future<void> onPrintPressed() async {
            await Printing.layoutPdf(
              onLayout: (_) async => pdfData,
              name: fileName,
            );
          }

          final hasMatches = textSearcher.hasMatches;
          final currentIndex = (textSearcher.currentIndex ?? 0) + 1;
          final totalMatches = textSearcher.matches.length;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(16),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 1000,
                    maxHeight: size.height * 0.9,
                  ),
                  child: Stack(
                    children: [
                      // Area PDF
                      Positioned.fill(
                        child: PdfViewer.data(
                          pdfData,
                          sourceName: fileName,
                          controller: viewerController,
                          params: PdfViewerParams(
                            enableTextSelection: true,
                            matchTextColor: Colors.yellow.withOpacity(0.4),
                            pagePaintCallbacks: [
                              textSearcher.pageTextMatchPaintCallback,
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.black54,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: 'Tutup',
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showSearchBar)
                              Container(
                                color: const Color(0xFFEEE8F8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: searchTextController,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          hintText: 'Cari teks di PDF...',
                                          border: OutlineInputBorder(),
                                        ),
                                        textInputAction: TextInputAction.search,
                                        onSubmitted: (_) => doSearch(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Info jumlah match
                                    if (hasMatches)
                                      Text('$currentIndex / $totalMatches'),
                                    const SizedBox(width: 8),
                                    // Prev / Next match
                                    IconButton(
                                      tooltip: 'Prev match',
                                      icon: const Icon(Icons.keyboard_arrow_up),
                                      onPressed: hasMatches
                                          ? () async {
                                              await textSearcher
                                                  .goToPrevMatch();
                                            }
                                          : null,
                                    ),
                                    IconButton(
                                      tooltip: 'Next match',
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      onPressed: hasMatches
                                          ? () async {
                                              await textSearcher
                                                  .goToNextMatch();
                                            }
                                          : null,
                                    ),
                                    IconButton(
                                      tooltip: 'Clear search',
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        searchTextController.clear();
                                        textSearcher.resetTextSearch();
                                        setState(() {
                                          showSearchBar = false;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            // Bar aksi utama
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: const Color(0xFFEDE6F3),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: 'Download',
                                        icon: const Icon(Icons.download),
                                        onPressed: onDownloadPressed,
                                      ),
                                      IconButton(
                                        tooltip: 'Print',
                                        icon: const Icon(Icons.print),
                                        onPressed: onPrintPressed,
                                      ),
                                      IconButton(
                                        tooltip: 'Search',
                                        icon: const Icon(Icons.search),
                                        onPressed: () {
                                          setState(() {
                                            showSearchBar = !showSearchBar;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );

  // Cleanup ketika dialog sudah ditutup
  searchTextController.dispose();
  textSearcher.dispose();
}
