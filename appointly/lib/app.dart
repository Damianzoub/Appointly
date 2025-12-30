import 'package:flutter/material.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const HomeShell();
  }
}

class HomeShell extends StatefulWidget{
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    BookPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i)=> setState(()=> _index =i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),label: "Home",),
          NavigationDestination(icon:Icon(Icons.event_available_outlined),label:"Book")
        ],
      ),
    );
  }
}

class AppScaffold extends StatelessWidget{
  final String title;
  final Widget child;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child
  });

  @override
  Widget build(BuildContext context){
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text(title),centerTitle: false,)
      ,body: Padding(padding: const EdgeInsets.all(16),child: child,),
      
    ));
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppScaffold(
      title: "Home",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome',style: Theme.of(context).textTheme.headlineMedium,),
          const SizedBox(height: 8,),
          Text("This is the home page",style:Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          FilledButton(onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pressed"))
            );
          },child: const Text("Get Started"),)
        ],
      )
    );
  }
}

class BookPage extends StatelessWidget{
  const BookPage({super.key});

  @override
  Widget build(BuildContext context){
    return AppScaffold(
      title: "Book",
      child: ListView(
        children: const [
            Text("Booking placeholder",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
            SizedBox(height: 12,),
            _CardLine(title:"Step 1", subtitle: "Choose Category"),
            _CardLine(title:"Step 2", subtitle: "Choose provider"),
            _CardLine(title:"Step 3", subtitle: "Pick date & time"),
        ],
      )
    );
  }
}

class _CardLine extends StatelessWidget{
  final String title;
  final String subtitle;

  const _CardLine({
    required this.title,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context){
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}