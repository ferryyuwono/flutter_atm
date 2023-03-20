import 'package:app_atm/app_atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format/format.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  static const String screenKey = 'screen.home';
  static const String listLogItemKey = 'screen.home.list.log.{0}';

  const HomePage() : super(key: const Key(HomePage.screenKey));

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  late final HomeBloc homeBloc = GetIt.instance.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>.value(
      value: homeBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("ATM Simulation"),
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) => previous.logList.length != current.logList.length ||
                previous.isLoading != current.isLoading,
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.logList.length,
                itemBuilder: (context, index) => _LogItem(
                  key: Key(HomePage.listLogItemKey.format(index)),
                  command: state.logList[index],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) => previous.typedCommand != current.typedCommand ||
            previous.isLoading != current.isLoading,
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: (value) => homeBloc.add(
                      HomeTypeCommandEvent(command: value)
                    ),
                    onSubmitted: (value) {
                      homeBloc.add(
                        HomeSendCommandEvent(command: value)
                      );
                      _textController.clear();
                    },
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.zero)
                      ),
                      hintText: 'Input command (login, deposit, withdraw, transfer, logout)',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.lightBlue,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () {
                      homeBloc.add(
                        HomeSendCommandEvent(command: state.typedCommand)
                      );
                      _textController.clear();
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final String command;

  const _LogItem({
    Key? key,
    required this.command,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      child: Text(
        command,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 14
        ),
      ),
    );
  }
}


