// class YourPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<FirstBloc>(
//           create: (context) => FirstBloc(),
//         ),
//         BlocProvider<SecondBloc>(
//           create: (context) => SecondBloc(),
//         ),
//       ],
//       child: WillPopScope(
//         onWillPop: () async {
//           // Access the blocs
//           final firstBloc = context.read<FirstBloc>();
//           final secondBloc = context.read<SecondBloc>();
//
//           // Trigger the events to fetch data from both blocs
//           firstBloc.add(FirstEvent()); // Replace with your actual event
//           secondBloc.add(SecondEvent()); // Replace with your actual event
//
//           // Allow the navigation to proceed
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text('Your Page'),
//           ),
//           body: Center(
//             child: Text('Your page content'),
//           ),
//         ),
//       ),
//     );
//   }
// }
