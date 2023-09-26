import 'dart:convert';
import 'package:perusano/util/globalVariables.dart';
import 'package:perusano/util/headers.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CredRegisterCenter {
  // Add register to network database
  Future<Map> addAnemiaCheck(int idKid, double result, String date) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/anemia_control/${idKid}'),
        body: jsonEncode({
          'result': result,
          'date': date,
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Delete register to network database
  Future<Map> deleteAnemiaCheck(int idData) async {
    try {
      final response = await http.delete(
        Uri.parse('${GlobalVariables.endpoint}/anemia_control/${idData}'),
        headers: await Headers.getAllHeaders(),
      );

      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Add register to network database
  Future<Map> addVaccineDose(
      int idKid, String suggest_date, int dosis_number, int vaccine_id) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/vaccine_dose/${idKid}'),
        body: jsonEncode({
          'suggest_date': suggest_date,
          'dosis_number': dosis_number,
          'vaccine_id': vaccine_id,
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Assign applied date to the vaccine in network database
  Future<Map> updateVaccinedDose(
      int idDose, String applied_date, int state) async {
    try {
      final response = await http.put(
        Uri.parse('${GlobalVariables.endpoint}/vaccine_dose_state/${idDose}'),
        body: jsonEncode({
          'applied_date': applied_date,
          'state': state,
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'doseId': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'doseId': 0};
      return vacio;
    }
  }

  // Delete applied date to the vaccine in network database
  Future<Map> deleteVaccinedAppliedDateDose(int idDose, int state) async {
    try {
      final response = await http.put(
        Uri.parse('${GlobalVariables.endpoint}/vaccine_dose_state/${idDose}'),
        body: jsonEncode({
          'applied_date': null,
          'state': state,
        }),
        headers: await Headers.getAllHeaders(),
      );

      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'doseId': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'doseId': 0};
      return vacio;
    }
  }

  // Add register to network database
  Future<Map> addWeightHeight(
      int idKid,
      double weight,
      double height,
      String date,
      String lengthDiagnostic,
      int lengthDiagnosticNumber,
      String weightForLengthDiagnostic,
      int weightForLengthDiagnosticNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/size_kid/${idKid}'),
        body: jsonEncode({
          'weight': weight,
          'height': height,
          'date': date,
          "lengthDiagnostic": lengthDiagnostic,
          "lengthDiagnosticNumber": lengthDiagnosticNumber,
          "weightForLengthDiagnostic": weightForLengthDiagnostic,
          "weightForLengthDiagnosticNumber": weightForLengthDiagnosticNumber
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Delete register to network database
  Future<Map> deleteWeightHeight(int idData) async {
    try {
      final response = await http.delete(
        Uri.parse('${GlobalVariables.endpoint}/size_kid/${idData}'),
        headers: await Headers.getAllHeaders(),
      );

      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Add register to network database
  Future<Map> addAppointment(
      int idKid, String scheduled_date, String description) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/appointment/${idKid}'),
        body: jsonEncode({
          'scheduled_date': scheduled_date,
          'description': description,
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Assign attendance date to the appointment in network database
  Future<Map> updateAppointmentState(
      int idAppointment, String applied_date, String attendance_date) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${GlobalVariables.endpoint}/appointment_completed/${idAppointment}'),
        body: jsonEncode({
          "applied_date": applied_date,
          "state": 1,
          "attendance_date": attendance_date
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Delete attendance date to the appointment in network database
  Future<Map> deleteAppointmentDateApplied(
      int idAppointment, String applied_date) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${GlobalVariables.endpoint}/appointment_completed/${idAppointment}'),
        body: jsonEncode({
          "applied_date": applied_date,
          "state": 2,
          "attendance_date": null
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Delete register to network database
  Future<Map> deleteAppointment(int idData) async {
    try {
      final response = await http.delete(
        Uri.parse('${GlobalVariables.endpoint}/appointment/${idData}'),
        headers: await Headers.getAllHeaders(),
      );

      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Add register to network database
  Future<Map> addIronSupplement(
      int idKid, int nameId, int amount, int unit, String delivery_date) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalVariables.endpoint}/iron_supplement/${idKid}'),
        body: jsonEncode({
          'nameId': nameId,
          'amount': amount,
          'unit': unit,
          'delivery_date': delivery_date,
        }),
        headers: await Headers.getAllHeaders(),
      );
      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }

  // Delete register to network database
  Future<Map> deleteIronSupplement(int idData) async {
    try {
      final response = await http.delete(
        Uri.parse('${GlobalVariables.endpoint}/iron_supplement/${idData}'),
        headers: await Headers.getAllHeaders(),
      );

      Map data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 400) {
        return data;
      } else {
        Map vacio = {'id': 0};
        return vacio;
      }
    } catch (e) {
      Map vacio = {'id': 0};
      return vacio;
    }
  }
}
