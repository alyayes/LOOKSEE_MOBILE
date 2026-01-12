import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../payment/payment_details_page.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String selectedTab = 'all';
  final List<String> tabs = ['all', 'pending', 'prepared', 'shipped', 'completed'];
  List<dynamic> allOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    final data = await ApiService().getOrders();
    setState(() {
      allOrders = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredOrders = selectedTab == 'all'
        ? allOrders
        : allOrders.where((order) => order['status'].toString().toLowerCase() == selectedTab).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: tabs.map((tab) => _buildTab(tab)).toList(),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF69B4)))
                : RefreshIndicator(
                    onRefresh: fetchOrders,
                    child: filteredOrders.isEmpty
                        ? const Center(child: Text("Belum ada pesanan"))
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: filteredOrders.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) => _buildOrderCard(filteredOrders[index]),
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    bool isActive = selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tab),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF69B4) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFFFF69B4) : Colors.grey.shade300),
        ),
        child: Text(
          tab.toUpperCase(),
          style: TextStyle(color: isActive ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final List items = order['items'] ?? [];
    if (items.isEmpty) return const SizedBox();
    final firstProduct = items[0]['produk'] ?? {};
    final itemCount = items.length;
    String imageName = firstProduct['gambar_produk'] ?? "";
    String assetPath = 'assets/produk-looksee/$imageName';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['order_date'] ?? "", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                order['status'].toString().toUpperCase(),
                style: const TextStyle(color: Color(0xFFFF69B4), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  assetPath,
                  width: 70, height: 70, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: Colors.grey[200], child: const Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(firstProduct['nama_produk'] ?? "Product", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(itemCount > 1 ? "+ ${itemCount - 1} other items" : "Quantity: ${items[0]['quantity']}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 8),
                    Text("Rp ${order['grand_total']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order['status'].toString().toLowerCase() == 'pending')
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailsPage(orderData: order))),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), shape: const StadiumBorder()),
                    child: const Text("Pay Now", style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
              OutlinedButton(
                onPressed: () => _showOrderDetailModal(order['order_id'].toString()),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFFF69B4)), shape: const StadiumBorder()),
                child: const Text("See Detail", style: TextStyle(color: Color(0xFFFF69B4), fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }

  // === MODAL DETAIL LENGKAP (API SYNC) ===
  void _showOrderDetailModal(String orderId) async {
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
    final data = await ApiService().getOrderDetail(orderId);
    Navigator.pop(context);

    if (data != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Modal
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order #${data['order_id']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(data['status'].toString().toUpperCase(), style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 30),

                // Section: Penerima & Alamat
                const Text("Shipping Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                _detailInfoRow("Recipient", data['nama_penerima'] ?? "-"),
                _detailInfoRow("Phone", data['no_telepon'] ?? "-"),
                _detailInfoRow("Address", "${data['alamat_lengkap']}, ${data['kota']}, ${data['provinsi']} (${data['kode_pos']})"),
                
                const Divider(height: 30),

                // Section: Produk
                const Text("Items Ordered", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                ...(data['items'] as List).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/produk-looksee/${item['gambar_produk']}', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___)=>const Icon(Icons.image)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['nama_produk'], style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text("${item['quantity']} x Rp ${item['price_at_purchase']}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      )
                    ],
                  ),
                )).toList(),

                const Divider(height: 30),

                // Section: Pembayaran
                const Text("Payment Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                _detailInfoRow("Method", data['payment_method'] ?? "-"),
                if (data['payment_detail'] != null && data['payment_detail'].toString().isNotEmpty)
                  _detailInfoRow("Provider", data['payment_detail']),
                _detailInfoRow("Trans. ID", data['transaction_code'] ?? "-"),
                
                const Divider(height: 30),

                // Section: Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp ${data['total_price']}", style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text("Close Detail")
                )),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _detailInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}