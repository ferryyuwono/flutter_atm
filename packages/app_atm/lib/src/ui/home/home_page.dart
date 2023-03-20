import 'package:app_atm/app_atm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:format/format.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  static const String screenKey = 'screen.home';
  static const String listLogItemKey = 'screen.home.list.log.{0}';
  static const String commandTextFieldKey = 'screen.home.textfield.command';
  static const String sendButtonKey = 'screen.home.button.send';

  const HomePage() : super(key: const Key(HomePage.screenKey));

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late final HomeBloc homeBloc = GetIt.instance.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
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
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) => previous.logList.length != current.logList.length ||
                      previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      );
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: state.logList.length,
                      itemBuilder: (context, index) => _LogItem(
                        key: Key(HomePage.listLogItemKey.format(index)),
                        command: state.logList[index],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key(HomePage.commandTextFieldKey),
                        controller: _textController,
                        onChanged: (value) => homeBloc.add(
                          HomeTypeCommandEvent(command: value)
                        ),
                        textInputAction: TextInputAction.done,
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
                    BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) => previous.typedCommand != current.typedCommand,
                      builder: (context, state) => Padding(
                        padding: const EdgeInsets.all(4),
                        child:
                        Ink(
                          decoration: const ShapeDecoration(
                            color: Colors.lightBlue,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            key: const Key(HomePage.sendButtonKey),
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
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
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
      padding: const EdgeInsets.all(4),
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


