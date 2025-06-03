import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart'; // Para formateo de fechas
import 'package:google_fonts/google_fonts.dart'; // Para fuentes

// Asumo que DataService y la lógica de getWorkoutHistory se reemplazarán por llamadas a API
import '../services/data_service.dart'; // Mantendremos esto por ahora para que compile

// La función isSameDay ya está definida en table_calendar, no es necesario redefinirla
// si usas selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
// pero si la quieres explícita para claridad, está bien.
// bool isSameDay(DateTime? a, DateTime? b) { ... }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<String>>
      _workoutHistory; // Eventualmente vendrá de un provider/API

  // Colores del tema
  static const Color primaryBlue = Color(0xFF005DC8);
  static const Color lightBlue =
      Color(0xFF0D75F3); // Un azul más claro para acentos
  static const Color darkBlue = Color(0xFF003366);
  static const Color accentGreen =
      Color(0xFF4CAF50); // Verde para marcadores/acciones positivas
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  static const Color textWhite54 = Colors.white54;

  @override
  void initState() {
    super.initState();
    // TODO: Reemplazar con llamada asíncrona a provider/servicio para obtener datos de API
    _workoutHistory = DataService.getWorkoutHistory();
    _selectedDay = _focusedDay;
  }

  List<String> _getEventsForDay(DateTime day) {
    // Normalizar el día para asegurar que la clave del mapa coincida
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _workoutHistory[normalizedDay] ??
        []; // Devolver lista vacía si no hay eventos
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectedDayEvents =
        _getEventsForDay(_selectedDay ?? _focusedDay);

    // Formateador de fecha para el título de eventos del día
    // 'en_US' asegura el formato de fecha en inglés independientemente del locale del dispositivo
    final DateFormat eventHeaderFormat =
        DateFormat('EEEE, MMMM d, yyyy', 'en_US');

    return Scaffold(
      backgroundColor: darkBlue, // Un fondo azul más oscuro y profundo
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, 24.0, 16.0, 16.0), // Más padding superior
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // TODO: Reemplazar con la imagen de perfil real del usuario
                  const CircleAvatar(
                    radius: 24, // Un poco más grande
                    backgroundColor: Colors.white12, // Más sutil
                    child: Icon(
                      Icons.person_outline, // Icono diferente
                      size: 28,
                      color: textWhite70,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Workout Calendar', // EN INGLÉS
                    style: GoogleFonts.poppins(
                      color: textWhite,
                      fontSize: 26, // Ligeramente más grande
                      fontWeight: FontWeight.w600, // Más peso
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendario
              Card(
                elevation: 6, // Más sombra para profundidad
                color: primaryBlue
                    .withOpacity(0.85), // Color de fondo de la tarjeta
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16), // Bordes más redondeados
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Padding interno
                  child: TableCalendar(
                    locale:
                        'en_US', // Asegurar que los nombres de meses/días estén en inglés
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay =
                            focusedDay; // Actualizar focusedDay también es buena práctica
                      });
                    },
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek:
                        StartingDayOfWeek.monday, // Común en muchas regiones

                    // Estilo del Header (Mes y flechas)
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: GoogleFonts.poppins(
                          color: textWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      leftChevronIcon:
                          const Icon(Icons.chevron_left, color: textWhite70),
                      rightChevronIcon:
                          const Icon(Icons.chevron_right, color: textWhite70),
                      decoration: BoxDecoration(
                          // Fondo sutil para el header
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          )),
                      headerPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),

                    // Estilo de los nombres de los días de la semana (Mon, Tue...)
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: GoogleFonts.poppins(
                          color: textWhite70,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                      weekendStyle: GoogleFonts.poppins(
                          color: textWhite54,
                          fontWeight: FontWeight.w500,
                          fontSize: 12), // Fines de semana un poco más tenues
                    ),

                    // Estilo de los días del calendario
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: GoogleFonts.poppins(color: textWhite),
                      weekendTextStyle: GoogleFonts.poppins(color: textWhite70),
                      outsideTextStyle: GoogleFonts.poppins(
                          color: textWhite
                              .withOpacity(0.4)), // Días fuera del mes actual

                      todayDecoration: BoxDecoration(
                        color: lightBlue
                            .withOpacity(0.6), // Un azul más claro para "hoy"
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: lightBlue, // Color de selección más brillante
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: GoogleFonts.poppins(
                        color: textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                      selectedTextStyle: GoogleFonts.poppins(
                        color: textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                      // Estilo para los marcadores de eventos
                      markerDecoration: const BoxDecoration(
                        color: accentGreen, // Verde para indicar evento
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount:
                          1, // Mostrar un solo marcador por simplicidad
                      markerSize: 5.0,
                      markerMargin: const EdgeInsets.symmetric(horizontal: 0.5)
                          .copyWith(top: 6.0),
                    ),
                    // Función para cargar eventos (marcadores)
                    eventLoader: (day) {
                      return _getEventsForDay(day);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Título de Eventos del día seleccionado
              Text(
                'Workouts for ${eventHeaderFormat.format(_selectedDay ?? _focusedDay)}', // EN INGLÉS y formato
                style: GoogleFonts.poppins(
                  color: textWhite,
                  fontSize: 18, // Tamaño consistente
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Lista de eventos
              Expanded(
                child: selectedDayEvents.isEmpty
                    ? Center(
                        child: Column(
                          // Para centrar icono y texto
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.event_busy_outlined,
                                color: textWhite54, size: 48),
                            const SizedBox(height: 12),
                            Text(
                              'No workouts scheduled for this day.', // EN INGLÉS
                              style: GoogleFonts.poppins(
                                  color: textWhite70, fontSize: 15),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedDayEvents.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 2.0),
                            color: Colors.white
                                .withOpacity(0.1), // Color de tarjeta sutil
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: const Icon(Icons.fitness_center,
                                  color: accentGreen,
                                  size: 28), // Icono más grande y con color
                              title: Text(
                                selectedDayEvents[index],
                                style: GoogleFonts.poppins(
                                    color: textWhite,
                                    fontWeight: FontWeight.w500),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: textWhite54, size: 16),
                              onTap: () {
                                // TODO: Implementar navegación al detalle del entrenamiento
                                // Necesitarás el ID del workout o más info para esto.
                                print('Tapped on: ${selectedDayEvents[index]}');
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // La función _getWeekdayName no se usa en este código, pero la dejo si la necesitas para otra cosa.
  // String _getWeekdayName(int weekday) {
  //   const weekdays = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  //   return weekdays[weekday];
  // }
}
