import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_tcc/database/querys_reports_database.dart';

class DueSalesReportScreen extends StatefulWidget {
  @override
  _DueSalesReportScreenState createState() => _DueSalesReportScreenState();
}

class _DueSalesReportScreenState extends State<DueSalesReportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _reportData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Clientes em Dívida'),
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
                  width: 150.0, // Ajuste a largura conforme necessário
                  child: ElevatedButton(
                    onPressed: _selectStartDate,
                    child: Text('Inicial'),
                  ),
                ),
                Container(
                  width: 150.0, // Ajuste a largura conforme necessário
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

        String customerName = rowData['customer_name'] ?? '';
        double totalDue = rowData['total_due'] ?? 0.0;
        List<String> productsSold =
            (rowData['products_sold'] as String).split(',');
        List<String> saleDates = (rowData['sale_dates'] as String).split(',');

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Cliente: $customerName'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Devido: $totalDue'),
                Text('Produtos Vendidos: ${productsSold.join(', ')}'),
                Text('Datas de Venda: ${_formatSaleDates(saleDates)}'),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatSaleDates(List<String> saleDates) {
    return saleDates.map((date) {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    }).join(', ');
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
        .getDueSalesGroupByCustomer(startDate: _startDate, endDate: _endDate);

    setState(() {
      _reportData = reportData;
      _startDate = null;
      _endDate = null;
    });
  }
}
