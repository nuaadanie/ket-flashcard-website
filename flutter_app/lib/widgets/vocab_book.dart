import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../services/speech_service.dart';
import '../services/storage_service.dart';

class VocabBookDialog extends StatefulWidget {
  final List<Word> allWords;
  final StorageService storage;
  final SpeechService speech;

  const VocabBookDialog({
    super.key,
    required this.allWords,
    required this.storage,
    required this.speech,
  });

  @override
  State<VocabBookDialog> createState() => _VocabBookDialogState();
}

class _VocabBookDialogState extends State<VocabBookDialog> {
  String _tab = 'unknown';
  String _levelFilter = '';
  String _topicFilter = '';
  bool _isExporting = false;

  List<Word> get _filtered {
    List<Word> words;
    switch (_tab) {
      case 'mastered':
        words = widget.allWords
            .where((w) => widget.storage.mastered.contains(w.id))
            .toList();
        break;
      case 'unknown':
        words = widget.allWords
            .where((w) => widget.storage.unknown.contains(w.id))
            .toList();
        break;
      default:
        words = widget.allWords;
    }
    if (_levelFilter.isNotEmpty) {
      words = words.where((w) => w.level == _levelFilter).toList();
    }
    if (_topicFilter.isNotEmpty) {
      words = words.where((w) => w.topic == _topicFilter).toList();
    }
    return words;
  }

  String get _tabTitle {
    switch (_tab) {
      case 'mastered': return '已会单词本';
      case 'unknown': return '不会单词本';
      default: return 'KET核心词汇大全';
    }
  }

  Future<void> _exportPdf() async {
    if (_isExporting) return;
    final words = _filtered;
    if (words.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('没有可导出的单词'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    setState(() => _isExporting = true);

    try {
      final font = await PdfGoogleFonts.notoSansSCRegular();
      final fontBold = await PdfGoogleFonts.notoSansSCBold();
    final pdf = pw.Document();
    final title = _tabTitle;

    // 每页约30个单词
    const perPage = 30;
    for (var i = 0; i < words.length; i += perPage) {
      final chunk = words.skip(i).take(perPage).toList();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (ctx) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (i == 0) ...[
                  pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 20)),
                  pw.SizedBox(height: 4),
                  pw.Text('总词数: ${words.length}', style: pw.TextStyle(font: font, fontSize: 12)),
                  pw.SizedBox(height: 12),
                ],
                ...chunk.asMap().entries.map((entry) {
                  final idx = i + entry.key + 1;
                  final w = entry.value;
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      children: [
                        pw.SizedBox(
                          width: 30,
                          child: pw.Text('$idx.', style: pw.TextStyle(font: font, fontSize: 10)),
                        ),
                        pw.SizedBox(
                          width: 100,
                          child: pw.Text(w.word, style: pw.TextStyle(font: fontBold, fontSize: 11)),
                        ),
                        pw.SizedBox(
                          width: 80,
                          child: pw.Text(w.phonetic, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey600)),
                        ),
                        pw.Expanded(
                          child: pw.Text(w.meaning, style: pw.TextStyle(font: font, fontSize: 10)),
                        ),
                        pw.SizedBox(
                          width: 40,
                          child: pw.Text(w.level, style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey700)),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          },
        ),
      );
    }

    await Printing.sharePdf(bytes: await pdf.save(), filename: '$title.pdf');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topics = widget.allWords.map((w) => w.topic).toSet().toList()..sort();
    final filtered = _filtered;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Dialog(
      backgroundColor: surfaceColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        side: microBorder(context),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 24 : 16,
        vertical: isLandscape ? 8 : 24,
      ),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * (isLandscape ? 0.92 : 0.8),
        ),
        padding: EdgeInsets.all(isLandscape ? 12 : 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Row(
              children: [
                Text('单词本',
                    style: TextStyle(
                        fontSize: isLandscape ? 18 : 22,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.picture_as_pdf, color: stichTertiary),
                        tooltip: '导出PDF',
                        onPressed: _exportPdf,
                      ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: isLandscape ? 6 : 12),
            // Tab + 筛选
            if (isLandscape)
              _buildFiltersRow(topics)
            else ...[
              _buildTabs(),
              const SizedBox(height: 12),
              _buildFilterDropdowns(topics),
            ],
            SizedBox(height: isLandscape ? 6 : 12),
            // 列表
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('暂无单词',
                          style: TextStyle(color: Colors.grey, fontSize: 16)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemExtent: isLandscape ? 48 : 64,
                      itemBuilder: (ctx, i) =>
                          _buildWordTile(filtered[i], isLandscape),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 横屏：tab和筛选放一行
  Widget _buildFiltersRow(List<String> topics) {
    return Row(
      children: [
        _tabBtn('不会', 'unknown', compact: true),
        const SizedBox(width: 4),
        _tabBtn('已会', 'mastered', compact: true),
        const SizedBox(width: 4),
        _tabBtn('全部', 'all', compact: true),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: DropdownButtonFormField<String>(
            value: _levelFilter.isEmpty ? null : _levelFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            hint: const Text('级别', style: TextStyle(fontSize: 12)),
            style: TextStyle(fontSize: 12, color: onSurfaceColor(context)),
            items: [
              const DropdownMenuItem(value: '', child: Text('所有')),
              for (final l in ['黑1', '蓝2', '红3'])
                DropdownMenuItem(value: l, child: Text(l)),
            ],
            onChanged: (v) => setState(() => _levelFilter = v ?? ''),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _topicFilter.isEmpty ? null : _topicFilter,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              isDense: true,
            ),
            isExpanded: true,
            hint: const Text('主题', style: TextStyle(fontSize: 12)),
            style: TextStyle(fontSize: 12, color: onSurfaceColor(context)),
            items: [
              const DropdownMenuItem(value: '', child: Text('所有')),
              for (final t in topics)
                DropdownMenuItem(
                    value: t, child: Text(t, overflow: TextOverflow.ellipsis)),
            ],
            onChanged: (v) => setState(() => _topicFilter = v ?? ''),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _tabBtn('不会单词', 'unknown'),
        const SizedBox(width: 8),
        _tabBtn('已会单词', 'mastered'),
        const SizedBox(width: 8),
        _tabBtn('全部单词', 'all'),
      ],
    );
  }

  Widget _buildFilterDropdowns(List<String> topics) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _levelFilter.isEmpty ? null : _levelFilter,
            decoration: InputDecoration(
              labelText: '级别',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: [
              const DropdownMenuItem(value: '', child: Text('所有级别')),
              for (final l in ['黑1', '蓝2', '红3'])
                DropdownMenuItem(value: l, child: Text(l)),
            ],
            onChanged: (v) => setState(() => _levelFilter = v ?? ''),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _topicFilter.isEmpty ? null : _topicFilter,
            decoration: InputDecoration(
              labelText: '主题',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kBorderRadius),
                borderSide: microBorder(context),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            isExpanded: true,
            items: [
              const DropdownMenuItem(value: '', child: Text('所有主题')),
              for (final t in topics)
                DropdownMenuItem(
                    value: t, child: Text(t, overflow: TextOverflow.ellipsis)),
            ],
            onChanged: (v) => setState(() => _topicFilter = v ?? ''),
          ),
        ),
      ],
    );
  }

  Widget _buildWordTile(Word w, bool compact) {
    final color = levelColors[w.level] ?? Colors.grey;
    return ListTile(
      dense: compact,
      visualDensity: compact ? const VisualDensity(vertical: -4) : null,
      contentPadding: EdgeInsets.symmetric(horizontal: compact ? 4 : 16),
      title: Row(
        children: [
          Text(w.word,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 14 : 16)),
          const SizedBox(width: 6),
          Text(w.phonetic,
              style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: compact ? 11 : 13)),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Text(w.level,
                style: TextStyle(
                    color: Colors.white, fontSize: compact ? 9 : 10)),
          ),
        ],
      ),
      subtitle: compact
          ? null
          : Text(w.meaning, style: const TextStyle(fontSize: 13)),
      trailing: compact
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(w.meaning,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => widget.speech.speak(w.word),
                  child: const Icon(Icons.volume_up, color: stichSecondary, size: 18),
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.volume_up, color: stichSecondary),
              onPressed: () => widget.speech.speak(w.word),
            ),
    );
  }

  Widget _tabBtn(String label, String tab, {bool compact = false}) {
    final active = _tab == tab;
    return GestureDetector(
      onTap: () => setState(() => _tab = tab),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: active ? stichPrimary : Colors.grey[200],
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: compact ? 12 : 14,
          ),
        ),
      ),
    );
  }
}
