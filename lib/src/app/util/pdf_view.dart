import 'dart:typed_data';
import 'package:download/download.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:printing/printing.dart';

Future<void> showDialogViewPDF({
  required BuildContext context,
  required Uint8List pdfData,
  required List<Widget> actions,
  required String fileName,
}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _PdfViewerDialog(
        pdfData: pdfData,
        fileName: fileName,
        actions: actions,
      );
    },
  );
}

class _PdfViewerDialog extends StatefulWidget {
  const _PdfViewerDialog({
    required this.pdfData,
    required this.fileName,
    required this.actions,
  });

  final Uint8List pdfData;
  final String fileName;
  final List<Widget> actions;

  @override
  State<_PdfViewerDialog> createState() => _PdfViewerDialogState();
}

class _PdfViewerDialogState extends State<_PdfViewerDialog> {
  late final PdfViewerController _viewerController;
  final TextEditingController _searchTextController = TextEditingController();
  PdfTextSearcher? _textSearcher;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _viewerController = PdfViewerController();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _textSearcher?.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _doSearch() async {
    final query = _searchTextController.text.trim();
    if (query.isEmpty) {
      _textSearcher?.resetTextSearch();
      return;
    }
    _textSearcher?.startTextSearch(query);
  }

  Future<void> _onDownloadPressed() async {
    final name = widget.fileName.endsWith('.pdf')
        ? widget.fileName
        : '${widget.fileName}.pdf';
    await download(
      Stream.fromIterable(widget.pdfData),
      name,
    );
  }

  Future<void> _onPrintPressed() async {
    await Printing.layoutPdf(
      onLayout: (_) async => widget.pdfData,
      name: widget.fileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hasMatches = _textSearcher?.hasMatches ?? false;
    final currentIndex = (_textSearcher?.currentIndex ?? 0) + 1;
    final totalMatches = _textSearcher?.matches.length ?? 0;

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
                    widget.pdfData,
                    sourceName: widget.fileName,
                    controller: _viewerController,
                    params: PdfViewerParams(
                      onViewerReady: (document, controller) {
                        _textSearcher?.dispose();
                        _textSearcher = PdfTextSearcher(controller)
                          ..addListener(_onSearchChanged);
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      textSelectionParams: const PdfTextSelectionParams(),
                      matchTextColor:
                          Colors.yellow.withValues(alpha: 0.4),
                      pagePaintCallbacks: [
                        (canvas, pageRect, page) {
                          _textSearcher?.pageTextMatchPaintCallback(
                            canvas,
                            pageRect,
                            page,
                          );
                        },
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
                        Navigator.of(context).pop();
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
                      if (_showSearchBar)
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
                                  controller: _searchTextController,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: 'Cari teks di PDF...',
                                    border: OutlineInputBorder(),
                                  ),
                                  textInputAction: TextInputAction.search,
                                  onSubmitted: (_) => _doSearch(),
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
                                        await _textSearcher?.goToPrevMatch();
                                      }
                                    : null,
                              ),
                              IconButton(
                                tooltip: 'Next match',
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onPressed: hasMatches
                                    ? () async {
                                        await _textSearcher?.goToNextMatch();
                                      }
                                    : null,
                              ),
                              IconButton(
                                tooltip: 'Clear search',
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchTextController.clear();
                                  _textSearcher?.resetTextSearch();
                                  setState(() {
                                    _showSearchBar = false;
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
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Download',
                                  icon: const Icon(Icons.download),
                                  onPressed: _onDownloadPressed,
                                ),
                                IconButton(
                                  tooltip: 'Print',
                                  icon: const Icon(Icons.print),
                                  onPressed: _onPrintPressed,
                                ),
                                IconButton(
                                  tooltip: 'Search',
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      _showSearchBar = !_showSearchBar;
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
  }
}
