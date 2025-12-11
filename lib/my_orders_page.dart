import 'package:flutter/material.dart';
import 'payment_details_page.dart';

// 1. MODEL DATA PESANAN (Supaya bisa difilter)
class OrderItem {
  String title;
  String img;
  String size;
  String price;
  int qty;

  OrderItem({required this.title, required this.img, required this.size, required this.price, this.qty = 1});
}

class Order {
  String id;
  String date;
  String status; // 'Pending', 'Prepared', 'Shipped', 'Completed'
  List<OrderItem> items;
  String paymentMethod;
  String total;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.paymentMethod,
    required this.total,
  });
}

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String selectedTab = 'All';
  final List<String> tabs = ['All', 'Pending', 'Prepared', 'Shipped', 'Completed'];

  // 2. DATA DUMMY PESANAN
  final List<Order> allOrders = [
    Order(
      id: "#52",
      date: "01 April 2025",
      status: "Pending",
      paymentMethod: "Bank Transfer (BCA)",
      total: "Rp 195.000",
      items: [
        OrderItem(title: "Robbonie Cardigan", img: "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=200", size: "M", price: "Rp 195.000"),
      ],
    ),
    Order(
      id: "#48",
      date: "28 Maret 2025",
      status: "Shipped",
      paymentMethod: "E-Wallet (Dana)",
      total: "Rp 295.000",
      items: [
        OrderItem(title: "Arket Shirt", img: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=200", size: "L", price: "Rp 120.000"),
        OrderItem(title: "Sunny Top", img: "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=200", size: "S", price: "Rp 175.000"),
      ],
    ),
    Order(
      id: "#45",
      date: "25 Maret 2025",
      status: "Completed",
      paymentMethod: "COD",
      total: "Rp 175.000",
      items: [
        OrderItem(title: "Lily Top", img: "https://images.unsplash.com/photo-1620799140408-ed5341cd2431?q=80&w=200", size: "M", price: "Rp 175.000"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 3. LOGIKA FILTER
    List<Order> filteredOrders = selectedTab == 'All' 
        ? allOrders 
        : allOrders.where((order) => order.status == selectedTab).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background abu muda agar card terlihat
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold)),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // === TABS OVAL ===
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

          // === LIST ORDER ===
          Expanded(
            child: filteredOrders.isEmpty 
            ? Center(child: Text("No orders in '$selectedTab'", style: const TextStyle(color: Colors.grey)))
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: filteredOrders.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildOrderCard(filteredOrders[index]);
                },
              ),
          ),
        ],
      ),
    );
  }

  // WIDGET TAB
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
          tab,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // WIDGET CARD ORDER
  Widget _buildOrderCard(Order order) {
    // Ambil item pertama untuk preview
    final firstItem = order.items[0];
    final itemCount = order.items.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card (Tanggal & Status)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status, 
                  style: const TextStyle(color: Color(0xFFFF69B4), fontSize: 12, fontWeight: FontWeight.bold)
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          
          // Content Preview
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(firstItem.img, width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(firstItem.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text("${itemCount > 1 ? '+ ${itemCount - 1} other items' : firstItem.size}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(order.total, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Buttons Action
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (order.status == 'Pending')
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDetailsPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF69B4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text("Pay Now", style: TextStyle(fontSize: 13)),
                  ),
                ),
              
              OutlinedButton(
                onPressed: () => _showOrderDetailModal(order),
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

  // 4. MODAL DETAIL ORDER (POP UP)
  void _showOrderDetailModal(Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50, height: 5,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Header Modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order ${order.id}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFFF69B4), borderRadius: BorderRadius.circular(20)),
                        child: Text(order.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Date: ${order.date}", style: TextStyle(color: Colors.grey[600])),
                  
                  const Divider(height: 40),

                  // List Produk
                  const Text("Product List", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.img, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("${item.qty} x ${item.price}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              Text("Size: ${item.size}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),

                  const Divider(height: 40),

                  // Detail Pengiriman & Pembayaran
                  const Text("Shipping Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _detailRow("Recipient", "Lucy Maudy"),
                  _detailRow("Address", "Jl. Raya Panjang Pisan..."),
                  _detailRow("Courier", "JNE Regular"),
                  
                  const SizedBox(height: 20),
                  const Text("Payment Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  _detailRow("Method", order.paymentMethod),
                  _detailRow("Shipping Fee", "Rp 0"),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(order.total, style: const TextStyle(color: Color(0xFFFF69B4), fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Close Detail"),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}