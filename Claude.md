# CLAUDE.md — Dungeon Plataformer Procedural

## Contexto del proyecto

Proyecto personal de portafolio. Primera vez haciendo un videojuego.
Motor: **Godot 4** (estándar, no .NET) en **macOS**.
Objetivo final: juego jugable publicado en **itch.io**, exportado como build web.
Duración estimada: **3 meses**.

---

## Descripción del juego

2D plataformer de acción con generación procedural de niveles estilo dungeon.
Cada run genera un mapa diferente. El jugador avanza por salas, combate enemigos y progresa desbloqueando mejoras.

Referentes visuales: Dead Cells (simplificado), estilo pixel art oscuro con antorchas y piedra.
Assets: **Dungeon Tileset II de 0x72** (itch.io, gratis) + packs de Kenney.nl.

---

## Stack

| Componente | Tecnología |
|---|---|
| Motor | Godot 4 |
| Lenguaje | GDScript |
| Arte | Assets gratis (0x72, Kenney) |
| Audio | Packs gratis de itch.io |
| Deploy | itch.io (build web HTML5) |
| Control de versiones | Git + GitHub |

---

## Arquitectura del proyecto (estructura de carpetas Godot)

```
project/
├── assets/
│   ├── sprites/        # Tilesets, personaje, enemigos
│   ├── audio/          # SFX y música
│   └── fonts/
├── scenes/
│   ├── player/         # Player.tscn + Player.gd
│   ├── enemies/        # Enemy.tscn + Enemy.gd
│   ├── world/          # Level.tscn, Room.tscn
│   └── ui/             # HUD.tscn, MainMenu.tscn
├── scripts/
│   ├── generation/     # Lógica de generación procedural
│   └── managers/       # GameManager, AudioManager
└── CLAUDE.md
```

---

## Roadmap

### Mes 1 — Fundamentos del motor y movimiento
**Objetivo:** personaje que se mueve en un nivel estático dibujado a mano.

- [ ] Instalar Godot 4 y configurar proyecto
- [ ] Crear escena de Player con CharacterBody2D
- [ ] Implementar movimiento (caminar, saltar, caída con gravedad)
- [ ] Configurar TileMapLayer con el tileset de 0x72
- [ ] Cámara que sigue al jugador (Camera2D con suavizado)
- [ ] Escena de nivel de prueba dibujada a mano
- [ ] Configurar Git + GitHub para el proyecto

**Milestone:** GIF del personaje moviéndose en el dungeon para el README.

---

### Mes 2 — Sistemas de juego y contenido
**Objetivo:** juego jugable de principio a fin aunque feo.

- [ ] Generación procedural de salas (algoritmo BSP o Room-and-Corridor)
- [ ] Conexión entre salas con puertas / pasillos
- [ ] Enemigo básico: patrulla horizontal, detecta al jugador, lo persigue
- [ ] Sistema de combate: atacar (hitbox), recibir daño, knockback
- [ ] Sistema de vida del jugador (HP)
- [ ] Muerte del jugador → restart
- [ ] UI básica: barra de vida, número de nivel/sala
- [ ] Spawn de enemigos en salas generadas

**Milestone:** video de una run completa de principio a fin.

---

### Mes 3 — Pulido, progresión y deploy
**Objetivo:** algo que alguien más pueda jugar y se vea bien.

- [ ] Progresión entre runs (ej: desbloquear nuevas armas o stats)
- [ ] Pantalla de inicio y game over con estilo
- [ ] Feedback visual: partículas al golpear, flash de daño
- [ ] Sonido: SFX de salto, ataque, daño, muerte
- [ ] Música de fondo (loop)
- [ ] Pulir generación procedural: evitar salas imposibles
- [ ] Exportar build HTML5 y subir a itch.io
- [ ] README con GIF de gameplay + descripción del proyecto
- [ ] Screenshots para la página de itch.io

**Milestone:** link de itch.io funcionando, compartible.

---

## Decisiones técnicas clave

### Movimiento del personaje
Usar `CharacterBody2D` con `move_and_slide()`. Gravedad manual en `_physics_process()`.
No usar `RigidBody2D` — da menos control para plataformer.

### Generación procedural
Approach recomendado: **BSP (Binary Space Partitioning)**.
1. Dividir el mapa en regiones recursivamente
2. Crear una sala en cada región
3. Conectar salas hermanas con pasillos
4. Pintar el resultado en el TileMapLayer

Alternativa más simple para empezar: array de salas prefabricadas conectadas aleatoriamente.

### Enemigos
Usar `CharacterBody2D` + `NavigationAgent2D` para pathfinding, o lógica simple de raycast si no hay obstáculos complejos.
Estado: idle → patrol → chase → attack. Implementar con un enum + match.

### Progresión
Guardar stats entre runs con `FileAccess` (JSON simple) o `ConfigFile` de Godot.

---

## Recursos

| Recurso | URL |
|---|---|
| Godot 4 descarga | https://godotengine.org |
| Dungeon Tileset II (0x72) | https://0x72.itch.io/dungeontileset-ii |
| Assets Kenney | https://kenney.nl/assets |
| Audio gratis | https://freesound.org / https://itch.io/game-assets/free/tag-audio |
| Docs oficiales Godot | https://docs.godotengine.org/en/stable/ |
| Tutorial oficial "First 2D Game" | https://docs.godotengine.org/en/stable/getting_started/first_2d_game/ |
| GDScript cheatsheet | https://gdscript.com |

---

## Convenciones de código (GDScript)

```gdscript
# Nombres de variables: snake_case
var player_speed: float = 200.0

# Nombres de funciones: snake_case
func take_damage(amount: int) -> void:
    pass

# Nombres de nodos en escena: PascalCase
# Constantes: UPPER_SNAKE_CASE
const MAX_HEALTH: int = 100

# Siempre tipar variables cuando sea posible
var health: int = MAX_HEALTH
```

---

## Estado actual

- [ ] Godot 4 instalado
- [ ] Assets de 0x72 descargados
- [ ] Proyecto creado en Godot
- [ ] Repositorio GitHub creado

**Próximo paso:** implementar movimiento del personaje (Player.gd).