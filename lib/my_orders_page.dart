import 'package:flutter/material.dart';
import 'payment_details_page.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  String selectedTab = 'All';
  final List<String> tabs = ['All', 'Pending', 'Prepared', 'Shipped', 'Delivered'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter Tabs
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
          
          // Order List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildOrderItem(
                  date: "01 April 2025",
                  title: "Robbonie Cardigan",
                  price: "1x Rp 195.000",
                  imageUrl: "https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=200",
                  btnText: "Pay Now",
                  isPrimaryBtn: true,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentDetailsPage())),
                ),
                _buildOrderItem(
                  date: "28 Maret 2025",
                  title: "Arket Shirt",
                  price: "1x Rp 120.000",
                  imageUrl: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?q=80&w=200",
                  btnText: "See Detail",
                  isPrimaryBtn: false,
                ),
                _buildOrderItem(
                  date: "25 Maret 2025",
                  title: "Sunny Top",
                  price: "1x Rp 175.000",
                  imageUrl: "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=200",
                  btnText: "Buy Again",
                  isPrimaryBtn: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String tab) {
    bool isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF69B4) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFFF69B4) : Colors.transparent),
        ),
        child: Text(
          tab,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required String date, required String title, required String price,
    required String imageUrl, required String btnText, required bool isPrimaryBtn,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Row(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.cover)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(price, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              if (isPrimaryBtn)
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF69B4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  ),
                  child: Text(btnText),
                )
              else
                OutlinedButton(
                  onPressed: onTap ?? () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF69B4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(btnText, style: const TextStyle(color: Color(0xFFFF69B4))),
                )
            ],
          ),
        ),
      ],
    );
  }
}