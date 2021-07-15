import 'package:flutter/material.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class InsertBoletoController {
  final formKey = GlobalKey<FormState>();
  final model = BoletoModel();

  String? validateName(String? value) =>
      value?.isEmpty ?? true ? "O nome não pode ser vazio" : null;
  String? validateVencimento(String? value) =>
      value?.isEmpty ?? true ? "A data de vencimento não pode ser vazio" : null;
  String? validateValor(double value) =>
      value == 0 ? "Insira um valor maior que R\$ 0,00" : null;
  String? validateCodigo(String? value) =>
      value?.isEmpty ?? true ? "O código do boleto não pode ser vazio" : null;

  void onChange({
    String? name,
    String? dueDate,
    double? value,
    String? barcode,
  }) {
    validateForm();
    model.copyWith(
      name: name,
      dueDate: dueDate,
      value: value,
      barcode: barcode,
    );
  }

  Future<void> cadastrarBoleto(BuildContext context) async {
    if (validateForm()) {
      await saveBoleto(context);
      Navigator.pop(context);
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Oops. Resolva as validações para salvar o boleto.",
        ),
      );
    }
  }

  Future<void> saveBoleto(BuildContext context) async {
    try {
      final instance = await SharedPreferences.getInstance();
      final boletos = instance.getStringList("boletos") ?? <String>[];
      boletos.add(model.toJson());
      await instance.setStringList("boletos", boletos);
      return;
    } catch (e) {
      print(e);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Oops. Falha ao salvar dados do boleto",
        ),
      );
    }
  }

  bool validateForm() {
    final form = formKey.currentState;
    return form!.validate();
  }
}
