import 'package:flutter/material.dart';

import '../models/Obra.dart';
import '../services/Catalogo_controlador.dart';

class vista_catalogo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InfiniteScrollCatalogoState();
}

class _InfiniteScrollCatalogoState extends State<vista_catalogo>{
  Catalogo_controlador catalogo_controlador = Catalogo_controlador();
  final ScrollController _scrollController = ScrollController();
  List<Obra> _obras = [];
  bool _isLoading = false;
  int _currentOffset = 0;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _fetchMoreObras();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchMoreObras();
      }
    });
  }

  Future<void> _fetchMoreObras() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Espera el resultado de obtener_catalogo
    List<Obra> newObras = await catalogo_controlador.obtener_catalogo(_currentOffset, _limit);
    print(newObras.length);
    setState(() {
      _obras.addAll(newObras);
      _currentOffset += _limit;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      // Floating action button en la esquina inferior derecha
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirFormulario(context);
        },
        child: Icon(Icons.add), // Icono del botón (puedes cambiarlo)
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        tooltip: 'Hacer sugerencia',
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        controller: _scrollController,
        itemCount: _obras.length + 1,
        itemBuilder: (context, index) {
          if (index < _obras.length) {
            final obra = _obras[index];
            return ListTile(
              textColor: Theme.of(context).colorScheme.secondary,
              tileColor: Theme.of(context).colorScheme.onPrimary,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(obra.nombreObra),
                        Text('Compositor: ${obra.compositor} - Estilo: ${obra.estilo}'),
                      ],
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icon(Icons.graphic_eq), // Icono del botón (puedes cambiarlo)
                    onPressed: () {
                      // Lógica para editar la obra
                      //_editarObra(obra); // Método que puedes definir para editar
                    },
                  ),
                ],
              ),
            );
          } else if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  // Método para abrir el formulario
  void _abrirFormulario(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hacer sugerencia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nombre de la Obra'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Compositor'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Comentario'),
              ),
              // Agrega más campos según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el formulario
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para guardar los datos del formulario
                Navigator.of(context).pop(); // Cierra el formulario después de guardar
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

}