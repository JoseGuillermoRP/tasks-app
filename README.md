# 📋 Lista de Tareas (Task Lifecycle App)

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

**Aplicación móvil nativa de gestión de tareas y alta productividad diseñada con Flutter.** Este proyecto va más allá de un CRUD tradicional, integrando persistencia local, arquitectura basada en estados limpios y un flujo de experiencia de usuario (UX) interactivo fundamentado en la ingeniería de la usabilidad.

</div>

---

## 📸 Demostración Visual

### Capturas de Pantalla
<div align="center">
  <img width="auto" height="300" alt="Captura de pantalla 2026-07-03 193230" src="https://github.com/user-attachments/assets/58bca10a-4fcb-4f4b-9c56-ede6b46ad61f" />
  <img width="auto" height="300" alt="Captura de pantalla 2026-07-03 193300" src="https://github.com/user-attachments/assets/dc45c2fd-9db4-4f1f-84f9-b33f3013b459" />
  
<img width="auto" height="300" alt="Captura de pantalla 2026-07-03 193352" src="https://github.com/user-attachments/assets/1fcc0424-ec59-4d41-a985-cfe723a3a296" />
  

<img width="auto" height="300" alt="Captura de pantalla 2026-07-03 193526" src="https://github.com/user-attachments/assets/2addffe2-34c8-4381-ba86-4954930a47fe" />
<img width="auto" height="300" alt="Captura de pantalla 2026-07-03 193415" src="https://github.com/user-attachments/assets/13ce86da-888f-4a56-9218-fe195a44a7b0" />



</div>

### 🎬 Video de Funcionamiento
A continuación, se muestra el flujo completo de la aplicación, incluyendo el comportamiento del onboarding dinámico, la persistencia de datos y las interacciones táctiles:

<div align="center">
  
[![▶️Ver Video Demostrativo](https://img.youtube.com/vi/BKttE8YUfhA/0.jpg)](https://youtube.com/shorts/BKttE8YUfhA)


*(Nota: Si clonas el repositorio, puedes encontrar el archivo de video directamente en la carpeta de recursos visuales).*
</div>

---

## 🚀 Características Principales

- 🔄 **CRUD Completo de Tareas:** Flujo interactivo para crear, leer, actualizar y marcar estados de cumplimiento.
- 🧠 **Contextual Onboarding & Tutorial:** Sistema inteligente que detecta mediante persistencia si el usuario es nuevo para presentarle una guía de gestos interactivos.
- ↔️ **Gestos Bidireccionales Avanzados:** Integración de componentes `Dismissible` con feedback visual semántico (Azul con icono para Editar al deslizar a la derecha, Rojo con icono para Eliminar al deslizar a la izquierda).
- 💾 **Persistencia de Datos Local:** Implementación de `SharedPreferences` para salvaguardar el estado de la aplicación y las preferencias del usuario sin depender de servidores externos.
- 📱 **Diseño Adaptativo al Entorno (UI/UX):** Control activo de las vistas inferiores mediante insets dinámicos para evitar la superposición del teclado del sistema al redactar tareas.

---

## 🧠 Enfoque de Diseño y UX (Principios Aplicados)

Fiel a los pilares de usabilidad de **Jakob Nielsen** y los enfoques cognitivos de **Don Norman**, la interfaz de este producto digital fue estructurada bajo una fuerte filosofía de diseño táctil móvil:

1. **Prevención de Errores y Carga Cognitiva Mínima:** Cuando la lista está vacía, se despliega una pantalla de estado vacío (*Empty State*) con microcopias amigables ("Empecemos") y una guía visual clara apuntando al botón de acción principal para eliminar la incertidumbre del usuario.
2. **Eficiencia de Uso (Gestos Coherentes):** El control de edición y eliminación se simplifica mediante deslizamientos laterales (*swiping*), emulando la ergonomía y las respuestas musculares que los usuarios esperan en herramientas móviles modernas de alto rendimiento.
3. **Estabilidad del Layout:** El uso estratégico de `SingleChildScrollView` combinado con `MediaQuery.of(context).viewInsets.bottom` en los formularios modales asegura que la interfaz se mueva de manera fluida y predecible con la apertura del teclado numérico o alfabético.

---

## 🛠️ Arquitectura y Stack Tecnológico

El proyecto se divide de forma modular siguiendo un enfoque por características (*Feature-First Style*) que organiza componentes, estados y pantallas de manera desacoplada:

- **Core Framework:** Flutter & Dart.
- **State Management:** `Provider` (Patrón arquitectónico enfocado en `ChangeNotifier` y optimizado con `Consumer` para reconstrucciones selectivas de widgets).
- **Local Storage:** `SharedPreferences` para persistencia clave-valor rápida de configuraciones del sistema y tutoriales.
- **Navegación Segura:** Patrón de ciclo de vida con validaciones sutiles (`mounted` hooks) antes de efectuar el descarte definitivo de pantallas efímeras (`pushReplacement`).

### Estructura del Código Fuente
```text
lib/app/
├── model/
│   └── task.dart                  # Entidad pura de datos (Task)
├── repository/
│   └── task_repository.dart       # Abstracción de persistencia local
└── view/
    ├── components/                # Elementos visuales atómicos (H1, Shape)
    ├── home/
    │   └── home_page.dart         # Vista de inicio/menú principal
    ├── splash/
    │   └── splash_page.dart       # Control de ciclo de vida y Onboarding inicial
    └── task_list/                 # Módulo principal de gestión de tareas
        ├── widgets/               # Componentes UI refactorizados y modulares
        │   ├── edit_task_modal.dart 
        │   ├── new_task_modal.dart
        │   ├── task_item.dart     # UI de tarea individual con animaciones y gestos
        │   └── task_list_header.dart
        ├── task_list_page.dart    # Gestión visual del CRUD y vista principal
        └── task_provider.dart     # Orquestador del estado y lógica del negocio
```

## 📄 Licencia

Este proyecto se distribuye bajo la Licencia MIT, permitiendo su uso, modificación y distribución libre de manera abierta. Consulta el archivo LICENSE adjunto para mayores detalles.
👨‍💻 Autor
José Rojas Product Developer & UI/UX Specialist - 📧 Email: joserojasdesign92@gmail.com

🌐 GitHub: @JoseGuillermoRP

📸 Instagram: @joserojas.code

Hecho con ❤️ y ☕ en Lima, Perú.

⭐ Si te fue útil este proyecto, considera darle una estrella en GitHub para apoyar su mantenimiento.
