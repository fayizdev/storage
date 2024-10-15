import 'package:flutter/material.dart';
import 'package:storage/controller/home_screen_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await HomeScreenController.getAllEmployees();
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Custom_buttomsheet(context);
          },
        ),
        body: ListView.separated(
            itemBuilder: (context, index) => ListTile(
                  title: Text(HomeScreenController.employeesDataList[index]
                          ["name"]
                      .toString()),
                  subtitle: Text(HomeScreenController.employeesDataList[index]
                          ["designation"]
                      .toString()),
                  trailing: IconButton(
                      onPressed: () {
                        setState(() async {
                          await HomeScreenController.removeEmployee(
                              HomeScreenController.employeesDataList[index]
                                  ["id"]);
                          Navigator.pop(context);
                        });
                      },
                      icon: Icon(Icons.delete)),
                ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: HomeScreenController.employeesDataList.length));
  }

  Future<dynamic> Custom_buttomsheet(BuildContext context) {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController descontroller = TextEditingController();
    return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              children: [
                TextFormField(
                  controller: namecontroller,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descontroller,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.white70)),
                          onPressed: () {
                            setState(() async {
                              await HomeScreenController.removeEmployee(
                                  namecontroller.text);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("cancel")),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.white70)),
                          onPressed: () {
                            setState(() async {
                              await HomeScreenController.addEmployee(
                                  namecontroller.text, descontroller.text);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("save")),
                    ),
                  ],
                )
              ],
            ));
  }
}
