class OrderInvoiceModel {
  final String invoiceNo;
  final String date;
  final int amountPaid;
  final String deliveryAddress;

  OrderInvoiceModel({
    required this.invoiceNo,
    required this.date,
    required this.amountPaid,
    required this.deliveryAddress,
  });

  factory OrderInvoiceModel.fromJson(Map<String, dynamic> json) {
    return OrderInvoiceModel(
      invoiceNo: json['invoice_no'] ?? 'INV-20261020-001',
      date: json['date'] ?? DateTime.now().toIso8601String(),
      amountPaid: (json['amount_paid'] ?? 0).toInt(),
      deliveryAddress: json['delivery_address'] ?? '',
    );
  }
}
