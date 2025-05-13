class Transaccion {
  final int id;
  final int usuarioId;
  final String tipo;
  final double monto;
  final String? categoria;
  final String nota;
  final DateTime fecha;

  Transaccion({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.monto,
    this.categoria,
    required this.nota,
    required this.fecha,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'usuario_id': usuarioId,
    'tipo': tipo,
    'monto': monto,
    'categoria': categoria,
    'nota': nota,
    'fecha':fecha.toIso8601String(),
  };

  factory Transaccion.fromMap(Map<String, dynamic> map) => Transaccion(
    id: map['id'], 
    usuarioId: map['usuarioId'], 
    tipo: map['tipo'], 
    monto: map['monto'], 
    nota: map['nota'], 
    fecha: DateTime.parse(map['fecha']),
    );
}