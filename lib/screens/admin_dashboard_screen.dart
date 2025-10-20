// ===============================
// File: lib/screens/admin/admin_dashboard_screen.dart
// Professional Admin Dashboard with Universal Search (Overflow-safe AppBar)
// ===============================
// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/tokens.dart';
import 'admin_login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _firestore = FirebaseFirestore.instance;

  static const String _peopleCollection = 'people';
  static const int _batchSize = 500;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
      );
    }
  }

  Future<void> _deleteDocument(String collection, String docId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestore.collection(collection).doc(docId).delete();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Record deleted successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _importJsonFromFile() async {
    if (!kIsWeb) {
      _toast('Bulk import is only available on Flutter Web.', Colors.orange);
      return;
    }

    try {
      final input = html.FileUploadInputElement()
        ..accept = '.json'
        ..click();

      await input.onChange.first;
      final file = (input.files ?? []).isNotEmpty ? input.files!.first : null;
      if (file == null) return;

      final reader = html.FileReader();
      reader.readAsText(file);
      await reader.onLoadEnd.first;

      final content = reader.result?.toString() ?? '';
      if (content.isEmpty) {
        _toast('Selected file is empty.', Colors.orange);
        return;
      }

      final parsed = jsonDecode(content);
      if (parsed is! List) {
        _toast('Top-level JSON must be an array of objects.', Colors.red);
        return;
      }

      final records = parsed.cast<dynamic>();
      final total = records.length;
      if (total == 0) {
        _toast('No records found in JSON.', Colors.orange);
        return;
      }

      final imported = ValueNotifier<int>(0);
      _showProgressDialog(total: total, imported: imported);

      WriteBatch batch = _firestore.batch();
      int inBatch = 0;
      int done = 0;

      for (final rec in records) {
        if (rec is! Map<String, dynamic>) continue;

        final docId = _buildDocId(rec);
        final mapped = _mapRecord(rec);
        final docRef = _firestore.collection(_peopleCollection).doc(docId);

        batch.set(docRef, mapped, SetOptions(merge: true));
        inBatch++;
        done++;
        imported.value = done;

        if (inBatch >= _batchSize) {
          await batch.commit();
          batch = _firestore.batch();
          inBatch = 0;
        }
      }
      if (inBatch > 0) {
        await batch.commit();
      }

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      _toast('Imported $total records successfully!', Colors.green);
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).maybePop();
        _toast('Import failed: $e', Colors.red);
      }
    }
  }

  void _showProgressDialog({
    required int total,
    required ValueNotifier<int> imported,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.cloud_upload, color: AppColors.blue600),
              SizedBox(width: 12),
              Text('Importing Data'),
            ],
          ),
          content: ValueListenableBuilder<int>(
            valueListenable: imported,
            builder: (_, value, __) {
              final pct = (value / total * 100)
                  .clamp(0, 100)
                  .toStringAsFixed(1);
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: total == 0 ? null : value / total,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.blue600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$value of $total records',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$pct% complete',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColors.blue600,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please keep this tab open',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _toast(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String? _cleanText(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    if (s.toUpperCase() == 'NA' || s.toUpperCase() == 'AS ABOVE') return null;
    return s;
  }

  num? _cleanNumberLike(dynamic v) {
    if (v == null) return null;
    final digits = v.toString().replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return null;
    return num.tryParse(digits);
  }

  List<String> _splitMobiles(dynamic raw) {
    if (raw == null) return const [];
    return raw
        .toString()
        .split(RegExp(r'[\/,\n,;]|\\s{2,}'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.toUpperCase() != 'NA')
        .toList(growable: false);
  }

  String _buildDocId(Map<String, dynamic> r) {
    final cnic = _cleanText(r['CNIC No']) ?? 'no_cnic';
    final plot = _cleanText(r['Plot No']) ?? 'no_plot';
    final sno = _cleanText(r['SNO'] ?? r['S.NO']) ?? 'no_sno';
    return '$cnic\_$plot\_$sno'.replaceAll(RegExp(r'[\/\s]+'), '-');
  }

  Map<String, dynamic> _mapRecord(Map<String, dynamic> r) {
    final nameRaw = r['NAME OF VOTERS\n,FATHER/HUSBAND NAME'];
    return {
      'sNo': _cleanText(r['SNO'] ?? r['S.NO']),
      'ref': _cleanText(r['REF']),
      'name': _cleanText(nameRaw),
      'address': _cleanText(r['AND ADDRESS']),
      'cnic': _cleanText(r['CNIC No']),
      'membershipNo': _cleanText(r['M.Ship No']),
      'plotNo': _cleanText(r['Plot No']),
      'street': _cleanText(r['Street']),
      'block': _cleanText(r['Block']),
      'dueAmountRaw': _cleanText(r['Due Amount']),
      'dueAmount': _cleanNumberLike(r['Due Amount']),
      'mobileNumbers': _splitMobiles(r['Mobile Number']),
      'countOfNumbers': _cleanNumberLike(r['Count of Number']),
      'rowRaw': _cleanText(r['ROW']),
      'name_lower': nameRaw == null ? null : nameRaw.toString().toLowerCase(),
      'createdAt': FieldValue.serverTimestamp(),
      'source': 'admin_import_web',
    };
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final screenW = MediaQuery.of(context).size.width;
    final showEmailChip = screenW >= 900; // hide chip on narrow widths

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 8,
        title: const _AppBarTitleBox(), // <— adaptive, overflow-safe
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true, // helps on small screens
                labelColor: AppColors.blue600,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.blue600,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.people), text: 'People'),
                  Tab(icon: Icon(Icons.contact_mail), text: 'Contact Forms'),
                  Tab(icon: Icon(Icons.mail), text: 'Newsletters'),
                  Tab(icon: Icon(Icons.cloud_upload), text: 'Bulk Import'),
                ],
              ),
              Container(height: 1, color: Colors.grey[200]),
            ],
          ),
        ),
        actions: [
          if (showEmailChip)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle, size: 18, color: Colors.grey[700]),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      user?.email ?? '',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Logout',
              style: IconButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PeopleTab(
            collection: _peopleCollection,
            onDelete: (docId) => _deleteDocument(_peopleCollection, docId),
          ),
          _ContactSubmissionsTab(
            onDelete: (docId) => _deleteDocument('contact_submissions', docId),
          ),
          _NewsletterSubscribersTab(
            onDelete: (docId) =>
                _deleteDocument('newsletter_subscribers', docId),
          ),
          _BulkImportTab(onImport: _importJsonFromFile),
        ],
      ),
    );
  }
}

/// Adaptive title that *never* overflows the AppBar middle slot.
/// It switches between: hidden (ultra-tight), icon-only (tight), compact, and full.
class _AppBarTitleBox extends StatelessWidget {
  const _AppBarTitleBox();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;

        // When the middle slot is effectively zero-width, render nothing.
        if (w < 48) {
          return const SizedBox.shrink();
        }

        // Very tight: show just the shield icon (32x32).
        if (w < 120) {
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.blue600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 18,
            ),
          );
        }

        // Compact: icon + short label.
        if (w < 200) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.blue600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Admin',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          );
        }

        // Full: icon + full title, ellipsized if still tight.
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.blue600,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320),
              child: Text(
                'Admin Dashboard',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ===============================
// PEOPLE TAB with UNIVERSAL SEARCH
// ===============================
class _PeopleTab extends StatefulWidget {
  final String collection;
  final Function(String) onDelete;

  const _PeopleTab({required this.collection, required this.onDelete});

  @override
  State<_PeopleTab> createState() => _PeopleTabState();
}

class _PeopleTabState extends State<_PeopleTab> {
  final _searchCtrl = TextEditingController();
  List<DocumentSnapshot> _allDocs = [];
  List<DocumentSnapshot> _filteredDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _searchCtrl.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(widget.collection)
          .get();

      setState(() {
        _allDocs = snapshot.docs;
        _filteredDocs = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _performSearch() {
    final query = _searchCtrl.text.trim().toLowerCase();

    if (query.isEmpty) {
      setState(() => _filteredDocs = _allDocs);
      return;
    }

    setState(() {
      _filteredDocs = _allDocs.where((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};

        // Search in all relevant fields
        final name = (data['name'] ?? '').toString().toLowerCase();
        final cnic = (data['cnic'] ?? '').toString().toLowerCase();
        final plot = (data['plotNo'] ?? '').toString().toLowerCase();
        final address = (data['address'] ?? '').toString().toLowerCase();
        final block = (data['block'] ?? '').toString().toLowerCase();
        final street = (data['street'] ?? '').toString().toLowerCase();
        final membership = (data['membershipNo'] ?? '')
            .toString()
            .toLowerCase();
        final phones =
            (data['mobileNumbers'] as List?)?.join(' ').toLowerCase() ?? '';

        return name.contains(query) ||
            cnic.contains(query) ||
            plot.contains(query) ||
            address.contains(query) ||
            block.contains(query) ||
            street.contains(query) ||
            membership.contains(query) ||
            phones.contains(query);
      }).toList();
    });
  }

  void _openAdd() {
    showDialog(
      context: context,
      builder: (_) => _PersonDialog(
        title: 'Add New Person',
        onSave: (docId, data) async {
          final col = FirebaseFirestore.instance.collection(widget.collection);
          if (docId == null || docId.isEmpty) {
            await col.add({
              ...data,
              'createdAt': FieldValue.serverTimestamp(),
              'source': 'admin_manual',
            });
          } else {
            await col.doc(docId).set({
              ...data,
              'createdAt': FieldValue.serverTimestamp(),
              'source': 'admin_manual',
            }, SetOptions(merge: true));
          }
          _loadAllData();
        },
      ),
    );
  }

  void _openEdit(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    showDialog(
      context: context,
      builder: (_) => _PersonDialog(
        title: 'Edit Person',
        existingDocId: doc.id,
        existing: data,
        onSave: (docId, newData) async {
          final col = FirebaseFirestore.instance.collection(widget.collection);

          if (docId != null && docId != doc.id && docId.isNotEmpty) {
            await col.doc(docId).set({
              ...newData,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
            await col.doc(doc.id).delete();
          } else {
            await col.doc(doc.id).set({
              ...newData,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }
          _loadAllData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Modern Search Bar
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: Column(
            children: [
              LayoutBuilder(
                builder: (_, c) {
                  final narrow = c.maxWidth < 720;
                  final searchField = Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: InputDecoration(
                        hintText:
                            'Search by name, CNIC, plot, phone, address, or any field...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.blue600,
                        ),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () => _searchCtrl.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  );

                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        searchField,
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _openAdd,
                              icon: const Icon(Icons.add, size: 20),
                              label: const Text('Add New'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: _loadAllData,
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Refresh',
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _CounterRow(
                                  filtered: _filteredDocs.length,
                                  total: _allDocs.length,
                                  hasQuery: _searchCtrl.text.isNotEmpty,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _openAdd,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add New'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _loadAllData,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _CounterRow(
                            filtered: _filteredDocs.length,
                            total: _allDocs.length,
                            hasQuery: _searchCtrl.text.isNotEmpty,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Results List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredDocs.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredDocs.length,
                  itemBuilder: (_, i) {
                    final d = _filteredDocs[i];
                    final m = (d.data() as Map<String, dynamic>? ?? {});
                    return _PersonCard(
                      data: m,
                      onEdit: () => _openEdit(d),
                      onDelete: () => widget.onDelete(d.id),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchCtrl.text.isEmpty
                  ? Icons.people_outline
                  : Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _searchCtrl.text.isEmpty ? 'No records yet' : 'No results found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchCtrl.text.isEmpty
                ? 'Add your first record to get started'
                : 'Try adjusting your search terms',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (_searchCtrl.text.isEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add First Record'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue600,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===============================
// Shrink-wrapping counter (prevents unbounded flex errors)
// ===============================
class _CounterRow extends StatelessWidget {
  final int filtered;
  final int total;
  final bool hasQuery;

  const _CounterRow({
    required this.filtered,
    required this.total,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            'Total records: $filtered${hasQuery ? " (filtered from $total)" : ""}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ===============================
// MODERN PERSON CARD
// ===============================
class _PersonCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PersonCard({
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? 'Unknown';
    final cnic = data['cnic'] ?? '—';
    final plot = data['plotNo'] ?? '—';
    final block = data['block'] ?? '—';
    final street = data['street'] ?? '';
    final address = data['address'] ?? '';
    final due = data['dueAmount'];
    final phones = (data['mobileNumbers'] as List?)?.join(', ') ?? '—';
    final membership = data['membershipNo'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue600,
                        AppColors.blue600.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _InfoChip(
                            icon: Icons.badge,
                            label: 'CNIC',
                            value: cnic,
                            color: Colors.blue,
                          ),
                          _InfoChip(
                            icon: Icons.home,
                            label: 'Plot',
                            value: plot,
                            color: Colors.green,
                          ),
                          if (block != '—')
                            _InfoChip(
                              icon: Icons.location_city,
                              label: 'Block',
                              value: block,
                              color: Colors.purple,
                            ),
                          if (membership.isNotEmpty)
                            _InfoChip(
                              icon: Icons.card_membership,
                              label: 'M.No',
                              value: membership,
                              color: Colors.orange,
                            ),
                        ],
                      ),
                      if (phones != '—') ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                phones,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (address.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                address,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (due != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Due: Rs. $due',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Actions
                Column(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        foregroundColor: Colors.blue[700],
                      ),
                      tooltip: 'Edit',
                    ),
                    const SizedBox(height: 4),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red[50],
                        foregroundColor: Colors.red[700],
                      ),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: color.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================
// PERSON DIALOG (ENHANCED)
// ===============================
class _PersonDialog extends StatefulWidget {
  final String title;
  final String? existingDocId;
  final Map<String, dynamic>? existing;
  final Future<void> Function(String? docId, Map<String, dynamic> data) onSave;

  const _PersonDialog({
    required this.title,
    required this.onSave,
    this.existing,
    this.existingDocId,
  });

  @override
  State<_PersonDialog> createState() => _PersonDialogState();
}

class _PersonDialogState extends State<_PersonDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController sNoCtrl;
  late final TextEditingController refCtrl;
  late final TextEditingController nameCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController cnicCtrl;
  late final TextEditingController membershipCtrl;
  late final TextEditingController plotCtrl;
  late final TextEditingController streetCtrl;
  late final TextEditingController blockCtrl;
  late final TextEditingController dueRawCtrl;
  late final TextEditingController dueCtrl;
  late final TextEditingController mobilesCtrl;
  late final TextEditingController countCtrl;
  late final TextEditingController rowCtrl;

  @override
  void initState() {
    super.initState();
    final m = widget.existing ?? {};
    sNoCtrl = TextEditingController(text: _t(m['sNo']));
    refCtrl = TextEditingController(text: _t(m['ref']));
    nameCtrl = TextEditingController(text: _t(m['name']));
    addressCtrl = TextEditingController(text: _t(m['address']));
    cnicCtrl = TextEditingController(text: _t(m['cnic']));
    membershipCtrl = TextEditingController(text: _t(m['membershipNo']));
    plotCtrl = TextEditingController(text: _t(m['plotNo']));
    streetCtrl = TextEditingController(text: _t(m['street']));
    blockCtrl = TextEditingController(text: _t(m['block']));
    dueRawCtrl = TextEditingController(text: _t(m['dueAmountRaw']));
    dueCtrl = TextEditingController(text: m['dueAmount']?.toString() ?? '');
    mobilesCtrl = TextEditingController(
      text: (m['mobileNumbers'] is List)
          ? (m['mobileNumbers'] as List).join(', ')
          : _t(m['mobileNumbers']),
    );
    countCtrl = TextEditingController(
      text: m['countOfNumbers']?.toString() ?? '',
    );
    rowCtrl = TextEditingController(text: _t(m['rowRaw']));
  }

  String _t(dynamic v) => v == null ? '' : v.toString();

  @override
  void dispose() {
    sNoCtrl.dispose();
    refCtrl.dispose();
    nameCtrl.dispose();
    addressCtrl.dispose();
    cnicCtrl.dispose();
    membershipCtrl.dispose();
    plotCtrl.dispose();
    streetCtrl.dispose();
    blockCtrl.dispose();
    dueRawCtrl.dispose();
    dueCtrl.dispose();
    mobilesCtrl.dispose();
    countCtrl.dispose();
    rowCtrl.dispose();
    super.dispose();
  }

  String _buildDocIdFromFields() {
    final cnic = cnicCtrl.text.trim();
    final plot = plotCtrl.text.trim();
    final sno = sNoCtrl.text.trim();
    if (cnic.isEmpty || plot.isEmpty || sno.isEmpty) return '';
    return '${cnic}_${plot}_$sno'.replaceAll(RegExp(r'[\/\s]+'), '-');
  }

  List<String> _parseMobiles(String raw) {
    if (raw.trim().isEmpty) return const [];
    return raw
        .split(RegExp(r'[\/,\n,;]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  num? _parseNum(String raw) {
    final d = raw.replaceAll(RegExp(r'[^\d]'), '');
    if (d.isEmpty) return null;
    return num.tryParse(d);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final nameLower = nameCtrl.text.trim().isEmpty
          ? null
          : nameCtrl.text.trim().toLowerCase();

      final data = {
        'sNo': sNoCtrl.text.trim().isEmpty ? null : sNoCtrl.text.trim(),
        'ref': refCtrl.text.trim().isEmpty ? null : refCtrl.text.trim(),
        'name': nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
        'address': addressCtrl.text.trim().isEmpty
            ? null
            : addressCtrl.text.trim(),
        'cnic': cnicCtrl.text.trim().isEmpty ? null : cnicCtrl.text.trim(),
        'membershipNo': membershipCtrl.text.trim().isEmpty
            ? null
            : membershipCtrl.text.trim(),
        'plotNo': plotCtrl.text.trim().isEmpty ? null : plotCtrl.text.trim(),
        'street': streetCtrl.text.trim().isEmpty
            ? null
            : streetCtrl.text.trim(),
        'block': blockCtrl.text.trim().isEmpty ? null : blockCtrl.text.trim(),
        'dueAmountRaw': dueRawCtrl.text.trim().isEmpty
            ? null
            : dueRawCtrl.text.trim(),
        'dueAmount': _parseNum(dueCtrl.text),
        'mobileNumbers': _parseMobiles(mobilesCtrl.text),
        'countOfNumbers': _parseNum(countCtrl.text),
        'rowRaw': rowCtrl.text.trim().isEmpty ? null : rowCtrl.text.trim(),
        'name_lower': nameLower,
      };

      final desiredDocId = _buildDocIdFromFields();
      await widget.onSave(desiredDocId, data);

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width < 720 ? size.width - 32 : 700.0;
    final dialogMaxHeight = size.height < 700 ? size.height - 100 : 600.0;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: dialogMaxHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.blue600,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_add, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (_, c) {
                          final isNarrow = c.maxWidth < 560;
                          if (isNarrow) {
                            // Stack fields on narrow dialogs
                            return Column(
                              children: [
                                _field(
                                  'Name*',
                                  nameCtrl,
                                  validator: (v) => v?.trim().isEmpty ?? true
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                _field(
                                  'CNIC*',
                                  cnicCtrl,
                                  validator: (v) => v?.trim().isEmpty ?? true
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                _field(
                                  'Plot No*',
                                  plotCtrl,
                                  validator: (v) => v?.trim().isEmpty ?? true
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                _field('Block', blockCtrl),
                                const SizedBox(height: 12),
                                _field('Street', streetCtrl),
                                const SizedBox(height: 12),
                                _field('S.No', sNoCtrl),
                              ],
                            );
                          }
                          // Two-column layout on wide dialogs
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _field(
                                      'Name*',
                                      nameCtrl,
                                      validator: (v) =>
                                          v?.trim().isEmpty ?? true
                                          ? 'Required'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _field(
                                      'CNIC*',
                                      cnicCtrl,
                                      validator: (v) =>
                                          v?.trim().isEmpty ?? true
                                          ? 'Required'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _field(
                                      'Plot No*',
                                      plotCtrl,
                                      validator: (v) =>
                                          v?.trim().isEmpty ?? true
                                          ? 'Required'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: _field('Block', blockCtrl)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _field('Street', streetCtrl)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _field('S.No', sNoCtrl)),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const Divider(height: 32),
                      const Text(
                        'Contact & Financial',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _field('Mobile Numbers (comma separated)', mobilesCtrl),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (_, c) {
                          final isNarrow = c.maxWidth < 560;
                          if (isNarrow) {
                            return Column(
                              children: [
                                _field('Membership No', membershipCtrl),
                                const SizedBox(height: 12),
                                _field('Due Amount', dueCtrl),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: _field('Membership No', membershipCtrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: _field('Due Amount', dueCtrl)),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _field('Address', addressCtrl, maxLines: 2),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (_, c) {
                          final isNarrow = c.maxWidth < 560;
                          if (isNarrow) {
                            return Column(
                              children: [
                                _field('REF', refCtrl),
                                const SizedBox(height: 12),
                                _field('Row', rowCtrl),
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: _field('REF', refCtrl)),
                              const SizedBox(width: 12),
                              Expanded(child: _field('Row', rowCtrl)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.blue600, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }
}

// ===============================
// Contact & Newsletter Tabs (Enhanced)
// ===============================
class _ContactSubmissionsTab extends StatelessWidget {
  final Function(String) onDelete;

  const _ContactSubmissionsTab({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('contact_submissions')
          .orderBy('submittedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.contact_mail,
            title: 'No contact submissions',
            subtitle: 'Submissions will appear here',
          );
        }

        final submissions = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: submissions.length,
          itemBuilder: (context, index) {
            final doc = submissions[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blue600.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: AppColors.blue600),
                ),
                title: Text(
                  data['name'] ?? 'No name',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  data['email'] ?? 'No email',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _StatusChip(status: data['status'] ?? 'new'),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => onDelete(doc.id),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: data['phone'] ?? 'N/A',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.business,
                          label: 'Property Type',
                          value: data['propertyType'] ?? 'N/A',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.message,
                          label: 'Message',
                          value: data['message'] ?? 'N/A',
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.access_time,
                          label: 'Submitted',
                          value: _formatTimestamp(data['submittedAt']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final dt = (timestamp as Timestamp).toDate();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'N/A';
    }
  }
}

class _NewsletterSubscribersTab extends StatelessWidget {
  final Function(String) onDelete;

  const _NewsletterSubscribersTab({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('newsletter_subscribers')
          .orderBy('subscribedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.mail,
            title: 'No newsletter subscribers',
            subtitle: 'Subscribers will appear here',
          );
        }

        final subscribers = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subscribers.length,
          itemBuilder: (context, index) {
            final doc = subscribers[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.blue600.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.mail, color: AppColors.blue600),
                ),
                title: Text(
                  data['email'] ?? 'No email',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Subscribed: ${_formatTimestamp(data['subscribedAt'])}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => onDelete(doc.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final dt = (timestamp as Timestamp).toDate();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'N/A';
    }
  }
}

class _BulkImportTab extends StatelessWidget {
  final Future<void> Function() onImport;

  const _BulkImportTab({required this.onImport});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.blue600,
                      AppColors.blue600.withOpacity(0.7),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Bulk Import',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Import multiple records at once from JSON file',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'What you need:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _bulletPoint('JSON file with array of objects'),
                    _bulletPoint('Fields: Name, CNIC, Plot No, etc.'),
                    _bulletPoint('Data will be normalized automatically'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onImport,
                  icon: const Icon(Icons.file_open),
                  label: const Text('Choose JSON File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// Helper Widgets
Widget _buildEmptyState({
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 64, color: Colors.grey[400]),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    ),
  );
}

Widget _buildErrorState(String error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        const Text(
          'Error Loading Data',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          error,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.blue600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'new':
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        break;
      case 'contacted':
        bgColor = const Color(0xFFDEF3FF);
        textColor = const Color(0xFF0369A1);
        break;
      case 'resolved':
        bgColor = const Color(0xFFE5E7EB);
        textColor = const Color(0xFF374151);
        break;
      default:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
