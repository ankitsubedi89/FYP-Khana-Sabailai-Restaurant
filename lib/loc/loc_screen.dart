import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:khana_sabailai_restaurant/controllers/loc_controller.dart';


class LocScreen extends StatelessWidget {
  const LocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Leftover Companies')),
      body: SingleChildScrollView(
        child: GetBuilder<LocController>(builder: (controller) {
          return Column(
            children: controller.loc
                .map(
                  (e) => ListTile(
                    tileColor: Colors.grey[200],
                    title: Text(e.name!),
                    subtitle: Text('${e.contact!}\n${e.email!}'),
                    isThreeLine: true,
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
