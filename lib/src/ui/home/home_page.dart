import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viensdindin/src/blocs/home/bloc.dart';

import 'home_list_view.dart';

class HomePage extends StatefulWidget {
  final HomeBloc homeBloc;

  const HomePage({Key key, @required this.homeBloc}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(homeBloc: homeBloc);
}

class _HomePageState extends State<HomePage> {
  final HomeBloc homeBloc;

  _HomePageState({@required this.homeBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: homeBloc,
        builder: (_, HomeState state) {
          if (state is HomeLoaded) {
            return HomeListView(homePageModel: state.model);
          }
          if (state is HomeError) {
            return AlertDialog(
              title: Text('Erreur'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("On dirait que le système n'est pas disponible, veuillez réessayer."),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Réessayer'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    homeBloc.dispatch(FetchHomePage());
                  },
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
