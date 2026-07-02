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
  <img src="assets/screenshots/splash_screen.png" width="240" alt="Pantalla de Bienvenida y Onboarding" />
  <img src="assets/screenshots/empty_state.png" width="240" alt="Estado Vacío / Inicio" />
  <img src="assets/screenshots/task_list.png" width="240" alt="Lista de Tareas Activa" />
</div>

### 🎬 Video de Funcionamiento
A continuación, se muestra el flujo completo de la aplicación, incluyendo el comportamiento del onboarding dinámico, la persistencia de datos y las interacciones táctiles:

<div align="center">

[▶️ Ver Video Demostrativo del Funcionamiento](assets/screenshots/demo_video.mp4)

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
├── view/
│   ├── components/                # Elementos visuales atómicos (H1, Shape)
│   ├── splash/
│   │   └── splash_page.dart       # Control de ciclo de vida y Onboarding inicial
│   └── task_list/
│       ├── task_list_page.dart    # Gestión visual del CRUD y modales responsivos
│       └── task_provider.dart     # Orquestador del estado y lógica del negocio

#### 📄Licencia

Este proyecto se distribuye bajo la Licencia MIT, permitiendo su uso, modificación y distribución libre de manera abierta. Consulta el archivo LICENSE adjunto para mayores detalles.
👨‍💻 Autor
José Rojas Product Developer & UI/UX Specialist - 📧 Email: joserojasdesign92@gmail.com

🌐 GitHub: @JoseGuillermoRP

📸 Instagram: @joserojas.code

Hecho con ❤️ y ☕ en Lima, Perú.

⭐ Si te fue útil este proyecto, considera darle una estrella en GitHub para apoyar su mantenimiento.
