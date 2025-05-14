import 'package:flutter/material.dart';

class LocalizationService {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'profile': 'Profile',
      'language': 'Language',
      'integrations': 'Integrations',
      'settings': 'Settings',
      'logout': 'Log Out',
      'select_language': 'Select Language',
      'english': 'English',
      'spanish': 'Spanish',
      'french': 'French',
    },
    'es': {
      'profile': 'Perfil',
      'language': 'Idioma',
      'integrations': 'Integraciones',
      'settings': 'Configuración',
      'logout': 'Cerrar Sesión',
      'select_language': 'Seleccionar Idioma',
      'english': 'Inglés',
      'spanish': 'Español',
      'french': 'Francés',
    },
    'fr': {
      'profile': 'Profil',
      'language': 'Langue',
      'integrations': 'Intégrations',
      'settings': 'Paramètres',
      'logout': 'Déconnexion',
      'select_language': 'Sélectionner la langue',
      'english': 'Anglais',
      'spanish': 'Espagnol',
      'french': 'Français',
    },
  };

  static String getTranslatedValue(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }
}