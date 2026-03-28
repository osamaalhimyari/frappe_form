import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frappe_form/frappe_form.dart';
import 'package:intl/intl.dart';
import 'package:contribution_heatmap/contribution_heatmap.dart';
// import 'package:get/get.dart';

class HeatMapView extends DocFieldTextFieldView {
  final List<dynamic> activityData;

  HeatMapView({super.key, required this.activityData, required super.field});

  @override
  State<HeatMapView> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMapView> {
  DateTime? selectedDate;
  Offset? _tapPosition;
  String? _tooltipText;

  //  Bool parameters controlled by buttons
  bool splitMonth = true;
  bool showCellDate = true;
  bool showMonthLabels = true;

  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> stockMap = buildStockMap(widget.activityData);

    List<ContributionEntry> entries = stockMap.entries
        .map((e) => ContributionEntry(e.key, e.value.toInt()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  Control buttons
        _buildControls(),
        const SizedBox(height: 8),

        //  Heatmap area
        SizedBox(
          height: 260,
          width: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (details) {
                      _tapPosition = details.globalPosition;
                    },
                    child: ContributionHeatmap(
                      entries: entries,
                      cellSize: 20,
                      cellSpacing: 4,
                      heatmapColor: HeatmapColor.green,
                      cellRadius: 5,

                      weekdayTextStyle: Theme.of(context).textTheme.bodyLarge,
                      monthTextStyle: Theme.of(context).textTheme.bodyLarge,
                      cellDateTextStyle: Theme.of(context).textTheme.bodyLarge!
                          .copyWith(color: Colors.black),

                      //  Controlled by buttons
                      splittedMonthView: splitMonth,
                      showCellDate: showCellDate,
                      showMonthLabels: showMonthLabels,
                      startWeekday: 7,

                      //  Cell tap tooltip
                      onCellTap: (date, value) {
                        final formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(date);
                        setState(() {
                          selectedDate = date;
                          _tooltipText = '$formattedDate: $value';
                        });

                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() => _tooltipText = null);
                        });
                      },
                    ),
                  ),
                ),
              ),

              //  Tooltip overlay
              if (_tooltipText != null && _tapPosition != null)
                Positioned(
                  left: _tapPosition!.dx - 90,
                  top: _tapPosition!.dy - 70,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _tooltipText!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  //  Build the control buttons
  Widget _buildControls() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        FilterChip(
          label: const Text('Split Months'),
          selected: splitMonth,
          onSelected: (v) => setState(() => splitMonth = v),
        ),
        FilterChip(
          label: const Text('Cell Date'),
          selected: showCellDate,
          onSelected: (v) => setState(() => showCellDate = v),
        ),
        FilterChip(
          label: const Text('Month Labels'),
          selected: showMonthLabels,
          onSelected: (v) => setState(() => showMonthLabels = v),
        ),
      ],
    );
  }

  //  Build the stock map with amplification (strong visual)
  Map<DateTime, double> buildStockMap(List<dynamic> activityData) {
    final Map<DateTime, double> stockMap = {};

    for (var entry in activityData) {
      if (entry['posting_date'] == null || entry['out_qty'] == null) continue;

      final DateTime date = DateTime.parse(entry['posting_date']);

      double qty = (entry['out_qty'] as num).abs().toDouble();

      qty = math.log(qty + 2) * 8;
      qty = math.pow(qty, 1.15).toDouble();
      qty = math.max(qty, 2.0); // minimum visible intensity

      stockMap.update(date, (value) => value + qty, ifAbsent: () => qty);
    }

    return stockMap;
  }
}
