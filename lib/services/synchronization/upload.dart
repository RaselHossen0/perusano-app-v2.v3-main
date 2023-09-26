import 'dart:io';

import 'package:perusano/services/apis/family/familyRegisterCenter.dart';
import 'package:perusano/services/fileManagement/cred/anemiaCheckFM.dart';
import 'package:perusano/services/fileManagement/cred/selectable/ironSupplementNameFM.dart';
import 'package:perusano/services/fileManagement/cred/selectable/ironSupplementTypeFM.dart';
import 'package:perusano/services/fileManagement/cred/vaccineFM.dart';
import 'package:perusano/services/fileManagement/family/familyMemberFM.dart';
import 'package:perusano/services/fileManagement/family/kidFM.dart';
import 'package:perusano/services/fileManagement/recipes/recipeFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/amountFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/recipeCategoryFM.dart';
import 'package:perusano/services/fileManagement/recipes/selectable/unitFM.dart';
import 'package:perusano/util/internVariables.dart';
import '../apis/cred/credRegisterCenter.dart';
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

class UploadService {
  final FamilyMemberFM _familyMemberStorage = FamilyMemberFM();
  final KidFM _kidStorage = KidFM();
  final AnemiaCheckFM _anemiaCheckStorage = AnemiaCheckFM();
  final VaccineFM _vaccineStorage = VaccineFM();
  final AppointmentFM _appointmentStorage = AppointmentFM();
  final WeightHeightFM _weightHeightStorage = WeightHeightFM();
  final IronSupplementFM _ironSupplementStorage = IronSupplementFM();
  final RecipeFM _recipeStorage = RecipeFM();
  final IronSupplementNameFM _ironSupplementNameStorage =
      IronSupplementNameFM();
  final IronSupplementTypeFM _ironSupplementTypeStorage =
      IronSupplementTypeFM();
  final IngredientFM _ingredientStorage = IngredientFM();
  final AllVaccinesFM _allVaccinesStorage = AllVaccinesFM();
  final UnitFM _unitStorage = UnitFM();
  final AmountFM _amountStorage = AmountFM();
  final RecipeCategoryFM _recipeCategoryStorage = RecipeCategoryFM();

  Future<void> uploadData() async {
    //Hay un bug que hace que, al iniciar la sesión, siempre detecte que tiene internet así no lo tenga
    try {
      //Tratara de acceder a un api, si se cae por falta de internet no realizará el upload
      List pruebaAntiInternet = await CredService().getAllVaccines();
      //print('Pasó la bandera'); //Si esto se muestra sin internet, la bandera esta fallando
      if (pruebaAntiInternet.isNotEmpty) {
        int familyId = InternVariables.idFamily;
        await _uploadFamilyMember(familyId);
        await _uploadKidData(familyId);
        await _uploadCredData();
        await _uploadRecipe();
      }
    } catch (e) {
      return;
    }
  }

  Future<void> _uploadFamilyMember(int familyId) async {
    List notUpdated = await _familyMemberStorage.getNotUpdated();
    for (var value in notUpdated) {
      Map answer = await FamilyRegisterCenter().addFamilyMember(
          value['dni'],
          value['name'],
          value['lastname'],
          value['mother_lastname'],
          value['relationship'],
          '',
          '',
          '',
          '',
          value['is_caregiver'],
          value['url_photo'],
          familyId);
      _familyMemberStorage.updateIdRegister(value['idLocal'], answer['id']);
    }
  }

  Future<void> _uploadKidData(int familyId) async {
    List notUpdated = await _kidStorage.getNotUpdated();
    for (var value in notUpdated) {
      Map answer = await FamilyRegisterCenter().addKid(
          value['names'],
          value['lastname'],
          value['mother_lastname'],
          value['dateRaw'],
          0,
          0,
          value['gender'],
          value['afiliateCode'],
          familyId);
      await _kidStorage.updateIdRegister(value['idLocal'], answer['id']);
    }
  }

  Future<void> _uploadCredData() async {
    await _uploadAnemiaCheck();
    await _uploadVaccines();
    await _uploadAppointment();
    await _uploadWeightHeight();
    await _uploadIronSupplement();
  }

  Future<void> _uploadAnemiaCheck() async {
    List deleted = await _anemiaCheckStorage.getDeleted();
    if (deleted.isNotEmpty) {
      for (var value in deleted) {
        await CredRegisterCenter().deleteAnemiaCheck(value['id']);
        await _anemiaCheckStorage.deleteRegister(value['idLocal']);
      }
    }
    List notUpdated = await _anemiaCheckStorage.getNotUpdated();
    if (notUpdated.isNotEmpty) {
      for (var value in notUpdated) {
        int idKid = await _kidStorage.getIdByIdLocal(value['idLocalKid']);
        Map answer = await CredRegisterCenter()
            .addAnemiaCheck(idKid, value['result'], value['dateRaw']);
        await _anemiaCheckStorage.updateIdRegister(
            idKid, value['idLocal'], answer['id']);
      }
    }
  }

  Future<void> _uploadVaccines() async {
    List vaccines = await _vaccineStorage.getNotUploaded();
    if (vaccines.isNotEmpty) {
      for (var value in vaccines) {
        if (value['idKid'] == 0) {
          //Obtiene IdGlobal del niño
          int idKid = await _kidStorage.getIdByIdLocal(value['idLocalKid']);
          //Asigna el idGlobal a todas las vacunas que coincida el idLocalKid
          await _vaccineStorage.updateIdKidInVaccines(
              value['idLocalKid'], idKid);
          //Obtiene el conjunto de vacunas del niño tanto del server como del localStorage
          List kidLocalVaccine =
              await _vaccineStorage.readFileById(value['idLocalKid']);
          List answerVaccine = await CredService().getVaccinesByKidId(idKid);
          //Recorre ambos a la vez para ir añadiendo el IdGlobal a cada dosis
          for (var index = 0; index < kidLocalVaccine.length; index++) {
            List localVaccineDoses = kidLocalVaccine[index]['dosis'];
            List globalVaccineDoses = answerVaccine[index]['dosis'];
            for (var indexDose = 0;
                indexDose < localVaccineDoses.length;
                indexDose++) {
              await _vaccineStorage.updateIdDoseInVaccines(
                  idKid,
                  answerVaccine[index]['id'],
                  localVaccineDoses[indexDose]['idLocal'],
                  globalVaccineDoses[indexDose]['id']);
            }
          }
        }
      }
    }
    List doseChanged = await _vaccineStorage.getChanged();
    if (doseChanged.isNotEmpty) {
      for (var value in doseChanged) {
        if (value['applied_date_raw'] == null) {
          await CredRegisterCenter()
              .deleteVaccinedAppliedDateDose(value['id'], 2);
        } else {
          await CredRegisterCenter()
              .updateVaccinedDose(value['id'], value['applied_date_raw'], 1);
        }
        await _vaccineStorage.changeWasChangedToFalse(value['idLocal']);
      }
    }
  }

  Future<void> _uploadAppointment() async {
    List deleted = await _appointmentStorage.getDeleted();
    if (deleted.isNotEmpty) {
      for (var value in deleted) {
        await CredRegisterCenter().deleteAppointment(value['id']);
        await _appointmentStorage.deleteRegister(value['idLocal']);
      }
    }

    List notUpdated = await _appointmentStorage.getNotUpdated();
    if (notUpdated.isNotEmpty) {
      for (var value in notUpdated) {
        int idKid = await _kidStorage.getIdByIdLocal(value['idLocalKid']);
        Map answer = await CredRegisterCenter()
            .addAppointment(idKid, value['date'], value['description']);
        await _appointmentStorage.updateIdRegister(
            idKid, value['idLocal'], answer['id']);
      }
    }

    List changed = await _appointmentStorage.getChanged();
    if (changed.isNotEmpty) {
      for (var value in changed) {
        if (value['attendanceDate'] == null) {
          await CredRegisterCenter()
              .deleteAppointmentDateApplied(value['id'], value['date']);
        } else {
          await CredRegisterCenter().updateAppointmentState(
              value['id'], value['date'], value['attendanceDate']);
        }
        await _appointmentStorage.changeWasChangedToFalse(value['idLocal']);
      }
    }
  }

  Future<void> _uploadWeightHeight() async {
    List deleted = await _weightHeightStorage.getDeleted();
    if (deleted.isNotEmpty) {
      for (var value in deleted) {
        await CredRegisterCenter().deleteWeightHeight(value['id']);
        await _weightHeightStorage.deleteRegister(value['idLocal']);
      }
    }

    List notUpdated = await _weightHeightStorage.getNotUpdated();
    if (notUpdated.isNotEmpty) {
      for (var value in notUpdated) {
        int idKid = await _kidStorage.getIdByIdLocal(value['idLocalKid']);
        Map answer = await CredRegisterCenter().addWeightHeight(
            idKid,
            value['weight'],
            value['height'],
            value['dateRaw'],
            value['lengthDiagnostic'],
            value['lengthDiagnosticNumber'],
            value['weightForLengthDiagnostic'],
            value['weightForLengthDiagnosticNumber']);
        await _weightHeightStorage.updateIdRegister(
            idKid, value['idLocal'], answer['id']);
      }
    }
  }

  Future<void> _uploadIronSupplement() async {
    List deleted = await _ironSupplementStorage.getDeleted();
    if (deleted.isNotEmpty) {
      for (var value in deleted) {
        await CredRegisterCenter().deleteIronSupplement(value['id']);
        await _ironSupplementStorage.deleteRegister(value['idLocal']);
      }
    }

    List notUpdated = await _ironSupplementStorage.getNotUpdated();
    if (notUpdated.isNotEmpty) {
      for (var value in notUpdated) {
        int idKid = await _kidStorage.getIdByIdLocal(value['idLocalKid']);
        Map answer = await CredRegisterCenter().addIronSupplement(
            idKid,
            value['nameId'],
            value['dosage']['amount'],
            value['dosage']['unitId'],
            value['dateRaw']);
        await _ironSupplementStorage.updateIdRegister(
            idKid, value['idLocal'], answer['id']);
      }
    }
  }

  Future<void> _uploadRecipe() async {
    List recipesNotUpdated = await _recipeStorage.getNotUpdated();
    for (var recipe in recipesNotUpdated) {
      List ingredientsFinal = [];
      for (var ingredient in recipe["ingredients"]) {
        List alternativesFinal = [];
        for (var alternative in ingredient["alternatives"]) {
          Map alt = {
            "id": alternative["id"],
            "amount_id": alternative["amount_id"],
            "unit_id": alternative["unit_id"]
          };
          alternativesFinal.add(alt);
        }
        Map ingredientFinal = {
          "id": ingredient["id"],
          "amount_id": ingredient["amount_id"],
          "unit_id": ingredient["unit_id"],
          "alternatives": alternativesFinal
        };
        ingredientsFinal.add(ingredientFinal);
      }
      Map recipeToUpload = {
        "title": recipe["title"],
        "total_likes": recipe["total_likes"],
        "author_id": recipe["author_id"],
        "age_tag_id": recipe["age_tag"]?["id"],
        "preparation": recipe["preparation"],
        "ingredients": ingredientsFinal
      };
      Map recipeFinal = await RecipesService().addRecipe(recipeToUpload);
      File image = File(recipe["url_photo"]);
      File video = File(recipe["url_video"]);

      await RecipesService().addImage(image, recipeFinal['id']);
      await RecipesService().addVideo(video, recipeFinal['id']);
      _recipeStorage.updateIdRegister(recipe['idLocal'], recipeFinal['id']);
    }
  }
}
