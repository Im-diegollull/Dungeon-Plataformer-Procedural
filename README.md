# Dungeon Plataformer Procedural

2D plataformer de acción con generación procedural de niveles estilo dungeon, hecho en Godot 4. Proyecto personal de portafolio — primer videojuego.

## Estado actual

🚧 En desarrollo (Mes 1 del roadmap). Por ahora hay un nivel de prueba con una plataforma y el personaje moviéndose, saltando y cayendo con gravedad. Todavía no hay arte final ni generación procedural.

## Requisitos

- [Godot 4](https://godotengine.org/download) (motor estándar, no la versión .NET)

## Cómo correr el proyecto

1. Cloná el repo:
   ```
   git clone https://github.com/Im-diegollull/Dungeon-Plataformer-Procedural.git
   ```
2. Abre Godot 4, haz click en **Import** y selecciona el archivo `project.godot` de la carpeta del repo.
3. Con el proyecto abierto, apretá **F5** (o el botón ▶ arriba a la derecha) para correrlo.
4. yo: godot --path "/Users/diegollull/Desktop/Riot HWG/Dungeon-Plataformer-Procedural"

## Controles

| Acción | Tecla |
|---|---|
| Moverse izquierda/derecha | Flechas ← → |
| Saltar | Espacio |

## Estructura del proyecto

```
assets/      # Sprites, audio, fuentes
scenes/
  player/    # Player.tscn + Player.gd
  enemies/   # Enemigos
  world/     # Niveles (Level.tscn)
  ui/        # HUD, menús
scripts/
  generation/  # Generación procedural de niveles
  managers/    # GameManager, AudioManager
```

## Stack

Godot 4 · GDScript · Assets gratuitos ([0x72](https://0x72.itch.io/dungeontileset-ii), [Kenney](https://kenney.nl/assets)) · Deploy en [itch.io](https://itch.io) (build web)
