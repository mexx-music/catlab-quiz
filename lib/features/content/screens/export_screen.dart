import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:catlab_quiz/features/content/data/export_service.dart';
import 'package:catlab_quiz/l10n/app_localizations.dart';
import 'package:catlab_quiz/shared/theme/app_theme.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final _service = ExportService();
  bool _loading = true;
  String _json = '';
  String _csv = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _service.load();
    if (mounted) {
      setState(() {
        _json = _service.toJsonString();
        _csv = _service.toCsvString();
        _loading = false;
      });
    }
  }

  Future<void> _copy(BuildContext context, String text, String msg) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppTheme.textDark),
        title: Text(l10n.exportTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 20),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatsRow(service: _service, l10n: l10n),
                  const SizedBox(height: 24),
                  _ExportBlock(
                    title: 'JSON',
                    subtitle: '${_service.totalPosts} Posts · RFC JSON',
                    preview: _jsonPreview(_json),
                    fullText: _json,
                    copyLabel: l10n.copyJson,
                    onCopy: () => _copy(context, _json, l10n.jsonCopied),
                  ),
                  const SizedBox(height: 16),
                  _ExportBlock(
                    title: 'CSV',
                    subtitle: '${_service.totalPosts} rows · RFC 4180',
                    preview: _csvPreview(_csv),
                    fullText: _csv,
                    copyLabel: l10n.copyCsv,
                    onCopy: () => _copy(context, _csv, l10n.csvCopied),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.schedulerHint,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Show first ~600 chars with a line-count note
  static String _jsonPreview(String json) {
    const max = 600;
    if (json.length <= max) return json;
    final total = json.split('\n').length;
    return '${json.substring(0, max)}\n\n... ($total Zeilen gesamt)';
  }

  // Show header + first 4 data rows
  static String _csvPreview(String csv) {
    final lines = csv.split('\n');
    final preview = lines.take(5).join('\n');
    if (lines.length <= 5) return preview;
    return '$preview\n\n... (${lines.length - 1} Zeilen gesamt)';
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final ExportService service;
  final AppLocalizations l10n;
  const _StatsRow({required this.service, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: l10n.quizbooks, value: '${service.quizCount}',
              color: AppTheme.primary),
          _Stat(label: l10n.postsTotalLabel, value: '${service.totalPosts}',
              color: AppTheme.textDark),
          _Stat(label: l10n.openPostsLabel, value: '${service.openPosts}',
              color: Colors.grey.shade500),
          _Stat(label: l10n.donePostsLabel, value: '${service.completedPosts}',
              color: Colors.green),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style:
                TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center),
      ],
    );
  }
}

// ── Export block (preview + copy button) ─────────────────────────────────────

class _ExportBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String preview;
  final String fullText;
  final String copyLabel;
  final VoidCallback onCopy;

  const _ExportBlock({
    required this.title,
    required this.subtitle,
    required this.preview,
    required this.fullText,
    required this.copyLabel,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark),
            ),
            const SizedBox(width: 8),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          constraints: const BoxConstraints(maxHeight: 220),
          child: SingleChildScrollView(
            child: Text(
              preview,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textDark,
                  fontFamily: 'monospace'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.copy, size: 14),
            label: Text(copyLabel,
                style: const TextStyle(fontSize: 13)),
            onPressed: onCopy,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primary,
              side: const BorderSide(color: AppTheme.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
}
