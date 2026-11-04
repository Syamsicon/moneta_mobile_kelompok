import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/quick_add_button.dart';
import '../widgets/top_nav_bar.dart';
import '../widgets/user_header.dart';
import '../widgets/transaction_list_section.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Fixed at top)
            Obx(
              () => TopNavBar(
                selectedIndex: controller.selectedNavIndex.value,
                onNavTap: controller.changeNavIndex,
              ),
            ),
            const SizedBox(height: 8),

            // Main White Sheet (Scrollable)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.sheetWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Header User
                      Obx(
                        () => UserHeader(
                          userName: controller.userName.value,
                          date: controller.currentDate.value,
                          initial: controller.userInitial.value,
                          onSettingsTap: controller.onSettingsClick,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Obx(
                        () => _AlokasiCard(
                          kebutuhan: controller.kebutuhan.value,
                          keinginan: controller.keinginan.value,
                          tabungan: controller.tabungan.value,
                        ),
                      ),
                      Obx(
                        () => _RencanaRealitaCard(
                          rencana: controller.rencana.value,
                          realita: controller.realita.value,
                        ),
                      ),
                      const _PersebaranCard(),

                      Obx(
                        () => TransactionListSection(
                          transaction: controller.transactions.toList(),
                          onViewAll: () {},
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: QuickAddButton(
        onPressed: controller.onQuickAddClick,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// ======= Chart =======

class _ChartItem {
  const _ChartItem(this.label, this.nominal, this.color);
  final String label;
  final double nominal;
  final Color color;
}

// dipake di card alokasi sama card persebaran

class _CardFrame extends StatelessWidget {
  const _CardFrame({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text('Oktober', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// pie chart dan donut chart

class _PieBox extends StatelessWidget {
  const _PieBox({
    required this.items, 
    required this.size, 
    this.holeRadius = 0, // 0 = pieChart, >0 = donut 
    this.center,
  });
  final List<_ChartItem> items;
  final double size;
  final double holeRadius;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final thickness = holeRadius > 0 ? size / 2 - holeRadius : size / 2;
    final total = items.fold<double>(0, (s, e) => s + e.nominal);

    final sections = total > 0
      ? [
        for (final e in items)
          if (e.nominal > 0)
            PieChartSectionData(
              value: e.nominal,
              color: e.color,
              radius: thickness,
              showTitle: false,
            ),
      ] : [
        PieChartSectionData(
          value: 1,
          color: const Color(0xFFE0E0E0),
          radius: thickness,
          showTitle: false,
        ),
      ];
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: 90,
              sectionsSpace: 2,
              centerSpaceRadius: holeRadius,
              borderData: FlBorderData(show: false),
              pieTouchData: PieTouchData(enabled: false),
              sections: sections,
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

// legend untuk masing masing chart

class _LegendList extends StatelessWidget {
  const _LegendList(this.items);
  final List<_ChartItem> items;

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (s, e) => s + e.nominal);
    return Column(
      children: [
        for (final e in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: e.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26, width: 0.5),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(e.label, style: const TextStyle(fontSize: 11)),
                ),
                SizedBox(
                  width: 34,
                  child: Text(
                    total > 0 ?'${(e.nominal / total * 100).round()}%' : '0%',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    _rupiah(e.nominal),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFFA09DAE)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ==== card alokasi ====

class _AlokasiCard extends StatelessWidget {
  const _AlokasiCard({
    required this.kebutuhan,
    required this.keinginan,
    required this.tabungan,
  });
  final double kebutuhan;
  final double keinginan;
  final double tabungan;

  @override
  Widget build(BuildContext context) {
    final items = [
      _ChartItem('Kebutuhan', kebutuhan, const Color(0xFF22212C)),
      _ChartItem('Keinginan', keinginan, const Color(0xFF777582)),
      _ChartItem('Tabungan', tabungan, const Color(0xFFF0EDF9)),
    ];
    final total = kebutuhan + keinginan + tabungan;

    return _CardFrame(
      title: 'Alokasi',
      child: Row(
        children: [
          _PieBox(
            items: items,
            size: 110,
            holeRadius: 32,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_ringkas(total),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text('Anggaran', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: _LegendList(items)),
        ],
      ),
    );
  }
}

// ==== card persebaran  =====
const _contohPersebaran = [
  _ChartItem('Transportasi', 640000, Color(0xFF8C8C8C)),
  _ChartItem('Makan', 1600000, Colors.black),
  _ChartItem('Langganan', 880000, Color(0xFFD3D3D3)),
  _ChartItem('Lain-lain...', 880000, Color(0xFF555555)),
];

class _PersebaranCard extends StatelessWidget {
  const _PersebaranCard();

  @override
  Widget build(BuildContext context) {
    return const _CardFrame(
      title: 'Persebaran',
      child: Column(
        children: [
          Center(child: _PieBox(items: _contohPersebaran, size: 140)),
          SizedBox(height: 12),
          _LegendList(_contohPersebaran),
        ],
      ),
    );
  }
}

// ===== bar chart =====
class _BarLegendRow extends StatelessWidget {
  const _BarLegendRow(
    this.label, this.color, this.persen, this.nominal
  );

  final String label;
  final Color color;
  final int persen;
  final String nominal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26, width: 0.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFFA09DAE))),
          ),
          SizedBox(
            width: 34,
            child: Text('$persen%',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 76,
            child: Text(nominal,
                maxLines: 1,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFFA09DAE))),
          ),
        ],
      ),
    );
  }
}

// konversi total alokasi ke ("Rp" + n + "Juta")
String _ringkas(double n) {
  if (n >= 1000000) {
    final juta = n / 1000000;
    final teks = juta == juta.roundToDouble()
        ? juta.round().toString()
        : juta.toStringAsFixed(1).replaceAll('.', ',');
    return 'Rp$teks jt';
  }
  if (n >= 1000) return 'Rp${(n / 1000).round()} rb';
  return 'Rp${n.round()}';
}

String _rupiah(double nilai) {
  final digits = nilai.round().toString();
  final dots = digits.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  return 'Rp$dots';
}

class _RencanaRealitaCard extends StatelessWidget {
  const _RencanaRealitaCard({
    this.rencana = 2000000, 
    this.realita = 1500000,
    });
  final double rencana;
  final double realita;

  static const _gradasi = Color(0xFF8C8C8C);

  @override
  Widget build(BuildContext context) {
    final rasio = rencana > 0 ? realita / rencana : 0.0;

    return _CardFrame(
      title: 'Rencana | Realita',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 16,
            child: Container(
              height: 16,
              width: double.infinity,
              color: _gradasi,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: rasio.clamp(0.0, 1.0),
                heightFactor: 1,
                child: const ColoredBox(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _BarLegendRow('Rencana', _gradasi, 100, _rupiah(rencana)),
          _BarLegendRow('Realita', Colors.black, (rasio * 100).round(), _rupiah(realita)),
        ],
      ),
    );
  }
}