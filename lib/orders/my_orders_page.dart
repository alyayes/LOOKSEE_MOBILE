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
    List<dynamic> filtered = selectedTab == 'all' 
        ? allOrders 
        : allOrders.where((o) => o['status'].toString().toLowerCase() == selectedTab).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final order = filtered[index];
                final item = order['items'][0];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      "http://172.28.115.142:8001/storage/products/${item['produk']['gambar_produk']}",
                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                    ),
                    title: Text("Order #${order['order_id']}"),
                    subtitle: Text("Total: Rp ${order['grand_total']} - ${order['status']}"),
                    trailing: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentDetailsPage(orderData: order))),
                      child: const Text("Bayar/Detail"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}