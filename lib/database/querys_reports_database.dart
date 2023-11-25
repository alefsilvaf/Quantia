import 'database_helper.dart';

class QueryReportDatabase {
  static final QueryReportDatabase instance =
      QueryReportDatabase._privateConstructor();

  QueryReportDatabase._privateConstructor();

  Future<List<Map<String, dynamic>>> getDueSalesGroupByCustomer(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final StringBuffer queryBuffer = StringBuffer('''
        SELECT
          C.Name AS customer_name,
          SUM(S.total_price) AS total_due,
          GROUP_CONCAT(P.name) AS products_sold,
          GROUP_CONCAT(S.sale_date) AS sale_dates
        FROM sales S
        INNER JOIN customers C ON C.id = S.customer_id
        INNER JOIN sale_items SI ON SI.sale_id = S.id
        INNER JOIN products P ON P.id = SI.product_id
        WHERE S.is_credit = 1 AND S.payment_date IS NULL

      ''');

      if (startDate != null && endDate != null) {
        // Ajustar a primeira data para 00:00:00
        DateTime adjustedStartDate =
            DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);

        // Ajustar a última data para 23:59:59
        DateTime adjustedEndDate =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

        queryBuffer.write('''
    AND S.sale_date BETWEEN '${adjustedStartDate.toIso8601String()}' AND '${adjustedEndDate.toIso8601String()}'
  ''');
      }

      queryBuffer.write('GROUP BY C.id, C.Name');

      final String query = queryBuffer.toString();

      return await db.rawQuery(query);
    } catch (e) {
      print('Erro ao obter relatório de clientes em dívida: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopSellingProducts(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final StringBuffer queryBuffer = StringBuffer('''
      SELECT
        P.name AS product_name,
        SUM(SI.quantity) AS total_sold,
        AVG(P.price) AS average_price,
        SUM(SI.quantity * P.price) AS total_revenue
      FROM sales S
      INNER JOIN sale_items SI ON SI.sale_id = S.id
      INNER JOIN products P ON P.id = SI.product_id
      WHERE 0 = 0
      ''');

      if (startDate != null && endDate != null) {
        DateTime adjustedStartDate =
            DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);

        DateTime adjustedEndDate =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

        queryBuffer.write('''
        AND S.sale_date BETWEEN '${adjustedStartDate.toIso8601String()}' AND '${adjustedEndDate.toIso8601String()}'
      ''');
      }

      queryBuffer.write('GROUP BY P.id, P.name ORDER BY total_sold DESC');

      final String query = queryBuffer.toString();

      return await db.rawQuery(query);
    } catch (e) {
      print('Erro ao obter relatório de produtos mais vendidos: $e');
      return [];
    }
  }
}
