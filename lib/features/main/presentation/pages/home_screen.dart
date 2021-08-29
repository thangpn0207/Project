import 'package:app_web_project/core/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:app_web_project/core/components/dialog.dart';
import 'package:app_web_project/core/themes/app_colors.dart';
import 'package:app_web_project/core/widgets/dialog_logout.dart';
import 'package:app_web_project/features/chat_room/presentation/blocs/chat_screen_bloc/chat_screen_bloc.dart';
import 'package:app_web_project/features/chat_room/presentation/pages/chat_screen.dart';
import 'package:app_web_project/features/main/presentation/blocs/home_cubit.dart';
import 'package:app_web_project/features/profile/presentation/pages/profile_screen.dart';
import 'package:app_web_project/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeCubit homeCubit;
  late AuthenticationCubit authenticationCubit;

  int pageIndex =0;
  @override
  void initState() {
    homeCubit = inject<HomeCubit>();
    authenticationCubit=inject<AuthenticationCubit>();
    homeCubit.getUserInfo();
    // TODO: implement initState
    super.initState();
  }
  Future<bool> _onWillPop() async {
    return (await showDialogApp(context, DialogLogOut())) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    return BlocProvider<HomeCubit>(
      create: (context) => homeCubit,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context,state){
          if(state is Loading){
            authenticationCubit.logOut();
          }
        },
          builder: (context, state) {
       if(state is Loaded){
         return WillPopScope(
           onWillPop: _onWillPop,
           child: Scaffold(
             extendBody: true,
             bottomNavigationBar: ClipRRect(
               borderRadius: BorderRadius.only(
                 topRight: Radius.circular(45),
                 topLeft: Radius.circular(45),
               ),
               child: Container(
                 child: BottomNavigationBar(
                   selectedLabelStyle: TextStyle(color: Colors.deepOrange),
                   unselectedLabelStyle: TextStyle(color: Colors.white),
                   selectedItemColor:  HexColor('#CD5C5C'),
                   unselectedItemColor: Colors.blueGrey,
                   type: BottomNavigationBarType.fixed,
                   currentIndex: pageIndex,
                   backgroundColor: Color(0xfffae7e9),
                   onTap: (idx) {
                     _pageController.jumpToPage(idx);
                   },
                   items: [
                     BottomNavigationBarItem(
                       icon: Icon(
                         Icons.person,
                       ),
                       activeIcon: Icon(
                         Icons.person,
                         size: 30.sp,
                       ),
                       label: 'Profile',),
                     BottomNavigationBarItem(
                         icon: Icon(
                           Icons.chat_bubble,
                         ),
                         activeIcon: Icon(
                           Icons.chat_bubble,
                           size: 30.sp,
                         ),
                         label: 'Chat')
                   ],
                 ),
               ),
             ),
             body: PageView(
               physics: NeverScrollableScrollPhysics(),
               controller: _pageController,
               onPageChanged: (idx) {
                 _pageController.jumpToPage(idx);
                 pageIndex=idx;
                 setState(() {

                 });
               },
               children: <Widget>[
                 ProfileScreen(
                   userModel: state.userModel,
                   userId: state.userModel.id??'',
                 ),
                 BlocProvider(
                   create: (context) => ChatScreenBloc(),
                   child: ChatScreen(userModel: state.userModel),
                 )
               ],
             ),
           ),
         );
       }else{
         return Container(color: Colors.white,);
       }
      }),
    );
  }
}
