import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Option {
	final String name;
	final String value;

	Option.json(Map<String, dynamic> json):
		name = json['text'] as String,
		value = json['value'] as String;
}

class Vehicle {
	final String year;
	final String make;
	final String model;
	final String vehicleClass;
	final String transmission;
	final String fuelType;
	final String cityMPG;
	final String highwayMPG;
	final String combinedMPG;
	final Uri photo;

	Vehicle.json(Map<String, dynamic> json, Map<String, dynamic> metaJson):
		year = json['year'] as String,
		make = json['make'] as String,
		model = json['model'] as String,
		vehicleClass = json['VClass'] as String,
		transmission = json['trany'] as String,
		fuelType = json['fuelType1'] as String,
		cityMPG = json['city08'] as String,
		highwayMPG = json['highway08'] as String,
		combinedMPG = json['comb08'] as String,
		photo = Uri.https('fueleconomy.gov', metaJson['photoUrl'] as String);
}

Future<Map<String, dynamic>> getAPIResource(String path, Map<String, dynamic>? params) async {
	final response = await http.get(
		Uri.https('fueleconomy.gov', path, params),
		headers: { 'Accept': 'application/json'	}
	);

	if (response.statusCode == 200) {
		return jsonDecode(response.body) as Map<String, dynamic>;
	}
	else {
		throw Exception('API Error');
	}
}

Future<List<Option>> getAPIMenuItems(String menu, Map<String, dynamic>? params) async {
	final json = (await getAPIResource('ws/rest/vehicle/menu/$menu', params))['menuItem'];

	if (json is List<dynamic>) {
		return json.map((item) => Option.json(item)).toList().cast<Option>();
	}

	return <Option>[Option.json(json)];
}

Future<List<Option>> getVehicleYears() {
	return getAPIMenuItems('year', {});
}

Future<List<Option>> getVehicleMakes(String year) {
	return getAPIMenuItems('make', {
		'year': year
	});
}

Future<List<Option>> getVehicleModels(String year, String make) {
	return getAPIMenuItems('model', {
		'year': year,
		'make': make
	});
}

Future<List<Option>> getVehicleTrims(String year, String make, String model) {
	return getAPIMenuItems('options', {
		'year': year,
		'make': make,
		'model': model
	});
}

Future<Vehicle> getVehicle(String vehicleID) async {
	return Vehicle.json(
		await getAPIResource('ws/rest/vehicle/$vehicleID', {}),
		await getAPIResource('/feg/Find.do', {
			'action': 'getMenuVehicle',
			'id': vehicleID
		})
	);
}
