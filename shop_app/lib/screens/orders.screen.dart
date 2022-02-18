import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  Future _refreshProducts(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error has occurred - please try again'),
              );
            }
            return Consumer<Orders>(
              builder: ((context, orders, child) => ListView.builder(
                    itemBuilder: (ctx, idx) =>
                        OrderItem(order: orders.items[idx]),
                    itemCount: orders.items.length,
                  )),
            );
          },
        ),
      ),
    );
  }
}