import 'package:baby_book/bloc/event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'replay_event_bus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventBloc>(
      create: (context) => EventBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 120),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyPage2(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
        body: const _ListViewEvent(),
        bottomSheet: const _BottomSheet(),
      ),
    );
  }
}

class _ListViewEvent extends StatelessWidget {
  const _ListViewEvent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(state.list[index]),
            );
          },
          itemCount: state.list.length,
        );
      },
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet();

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    context
                        .read<EventBloc>()
                        .add(EventMessageChangedEvent(value));
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: state.isValid
                    ? () {
                        context.read<EventBloc>().add(const EventSendEvent());
                        controller.clear();
                      }
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyPage2 extends StatefulWidget {
  const MyPage2({super.key});

  @override
  State<MyPage2> createState() => _MyPage2State();
}

class _MyPage2State extends State<MyPage2> {
  final bus = ReplayEventBus();

  List<String> list = [];

  @override
  void initState() {
    super.initState();
    bus.on<MyEvent>().listen((event) {
      if(!mounted) return;
      setState(() {
        list.add(event.message);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page2'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(list[index]),
          );
        },
        itemCount: list.length,
      ),
    );
  }
}

class MyEvent {
  final String message;

  MyEvent(this.message);
}


