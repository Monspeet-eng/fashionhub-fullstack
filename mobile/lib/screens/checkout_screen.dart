import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/checkout_provider.dart';
import '../utils/currency_formatter.dart';
import '../widgets/fashion_app_bar.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController(text: 'budi.fashion@example.com');
  final _firstNameCtrl = TextEditingController(text: 'Budi');
  final _lastNameCtrl = TextEditingController(text: 'Santoso');
  final _addressCtrl =
      TextEditingController(text: 'Jl. Merdeka No. 45, Jakarta Pusat');
  final _zipCtrl = TextEditingController(text: '10110');
  final _phoneCtrl = TextEditingController(text: '081234567890');

  final _cardNumberCtrl = TextEditingController(text: '4111 2222 3333 4444');
  final _expiryCtrl = TextEditingController(text: '12/28');
  final _cvvCtrl = TextEditingController(text: '123');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _addressCtrl.dispose();
    _zipCtrl.dispose();
    _phoneCtrl.dispose();
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi seluruh field yang wajib diisi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final cart = context.read<CartProvider>();
    final checkout = context.read<CheckoutProvider>();

    final invoice = await checkout.processCheckout(
      email: _emailCtrl.text.trim(),
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      zipCode: _zipCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      cardNumber: _cardNumberCtrl.text.trim(),
      expiryDate: _expiryCtrl.text.trim(),
      cvv: _cvvCtrl.text.trim(),
      couponCode: cart.couponCode,
      totalAmount: cart.grandTotal,
    );

    if (!mounted) return;
    if (invoice != null) {
      cart.clearLocalCart();
      Navigator.of(context).pushReplacementNamed('/invoice');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final checkout = context.watch<CheckoutProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const FashionAppBar(title: 'CHECKOUT & PAYMENT', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Ringkasan Pesanan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'RINGKASAN PESANAN',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Item (${cart.totalItems} pcs)'),
                        Text(CurrencyFormatter.formatIdr(cart.subtotal)),
                      ],
                    ),
                    if (cart.discountAmount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Diskon (${cart.couponCode})',
                              style: const TextStyle(color: Colors.green)),
                          Text(
                            '- ${CurrencyFormatter.formatIdr(cart.discountAmount)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Pengiriman'),
                        Text('GRATIS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8B6508))),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Tagihan',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        Text(
                          CurrencyFormatter.formatIdr(cart.grandTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: Color(0xFF8B6508),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 1. Kontak Pemesan
              _SectionCard(
                title: '1. INFORMASI KONTAK',
                children: [
                  _buildTextField(
                    controller: _emailCtrl,
                    label: 'Alamat Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Masukkan alamat email yang valid'
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Informasi Pengiriman
              _SectionCard(
                title: '2. ALAMAT PENGIRIMAN',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameCtrl,
                          label: 'Nama Depan',
                          icon: Icons.person_outline,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameCtrl,
                          label: 'Nama Belakang',
                          icon: Icons.person_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _addressCtrl,
                    label: 'Alamat Lengkap',
                    icon: Icons.location_on_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _zipCtrl,
                          label: 'Kode Pos',
                          icon: Icons.markunread_mailbox_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _phoneCtrl,
                          label: 'Nomor Telepon',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 3. Simulasi Metode Pembayaran (Dummy Credit Card)
              _SectionCard(
                title: '3. METODE PEMBAYARAN (SIMULASI CREDIT CARD)',
                children: [
                  _buildTextField(
                    controller: _cardNumberCtrl,
                    label: 'Card Number',
                    icon: Icons.credit_card,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _expiryCtrl,
                          label: 'Expiry Date (MM/YY)',
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _cvvCtrl,
                          label: 'CVV',
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: checkout.isSubmitting ? null : _submitOrder,
                child: checkout.isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'BAYAR SEKARANG',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator ??
          (v) => v == null || v.trim().isEmpty ? '$label wajib diisi' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}
