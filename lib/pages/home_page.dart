import 'package:flutter/material.dart';
import 'package:national_calendar_hub_app/network/home_repository.dart';
import 'package:national_calendar_hub_app/widgets/error_state.dart';
import 'package:national_calendar_hub_app/widgets/home_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HomeListItem> _listItems = [];
  HomeRepository homeRepository = HomeRepository();
  HomePageState currentPageState = HomePageState.loading;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setCurrentPageState(HomePageState.loading);

    final response = await homeRepository.fetchHomePageItems();
    if (response is HomeSuccessResponse) {
      setState(() {
        _listItems = response.listItems;
        currentPageState = HomePageState.success;
      });
    } else {
      setCurrentPageState(HomePageState.error);
    }
  }

  void setCurrentPageState(HomePageState state) {
    setState(() {
      currentPageState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentPageState == HomePageState.loading
        ? const Center(child: CircularProgressIndicator())
        : currentPageState == HomePageState.error
            ? const ErrorState()
            : Scaffold(
                body: SafeArea(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _listItems.length,
                        itemBuilder: (context, index) {
                          return _listItems[index].build(context);
                        })));
  }
}

enum HomePageState { loading, success, error }
