import 'package:celloapp/models/Sugerencia.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/Obra.dart';
import '../services/Catalogo_controlador.dart';
import '../services/Sugerencia_controlador.dart';

class vista_catalogo extends StatefulWidget {
  const vista_catalogo({super.key});

  @override
  State<StatefulWidget> createState() => _InfiniteScrollCatalogoState();
}

class _InfiniteScrollCatalogoState extends State<vista_catalogo> {
  Catalogo_controlador catalogo_controlador = Catalogo_controlador();
  final ScrollController _scrollController = ScrollController();
  final List<Obra> _obras = [];
  bool _isLoading = false;
  int _currentOffset = 0;
  final int _limit = 10;
  final TextEditingController _nombreObraController = TextEditingController();
  final TextEditingController _compositorController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final User? usuarioActual = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchMoreObras();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
    List<Obra> newObras =
        await catalogo_controlador.obtener_catalogo(_currentOffset, _limit);
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
        }, // Icono del botón (puedes cambiarlo)
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        tooltip: 'Hacer sugerencia',
        child: Icon(Icons.add),
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
                        Text(
                            'Compositor: ${obra.compositor} - Estilo: ${obra.estilo}'),
                      ],
                    ),
                  ),
                  IconButton(
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icon(
                        Icons.graphic_eq), // Icono del botón (puedes cambiarlo)
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
                controller: _nombreObraController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Compositor'),
                controller: _compositorController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Comentario'),
                controller: _comentarioController,
              ),
              // Agrega más campos según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el formulario
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            TextButton(
              onPressed: () async {
                Sugerencia sugerencia = Sugerencia(
                    nombreObra: _nombreObraController.text,
                    compositor: _compositorController.text,
                    comentario: _comentarioController.text,
                    usuario: usuarioActual?.email);

                Sugerencia_controlador controladorSugerencia =
                    Sugerencia_controlador();
                bool correcto =
                    await controladorSugerencia.registra_sugerencia(sugerencia);
                if (!correcto) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Hubo un error al hacer sugerencia')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Se registro correctamente')),
                  );
                }
                // Lógica para guardar los datos del formulario
                Navigator.of(context)
                    .pop(); // Cierra el formulario después de guardar
              },
              child: Text('Guardar',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ],
        );
      },
    );
  }
}
