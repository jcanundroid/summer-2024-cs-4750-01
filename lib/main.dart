import 'package:flutter/material.dart';
import 'add-vehicles-page.dart';
import 'compare-vehicles-page.dart';
import 'edit-vehicle-page.dart';

void main() {
	runApp(const App());
}

class App extends StatelessWidget {
	const App({ super.key });

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'FuelEco',
			initialRoute: '/',
			routes: {
				'/': (context) => AddVehiclesPage(),
				'/new': (context) => EditVehiclePage(isNew: true),
				'/comparison': (context) => CompareVehiclesPage()
			},
			theme: ThemeData(
				useMaterial3: true,
				colorScheme: ColorScheme.fromSeed(
					seedColor: Colors.blue,
					brightness: Brightness.dark,
				)
			)
		);
	}
}
