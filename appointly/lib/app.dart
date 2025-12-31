import 'package:flutter/material.dart';


class AuthController extends ChangeNotifier{
  bool _isLoggedIn = false;

  String? _name;
  String? _surname;
  String? _email;
  DateTime? _dob;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;

  String get displayName{
    final n = (_name ?? "").trim();
    final s = (_surname ?? "").trim();
    final full = ("$n $s").trim();
    return full.isEmpty ? (_username ?? "User") : full;
  }

  String get email => (_email ?? "").trim();
  DateTime? get dob => _dob;

  void login({required  String username, required String password}){
    // Replace with real authentication logic
    _isLoggedIn = true;
    _username = username;
    notifyListeners();
  }

  void signup({
    required String name,
    required String surname,
    required String email,
    required DateTime dob,
    required String username,
    required String password
  }){
    // Replace with real signup logic
    _isLoggedIn = true;
    _name = name;
    _surname = surname;
    _email = email;
    _dob = dob;
    _username = username;
    notifyListeners();
  }


  void logout(){
    _isLoggedIn = false;
    _name = null;
    _surname = null;
    _email = null;
    _dob = null;
    _username = null;
    notifyListeners();
  }
}

final AuthController auth = AuthController();

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
    LoginPage(),
    SignupPage(),
    ProfilePage(),
    ForgotPasswordPage()
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
          NavigationDestination(icon:Icon(Icons.event_available_outlined),label:"Book"),
          NavigationDestination(icon:Icon(Icons.login_outlined),label:"Login"),
          NavigationDestination(icon:Icon(Icons.app_registration_outlined),label:"Sign Up"),
          NavigationDestination(icon:Icon(Icons.person_outline),label:"Profile"),
          NavigationDestination(icon:Icon(Icons.lock_reset_outlined),label:"Forgot"),
          
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


class LoginPage extends StatefulWidget{
  static const route = "/login";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  final _formkey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose(){
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }
  
  void _submit(){
    if(!_formkey.currentState!.validate()){
      return;
    }
    auth.login(
      username: _usernameCtrl.text.trim(),
      password: _passwordCtrl.text.trim()
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
     const SnackBar(content: Text("Logged In"))
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppScaffold(title: "Login",
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Form(
          key: _formkey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder()
                ),
                validator: (v){
                  final s = (v ?? "").trim();
                  if (s.isEmpty){
                    return "Please enter your username";
                  }
                  if(s.length < 3){
                    return "Username must be at least 3 characters long";
                  }
                },
              ),
              const SizedBox(height: 12,),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon:IconButton(
                    onPressed: ()=> setState(()=> _obscure = !_obscure),
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  ) 
                ),
                validator: (v){
                  if((v ?? "").isEmpty){
                    return "Please enter your password";
                  }
                  if((v ?? "").length < 6){
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8,),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: ()=> Navigator.pushNamed(context,ForgotPasswordPage.route),
                  child: const Text("Forgot Password")
                ),
              ),
              const SizedBox(height: 8,),
              FilledButton(onPressed: _submit, child: const  Text("Login")),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No account?"),
                  TextButton(
                    onPressed: ()=> Navigator.pushNamed(context,SignupPage.route),
                    child: const Text("Sign Up")
                  )
                ],
              )
            ],
          )

        )
      )
    ),);
  }
}

class SignupPage extends StatefulWidget{
  static const route = "/signup";
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  DateTime? _dob;
  bool _obscure = true;
  bool _confirmObscure = true;

  @override
  void dispose(){
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async{
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year-18,now.month,now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null){
      setState(()=> _dob = picked);
    }
  }
  void _submit(){
    if (!_formKey.currentState!.validate()) return ;
    if (_dob == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select your date of birth"))
      );
      return;
    }
    auth.signup(
      name: _nameCtrl.text.trim(),
      surname: _surnameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      dob: _dob!,
      username: _usernameCtrl.text.trim(),
      password: _passwordCtrl.text.trim()
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signed Up and Logged In"))
    );
  
  }

  
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Sign up",
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return "Name is required";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _surnameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Surname",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if ((v ?? '').trim().isEmpty) return "Surname is required";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return "Email is required";
                    if (!s.contains("@") || !s.contains(".")) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // DoB picker
                OutlinedButton.icon(
                  onPressed: _pickDob,
                  icon: const Icon(Icons.cake_outlined),
                  label: Text(
                    _dob == null
                        ? "Select Date of Birth"
                        : "DoB: ${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}",
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (v) {
                    if ((v ?? '').isEmpty) return "Password is required";
                    if ((v ?? '').length < 6) return "Password must be at least 6 chars";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordCtrl,
                  obscureText: _confirmObscure,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _confirmObscure = !_confirmObscure),
                      icon: Icon(_confirmObscure ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (v) {
                    if ((v ?? '').isEmpty) return "Please confirm password";
                    if (v != _passwordCtrl.text) return "Passwords do not match";
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submit,
                  child: const Text("Create account"),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, LoginPage.route),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  static const route = "/profile";
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Profile",
      child: AnimatedBuilder(
        animation: auth,
        builder: (context, _) {
          if (!auth.isLoggedIn) {
            return const Text("You are not logged in.");
          }

          final dob = auth.dob;
          final dobText = dob == null
              ? "—"
              : "${dob.year}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(auth.displayName, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("Email: ${auth.email.isEmpty ? "—" : auth.email}"),
              const SizedBox(height: 8),
              Text("DoB: $dobText"),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  auth.logout();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logged out")),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget{
  static const route = "/forgot";
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppScaffold(
      title: "Forgot Password",
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Placeholder: here you'll implement password reset.\nFor now just go back",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16,),
              FilledButton(onPressed: ()=> Navigator.pop(context), child: const Text("Go Back"))
            ],
          )
        )
      )
    );
  }
}

