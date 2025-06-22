import 'package:coeur_net_app/providers/tensor_provider.dart';
import 'package:coeur_net_app/views/widget/error_presentation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TensorWidget extends ConsumerWidget {
  const TensorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Mon tensor')),

      body: Center(child: _Content()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.invalidate(tensorProvider),
        tooltip: 'Generer un nouveau tensor',
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(tensorProvider);

    return provider.when(
      data: (tensor) => _TensorChart(tensor: tensor),
      loading: () => CircularProgressIndicator(strokeWidth: 48.0),
      error:
          (error, stackTrace) =>
              ErrorPresentation(error: error, stackTrace: stackTrace),
    );
  }
}

class _TensorChart extends StatelessWidget {
  final List<double> tensor;
  const _TensorChart({required this.tensor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 400,
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barGroups:
              tensor
                  .asMap()
                  .entries
                  .map(
                    (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: double.parse((entry.value.toStringAsFixed(3))),
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  )
                  .toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          ),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }
}
