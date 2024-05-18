import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    data['independent'] = data['independent'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    height: MediaQuery.of(context).size.height * 0.53,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          data['flags']['png'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.53,
                  padding: const EdgeInsets.all(30.0),
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      const BoxDecoration(color: Color.fromRGBO(7, 7, 7, 0.8)),
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 120.0),
                      const Icon(
                        Icons.flag,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      const SizedBox(
                        width: 90.0,
                        child: Divider(color: Colors.green),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        data['name']['official'],
                        style: const TextStyle(
                            color: Colors.white, fontSize: 30.0),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: data['independent']
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 30.0,
                                  )
                                : const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 30.0,
                                  ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    data['independent']
                                        ? "Independent country"
                                        : "Non-Independent country",
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('population'),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 4, 255, 25)),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      child:
                                          Text(data['population'].toString()))
                                ],
                              ))
                        ],
                      ),
                    ],
                  )),
                ),
                Positioned(
                  left: 8.0,
                  top: 60.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Status  :',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      data['status'],
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'capital  :',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      data['capital'] != null
                          ? data['capital'][0].toString()
                          : '',
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Timezone  :',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      data['timezones'][0].toString(),
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Region  :',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      data['region'].toString(),
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Row(
                children: [
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Sub-Region  :',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      data['subregion'] ?? '',
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
