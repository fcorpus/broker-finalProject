class Usuario {
  final int id;
  final String nombre;
  final String password;
  final String monedaPreferida;
  final bool modoOscuro;

  Usuario({
    required this.id,
    required this.nombre,
    required this.password,
    required this.monedaPreferida,
    required this.modoOscuro,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'password': password,
    'moneda_preferida': monedaPreferida,
    'modo_oscuro': modoOscuro,
  };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id'],
    nombre: map['nombre'],
    password: map['password'],
    monedaPreferida: map['monedaPreferida'], 
    modoOscuro: map['modoOscuro'] == 1
  );
}