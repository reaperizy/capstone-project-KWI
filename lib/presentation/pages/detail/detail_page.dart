// ignore_for_file: must_be_immutable

import 'package:capstone_project_sib_kwi/data/models/destination_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project_sib_kwi/common/constants.dart';
import 'package:url_launcher/link.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail_page';
  DestinationDetail destinationDetail;

  DetailPage({Key? key, required this.destinationDetail}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future addBookmark() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users");
    return collectionRef
        .doc(currentUser?.uid)
        .collection("bookmarks")
        .doc(widget.destinationDetail.idDoc)
        .set({
      "name": widget.destinationDetail.name,
      "city": widget.destinationDetail.city,
      "imageUrl": widget.destinationDetail.urlImage,
      "rating": double.parse(widget.destinationDetail.rating!),
      "id": widget.destinationDetail.idDoc,
      "description": widget.destinationDetail.description,
      "location": widget.destinationDetail.location,
      "urlWeb": widget.destinationDetail.urlWeb,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added to Bookmarks'),
        duration: Duration(seconds: 1),
      ));
    });
  }

  Future deleteBookmark() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users");
    return collectionRef
        .doc(currentUser?.uid)
        .collection("bookmarks")
        .doc(widget.destinationDetail.idDoc)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Removed from Bookmarks'),
        duration: Duration(seconds: 1),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(data);
    return Scaffold(
      //backgroundColor: primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              child: Hero(
                tag: widget.destinationDetail.urlImage!,
                child: Image.network(
                  widget.destinationDetail.urlImage!,
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 80),
                ),
                const SizedBox(
                  height: 200,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              color: primaryColor,
                              height: 4,
                              width: 48,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.destinationDetail.name!,
                                style: kHeading5,
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser?.uid)
                                      .collection('bookmarks')
                                      .where('id',
                                          isEqualTo:
                                              widget.destinationDetail.idDoc)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                        child: Text('Error'),
                                      );
                                    } else if (snapshot.hasData) {
                                      return IconButton(
                                        onPressed: () =>
                                            snapshot.data!.docs.isEmpty
                                                ? addBookmark()
                                                : deleteBookmark(),
                                        icon: snapshot.data!.docs.isEmpty
                                            ? const Icon(
                                                Icons.bookmark_outline,
                                                size: 32,
                                              )
                                            : const Icon(
                                                Icons.bookmark,
                                                size: 32,
                                              ),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: greyColor,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.destinationDetail.city.toString(),
                                style: kSubtitle,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              const Icon(
                                Icons.star_rate,
                                color: Colors.orange,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.destinationDetail.rating.toString(),
                                style: kSubtitle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Text(
                                "Deskripsi Wisata",
                                style: kHeading6,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.destinationDetail.description.toString(),
                            style: kBodyText,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: const [
                              // Column(
                              //   children: [
                              //     Container(
                              //       padding: const EdgeInsets.all(12.0),
                              //       decoration: const BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color: Color(0xffE8F8F5)),
                              //       child:
                              //           Image.asset('assets/icons/pizza (1).png'),
                              //       width: 75,
                              //     ),
                              //     const SizedBox(
                              //       height: 6,
                              //     ),
                              //     const Text(
                              //       'Makanan',
                              //style: interText2.copyWith(
                              // fontSize: 18, color: kText),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   width: 16,
                              // ),
                              // Column(
                              //   children: [
                              //     Container(
                              //       padding: const EdgeInsets.all(12.0),
                              //       decoration: const BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color: Color(0xffE8F8F5)),
                              //       child: Image.asset(
                              //           'assets/icons/coffee (1).png'),
                              //       width: 75,
                              //     ),
                              //     const SizedBox(
                              //       height: 6,
                              //     ),
                              //     const Text(
                              //       'Minuman',
                              //style: interText2.copyWith(
                              // fontSize: 18, color: kText),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   width: 16,
                              // ),
                              // Column(
                              //   children: [
                              //     Container(
                              //       padding: const EdgeInsets.all(12.0),
                              //       decoration: const BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color: Color(0xffE8F8F5)),
                              //       child: Image.asset('assets/icons/wifi.png'),
                              //       width: 75,
                              //     ),
                              //     const SizedBox(
                              //       height: 6,
                              //     ),
                              //     const Text(
                              //       'Wifi',
                              // style: interText2.copyWith(
                              //     fontSize: 18, color: kText),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                      width: 75,
                                      height: 50,
                                      child: Link(
                                        target: LinkTarget.blank,
                                        uri: Uri.parse(
                                            "https://www.google.com/maps/dir//water+blaster/data=!4m6!4m5!1m1!4e2!1m2!1m1!1s0x2e708d368c2bab47:0x7cb65896fa025470?sa=X&ved=2ahUKEwj8iPLQ2Zr4AhWEUGwGHa2CALMQ9Rd6BAhxEAQ"),
                                        builder: (context, followLink) {
                                          return ElevatedButton(
                                            onPressed: followLink,
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        primaryColor),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                        side: const BorderSide(
                                                            color: Colors
                                                                .green)))),
                                            child: const Icon(
                                              Icons.add_location_alt_outlined,
                                              color: Colors.white,
                                              size: 24.0,
                                            ),
                                            // child: Text(
                                            //   'Detail lebih lanjut',
                                            //   style: interText2.copyWith(
                                            //       fontSize: 17, color: Colors.white),
                                            // )
                                          );
                                        },
                                      )),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: SizedBox(
                                      width: 260,
                                      height: 50,
                                      child: Link(
                                        target: LinkTarget.blank,
                                        uri: Uri.parse(
                                            widget.destinationDetail.urlWeb!),
                                        builder: (context, followLink) {
                                          return ElevatedButton(
                                              onPressed: followLink,
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          primaryColor),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                          side: const BorderSide(
                                                              color: Colors
                                                                  .green)))),
                                              child: Text(
                                                'Detail lebih lanjut',
                                                style: interText2.copyWith(
                                                    fontSize: 17,
                                                    color: Colors.white),
                                              ));
                                        },
                                      )),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        Navigator.of(context, rootNavigator: true).pop(context);
                      },
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
