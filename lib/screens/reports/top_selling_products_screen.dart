import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tcc/database/querys_reports_database.dart';

class TopSellingProductsReportScreen extends StatefulWidget {
  @override
  _TopSellingProductsReportScreenState createState() =>
      _TopSellingProductsReportScreenState();
}

class _TopSellingProductsReportScreenState
    extends State<TopSellingProductsReportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _reportData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Produtos Mais Vendidos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por data:',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: _selectStartDate,
                    child: Text('Inicial'),
                  ),
                ),
                Container(
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: _selectEndDate,
                    child: Text('Final'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            _buildDateText(),
            SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _refreshData,
                child: Text('Atualizar Relatório'),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildReportList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateText() {
    String dateText = _startDate != null && _endDate != null
        ? 'De ${DateFormat('dd/MM/yyyy').format(_startDate!)} à ${DateFormat('dd/MM/yyyy').format(_endDate!)}'
        : 'Selecione um intervalo de datas';

    return Text(
      dateText,
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildReportList() {
    if (_reportData.isEmpty) {
      return Center(
        child: Text('Nenhum dado disponível para o período selecionado'),
      );
    }

    return ListView.builder(
      itemCount: _reportData.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> rowData = _reportData[index];

        String productName = rowData['product_name'] ?? '';
        double totalSold = rowData['total_sold'] ?? 0.0;
        double averagePrice = rowData['average_price'] ?? 0.0;
        double totalRevenue = rowData['total_revenue'] ?? 0.0;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Produto: $productName'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantidade Vendida: $totalSold'),
                Text('Preço Médio: $averagePrice'),
                Text('Receita Total: $totalRevenue'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  void _selectEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  void _refreshData() async {
    List<Map<String, dynamic>> reportData = await QueryReportDatabase.instance
        .getTopSellingProducts(startDate: _startDate, endDate: _endDate);

    setState(() {
      _reportData = reportData;
      _startDate = null;
      _endDate = null;
    });
  }
}
