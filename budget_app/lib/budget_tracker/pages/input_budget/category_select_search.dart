import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'income_category.dart';
import 'income_category_list.dart';

class CategorySelectSearch extends StatefulWidget {
  const CategorySelectSearch({Key? key}) : super(key: key);

  @override
  State<CategorySelectSearch> createState() => _CategorySelectSearchState();
}

class _CategorySelectSearchState extends State<CategorySelectSearch> {
  var selectedIncomeCategory = 'Food';
  List<IncomeCategory> results = [];
  List _foundUsers = [];

  TextEditingController _searchController = TextEditingController();

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = incomeCategoryList;
    } else {
      for (IncomeCategory c in incomeCategoryList) {
        if (c.category.toLowerCase().contains(enteredKeyword.toLowerCase())) {
          results.add(c);
        }
      }
    }
    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  _searchForm(BuildContext context, controller, hint, filteredSearchList) {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (value) => _runFilter(value),
              readOnly: false,
              autofocus: false,
              cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: const Icon(
              Icons.search_outlined,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = incomeCategoryList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: _appBar(context),
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _searchForm(context, _searchController, "Search for a category ",
              _searchController),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.back(result: _foundUsers[index].category);
                            setState(() {
                              //selectedIncomeCategory = LocalStorage().loadCurrencyFromBox();
                            });
                            Get.snackbar(
                              "Category Selected is ",
                              selectedIncomeCategory,
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: context.theme.backgroundColor,
                              duration: const Duration(seconds: 2),
                              shouldIconPulse: true,
                              icon: _foundUsers[index].incomeIcon,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: ListTile(
                                  leading: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _foundUsers[index].color,
                                    ),
                                    child: Icon(
                                      _foundUsers[index].incomeIcon,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                      _foundUsers[index].category.toString()),
                                ),
                              ),
                              Container(
                                height: 1.5,
                                width: double.infinity,
                                color: Colors.grey.shade400,
                              )
                            ],
                          ),
                        );
                      })
                  : const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios_rounded,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      // actions: const [
      //   CircleAvatar(
      //     backgroundImage: AssetImage("assets/images/sonic_img2.png"),
      //   )
      // ],
      title: const Text("Select a Category"),
      centerTitle: true,
    );
  }
}
