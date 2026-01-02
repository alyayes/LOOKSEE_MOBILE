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
    // Memanggil fungsi getOrders dari ApiService yang menggunakan route /api/orders
    final data = await ApiService().getOrders();
    setState(() {
      allOrders = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Logika Filter sesuai kolom 'status' di database (lowercase)
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
          // TABS OVAL
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

          // LIST ORDER
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF69B4)))
                : RefreshIndicator(
                    onRefresh: fetchOrders,
                    child: filteredOrders.isEmpty
                        ? Center(child: Text("Belum ada pesanan di kategori $selectedTab"))
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: filteredOrders.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              return _buildOrderCard(filteredOrders[index]);
                            },
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
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final List items = order['items'] ?? [];
    if (items.isEmpty) return const SizedBox();
    final firstItem = items[0]['produk'] ?? {};
    final itemCount = items.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['order_date'] ?? "", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFF0F5), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  order['status'].toString().toUpperCase(),
                  style: const TextStyle(color: Color(0xFFFF69B4), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "http://172.28.115.142:8001/storage/products/${firstItem['gambar_produk']}",
                  width: 70, height: 70, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(firstItem['nama_produk'] ?? "Product", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(itemCount > 1 ? '+ ${itemCount - 1} items lainnya' : "Qty: ${items[0]['quantity']}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 8),
                    Text("Rp ${order['grand_total']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
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
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF69B4), foregroundColor: Colors.white, shape: const StadiumBorder()),
                    child: const Text("Pay Now", style: TextStyle(fontSize: 13)),
                  ),
                ),
              OutlinedButton(
                onPressed: () => _showOrderDetailModal(order['order_id'].toString()),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF69B4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(0, 36),
                ),
                child: const Text("See Detail", style: TextStyle(color: Color(0xFFFF69B4), fontSize: 13)),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showOrderDetailModal(String orderId) async {
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
    // Memanggil detail pesanan dari /api/orders/{id}
    final data = await ApiService().getOrderDetail(orderId);
    Navigator.pop(context);

    if (data != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          expand: false,
          builder: (_, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order Detail #${data['order_id']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(height: 32),
                const Text("Recipient Info", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("${data['nama_penerima']} (${data['no_telepon']})"),
                Text(data['alamat_lengkap']),
                const Divider(height: 32),
                const Text("Products", style: TextStyle(fontWeight: FontWeight.bold)),
                ...(data['items'] as List).map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item['nama_produk']),
                  subtitle: Text("${item['quantity']} x Rp ${item['price_at_purchase']}"),
                )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Rp ${data['total_price']}", style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Close Detail"))),
              ],
            ),
          ),
        ),
      );
    }
  }
}