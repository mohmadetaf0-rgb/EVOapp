import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  // تشغيل الواجهة مباشرة بدون انتظار أي قراءة للبيانات.
  // تحميل البيانات يبدأ بعد الدخول للتطبيق، مما يجعل شاشة البداية سريعة.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EvoAcademyApp());
}

// ============================================================
// التطبيق + شاشة الترحيب واختيار نوع التشغيل
// ============================================================

enum AppDeviceMode {
  mobileTablet,
  desktopWeb,
}

class EvoAcademyApp extends StatelessWidget {
  const EvoAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0B5ED7);
    const dark = Color(0xFF0B1F3A);
    const accent = Color(0xFF19C37D);

    return MaterialApp(
      title: 'EVO Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
          primary: primary,
          secondary: accent,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: dark,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: Color(0xFFE3E9F2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide(color: primary, width: 1.5),
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openDeviceSelection(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const DeviceModeSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _openDeviceSelection(context),
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF071A33),
                  Color(0xFF0B5ED7),
                  Color(0xFF123B78),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(28, 34, 28, 34),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .97),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x55000000),
                            blurRadius: 35,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/evo_academy_logo.jpg',
                              width: 190,
                              height: 190,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) {
                                return const SizedBox(
                                  width: 190,
                                  height: 190,
                                  child: Icon(
                                    Icons.sports_soccer_rounded,
                                    size: 80,
                                    color: Color(0xFF0B5ED7),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'أهلاً بكم في عالم EVO',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 29,
                              height: 1.15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0B1F3A),
                              letterSpacing: -.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'حيث لا نكتفي بتطوير المهارات، بل نصنع عقولاً رياضية متطورة وقادة حقيقيين للمستقبل.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.65,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0B5ED7),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'EVO FOOTBALL ACADEMY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF98A2B3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeviceModeSelectionScreen extends StatelessWidget {
  const DeviceModeSelectionScreen({super.key});

  void _openApp(BuildContext context, AppDeviceMode mode) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(mode: mode),
      ),
    );
  }

  Widget _modeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required AppDeviceMode mode,
    required String badge,
  }) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openApp(context, mode),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B5ED7).withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Color(0xFF0B5ED7),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B5ED7), Color(0xFF1D83FF)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B1F3A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'دخول',
                      style: TextStyle(
                        color: Color(0xFF087A4D),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_back_rounded,
                        color: Color(0xFF087A4D), size: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFF5F7FB), Color(0xFFEAF2FF)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B5ED7).withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.devices_rounded,
                            size: 34, color: Color(0xFF0B5ED7)),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'اختر بيئة التشغيل',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0B1F3A),
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'نفس البيانات ونفس الوظائف — فقط تجربة واجهة محسّنة حسب جهازك.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFF667085), fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cards = [
                            _modeCard(
                              context: context,
                              icon: Icons.phone_android_rounded,
                              title: 'هاتف / تابلت',
                              subtitle:
                                  'تجربة لمس سريعة وواضحة للشاشات الصغيرة والمتوسطة.',
                              mode: AppDeviceMode.mobileTablet,
                              badge: 'MOBILE',
                            ),
                            _modeCard(
                              context: context,
                              icon: Icons.laptop_mac_rounded,
                              title: 'لابتوب / ويب',
                              subtitle:
                                  'مساحة عمل احترافية للشاشات الكبيرة والويب.',
                              mode: AppDeviceMode.desktopWeb,
                              badge: 'DESKTOP',
                            ),
                          ];
                          return constraints.maxWidth < 620
                              ? Column(children: cards)
                              : Row(children: cards);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// سجل الحضور والغياب
// ============================================================

class AttendanceRecord {
  DateTime dateTime;
  bool present;

  AttendanceRecord({
    required this.dateTime,
    required this.present,
  });

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'present': present,
      };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final parsedDate =
        DateTime.tryParse(json['dateTime']?.toString() ?? '') ?? DateTime.now();

    return AttendanceRecord(
      dateTime: parsedDate,
      present: json['present'] == true,
    );
  }
}

// ============================================================
// موديل اللاعب
// ============================================================

class Player {
  String id;
  String name;
  String position;
  String birthYear;
  String branch;
  String height;
  String weight;
  String phone;
  String whatsapp;

  String? imageBase64;
  bool? attendanceToday;
  bool isPaid;
  String? paymentDate;
  double discountPercentage;
  List<bool> lastThreeDays;
  DateTime createdAt;
  List<AttendanceRecord> attendanceHistory;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.birthYear,
    required this.branch,
    required this.height,
    required this.weight,
    required this.phone,
    required this.whatsapp,
    this.imageBase64,
    this.attendanceToday,
    this.isPaid = false,
    this.paymentDate,
    this.discountPercentage = 0,
    required this.lastThreeDays,
    DateTime? createdAt,
    List<AttendanceRecord>? attendanceHistory,
  })  : createdAt = createdAt ?? DateTime.now(),
        attendanceHistory = attendanceHistory ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'birthYear': birthYear,
      'branch': branch,
      'height': height,
      'weight': weight,
      'phone': phone,
      'whatsapp': whatsapp,
      'imageBase64': imageBase64,
      'attendanceToday': attendanceToday,
      'isPaid': isPaid,
      'paymentDate': paymentDate,
      'discountPercentage': discountPercentage,
      'lastThreeDays': lastThreeDays,
      'createdAt': createdAt.toIso8601String(),
      'attendanceHistory': attendanceHistory.map((e) => e.toJson()).toList(),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    final dynamic discount = json['discountPercentage'];
    final createdAt = DateTime.tryParse(json['createdAt']?.toString() ?? '');

    final List<AttendanceRecord> attendanceHistory = json['attendanceHistory']
            is List
        ? (json['attendanceHistory'] as List)
            .whereType<Map>()
            .map((e) => AttendanceRecord.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : [];

    return Player(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      position: json['position']?.toString() ?? 'غير محدد',
      birthYear: json['birthYear']?.toString() ?? '-',
      branch: json['branch']?.toString() ?? 'الرئيسي',
      height: json['height']?.toString() ?? '-',
      weight: json['weight']?.toString() ?? '-',
      phone: json['phone']?.toString() ?? '-',
      whatsapp: json['whatsapp']?.toString() ?? '-',
      imageBase64: json['imageBase64']?.toString(),
      attendanceToday: json['attendanceToday'] as bool?,
      isPaid: json['isPaid'] == true,
      paymentDate: json['paymentDate']?.toString(),
      discountPercentage: discount is num
          ? discount.toDouble()
          : double.tryParse(discount?.toString() ?? '') ?? 0,
      lastThreeDays: json['lastThreeDays'] is List
          ? List<bool>.from(
              (json['lastThreeDays'] as List).map((e) => e == true),
            )
          : [true, true, true],
      createdAt: createdAt,
      attendanceHistory: attendanceHistory,
    );
  }
}

// ============================================================
// السجلات اليومية الثابتة
// ============================================================

class DailyRecord {
  final String dateKey;
  final List<String> presentNames;
  final List<String> absentNames;
  final List<String> paidNames;
  final int totalPlayers;

  DailyRecord({
    required this.dateKey,
    required this.presentNames,
    required this.absentNames,
    required this.paidNames,
    required this.totalPlayers,
  });

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'presentNames': presentNames,
        'absentNames': absentNames,
        'paidNames': paidNames,
        'totalPlayers': totalPlayers,
      };

  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      dateKey: json['dateKey']?.toString() ?? '',
      presentNames: (json['presentNames'] is List)
          ? List<String>.from(
              (json['presentNames'] as List).map((e) => e.toString()))
          : <String>[],
      absentNames: (json['absentNames'] is List)
          ? List<String>.from(
              (json['absentNames'] as List).map((e) => e.toString()))
          : <String>[],
      paidNames: (json['paidNames'] is List)
          ? List<String>.from(
              (json['paidNames'] as List).map((e) => e.toString()))
          : <String>[],
      totalPlayers: (json['totalPlayers'] is num)
          ? (json['totalPlayers'] as num).toInt()
          : 0,
    );
  }
}

String _dailyDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

String _dailyDateLabel(String key) {
  final parts = key.split('-');
  if (parts.length != 3) return key;
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}

bool _paymentWasOnDate(Player player, DateTime date) {
  if (!player.isPaid || player.paymentDate == null) return false;

  final payment = player.paymentDate!.trim();
  final expected =
      '${date.year.toString().padLeft(4, '0')}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

  return payment.startsWith(expected);
}

Future<void> _saveDailyRecordSnapshot(
  List<Player> players, {
  DateTime? date,
}) async {
  final day = date ?? DateTime.now();
  final dateKey = _dailyDateKey(day);

  final presentNames = <String>[];
  final absentNames = <String>[];
  final paidNames = <String>[];

  for (final player in players) {
    final attendance = player.attendanceHistory.where(
      (record) =>
          record.dateTime.year == day.year &&
          record.dateTime.month == day.month &&
          record.dateTime.day == day.day,
    );

    final isPresent = attendance.isNotEmpty && attendance.any((e) => e.present);

    if (isPresent) {
      presentNames.add(player.name);
    } else {
      absentNames.add(player.name);
    }

    if (_paymentWasOnDate(player, day)) {
      paidNames.add(player.name);
    }
  }

  final record = DailyRecord(
    dateKey: dateKey,
    presentNames: presentNames,
    absentNames: absentNames,
    paidNames: paidNames,
    totalPlayers: players.length,
  );

  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('daily_records');
  final records = <DailyRecord>[];

  if (raw != null && raw.isNotEmpty) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        records.addAll(
          decoded.whereType<Map>().map((e) => DailyRecord.fromJson(
                Map<String, dynamic>.from(e),
              )),
        );
      }
    } catch (_) {}
  }

  final index = records.indexWhere((e) => e.dateKey == dateKey);
  if (index >= 0) {
    records[index] = record;
  } else {
    records.add(record);
  }

  records.sort((a, b) => b.dateKey.compareTo(a.dateKey));

  await prefs.setString(
    'daily_records',
    jsonEncode(records.map((e) => e.toJson()).toList()),
  );
}

Future<List<DailyRecord>> _loadDailyRecords() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('daily_records');

  if (raw == null || raw.isEmpty) return <DailyRecord>[];

  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <DailyRecord>[];

    final records = decoded
        .whereType<Map>()
        .map((e) => DailyRecord.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.dateKey.isNotEmpty)
        .toList();

    records.sort((a, b) => b.dateKey.compareTo(a.dateKey));
    return records;
  } catch (_) {
    return <DailyRecord>[];
  }
}

// ============================================================
// إعدادات الأكاديمية
// ============================================================

class AcademySettings {
  static String? academyLogoBase64;
  static String targetMonth = 'August 2026';
  static String subscriptionAmount = '300';
  static String receiptLogoName = 'EVO';
  static String responsibleName = 'محمد';
}

// ============================================================
// التنقل الرئيسي
// ============================================================

class MainNavigationScreen extends StatefulWidget {
  final AppDeviceMode mode;

  const MainNavigationScreen({
    super.key,
    required this.mode,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PlayersManagementScreen(),
    DailyRecordsScreen(),
    SubscriptionsScreen(),
    SettingsScreen(),
  ];

  static const _navItems = <NavigationItem>[
    NavigationItem(Icons.people, 'اللاعبون'),
    NavigationItem(Icons.calendar_month, 'السجل'),
    NavigationItem(Icons.card_membership, 'الاشتراكات'),
    NavigationItem(Icons.settings, 'الإعدادات'),
  ];

  Widget _buildSelectedScreen() {
    // في وضع اللابتوب/الويب يتم تحديد عرض أقصى حتى لا تتمدد الواجهة
    // بشكل مبالغ فيه على الشاشات الكبيرة.
    if (widget.mode == AppDeviceMode.desktopWeb) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1500),
          child: _screens[_currentIndex],
        ),
      );
    }

    // الهاتف والتابلت: الواجهة بعرض الشاشة بالكامل مع نفس الوظائف.
    return _screens[_currentIndex];
  }

  Widget _buildDesktopNavigation() {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1F3A),
        border: const Border(left: BorderSide(color: Color(0xFF19345A))),
      ),
      child: NavigationRail(
        extended: true,
        backgroundColor: const Color(0xFF0B1F3A),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        selectedIconTheme: const IconThemeData(
          color: Color(0xFF4DA3FF),
        ),
        selectedLabelTextStyle: const TextStyle(
          color: Color(0xFF4DA3FF),
          fontWeight: FontWeight.bold,
        ),
        unselectedIconTheme: const IconThemeData(color: Color(0xFF9FB0C8)),
        destinations: _navItems
            .map(
              (item) => NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.icon),
                label: Text(item.label),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMobileNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: const Color(0xFF0B5ED7),
      unselectedItemColor: const Color(0xFF8A98AA),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      items: _navItems
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = widget.mode == AppDeviceMode.desktopWeb;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: isDesktop
            ? Row(
                children: [
                  Expanded(child: _buildSelectedScreen()),
                  _buildDesktopNavigation(),
                ],
              )
            : _buildSelectedScreen(),
        bottomNavigationBar: isDesktop ? null : _buildMobileNavigation(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem(this.icon, this.label);
}

// ============================================================
// شاشة السجل اليومي
// ============================================================

class DailyRecordsScreen extends StatefulWidget {
  const DailyRecordsScreen({super.key});

  @override
  State<DailyRecordsScreen> createState() => _DailyRecordsScreenState();
}

class _DailyRecordsScreenState extends State<DailyRecordsScreen> {
  List<DailyRecord> records = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final loaded = await _loadDailyRecords();

    if (!mounted) return;
    setState(() {
      records = loaded;
      loading = false;
    });
  }

  Future<void> _downloadRecordPdf(DailyRecord record) async {
    try {
      final arabicFont = await PdfGoogleFonts.notoNaskhArabicRegular();
      final arabicBoldFont = await PdfGoogleFonts.notoNaskhArabicBold();

      final pdf = pw.Document();
      final present = [...record.presentNames]..sort();
      final absent = [...record.absentNames]..sort();
      final paid = [...record.paidNames]..sort();

      pw.Widget namesTable(
        String title,
        List<String> names,
        PdfColor headerColor,
      ) {
        final rows = <pw.TableRow>[
          pw.TableRow(
            decoration: pw.BoxDecoration(color: headerColor),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(7),
                child: pw.Text(
                  title,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: arabicBoldFont,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ];

        if (names.isEmpty) {
          rows.add(
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(7),
                  child: pw.Text(
                    'لا يوجد',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: arabicFont),
                  ),
                ),
              ],
            ),
          );
        } else {
          for (var i = 0; i < names.length; i++) {
            rows.add(
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      '${i + 1} - ${names[i]}',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: arabicFont),
                    ),
                  ),
                ],
              ),
            );
          }
        }

        return pw.Table(
          border: pw.TableBorder.all(
            color: PdfColors.grey500,
            width: .6,
          ),
          children: rows,
        );
      }

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(28),
          build: (context) => [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(
                    'سجل اليوم',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: arabicBoldFont,
                      fontSize: 20,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'التاريخ: ${_dailyDateLabel(record.dateKey)}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 12,
                    ),
                  ),
                  pw.SizedBox(height: 14),
                  pw.Table(
                    border: pw.TableBorder.all(
                      color: PdfColors.grey500,
                      width: .6,
                    ),
                    children: [
                      pw.TableRow(
                        children: [
                          _dailyPdfSummaryCell(
                            'إجمالي اللاعبين',
                            '${record.totalPlayers}',
                            arabicFont,
                            arabicBoldFont,
                          ),
                          _dailyPdfSummaryCell(
                            'الحضور',
                            '${present.length}',
                            arabicFont,
                            arabicBoldFont,
                          ),
                          _dailyPdfSummaryCell(
                            'الغياب',
                            '${absent.length}',
                            arabicFont,
                            arabicBoldFont,
                          ),
                          _dailyPdfSummaryCell(
                            'دفع الاشتراك',
                            '${paid.length}',
                            arabicFont,
                            arabicBoldFont,
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 14),
                  namesTable('اللاعبون الحاضرون', present, PdfColors.green100),
                  pw.SizedBox(height: 12),
                  namesTable('اللاعبون الغائبون', absent, PdfColors.red100),
                  pw.SizedBox(height: 12),
                  namesTable(
                      'من دفع الاشتراك في هذا اليوم', paid, PdfColors.amber100),
                ],
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final fileName = 'سجل_${record.dateKey}.pdf';

      if (kIsWeb) {
        final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..style.display = 'none';
        html.document.body?.children.add(anchor);
        anchor.click();
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(
              Uint8List.fromList(bytes),
              mimeType: 'application/pdf',
            ),
          ],
          fileNameOverrides: [fileName],
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تجهيز ملف PDF للسجل اليومي')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر إنشاء PDF: $e')),
        );
      }
    }
  }

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 23),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('السجل اليومي'),
        actions: [
          IconButton(
            tooltip: 'تحديث',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : records.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.calendar_month,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'لا توجد سجلات محفوظة حتى الآن',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DailyRecordDetailsScreen(
                                  record: record,
                                  onDownload: _downloadRecordPdf,
                                ),
                              ),
                            );
                            _refresh();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1976D2)
                                        .withValues(alpha: .10),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Color(0xFF4DA3FF),
                                    size: 29,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'سجل ${_dailyDateLabel(record.dateKey)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Row(
                                        children: [
                                          Text(
                                            'حضور: ${record.presentNames.length}',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'غياب: ${record.absentNames.length}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'دفع: ${record.paidNames.length}',
                                            style: const TextStyle(
                                              color: Colors.orange,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'تنزيل PDF',
                                  onPressed: () => _downloadRecordPdf(record),
                                  icon: const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.red,
                                  ),
                                ),
                                const Icon(Icons.chevron_left,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

pw.Widget _dailyPdfSummaryCell(
  String title,
  String value,
  pw.Font font,
  pw.Font boldFont,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 3),
    child: pw.Column(
      children: [
        pw.Text(
          value,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: boldFont, fontSize: 14),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: font, fontSize: 9),
        ),
      ],
    ),
  );
}

class DailyRecordDetailsScreen extends StatelessWidget {
  final DailyRecord record;
  final Future<void> Function(DailyRecord record) onDownload;

  const DailyRecordDetailsScreen({
    super.key,
    required this.record,
    required this.onDownload,
  });

  Future<void> _download(BuildContext context) async {
    await onDownload(record);
  }

  Widget _section(
    String title,
    List<String> names,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$title (${names.length})',
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            if (names.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('لا يوجد'),
              )
            else
              ...names.map(
                (name) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withValues(alpha: .10),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  title: Text(name),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final present = [...record.presentNames]..sort();
    final absent = [...record.absentNames]..sort();
    final paid = [...record.paidNames]..sort();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('سجل ${_dailyDateLabel(record.dateKey)}'),
          actions: [
            IconButton(
              tooltip: 'تنزيل PDF',
              onPressed: () => _download(context),
              icon: const Icon(Icons.picture_as_pdf),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Row(
              children: [
                _dailySummaryTile(
                  'الحضور',
                  '${present.length}',
                  Icons.check_circle,
                  Colors.green,
                ),
                const SizedBox(width: 8),
                _dailySummaryTile(
                  'الغياب',
                  '${absent.length}',
                  Icons.cancel,
                  Colors.red,
                ),
                const SizedBox(width: 8),
                _dailySummaryTile(
                  'الدفع',
                  '${paid.length}',
                  Icons.payments,
                  Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _section(
              'اللاعبون الحاضرون',
              present,
              Icons.check_circle,
              Colors.green,
            ),
            _section(
              'اللاعبون الغائبون',
              absent,
              Icons.cancel,
              Colors.red,
            ),
            _section(
              'من دفع الاشتراك في هذا اليوم',
              paid,
              Icons.payments,
              Colors.orange,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _download(context),
              icon: const Icon(Icons.download, color: Colors.white),
              label: const Text(
                'تنزيل سجل اليوم كـ PDF',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailySummaryTile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// إدارة اللاعبين
// ============================================================

class PlayersManagementScreen extends StatefulWidget {
  const PlayersManagementScreen({super.key});

  @override
  State<PlayersManagementScreen> createState() =>
      _PlayersManagementScreenState();
}

class _PlayersManagementScreenState extends State<PlayersManagementScreen> {
  List<Player> players = [];

  final TextEditingController _playerSearchController = TextEditingController();
  String _playerSearch = '';

  List<Player> get _filteredPlayers {
    final query = _playerSearch.trim().toLowerCase();
    if (query.isEmpty) return players;

    return players.where((player) {
      return player.name.toLowerCase().contains(query) ||
          player.position.toLowerCase().contains(query) ||
          player.branch.toLowerCase().contains(query) ||
          player.birthYear.toLowerCase().contains(query);
    }).toList();
  }

  String? sortByName;
  String? sortByBirth;
  String? sortByPosition;
  String? sortByBranch;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _playerSearchController.addListener(() {
      if (mounted) {
        setState(() => _playerSearch = _playerSearchController.text);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _playerSearchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    AcademySettings.academyLogoBase64 = prefs.getString('academy_logo_base64');
    AcademySettings.targetMonth =
        prefs.getString('target_month') ?? 'August 2026';
    AcademySettings.subscriptionAmount = prefs.getString('sub_amount') ?? '300';
    AcademySettings.receiptLogoName =
        prefs.getString('receipt_logo_name') ?? 'EVO';
    AcademySettings.responsibleName =
        prefs.getString('responsible_name') ?? 'محمد';

    final String? playersString = prefs.getString('saved_players');

    if (playersString != null && playersString.isNotEmpty) {
      try {
        final List decoded = jsonDecode(playersString);
        if (!mounted) return;
        setState(() {
          players = decoded
              .map((e) => Player.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        });
        await _saveDailyRecordSnapshot(players);
      } catch (_) {
        await _createDefaultPlayer();
      }
    } else {
      await _createDefaultPlayer();
    }
  }

  Future<void> _createDefaultPlayer() async {
    players = [
      Player(
        id: '1',
        name: 'محمد عاطف عبدالحليم',
        position: 'مدافع',
        birthYear: '2002',
        branch: 'اللاهون',
        height: '175',
        weight: '70',
        phone: '01032003604',
        whatsapp: '01032003604',
        createdAt: DateTime(2026, 8, 1),
        lastThreeDays: [true, true, true],
      ),
    ];
    await _saveData();
    if (mounted) setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedPlayers = jsonEncode(players.map((e) => e.toJson()).toList());
    await prefs.setString('saved_players', encodedPlayers);

    if (AcademySettings.academyLogoBase64 != null) {
      await prefs.setString(
          'academy_logo_base64', AcademySettings.academyLogoBase64!);
    } else {
      await prefs.remove('academy_logo_base64');
    }
    await prefs.setString('target_month', AcademySettings.targetMonth);
    await prefs.setString('sub_amount', AcademySettings.subscriptionAmount);
    await prefs.setString('receipt_logo_name', AcademySettings.receiptLogoName);
    await prefs.setString('responsible_name', AcademySettings.responsibleName);

    // تحديث سجل اليوم فقط دون المساس بالسجلات السابقة.
    await _saveDailyRecordSnapshot(players);
  }

  Future<void> _manualSave() async {
    await _saveData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ البيانات بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<String?> _pickImageAsBase64() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (pickedFile == null) return null;
      final Uint8List bytes = await pickedFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null;
    }
  }

  Widget _buildImageWidget(String? imageBase64, {double size = 50}) {
    if (imageBase64 == null || imageBase64.isEmpty) {
      return Icon(Icons.person, size: size * 0.7, color: Colors.grey);
    }
    try {
      final bytes = base64Decode(imageBase64);
      return Image.memory(bytes, width: size, height: size, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
        return Icon(Icons.person, size: size * 0.7, color: Colors.grey);
      });
    } catch (_) {
      return Icon(Icons.person, size: size * 0.7, color: Colors.grey);
    }
  }

  void _applySorting() {
    setState(() {
      if (sortByName != null && sortByName != 'الكل') {
        players.sort((a, b) => sortByName == 'أبجدي أ-ي'
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
      } else if (sortByBirth != null && sortByBirth != 'الكل') {
        players.sort((a, b) => sortByBirth == 'الأحدث'
            ? b.birthYear.compareTo(a.birthYear)
            : a.birthYear.compareTo(b.birthYear));
      } else if (sortByPosition != null && sortByPosition != 'الكل') {
        players.sort((a, b) => a.position.compareTo(b.position));
      } else if (sortByBranch != null && sortByBranch != 'الكل') {
        players.sort((a, b) => a.branch.compareTo(b.branch));
      }
    });
    _saveData();
  }

  String _formatAttendanceDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatAttendanceTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _arabicDayName(DateTime date) {
    const days = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return days[date.weekday - 1];
  }

  Future<void> _recordQrAttendance(Player player) async {
    final now = DateTime.now();
    final index = player.attendanceHistory.indexWhere(
      (record) =>
          record.dateTime.year == now.year &&
          record.dateTime.month == now.month &&
          record.dateTime.day == now.day,
    );

    if (index >= 0 && player.attendanceHistory[index].present) {
      return;
    }

    setState(() {
      player.attendanceToday = true;
      if (index >= 0) {
        player.attendanceHistory[index]
          ..dateTime = now
          ..present = true;
      } else {
        player.attendanceHistory.add(
          AttendanceRecord(dateTime: now, present: true),
        );
      }
      player.attendanceHistory.sort(
        (a, b) => a.dateTime.compareTo(b.dateTime),
      );
    });

    await _saveData();
  }

  Future<void> _openQrAttendanceScanner() async {
    if (players.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد لاعبين مسجلين حالياً')),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QrAttendanceScannerScreen(
          players: players,
          onAttendance: (player) => _recordQrAttendance(player),
        ),
      ),
    );

    if (mounted) setState(() {});
  }

  Future<void> _recordAttendance(Player player, bool present) async {
    final now = DateTime.now();

    // سجل واحد فقط لكل يوم، وإذا تم تغيير الحالة في نفس اليوم
    // يتم تحديث السجل بدلاً من إنشاء سجل مكرر.
    final index = player.attendanceHistory.indexWhere(
      (record) =>
          record.dateTime.year == now.year &&
          record.dateTime.month == now.month &&
          record.dateTime.day == now.day,
    );

    setState(() {
      player.attendanceToday = present;

      if (index >= 0) {
        player.attendanceHistory[index]
          ..dateTime = now
          ..present = present;
      } else {
        player.attendanceHistory.add(
          AttendanceRecord(
            dateTime: now,
            present: present,
          ),
        );
      }

      player.attendanceHistory.sort(
        (a, b) => a.dateTime.compareTo(b.dateTime),
      );
    });

    await _saveData();
  }

  Color _attendanceBlockColor(int index) {
    // كل 8 تمرينات لها لون مميز، ثم تتكرر الألوان.
    const colors = [
      Color(0xFFE3F2FD),
      Color(0xFFE8F5E9),
      Color(0xFFFFF3E0),
      Color(0xFFF3E5F5),
      Color(0xFFFFEBEE),
      Color(0xFFE0F7FA),
    ];
    return colors[(index ~/ 8) % colors.length];
  }

  PdfColor _attendancePdfBlockColor(int index) {
    const colors = [
      PdfColors.blue50,
      PdfColors.green50,
      PdfColors.orange50,
      PdfColors.purple50,
      PdfColors.red50,
      PdfColors.cyan50,
    ];
    return colors[(index ~/ 8) % colors.length];
  }

  void _showAttendanceHistoryDialog(Player player) {
    final history = [...player.attendanceHistory]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final presentCount = history.where((e) => e.present).length;
    final absentCount = history.length - presentCount;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 720,
                maxHeight: 700,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 52,
                            height: 52,
                            child: _buildImageWidget(
                              player.imageBase64,
                              size: 52,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'سجل الحضور والغياب منذ إضافة اللاعب: '
                                '${_formatAttendanceDate(player.createdAt)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _attendanceSummaryBox(
                            'إجمالي التمرينات',
                            '${history.length}',
                            const Color(0xFFE3F2FD),
                            const Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _attendanceSummaryBox(
                            'حضور',
                            '$presentCount',
                            const Color(0xFFE8F5E9),
                            const Color(0xFF00897B),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _attendanceSummaryBox(
                            'غياب',
                            '$absentCount',
                            const Color(0xFFFFEBEE),
                            const Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (history.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            'لم يتم تسجيل حضور أو غياب لهذا اللاعب حتى الآن.\n'
                            'سيبدأ السجل تلقائياً من أول تسجيل حضور أو غياب.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              final record = history[index];

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: _attendanceBlockColor(
                                    history.length - 1 - index,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(
                                        '${history.length - index}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF455A64),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _formatAttendanceDate(record.dateTime),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _arabicDayName(record.dateTime),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _formatAttendanceTime(record.dateTime),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: record.present
                                            ? Colors.teal
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        record.present ? 'حاضر' : 'غائب',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(Icons.close),
                            label: const Text('إغلاق'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00796B),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: history.isEmpty
                                ? null
                                : () => _downloadAttendancePdf(player),
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'تنزيل سجل الحضور PDF',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _attendanceSummaryBox(
    String title,
    String value,
    Color background,
    Color foreground,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAttendancePdf(Player player) async {
    if (player.attendanceHistory.isEmpty) return;

    final history = [...player.attendanceHistory]
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    try {
      final arabicFont = await PdfGoogleFonts.notoNaskhArabicRegular();
      final arabicBoldFont = await PdfGoogleFonts.notoNaskhArabicBold();

      final pdf = pw.Document();
      final presentCount = history.where((e) => e.present).length;
      final absentCount = history.length - presentCount;
      final downloadDate = _formatDateTime(DateTime.now());

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(24, 28, 24, 28),
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicBoldFont,
          ),
          header: (_) => pw.Column(
            children: [
              pw.Text(
                'سجل حضور وغياب اللاعب',
                style: pw.TextStyle(
                  font: arabicBoldFont,
                  fontSize: 18,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                player.name,
                style: pw.TextStyle(
                  font: arabicBoldFont,
                  fontSize: 14,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'تاريخ إضافة اللاعب: ${_formatAttendanceDate(player.createdAt)}',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 9,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.Text(
                'تاريخ تنزيل السجل: $downloadDate',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 8,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),
            ],
          ),
          footer: (context) => pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'صفحة ${context.pageNumber} من ${context.pagesCount}',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 7,
              ),
            ),
          ),
          build: (_) => [
            pw.Row(
              children: [
                pw.Expanded(
                  child: _pdfAttendanceSummaryBox(
                    'إجمالي التمرينات',
                    '${history.length}',
                    PdfColors.blue50,
                    arabicFont,
                    arabicBoldFont,
                  ),
                ),
                pw.SizedBox(width: 6),
                pw.Expanded(
                  child: _pdfAttendanceSummaryBox(
                    'حضور',
                    '$presentCount',
                    PdfColors.green50,
                    arabicFont,
                    arabicBoldFont,
                  ),
                ),
                pw.SizedBox(width: 6),
                pw.Expanded(
                  child: _pdfAttendanceSummaryBox(
                    'غياب',
                    '$absentCount',
                    PdfColors.red50,
                    arabicFont,
                    arabicBoldFont,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey500,
                width: .6,
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: pw.FlexColumnWidth(1.0),
                1: pw.FlexColumnWidth(2.2),
                2: pw.FlexColumnWidth(2.0),
                3: pw.FlexColumnWidth(1.5),
                4: pw.FlexColumnWidth(1.5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    _pdfAttendanceCell(
                      '#',
                      true,
                      arabicFont,
                      arabicBoldFont,
                    ),
                    _pdfAttendanceCell(
                      'التاريخ',
                      true,
                      arabicFont,
                      arabicBoldFont,
                    ),
                    _pdfAttendanceCell(
                      'اليوم',
                      true,
                      arabicFont,
                      arabicBoldFont,
                    ),
                    _pdfAttendanceCell(
                      'الوقت',
                      true,
                      arabicFont,
                      arabicBoldFont,
                    ),
                    _pdfAttendanceCell(
                      'الحالة',
                      true,
                      arabicFont,
                      arabicBoldFont,
                    ),
                  ],
                ),
                ...history.asMap().entries.map((entry) {
                  final index = entry.key;
                  final record = entry.value;

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: _attendancePdfBlockColor(index),
                    ),
                    children: [
                      _pdfAttendanceCell(
                        '${index + 1}',
                        false,
                        arabicFont,
                        arabicBoldFont,
                      ),
                      _pdfAttendanceCell(
                        _formatAttendanceDate(record.dateTime),
                        false,
                        arabicFont,
                        arabicBoldFont,
                      ),
                      _pdfAttendanceCell(
                        _arabicDayName(record.dateTime),
                        false,
                        arabicFont,
                        arabicBoldFont,
                      ),
                      _pdfAttendanceCell(
                        _formatAttendanceTime(record.dateTime),
                        false,
                        arabicFont,
                        arabicBoldFont,
                      ),
                      _pdfAttendanceCell(
                        record.present ? 'حاضر' : 'غائب',
                        false,
                        arabicFont,
                        arabicBoldFont,
                      ),
                    ],
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'ملاحظة: كل 8 تمرينات متتالية لها لون مميز لتسهيل التفريق بين الفترات الشهرية.',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 8,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final fileName =
          'attendance_${_safeFileName(player.name)}_${player.id}.pdf';

      if (kIsWeb) {
        _downloadBytes(
          Uint8List.fromList(bytes),
          fileName,
          'application/pdf',
        );
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(
              Uint8List.fromList(bytes),
              mimeType: 'application/pdf',
            ),
          ],
          fileNameOverrides: [fileName],
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر إنشاء سجل الحضور PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  pw.Widget _pdfAttendanceSummaryBox(
    String title,
    String value,
    PdfColor background,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(7),
      decoration: pw.BoxDecoration(
        color: background,
        border: pw.Border.all(
          color: PdfColors.grey400,
          width: .4,
        ),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: font,
              fontSize: 8,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 11,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfAttendanceCell(
    String value,
    bool isHeader,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
      alignment: pw.Alignment.center,
      child: pw.Text(
        value,
        style: pw.TextStyle(
          font: isHeader ? boldFont : font,
          fontSize: isHeader ? 8 : 8.5,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  void _showCardDialog(Player player) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 390,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.grey, size: 20),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                      const Expanded(
                        child: Text(
                          'كارنيه اللاعب الرسمي',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final image = await _pickImageAsBase64();
                                      if (image == null) return;
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        AcademySettings.academyLogoBase64 =
                                            image;
                                      });
                                      await prefs.setString(
                                          'academy_logo_base64', image);
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: AcademySettings
                                                        .academyLogoBase64 !=
                                                    null &&
                                                AcademySettings
                                                    .academyLogoBase64!
                                                    .isNotEmpty
                                            ? _buildImageWidget(
                                                AcademySettings
                                                    .academyLogoBase64,
                                                size: 70)
                                            : Icon(Icons.shield,
                                                size: 58,
                                                color: Colors.orange.shade800),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  player.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _buildDetailRow('المواليد:', player.birthYear),
                                _buildDetailRow('المركز:', player.position),
                                _buildDetailRow('الفرع:', player.branch),
                                _buildDetailRow('الهاتف:', player.phone),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            children: [
                              Container(
                                width: 90,
                                height: 105,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: const Color(0xFF42A5F5),
                                      width: 1.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: _buildImageWidget(player.imageBase64,
                                      size: 90),
                                ),
                              ),
                              const SizedBox(height: 10),
                              QrImageView(
                                data:
                                    'PLAYER_ID:${player.id}|NAME:${player.name}',
                                version: QrVersions.auto,
                                size: 95,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        await _downloadScreenshot(
                          screenshotController,
                          'card_${_safeFileName(player.name)}.png',
                        );
                      },
                      icon: const Icon(Icons.file_download_outlined,
                          color: Colors.white, size: 20),
                      label: const Text(
                        'تنزيل الكارنيه كصورة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0))),
          const SizedBox(width: 4),
          Flexible(
            child: Text(value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238))),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadScreenshot(
      ScreenshotController controller, String fileName) async {
    try {
      final Uint8List? imageBytes = await controller.capture(
        pixelRatio: 2,
        delay: const Duration(milliseconds: 100),
      );
      if (imageBytes == null) throw Exception();

      if (kIsWeb) {
        final blob = html.Blob([imageBytes], 'image/png');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..style.display = 'none';
        html.document.body?.children.add(anchor);
        anchor.click();
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      } else {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Text('تم إنشاء الصورة'),
                  content: Image.memory(imageBytes),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    } catch (_) {}
  }

  String _safeFileName(String value) {
    return value.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').replaceAll(' ', '_');
  }

  void _showAddPlayerDialog() {
    final nameController = TextEditingController();
    final posController = TextEditingController();
    final birthController = TextEditingController();
    final branchController = TextEditingController();
    final heightController = TextEditingController();
    final weightController = TextEditingController();
    final phoneController = TextEditingController();
    final whatsappController = TextEditingController();

    String? selectedImageBase64;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title:
                    const Text('إضافة لاعب جديد', textAlign: TextAlign.right),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final image = await _pickImageAsBase64();
                          if (image != null) {
                            setDialogState(() => selectedImageBase64 = image);
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF1976D2),
                          child: selectedImageBase64 == null
                              ? const Icon(Icons.add_a_photo,
                                  color: Colors.white, size: 28)
                              : ClipOval(
                                  child: _buildImageWidget(selectedImageBase64,
                                      size: 80)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('اضغط لاختيار صورة اللاعب',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                      TextField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(labelText: 'اسم اللاعب')),
                      TextField(
                          controller: posController,
                          decoration:
                              const InputDecoration(labelText: 'المركز')),
                      TextField(
                          controller: birthController,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: 'سنة الميلاد')),
                      TextField(
                          controller: branchController,
                          decoration:
                              const InputDecoration(labelText: 'الفرع')),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                                  controller: heightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'الطول (سم)'))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                                  controller: weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      labelText: 'الوزن (كجم)'))),
                        ],
                      ),
                      TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(labelText: 'رقم الهاتف')),
                      TextField(
                          controller: whatsappController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(labelText: 'رقم واتساب')),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('إلغاء')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2)),
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) return;
                      final player = Player(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text.trim(),
                        position: posController.text.trim().isEmpty
                            ? 'غير محدد'
                            : posController.text.trim(),
                        birthYear: birthController.text.trim().isEmpty
                            ? '2002'
                            : birthController.text.trim(),
                        branch: branchController.text.trim().isEmpty
                            ? 'الرئيسي'
                            : branchController.text.trim(),
                        height: heightController.text.trim().isEmpty
                            ? '-'
                            : heightController.text.trim(),
                        weight: weightController.text.trim().isEmpty
                            ? '-'
                            : weightController.text.trim(),
                        phone: phoneController.text.trim().isEmpty
                            ? '-'
                            : phoneController.text.trim(),
                        whatsapp: whatsappController.text.trim().isEmpty
                            ? '-'
                            : whatsappController.text.trim(),
                        imageBase64: selectedImageBase64,
                        createdAt: DateTime.now(),
                        lastThreeDays: [true, true, false],
                      );
                      setState(() => players.add(player));
                      _applySorting();
                      await _saveData();
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                    },
                    child: const Text('إضافة وحفظ',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showEditPlayerDialog(Player player) {
    final nameController = TextEditingController(text: player.name);
    final posController = TextEditingController(text: player.position);
    final birthController = TextEditingController(text: player.birthYear);
    final branchController = TextEditingController(text: player.branch);
    final heightController = TextEditingController(text: player.height);
    final weightController = TextEditingController(text: player.weight);
    final phoneController = TextEditingController(text: player.phone);
    final whatsappController = TextEditingController(text: player.whatsapp);

    String? selectedImageBase64 = player.imageBase64;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('تعديل بيانات اللاعب',
                    textAlign: TextAlign.right),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final image = await _pickImageAsBase64();
                          if (image != null) {
                            setDialogState(() => selectedImageBase64 = image);
                          }
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF1976D2),
                          child: selectedImageBase64 == null
                              ? const Icon(Icons.add_a_photo,
                                  color: Colors.white, size: 28)
                              : ClipOval(
                                  child: _buildImageWidget(selectedImageBase64,
                                      size: 80)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('اضغط لتغيير صورة اللاعب',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                      TextField(
                          controller: nameController,
                          decoration:
                              const InputDecoration(labelText: 'الاسم')),
                      TextField(
                          controller: posController,
                          decoration:
                              const InputDecoration(labelText: 'المركز')),
                      TextField(
                          controller: birthController,
                          decoration:
                              const InputDecoration(labelText: 'سنة الميلاد')),
                      TextField(
                          controller: branchController,
                          decoration:
                              const InputDecoration(labelText: 'الفرع')),
                      Row(
                        children: [
                          Expanded(
                              child: TextField(
                                  controller: heightController,
                                  decoration: const InputDecoration(
                                      labelText: 'الطول (سم)'))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: TextField(
                                  controller: weightController,
                                  decoration: const InputDecoration(
                                      labelText: 'الوزن (كجم)'))),
                        ],
                      ),
                      TextField(
                          controller: phoneController,
                          decoration:
                              const InputDecoration(labelText: 'رقم الهاتف')),
                      TextField(
                          controller: whatsappController,
                          decoration:
                              const InputDecoration(labelText: 'رقم واتساب')),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('إلغاء')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB8C00)),
                    onPressed: () async {
                      setState(() {
                        player.name = nameController.text.trim();
                        player.position = posController.text.trim();
                        player.birthYear = birthController.text.trim();
                        player.branch = branchController.text.trim();
                        player.height = heightController.text.trim();
                        player.weight = weightController.text.trim();
                        player.phone = phoneController.text.trim();
                        player.whatsapp = whatsappController.text.trim();
                        player.imageBase64 = selectedImageBase64;
                      });
                      _applySorting();
                      await _saveData();
                      if (dialogContext.mounted) Navigator.pop(dialogContext);
                    },
                    child: const Text('حفظ التعديلات',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmDialog(Player player) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد الحذف', textAlign: TextAlign.right),
            content: Text('هل أنت متأكد من حذف اللاعب (${player.name})؟'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935)),
                onPressed: () async {
                  setState(() => players.removeWhere((p) => p.id == player.id));
                  await _saveData();
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                child: const Text('حذف', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortDropdown(
      String label, List<String> options, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.black54)),
          items: options
              .map((opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(opt,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} - '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  void _downloadBytes(Uint8List bytes, String fileName, String mimeType) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1976D2),
        onPressed: _showAddPlayerDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                color: const Color(0xFF1976D2),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: const Text(
                          'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'حفظ',
                      onPressed: _manualSave,
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openQrAttendanceScanner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner, size: 25),
                  label: const Text(
                    '📷 تسجيل الحضور بالـ QR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _playerSearchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'بحث بالاسم أو المركز أو الفرع أو المواليد',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _playerSearch.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'مسح البحث',
                          onPressed: _playerSearchController.clear,
                          icon: const Icon(Icons.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: _buildSortDropdown(
                          'ترتيب الفرع', ['الكل', 'اللاهون', 'الفيوم'], (v) {
                        sortByBranch = v;
                        _applySorting();
                      }),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 130,
                      child: _buildSortDropdown(
                          'ترتيب المركز', ['الكل', 'مدافع', 'حارس', 'هجوم'],
                          (v) {
                        sortByPosition = v;
                        _applySorting();
                      }),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 130,
                      child: _buildSortDropdown(
                          'ترتيب المواليد', ['الأحدث', 'الأقدم'], (v) {
                        sortByBirth = v;
                        _applySorting();
                      }),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 140,
                      child: _buildSortDropdown(
                          'ترتيب الاسم', ['أبجدي أ-ي', 'أبجدي ي-أ'], (v) {
                        sortByName = v;
                        _applySorting();
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _filteredPlayers.isEmpty
                  ? Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const Text(
                        'لا يوجد لاعبين مسجلين حالياً.\nاضغط على زر (+) لإضافة لاعب جديد.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 18,
                          headingRowHeight: 45,
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 60,
                          columns: const [
                            DataColumn(
                                label: Text('الصورة / السجل',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الاسم',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('المركز',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('المواليد',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الفرع',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الحضور',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الإجراءات',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: _filteredPlayers.map((player) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  InkWell(
                                    borderRadius: BorderRadius.circular(22),
                                    onTap: () =>
                                        _showAttendanceHistoryDialog(player),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.grey.shade200,
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: _buildImageWidget(
                                              player.imageBase64,
                                              size: 36),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 170,
                                    child: Text(
                                      player.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(Text(player.position)),
                                DataCell(Text(player.birthYear)),
                                DataCell(Text(player.branch)),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _recordAttendance(
                                            player,
                                            false,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                player.attendanceToday == false
                                                    ? Colors.red
                                                    : Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Icon(Icons.close,
                                              size: 16,
                                              color: player.attendanceToday ==
                                                      false
                                                  ? Colors.white
                                                  : Colors.red.shade700),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () async {
                                          await _recordAttendance(
                                            player,
                                            true,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color:
                                                player.attendanceToday == true
                                                    ? Colors.teal
                                                    : Colors.teal.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Icon(Icons.check,
                                              size: 16,
                                              color:
                                                  player.attendanceToday == true
                                                      ? Colors.white
                                                      : Colors.teal.shade700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildActionButton(
                                          Icons.badge,
                                          const Color(0xFF5E35B1),
                                          () => _showCardDialog(player)),
                                      const SizedBox(width: 6),
                                      _buildActionButton(
                                          Icons.edit,
                                          const Color(0xFFFB8C00),
                                          () => _showEditPlayerDialog(player)),
                                      const SizedBox(width: 6),
                                      _buildActionButton(
                                          Icons.delete,
                                          const Color(0xFFE53935),
                                          () =>
                                              _showDeleteConfirmDialog(player)),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// الاشتراكات
// ============================================================

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Player> players = [];

  final TextEditingController _subscriptionSearchController =
      TextEditingController();
  String _subscriptionSearch = '';

  List<Player> get _filteredSubscriptionPlayers {
    final query = _subscriptionSearch.trim().toLowerCase();
    if (query.isEmpty) return players;

    return players.where((player) {
      return player.name.toLowerCase().contains(query) ||
          player.position.toLowerCase().contains(query) ||
          player.branch.toLowerCase().contains(query) ||
          player.birthYear.toLowerCase().contains(query);
    }).toList();
  }

  final ScreenshotController receiptScreenshotController =
      ScreenshotController();

  late TextEditingController monthController;
  late TextEditingController amountController;
  late TextEditingController logoNameController;
  late TextEditingController responsibleController;

  @override
  void initState() {
    super.initState();
    _subscriptionSearchController.addListener(() {
      if (mounted) {
        setState(
            () => _subscriptionSearch = _subscriptionSearchController.text);
      }
    });
    monthController = TextEditingController(text: AcademySettings.targetMonth);
    amountController =
        TextEditingController(text: AcademySettings.subscriptionAmount);
    logoNameController =
        TextEditingController(text: AcademySettings.receiptLogoName);
    responsibleController =
        TextEditingController(text: AcademySettings.responsibleName);
    _loadPlayers();
  }

  @override
  void dispose() {
    _subscriptionSearchController.dispose();
    monthController.dispose();
    amountController.dispose();
    logoNameController.dispose();
    responsibleController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? playersString = prefs.getString('saved_players');
    if (playersString == null || playersString.isEmpty) return;

    try {
      final List decoded = jsonDecode(playersString);
      if (!mounted) return;
      setState(() {
        players = decoded
            .map((e) => Player.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      });
    } catch (_) {}
  }

  Future<void> _savePlayers() async {
    AcademySettings.targetMonth = monthController.text.trim();
    AcademySettings.subscriptionAmount = amountController.text.trim();
    AcademySettings.receiptLogoName = logoNameController.text.trim();
    AcademySettings.responsibleName = responsibleController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'saved_players', jsonEncode(players.map((e) => e.toJson()).toList()));
    await prefs.setString('target_month', AcademySettings.targetMonth);
    await prefs.setString('sub_amount', AcademySettings.subscriptionAmount);
    await prefs.setString('receipt_logo_name', AcademySettings.receiptLogoName);
    await prefs.setString('responsible_name', AcademySettings.responsibleName);

    // حفظ حالة الدفع في سجل اليوم، بينما تبقى السجلات السابقة ثابتة.
    await _saveDailyRecordSnapshot(players);
  }

  void _showResetConfirmDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('تأكيد إعادة الضبط', textAlign: TextAlign.right),
            content: const Text(
                'هل أنت متأكد من رغبتك في إعادة ضبط إعدادات الاشتراكات وحالات الدفع؟'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935)),
                onPressed: () async {
                  setState(() {
                    monthController.text = 'August 2026';
                    amountController.text = '300';
                    logoNameController.text = 'EVO';
                    responsibleController.text = 'محمد';
                    for (final player in players) {
                      player.isPaid = false;
                      player.paymentDate = null;
                      player.discountPercentage = 0;
                    }
                  });
                  await _savePlayers();
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                child: const Text('تأكيد إعادة الضبط',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDiscountDialog(Player player) {
    final discountController = TextEditingController(
      text: player.discountPercentage.toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تحديد نسبة الخصم للاعب: ${player.name}',
                textAlign: TextAlign.right),
            content: TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'نسبة الخصم من 100 (%)',
                suffixText: '%',
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2)),
                onPressed: () async {
                  double value = double.tryParse(discountController.text) ?? 0;
                  value = value.clamp(0, 100);
                  setState(() => player.discountPercentage = value);
                  await _savePlayers();
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                },
                child: const Text('حفظ', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReceiptDialog(Player player) {
    final now = DateTime.now();
    final formattedDate = '${now.year}/${now.month}/${now.day} - '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final baseAmount = double.tryParse(amountController.text) ?? 300;
    final discountValue = baseAmount * (player.discountPercentage / 100);
    final finalAmount = baseAmount - discountValue;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 390,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.grey, size: 20),
                        onPressed: () => Navigator.pop(dialogContext),
                      ),
                      const Expanded(
                        child: Text(
                          'إيصال تحصيل اشتراك شهري',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Screenshot(
                    controller: receiptScreenshotController,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            logoNameController.text.trim().isEmpty
                                ? 'EVO'
                                : logoNameController.text.trim(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4DA3FF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('إيصال تحصيل اشتراك شهري',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey)),
                          const Divider(height: 20),
                          _buildReceiptRow('اسم اللاعب:', player.name),
                          _buildReceiptRow('الفرع:', player.branch),
                          _buildReceiptRow('التاريخ والوقت:', formattedDate),
                          _buildReceiptRow(
                              'الشهر المستحق:', monthController.text),
                          _buildReceiptRow('قيمة الاشتراك الأساسية:',
                              '${baseAmount.toStringAsFixed(0)} ج.م'),
                          _buildReceiptRow('نسبة الخصم:',
                              '${player.discountPercentage.toInt()}%'),
                          _buildReceiptRow('قيمة الخصم:',
                              '${discountValue.toStringAsFixed(0)} ج.م'),
                          _buildReceiptRow('القيمة النهائية:',
                              '${finalAmount.toStringAsFixed(0)} ج.م'),
                          _buildReceiptRow(
                              'اسم المسئول:', responsibleController.text),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async => await _downloadReceipt(player),
                      icon: const Icon(Icons.file_download_outlined,
                          color: Colors.white, size: 20),
                      label: const Text(
                        'تنزيل الإيصال كصورة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _downloadReceipt(Player player) async {
    try {
      final Uint8List? imageBytes = await receiptScreenshotController.capture(
        pixelRatio: 2,
        delay: const Duration(milliseconds: 100),
      );
      if (imageBytes == null) throw Exception();

      if (kIsWeb) {
        _downloadBytes(imageBytes, 'receipt_${player.id}.png', 'image/png');
      } else {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Text('تم إنشاء الإيصال'),
                content: Image.memory(imageBytes),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إغلاق')),
                ],
              ),
            );
          },
        );
      }
    } catch (_) {}
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F))),
          ),
          Expanded(
            flex: 5,
            child: Text(value,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAllPaidReceipts() async {
    final paidPlayers = players.where((p) => p.isPaid).toList();
    if (paidPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('لا يوجد لاعبين قاموا بالدفع لتنزيل الإيصالات'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    final now = DateTime.now();
    final date = _formatDateTime(now);
    _showProgressDialog('جاري إنشاء جميع الإيصالات...');

    try {
      final archive = Archive();
      for (final player in paidPlayers) {
        final bytes = await receiptScreenshotController.captureFromWidget(
          _buildReceiptCaptureWidget(player, date),
          context: context,
          pixelRatio: 2,
          delay: const Duration(milliseconds: 120),
        );
        archive.addFile(ArchiveFile(
          'receipt_${_safeFileName(player.name)}_${player.id}.png',
          bytes.length,
          bytes,
        ));
      }

      final zipBytes = ZipEncoder().encode(archive);
      if (zipBytes == null || zipBytes.isEmpty)
        throw Exception('تعذر إنشاء ملف ZIP');

      final zipName =
          'all_paid_receipts_${_safeFileName(monthController.text)}.zip';
      if (kIsWeb) {
        _downloadBytes(
            Uint8List.fromList(zipBytes), zipName, 'application/zip');
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(Uint8List.fromList(zipBytes),
                mimeType: 'application/zip')
          ],
          fileNameOverrides: [zipName],
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر إنشاء ملف الإيصالات: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _closeProgressDialog();
    }
  }

  Widget _buildReceiptCaptureWidget(Player player, String date) {
    final baseAmount = double.tryParse(amountController.text) ?? 300;
    final discountValue = baseAmount * (player.discountPercentage / 100);
    final finalAmount = baseAmount - discountValue;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.white,
        child: Container(
          width: 390,
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  logoNameController.text.trim().isEmpty
                      ? 'EVO'
                      : logoNameController.text.trim(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2)),
                ),
                const SizedBox(height: 4),
                const Text('إيصال تحصيل اشتراك شهري',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                const Divider(height: 20),
                _buildReceiptRow('اسم اللاعب:', player.name),
                _buildReceiptRow('الفرع:', player.branch),
                _buildReceiptRow('التاريخ والوقت:', date),
                _buildReceiptRow('الشهر المستحق:', monthController.text),
                _buildReceiptRow('قيمة الاشتراك الأساسية:',
                    '${baseAmount.toStringAsFixed(0)} ج.م'),
                _buildReceiptRow(
                    'نسبة الخصم:', '${player.discountPercentage.toInt()}%'),
                _buildReceiptRow(
                    'قيمة الخصم:', '${discountValue.toStringAsFixed(0)} ج.م'),
                _buildReceiptRow('القيمة النهائية:',
                    '${finalAmount.toStringAsFixed(0)} ج.م'),
                _buildReceiptRow('اسم المسئول:', responsibleController.text),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProgressDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3)),
              const SizedBox(width: 14),
              Flexible(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  void _closeProgressDialog() {
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} - '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  String _safeFileName(String value) {
    final cleaned = value.trim().replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return cleaned.isEmpty ? 'player' : cleaned;
  }

  void _downloadBytes(Uint8List bytes, String fileName, String mimeType) {
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';
    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _downloadComprehensivePaidReport() async {
    if (players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('لا يوجد لاعبين لإنشاء التقرير'),
        backgroundColor: Colors.orange,
      ));
      return;
    }

    final now = DateTime.now();
    final downloadDate = _formatDateTime(now);
    final baseAmount = double.tryParse(amountController.text) ?? 300;

    double totalCollected = 0;
    for (final p in players) {
      if (p.isPaid) {
        totalCollected +=
            baseAmount - (baseAmount * p.discountPercentage / 100);
      }
    }

    _showProgressDialog('جاري إنشاء التقرير PDF...');

    try {
      // خط عربي حقيقي داخل ملف PDF لمنع ظهور المربعات أو الحروف غير المفهومة.
      // PdfGoogleFonts موجودة ضمن حزمة printing وتوفر Noto Naskh Arabic.
      final arabicFont = await PdfGoogleFonts.notoNaskhArabicRegular();
      final arabicBoldFont = await PdfGoogleFonts.notoNaskhArabicBold();

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(24, 28, 24, 28),
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(
            base: arabicFont,
            bold: arabicBoldFont,
          ),
          header: (_) => pw.Column(
            children: [
              pw.Text(
                'التقرير الشامل للاشتراكات',
                style: pw.TextStyle(
                  font: arabicBoldFont,
                  fontSize: 18,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'الشهر المستحق: ${monthController.text}',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 10,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'تاريخ تنزيل التقرير: $downloadDate',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 8,
                ),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),
            ],
          ),
          footer: (context) => pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'صفحة ${context.pageNumber} من ${context.pagesCount}',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 7,
              ),
            ),
          ),
          build: (_) => [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey500, width: .7),
                color: PdfColors.grey100,
              ),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: _pdfSummaryBox(
                      'إجمالي اللاعبين',
                      '${players.length}',
                      PdfColors.blue50,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: _pdfSummaryBox(
                      'المدفوع',
                      '${players.where((p) => p.isPaid).length}',
                      PdfColors.green50,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: _pdfSummaryBox(
                      'غير المدفوع',
                      '${players.where((p) => !p.isPaid).length}',
                      PdfColors.red50,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ),
                  pw.SizedBox(width: 6),
                  pw.Expanded(
                    child: _pdfSummaryBox(
                      'إجمالي المبلغ المحصل',
                      '${totalCollected.toStringAsFixed(0)} ج.م',
                      PdfColors.amber50,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 14),
            pw.Text(
              'كشف الاشتراكات',
              style: pw.TextStyle(
                font: arabicBoldFont,
                fontSize: 13,
              ),
            ),
            pw.SizedBox(height: 7),

            // جدول بشكل قريب من Excel، ويحتوي كل البيانات المطلوبة.
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey500,
                width: .6,
              ),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: pw.FlexColumnWidth(2.2),
                1: pw.FlexColumnWidth(3.1),
                2: pw.FlexColumnWidth(1.8),
                3: pw.FlexColumnWidth(1.8),
                4: pw.FlexColumnWidth(2.2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    _pdfCell(
                      'تاريخ تنزيل التقرير',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                    _pdfCell(
                      'اسم اللاعب',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                    _pdfCell(
                      'حالة الدفع',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                    _pdfCell(
                      'قيمة الاشتراك',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                    _pdfCell(
                      'التاريخ (تاريخ الدفع)',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ],
                ),
                ...players.map((p) {
                  final finalAmount =
                      baseAmount - (baseAmount * p.discountPercentage / 100);

                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: p.isPaid ? PdfColors.green50 : PdfColors.red50,
                    ),
                    children: [
                      _pdfCell(
                        downloadDate,
                        font: arabicFont,
                        boldFont: arabicBoldFont,
                      ),
                      _pdfCell(
                        p.name,
                        font: arabicFont,
                        boldFont: arabicBoldFont,
                      ),
                      _pdfCell(
                        p.isPaid ? 'دفع' : 'لم يدفع',
                        font: arabicFont,
                        boldFont: arabicBoldFont,
                      ),
                      _pdfCell(
                        p.isPaid
                            ? '${finalAmount.toStringAsFixed(0)} ج.م'
                            : '0 ج.م',
                        font: arabicFont,
                        boldFont: arabicBoldFont,
                      ),
                      _pdfCell(
                        p.isPaid ? (p.paymentDate ?? '-') : '-',
                        font: arabicFont,
                        boldFont: arabicBoldFont,
                      ),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 12),

            // صفوف إجمالية في نهاية الجدول مثل كشف Excel.
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey500,
                width: .6,
              ),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.blue100),
                  children: [
                    _pdfCell(
                      'إجمالي اللاعبين',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                    _pdfCell(
                      '${players.length}',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ],
                ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.amber50),
                  children: [
                    _pdfCell(
                      'إجمالي المبلغ المحصل',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                    _pdfCell(
                      '${totalCollected.toStringAsFixed(0)} ج.م',
                      isHeader: true,
                      font: arabicFont,
                      boldFont: arabicBoldFont,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

      final bytes = await pdf.save();
      final pdfName =
          'comprehensive_report_${_safeFileName(monthController.text)}.pdf';

      if (kIsWeb) {
        _downloadBytes(
          Uint8List.fromList(bytes),
          pdfName,
          'application/pdf',
        );
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(
              Uint8List.fromList(bytes),
              mimeType: 'application/pdf',
            ),
          ],
          fileNameOverrides: [pdfName],
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر إنشاء التقرير PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _closeProgressDialog();
    }
  }

  pw.Widget _pdfSummaryBox(
    String title,
    String value,
    PdfColor color, {
    required pw.Font font,
    required pw.Font boldFont,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        color: color,
        border: pw.Border.all(color: PdfColors.grey400, width: .4),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              font: font,
              fontSize: 7,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            value,
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 9,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfCell(
    String value, {
    bool isHeader = false,
    required pw.Font font,
    required pw.Font boldFont,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
      alignment: pw.Alignment.center,
      child: pw.Text(
        value,
        style: pw.TextStyle(
          font: isHeader ? boldFont : font,
          fontSize: isHeader ? 8 : 8.5,
        ),
        textAlign: pw.TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: const Color(0xFF1976D2),
                child: const Center(
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'قائمة تحصيل الاشتراكات الشهرية',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238)),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5E35B1)),
                        onPressed: _downloadAllPaidReceipts,
                        icon: const Icon(Icons.archive_outlined,
                            color: Colors.white, size: 16),
                        label: const Text('تنزيل جميع الإيصالات',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00796B)),
                        onPressed: _downloadComprehensivePaidReport,
                        icon: const Icon(Icons.summarize,
                            color: Colors.white, size: 16),
                        label: const Text('التقرير الشامل',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF607D8B)),
                        onPressed: _showResetConfirmDialog,
                        icon: const Icon(Icons.refresh,
                            color: Colors.white, size: 16),
                        label: const Text('إعادة ضبط',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _subscriptionSearchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'بحث بالاسم أو المركز أو الفرع أو المواليد',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _subscriptionSearch.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'مسح البحث',
                          onPressed: _subscriptionSearchController.clear,
                          icon: const Icon(Icons.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _filteredSubscriptionPlayers.isEmpty
                  ? Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: Text(
                        _subscriptionSearch.trim().isEmpty
                            ? 'لا يوجد لاعبين مضافين حالياً.'
                            : 'لا توجد نتائج مطابقة للبحث.',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 25,
                          headingRowHeight: 45,
                          dataRowMinHeight: 60,
                          dataRowMaxHeight: 60,
                          columns: const [
                            DataColumn(
                                label: Text('اسم اللاعب',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الفرع',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الخصم (%)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('حالة الدفع',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text('الإجراءات',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          rows: _filteredSubscriptionPlayers.map((player) {
                            return DataRow(
                              cells: [
                                DataCell(SizedBox(
                                    width: 180,
                                    child: Text(player.name,
                                        overflow: TextOverflow.ellipsis))),
                                DataCell(Text(player.branch)),
                                DataCell(
                                  InkWell(
                                    onTap: () => _showDiscountDialog(player),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(
                                          '${player.discountPercentage.toInt()}%',
                                          style: TextStyle(
                                              color: Colors.orange.shade900,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            player.isPaid = false;
                                            player.paymentDate = null;
                                          });
                                          await _savePlayers();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: !player.isPaid
                                                ? Colors.red.shade400
                                                : Colors.red.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text('لم يدفع',
                                              style: TextStyle(
                                                  color: !player.isPaid
                                                      ? Colors.white
                                                      : Colors.red.shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            player.isPaid = true;
                                            player.paymentDate =
                                                _formatDateTime(DateTime.now());
                                          });
                                          await _savePlayers();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: player.isPaid
                                                ? Colors.teal
                                                : Colors.teal.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text('تم الدفع',
                                              style: TextStyle(
                                                  color: player.isPaid
                                                      ? Colors.white
                                                      : Colors.teal.shade700,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE53935),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                    ),
                                    onPressed: () => _showReceiptDialog(player),
                                    icon: const Icon(Icons.image,
                                        size: 14, color: Colors.white),
                                    label: const Text('الإيصال',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ماسح QR لتسجيل الحضور - يعمل محلياً بدون إنترنت أو Cloud
// ============================================================

class QrAttendanceScannerScreen extends StatefulWidget {
  final List<Player> players;
  final Future<void> Function(Player player) onAttendance;

  const QrAttendanceScannerScreen({
    super.key,
    required this.players,
    required this.onAttendance,
  });

  @override
  State<QrAttendanceScannerScreen> createState() =>
      _QrAttendanceScannerScreenState();
}

class _QrAttendanceScannerScreenState extends State<QrAttendanceScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    detectionTimeoutMs: 1200,
  );

  bool _processing = false;
  String _status = 'وجّه الكاميرا نحو QR اللاعب';
  String? _lastPlayerName;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Player? _findPlayerFromQr(String raw) {
    final data = raw.trim();
    String? id;
    String? name;

    // التنسيق الحالي للكارنيه:
    // PLAYER_ID:<id>|NAME:<name>
    for (final part in data.split('|')) {
      if (part.startsWith('PLAYER_ID:')) {
        id = part.substring('PLAYER_ID:'.length).trim();
      } else if (part.startsWith('NAME:')) {
        name = part.substring('NAME:'.length).trim();
      }
    }

    if (id != null && id.isNotEmpty) {
      for (final player in widget.players) {
        if (player.id == id) return player;
      }
    }

    // توافق احتياطي مع QR قديم يحتوي الاسم فقط.
    if (name != null && name.isNotEmpty) {
      for (final player in widget.players) {
        if (player.name.trim() == name) return player;
      }
    }

    return null;
  }

  bool _alreadyPresentToday(Player player) {
    final now = DateTime.now();
    return player.attendanceHistory.any(
      (record) =>
          record.present &&
          record.dateTime.year == now.year &&
          record.dateTime.month == now.month &&
          record.dateTime.day == now.day,
    );
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_processing || capture.barcodes.isEmpty) return;

    final raw = capture.barcodes
        .map((b) => b.rawValue)
        .whereType<String>()
        .map((v) => v.trim())
        .firstWhere((v) => v.isNotEmpty, orElse: () => '');

    if (raw.isEmpty) return;

    final player = _findPlayerFromQr(raw);
    if (player == null) {
      if (!mounted) return;
      setState(() {
        _status = '❌ QR غير مرتبط بأي لاعب';
        _lastPlayerName = null;
      });
      await Future.delayed(const Duration(milliseconds: 1100));
      if (mounted) {
        setState(() => _status = 'وجّه الكاميرا نحو QR اللاعب');
      }
      return;
    }

    _processing = true;
    await _controller.stop();

    try {
      final alreadyPresent = _alreadyPresentToday(player);
      if (!alreadyPresent) {
        await widget.onAttendance(player);
      }

      if (!mounted) return;

      HapticFeedback.mediumImpact();
      setState(() {
        _lastPlayerName = player.name;
        _status = alreadyPresent
            ? '⚠️ ${player.name} مسجل حضوره بالفعل اليوم'
            : '✅ تم تسجيل حضور اللاعب ${player.name}';
      });

      await Future.delayed(const Duration(milliseconds: 1300));

      if (mounted) {
        setState(() {
          _status = 'جاهز لمسح اللاعب التالي';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _status = '❌ تعذر تسجيل الحضور: $e';
        });
      }
    } finally {
      _processing = false;
      if (mounted) {
        await _controller.start();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'تسجيل الحضور بالـ QR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF00796B),
          actions: [
            IconButton(
              tooltip: 'تبديل الكاميرا',
              icon: const Icon(Icons.cameraswitch),
              onPressed: () => _controller.switchCamera(),
            ),
            IconButton(
              tooltip: 'الفلاش',
              icon: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
              onPressed: () async {
                await _controller.toggleTorch();
                if (mounted) setState(() => _torchOn = !_torchOn);
              },
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _handleBarcode,
            ),
            IgnorePointer(
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 28,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .78),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_lastPlayerName != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _lastPlayerName!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// الإعدادات
// ============================================================

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<String?> _pickLogo() async {
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        maxWidth: 1200,
      );
      if (file == null) return null;
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (_) {
      return null;
    }
  }

  Widget _logoWidget() {
    final image = AcademySettings.academyLogoBase64;
    if (image == null || image.isEmpty) {
      return const Icon(Icons.image, size: 40, color: Colors.grey);
    }
    try {
      return Image.memory(base64Decode(image), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
        return const Icon(Icons.image, size: 40, color: Colors.grey);
      });
    } catch (_) {
      return const Icon(Icons.image, size: 40, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: const Color(0xFF1976D2),
                child: const Center(
                  child: Text(
                    'إعدادات الأكاديمية',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'إدراج شعار الكارنيه',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'اختر صورة الشعار من الاستوديو أو الملفات ليتم حفظها وعرضها تلقائياً.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _logoWidget(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1976D2),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                              ),
                              onPressed: () async {
                                final image = await _pickLogo();
                                if (image == null) return;
                                final prefs =
                                    await SharedPreferences.getInstance();
                                setState(() =>
                                    AcademySettings.academyLogoBase64 = image);
                                await prefs.setString(
                                    'academy_logo_base64', image);
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'تم حفظ وتحديث شعار الكارنيه تلقائياً')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.folder_open,
                                  color: Colors.white, size: 18),
                              label: const Text(
                                  'اختيار شعار من الملفات / الاستوديو',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
