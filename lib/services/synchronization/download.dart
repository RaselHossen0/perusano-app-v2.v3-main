import 'package:perusano/services/fileManagement/cred/anemiaCheckFM.dart';
import 'package:perusano/services/fileManagement/cred/selectable/ironSupplementNameFM.dart';
import 'package:perusano/services/fileManagement/cred/selectable/ironSupplementTypeFM.dart';
import 'package:perusano/services/fileManagement/cred/vaccineFM.dart';
import 'package:perusano/services/fileManagement/family/familyMemberFM.dart';
import 'package:perusano/services/fileManagement/family/kidFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/amountFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/recipeCategoryFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/unitFM.dart';
import '../fileManagement/cred/allVaccinesFM.dart';
import '../fileManagement/cred/appointmentFM.dart';
import '../fileManagement/cred/ironSupplementFM.dart';
import '../fileManagement/cred/weightHeightFM.dart';
import '../fileManagement/recipes/selectable/ingredientFM.dart';

import 'package:perusano/util/class/cred/anemiaCheck/anemiaCheckClass.dart';
import 'package:perusano/util/class/cred/appointments/appointmentClass.dart';
import 'package:perusano/util/class/cred/ironSupplement/ironSupplementClass.dart';
import 'package:perusano/util/class/cred/selectable/ironSupplementNameClass.dart';
import 'package:perusano/util/class/cred/selectable/ironSupplementTypeClass.dart';
import 'package:perusano/util/class/cred/vaccines/doseClass.dart';
import 'package:perusano/util/class/cred/vaccines/vaccineClass.dart';
import 'package:perusano/util/class/cred/vaccines/vaccineDataClass.dart';
import 'package:perusano/util/class/cred/weightHeight/weightHeightClass.dart';
import 'package:perusano/util/class/family/kids/kidClass.dart';
import 'package:perusano/util/class/recipes/selectable/amountClass.dart';
import 'package:perusano/util/class/recipes/selectable/ingredientClass.dart';
import 'package:perusano/util/class/recipes/selectable/recipeCategoryClass.dart';
import 'package:perusano/util/class/recipes/selectable/unitClass.dart';
import '../../util/class/family/familyMember/familyMemberClass.dart';
import '../apis/cred/credService.dart';
import '../apis/family/familyService.dart';
import '../apis/recipe/recipesService.dart';

class DownloadService {
  final FamilyMemberFM _familyMemberStorage = FamilyMemberFM();
  final KidFM _kidStorage = KidFM();
  final AnemiaCheckFM _anemiaCheckStorage = AnemiaCheckFM();
  final VaccineFM _vaccineStorage = VaccineFM();
  final AppointmentFM _appointmentStorage = AppointmentFM();
  final WeightHeightFM _weightHeightStorage = WeightHeightFM();
  final IronSupplementFM _ironSupplementStorage = IronSupplementFM();
  final IronSupplementNameFM _ironSupplementNameStorage =
      IronSupplementNameFM();
  final IronSupplementTypeFM _ironSupplementTypeStorage =
      IronSupplementTypeFM();
  final IngredientFM _ingredientStorage = IngredientFM();
  final AllVaccinesFM _allVaccinesStorage = AllVaccinesFM();
  final UnitFM _unitStorage = UnitFM();
  final AmountFM _amountStorage = AmountFM();
  final RecipeCategoryFM _recipeCategoryStorage = RecipeCategoryFM();

  Future<void> downloadData(int idFamily) async {
    await _downloadFamilyMember(idFamily);
    await _downloadCRED(idFamily);
    await downloadSelectable();
  }

  Future<void> downloadSelectable() async {
    await _downloadUnits();
    await _downloadAmounts();
    await _downloadIronSupplementNames();
    await _downloadIronSupplementTypes();
    await _downloadIngredients();
    await _downloadRecipeCategory();
    await _downloadAllVaccines();
  }

  _downloadFamilyMember(int idFamily) async {
    List data = await FamilyService.getMembersByFamilyId(idFamily);
    for (var value in data) {
      FamilyMemberRegister register = FamilyMemberRegister(
          value['id'],
          value['dni'].toString(),
          value['name'].toString(),
          value['lastname'].toString(),
          value['mother_lastname'].toString(),
          value['relationship'].toString(),
          '',
          '',
          'occupation',
          'email',
          value['is_caregiver'],
          value['url_photo'],
          idFamily,
          false,
          false);
      Map registerJson = register.toJson();

      await _familyMemberStorage.writeRegister(registerJson);
    }
  }

  _downloadCRED(int idFamily) async {
    List data = await FamilyService.getKidsByFamilyId(idFamily);
    for (var value in data) {
      Map answer = await _downloadKidsData(idFamily, value['id']);
      await _downloadAnemiaCheck(value['id'], answer['idLocal']);
      await _downloadVaccines(value['id'], answer['idLocal']);
      await _downloadAppointment(value['id'], answer['idLocal']);
      await _downloadWeightHeight(value['id'], answer['idLocal']);
      await _downloadIronSupplement(value['id'], answer['idLocal']);
    }
  }

  Future<Map> _downloadKidsData(int idFamily, int idKid) async {
    Map data = await CredService().getPrincipalDataByKidId(idKid);
    KidRegister register = KidRegister(
        idKid,
        data['names'],
        data['lastname'],
        data['mother_lastname'],
        data['birthday'],
        data['dateRaw'],
        data['gender'],
        data['afiliate_code'],
        data['url_photo'],
        idFamily,
        false,
        false);
    Map registerJson = register.toJson();
    Map answer = await _kidStorage.writeRegister(registerJson);
    return answer;
  }

  _downloadAnemiaCheck(int idKid, int idLocalKid) async {
    List data = await CredService().getAnemiaCheckByKidId(idKid);
    for (var value in data) {
      AnemiaCheckRegister register = AnemiaCheckRegister(
          idKid,
          idLocalKid,
          value['id'],
          double.parse(value['result'].toString()),
          value['date'],
          value['dateRaw'],
          value['age'],
          false,
          false);
      Map registerJson = register.toJson();
      await _anemiaCheckStorage.writeRegister(registerJson);
    }
  }

  _downloadVaccines(int idKid, int idLocalKid) async {
    List data = await CredService().getVaccinesByKidId(idKid);
    for (var value in data) {
      List doses = [];
      for (var doseValue in value['dosis']) {
        DoseRegister doseRegister = DoseRegister(
            doseValue['id'],
            doseValue['dosis_number'],
            doseValue['applied_date'],
            doseValue['applied_date_raw'],
            doseValue['suggest_date_format'],
            doseValue['suggest_date'],
            doseValue['month'],
            false);
        Map doseRegisterJson = doseRegister.toJson();

        doses.add(doseRegisterJson);
      }

      VaccineRegister register =
          VaccineRegister(idKid, idLocalKid, value['id'], value['name'], doses);
      Map registerJson = register.toJson();

      await _vaccineStorage.writeRegister(registerJson);
    }
  }

  _downloadAllVaccines() async {
    List data = await CredService().getAllVaccines();
    if (data.isNotEmpty) {
      _allVaccinesStorage.emptyFile();
      for (var value in data) {
        List timeDosis = [];
        for (var time in value['timeDosis']) {
          timeDosis.add(time);
        }
        VaccineDataRegister register = VaccineDataRegister(
            value['id'],
            value['name'],
            value['description'],
            value['totalDosis'],
            timeDosis,
            false,
            false);
        Map registerJson = register.toJson();
        await _allVaccinesStorage.writeRegister(registerJson);
      }
    }
  }

  _downloadAppointment(int idKid, int idLocalKid) async {
    List data = await CredService().getAppointmentsByKidId(idKid);
    for (var value in data) {
      AppointmentRegister register = AppointmentRegister(
          idKid,
          idLocalKid,
          value['id'],
          value['date_format'],
          value['date'],
          value['attendanceDate'],
          value['attendanceDate_format'],
          value['description'],
          value['state_value'],
          value['state_id'],
          false,
          false);
      Map registerJson = register.toJson();
      await _appointmentStorage.writeRegister(registerJson);
    }
  }

  _downloadWeightHeight(int idKid, int idLocalKid) async {
    List data = await CredService().getWeightAndHeightByKidId(idKid);
    for (var value in data) {
      WeightHeightRegister register = WeightHeightRegister(
          idKid,
          idLocalKid,
          value['id'],
          double.parse(value['weight'].toString()),
          double.parse(value['height'].toString()),
          value['date'],
          value['dateRaw'],
          value['age'],
          value['lengthDiagnostic'],
          value['lengthDiagnosticNumber'],
          value['weightForLengthDiagnostic'],
          value['weightForLengthDiagnosticNumber'],
          false,
          false);
      Map registerJson = register.toJson();
      await _weightHeightStorage.writeRegister(registerJson);
    }
  }

  _downloadIronSupplement(int idKid, int idLocalKid) async {
    List data = await CredService().getIronSupplementByKidId(idKid);
    for (var value in data) {
      Map dosage = {
        'amount': value['dosage']['amount'],
        'unit': value['dosage']['unit'],
        'unitId': value['dosage']['unitId']
      };
      IronSupplementRegister register = IronSupplementRegister(
          idKid,
          idLocalKid,
          value['id'],
          value['name'],
          0,
          value['type'],
          dosage,
          value['deliveryDate'],
          value['dateRaw'],
          false,
          false);
      Map registerJson = register.toJson();
      await _ironSupplementStorage.writeRegister(registerJson);
    }
  }

  _downloadIronSupplementNames() async {
    List data = await CredService().getIronSupplement();
    if (data.isNotEmpty) {
      _ironSupplementNameStorage.emptyFile();
      for (var value in data) {
        Map type = {'id': value['type']['id'], 'label': value['type']['label']};
        IronSupplementNameRegister register = IronSupplementNameRegister(
            value['id'], value['label'], type, false, false);
        Map registerJson = register.toJson();
        await _ironSupplementNameStorage.writeRegister(registerJson);
      }
    }
  }

  _downloadIronSupplementTypes() async {
    List data = await CredService().getIronSupplementTypes();
    if (data.isNotEmpty) {
      _ironSupplementTypeStorage.emptyFile();
      for (var value in data) {
        IronSupplementTypeRegister register = IronSupplementTypeRegister(
            value['id'], value['label'], false, false);
        Map registerJson = register.toJson();
        await _ironSupplementTypeStorage.writeRegister(registerJson);
      }
    }
  }

  _downloadIngredients() async {
    List data = await RecipesService().getIngredients();
    if (data.isNotEmpty) {
      _ingredientStorage.emptyFile();
      for (var value in data) {
        IngredientRegister register =
            IngredientRegister(value['id'], value['value']);
        Map registerJson = register.toJson();
        await _ingredientStorage.writeRegister(registerJson);
      }
    }
  }

  _downloadRecipeCategory() async {
    List data = await RecipesService().getTags();
    if (data.isNotEmpty) {
      _recipeCategoryStorage.emptyFile();
      for (var value in data) {
        RecipeCategoryRegister register =
            RecipeCategoryRegister(value['id'], value['value']);
        Map registerJson = register.toJson();
        await _recipeCategoryStorage.writeRegister(registerJson);
      }
    }
  }

  _downloadUnits() async {
    List data = await RecipesService().getUnits();
    if (data.isNotEmpty) {
      await _unitStorage.emptyFile();
      for (var value in data) {
        UnitRegister register = UnitRegister(value['id'], value['value']);
        Map registerJson = register.toJson();
        await _unitStorage.writeRegister(registerJson);
      }
    }
  }

  _downloadAmounts() async {
    List data = await RecipesService().getAmounts();
    if (data.isNotEmpty) {
      await _amountStorage.emptyFile();
      for (var value in data) {
        AmountRegister register = AmountRegister(value['id'], value['value']);
        Map registerJson = register.toJson();
        await _amountStorage.writeRegister(registerJson);
      }
    }
  }
}
