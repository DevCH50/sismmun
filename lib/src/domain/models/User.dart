DateTime? _parseDate(String? dateStr) {
  if (dateStr == null) return null;
  try {
    // Intenta formato yyyy-mm-dd
    return DateTime.parse(dateStr);
  } catch (_) {
    try {
      // Intenta formato dd-mm-yyyy
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (_) {}
  }
  return null;
}

class User {
    int id;
    String username;
    String email;
    String nombre;
    String apPaterno;
    String apMaterno;
    String curp;
    String celulares;
    DateTime? fechaNacimiento;
    dynamic filenameThumb;
    List<int> roleIdArray;
    List<int> dependenciaIdArray;
    String strGenero;
    String fullName;

    User({
        required this.id,
        required this.username,
        required this.email,
        required this.nombre,
        required this.apPaterno,
        required this.apMaterno,
        required this.curp,
        required this.celulares,
        this.fechaNacimiento,
        required this.filenameThumb,
        required this.roleIdArray,
        required this.dependenciaIdArray,
        required this.strGenero,
        required this.fullName,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? 0,
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        nombre: json['nombre'] ?? '',
        apPaterno: json['ap_paterno'] ?? '',
        apMaterno: json['ap_materno'] ?? '',
        curp: json['curp'] ?? '',
        celulares: json['celulares'] ?? '',
        fechaNacimiento: _parseDate(json['fecha_nacimiento']),
        filenameThumb: json['filename_thumb'],
        roleIdArray: json['role_id_array'] != null
            ? List<int>.from(json['role_id_array'].map((x) => x))
            : [],
        dependenciaIdArray: json['dependencia_id_array'] != null
            ? List<int>.from(json['dependencia_id_array'].map((x) => x))
            : [],
        strGenero: json['str_genero'] ?? '',
        fullName: json['full_name'] ?? '',
    );

    Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'nombre': nombre,
        'ap_paterno': apPaterno,
        'ap_materno': apMaterno,
        'curp': curp,
        'celulares': celulares,
        'fecha_nacimiento': fechaNacimiento != null ? "${fechaNacimiento!.day.toString().padLeft(2, '0')}-${fechaNacimiento!.month.toString().padLeft(2, '0')}-${fechaNacimiento!.year.toString().padLeft(4, '0')}" : null,
        'filename_thumb': filenameThumb,
        'role_id_array': List<dynamic>.from(roleIdArray.map((x) => x)),
        'dependencia_id_array': List<dynamic>.from(dependenciaIdArray.map((x) => x)),
        'str_genero': strGenero,
        'full_name': fullName,
    };
}
