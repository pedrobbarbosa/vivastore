import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/blocs/checkout/checkout_bloc.dart';
import 'package:flutter_ecommerce_app/widgets/widgets.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => CheckoutScreen(),
    );
  }

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _cepController = TextEditingController();
  String? _address;
  String? _shippingPrice;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Future<String?> _searchAddress(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final address = data['logradouro'] +
          ', ' +
          data['bairro'] +
          ', ' +
          data['localidade'] +
          ' - ' +
          data['uf'];
      return address;
    } else {
      return null;
    }
  }

  Future<String?> _calculateShippingPrice(String cep) async {
    // Chamar a API dos Correios para obter o preço estimado do frete
    // Substitua a chamada abaixo pela lógica de chamada à API dos Correios
    final double price = 15.90;

    return 'R\$ ${price.toStringAsFixed(2)}';
  }

  void _updateAddressAndPrice() async {
    final address =
        await _searchAddress(_cepController.text.trim().replaceAll('-', ''));
    final price = await _calculateShippingPrice(
        _cepController.text.trim().replaceAll('-', ''));

    setState(() {
      _address = address;
      _shippingPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Confira',
      ),
      bottomNavigationBar: CustomNavBar(screen: CheckoutScreen.routeName),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações do cliente',
              style: Theme.of(context).textTheme.headline3,
            ),
            _buildTextFormField((value) {
              context.read<CheckoutBloc>().add(UpdateCheckout(email: value));
            }, context, 'Email'),
            _buildTextFormField((value) {
              context.read<CheckoutBloc>().add(UpdateCheckout(fullName: value));
            }, context, 'Nome completo'),
            SizedBox(height: 20),
            Text(
              'Informações da entrega',
              style: Theme.of(context).textTheme.headline3,
            ),
            _buildTextFormField((value) {
              context.read<CheckoutBloc>().add(UpdateCheckout(address: value));
            }, context, 'Endereço'),
            _buildTextFormField((value) {
              context.read<CheckoutBloc>().add(UpdateCheckout(city: value));
            }, context, 'Cidade'),
            _buildTextFormField((value) {
              context.read<CheckoutBloc>().add(UpdateCheckout(country: value));
            }, context, 'País'),
            Row(
              children: [
                SizedBox(
                  width: 75,
                  child: Text(
                    'CEP',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _cepController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.only(left: 10),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                // put something here to make the button break to a new line
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: hexToColor('#EB690A'),
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                  ),
                  onPressed: _updateAddressAndPrice,
                  child: Text('Calcular Frete'),
                ),
              ],
            ),
            if (_address != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    'Endereço de entrega:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_address!),
                  if (_shippingPrice != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.0),
                        Text(
                          'Preço estimado do frete:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(_shippingPrice!),
                      ],
                    ),
                ],
              ),
            SizedBox(height: 20),
            Text(
              'Resumo da compra',
              style: Theme.of(context).textTheme.headline3,
            ),
            OrderSummary(),
          ],
        ),
      ),
    );
  }

  Padding _buildTextFormField(
    Function(String) onChanged,
    BuildContext context,
    String labelText,
  ) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.only(left: 10),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
