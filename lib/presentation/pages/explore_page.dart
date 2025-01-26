import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/explore_screen.dart';
import '../widgets/load/load_widget.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  final TextEditingController _controller = TextEditingController();
  late final List<int> listYear;
  late final List<int> listYearSelected = List.empty(growable: true);
  @override
  void initState() {
    listYear = List.empty(growable: true);
    for (int i = 1990; i <= DateTime.now().year.toInt(); i++) {
      listYear.add(i);
    }
    super.initState();
  }

  void onSubmit() {
    context.read<AnimeBloc>().add(SearchAnime(query: _controller.text));
  }

  void openFilterDialog(Size size) async {
    await FilterListDialog.display<int>(
      context,
      listData: listYear,
      selectedListData: listYearSelected,
      choiceChipLabel: (user) => user.toString(),
      hideSearchField: true,
      height: size.height * 0.6,
      hideCloseIcon: true,
      choiceChipBuilder: (context, item, isSelected) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          height: 40,
          margin: EdgeInsets.symmetric(
              vertical: size.height * 0.01, horizontal: size.width * 0.01),
          decoration: BoxDecoration(
              color: isSelected! ? Colors.grey.shade300 : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(item.toString(),style: TextStyle(color: isSelected ? Colors.black : Colors.white),),
        );
      },

      themeData: FilterListThemeData.dark(context).copyWith(
          headerTheme: HeaderThemeData.dark()
              .copyWith(backgroundColor: Colors.transparent),
          wrapCrossAxisAlignment: WrapCrossAlignment.center,
          wrapAlignment: WrapAlignment.center),
      validateSelectedItem: (list, val) => list!.contains(val),
      hideSelectedTextCount: true,
      onItemSearch: (user, query) {
        return false;
      },
      onApplyButtonClick: (list) {
        /*
         setState(() {
          selectedUserList = List.from(list!);
        });
        Navigator.pop(context);
         */
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) {
        return AnimationLoadPage(
            child: ExploreScreen(
                controller: _controller,
                onSubmit: onSubmit,
                listAnime: state.listSearchAnime,
                onPressed: openFilterDialog));
      },
    );
  }
}
