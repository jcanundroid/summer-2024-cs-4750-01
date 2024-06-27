import 'package:flutter/material.dart';
import 'api.dart';

class EditVehiclePage extends StatefulWidget {
	const EditVehiclePage({ super.key, required this.isNew });

	final bool isNew;

	@override
	State<EditVehiclePage> createState() => _EditVehiclePageState();

	get title {
		return this.isNew ? 'New Vehicle' : 'Edit Vehicle';
	}
}

class _EditVehiclePageState extends State<EditVehiclePage> {
	String? _year = null;
	String? _make = null;
	String? _model = null;
	String? _trim = null;

	List<Option> _years = [];
	List<Option> _makes = [];
	List<Option> _models = [];
	List<Option> _trims = [];

	Vehicle? _vehicle = null;

	void initState() {
		getVehicleYears().then((data) {
			setState(() {
				_years = data;
			});
		});
	}

	void _onYearChanged(String? value) {
		setState(() {
			_year = value;
			_make = null;
			_model = null;
			_trim = null;
			_vehicle = null;
		});

		getVehicleMakes(value!).then((data) {
			setState(() {
				_makes = data;
			});
		});
	}

	void _onMakeChanged(String? value) {
		setState(() {
			_make = value;
			_model = null;
			_trim = null;
			_vehicle = null;
		});

		getVehicleModels(_year!, value!).then((data) {
			setState(() {
				_models = data;
			});
		});
	}

	void _onModelChanged(String? value) {
		setState(() {
			_model = value;
			_trim = null;
			_vehicle = null;
		});

		getVehicleTrims(_year!, _make!, value!).then((data) {
			setState(() {
				_trims = data;
			});
		});
	}

	void _onTrimChanged(String? value) {
		setState(() {
			_trim = value;
			_vehicle = null;
		});

		getVehicle(value!).then((data) {
			setState(() {
				_vehicle = data;
			});
		});
	}

	void _onCancelPressed() {
		Navigator.pop(context);
	}

	void _onDonePressed() {
		Navigator.pop(context, _vehicle);
	}

	List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<Option> options) {
		return options.map((option) => DropdownMenuItem<String>(
			value: option.value,
			child: Text(option.name)
		)).toList();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				centerTitle: true,
				title: Text(widget.title),
			),
			body: Center(
				child: Column(
					children: <Widget>[
						Expanded(
							child: ListView(
								padding: const EdgeInsets.all(16.0),
								children: <Widget>[
									DropdownButton<String>(
										hint: const Text('Year'),
										isExpanded: true,
										value: _year,
										onChanged: _onYearChanged,
										items: _buildDropdownMenuItems(_years)
									),
									SizedBox(height: 16.0),
									DropdownButton<String>(
										hint: const Text('Make'),
										isExpanded: true,
										value: _make,
										onChanged: _year != null ? _onMakeChanged : null,
										items: _buildDropdownMenuItems(_makes)
									),
									SizedBox(height: 16.0),
									DropdownButton<String>(
										hint: const Text('Model'),
										isExpanded: true,
										value: _model,
										onChanged: _make != null ? _onModelChanged : null,
										items: _buildDropdownMenuItems(_models)
									),
									SizedBox(height: 16.0),
									DropdownButton<String>(
										hint: const Text('Trim'),
										isExpanded: true,
										value: _trim,
										onChanged: _model != null ? _onTrimChanged : null,
										items: _buildDropdownMenuItems(_trims)
									),
									SizedBox(height: 48.0),
									if (_vehicle != null)
										Column(
											children: <Widget>[
												Image.network(
													'${_vehicle!.photo}',
													width: 400,
													fit: BoxFit.contain
												),
												SizedBox(height: 16.0),
												Text('${_vehicle!.vehicleClass}'),
												Text('${_vehicle!.year} ${_vehicle!.make} ${_vehicle!.model}'),
												Text('${_vehicle!.transmission}'),
												Text('${_vehicle!.fuelType}'),
											]
										)
								]
							)
						),
						Padding(
							padding: EdgeInsets.all(16.0),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									FilledButton(
										child: const Text('Cancel'),
										onPressed: _onCancelPressed
									),
									SizedBox(width: 16.0),
									FilledButton(
										child: const Text('Done'),
										onPressed: _vehicle != null ? _onDonePressed : null
									)
								]
							)
						)
					]
				)
			)
		);
	}
}
