# AI Module (.AIAgents) · Módulo AI (.AIAgents)

[English](#english) · [Español](#español)

---

## English

Reusable Markdown module to import into any software project.
Provides workflow skills for the planning pipeline and domain-scoped skills to minimize token usage per task.
Supports four AI agents: Claude, Codex, Gemini, and GitHub Copilot.

### Structure

```
.AIAgents/
├── COMMANDS.md                    # Command reference (legacy)
├── ROUTING.md                     # Agent-to-folder mapping
│
├── _shared/templates/             # Base templates
│   ├── project-context-template.md
│   ├── command-template.md
│   ├── skill-template.md
│   └── spec-template.md
│
├── Claude/                        # Claude source files
│   ├── commands/                  # Slash commands (legacy, kept for compatibility)
│   └── skills/
│       ├── scan/                  # Workflow: populate project-context.md
│       ├── spec/                  # Workflow: write feature/bug spec
│       ├── plan/                  # Workflow: phased implementation plan
│       ├── tasks/                 # Workflow: atomic task list
│       ├── implement/             # Workflow: execute tasks domain-by-domain
│       ├── spec-review/           # Workflow: validate implementation vs spec
│       ├── fix/                   # Workflow: minimal bug fix
│       ├── status/                # Workflow: pipeline snapshot
│       ├── switch/                # Workflow: change active spec
│       ├── mkskill/               # Workflow: create/update a project skill
│       ├── harness/               # Workflow: configure Claude Code hooks
│       ├── backend/               # Domain: backend tasks
│       ├── frontend/              # Domain: frontend tasks
│       ├── data/                  # Domain: data layer tasks
│       ├── testing/               # Domain: test writing and coverage
│       ├── devops/                # Domain: CI/CD and infrastructure
│       └── architecture-review/   # Domain: architecture decisions
│
├── Codex/                         # Codex source files
│   ├── commands/                  # Slash commands (primary mechanism for Codex)
│   └── skills/                    # Domain skills
│
├── Gemini/                        # Gemini source files
│   ├── commands/                  # Slash commands (primary mechanism for Gemini)
│   └── skills/                    # Domain skills
│
├── Copilot/                       # GitHub Copilot source files
│   ├── commands/                  # Prompt templates (paste into Copilot Chat)
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── fix.md
│   │   ├── status.md
│   │   ├── switch.md
│   │   └── mcp-create.md          # Interactive MCP server configurator
│   └── skills/                    # Domain skills (model-agnostic, YAML frontmatter)
│
└── scripts/
    └── bootstrap-commands.sh
```

### Workflow skills

> **Agents:** Claude Code (native Skill tool) · Codex (slash commands) · Gemini (slash commands) · Copilot (prompt templates — paste into chat)

Each workflow skill covers one step of the planning pipeline. Claude Code invokes them natively via the Skill tool. Codex and Gemini use slash commands. Copilot uses prompt templates from `.copilot/commands/`.

| Skill          | Purpose                                                        |
|----------------|----------------------------------------------------------------|
| `scan`         | Populate `.ai/project-context.md` from repo evidence          |
| `spec`         | Write a feature or bug spec, set `.ai/current`                |
| `plan`         | Phased implementation plan from spec                          |
| `tasks`        | Atomic task list with domain assignments                      |
| `implement`    | Execute tasks domain-by-domain with sub-agents                |
| `spec-review`  | Validate implementation against spec criteria                 |
| `fix`          | Minimal bug fix; `--trace` for bug spec traceability          |
| `status`       | Read-only pipeline snapshot                                   |
| `switch`       | Change active spec without re-running spec                    |
| `mkskill`      | Create or update a project-specific skill                     |
| `harness`      | Configure Claude Code hooks and permissions                   |

### Domain skills

> **Agents:** All four — Claude, Codex, Gemini, Copilot

Each domain skill loads only one section of `project-context.md`, not the full file.
This keeps token usage low and context noise minimal.
All domain skills include YAML frontmatter (`name` + `description`) for native auto-discovery in Copilot Agent Mode.

| Skill      | Reads                  |
|------------|------------------------|
| `backend`  | `[context.backend]`    |
| `frontend` | `[context.frontend]`   |
| `data`     | `[context.data]`       |
| `testing`  | `[context.testing]`    |
| `devops`   | `[context.devops]`     |

### Agent mechanisms

| Agent   | Workflow commands      | Domain skills         | Config file                       |
|---------|------------------------|-----------------------|-----------------------------------|
| Claude  | `.claude/skills/`      | `.claude/skills/`     | `CLAUDE.md`                       |
| Codex   | `.codex/commands/`     | `.codex/skills/`      | `AGENTS.md`                       |
| Gemini  | `.gemini/commands/`    | `.gemini/skills/`     | `GEMINI.md`                       |
| Copilot | `.copilot/commands/` ¹ | `.github/skills/` ²   | `.github/copilot-instructions.md` |

¹ Copilot has no native slash commands — these are prompt templates to paste in Copilot Chat.  
² Skills in `.github/skills/` are auto-discovered by Copilot Agent Mode (VS Code). In regular chat, paste the skill content manually.

### GitHub Copilot — features

> **Agents:** Copilot only

**Skills (auto-discovery):** Domain skills in `.github/skills/` are automatically activated by Copilot Agent Mode when your prompt is relevant to a domain. No manual loading needed.

**Commands (prompt templates):** Workflow commands are Markdown files you open and paste into Copilot Chat. They are model-agnostic — they work with GPT-4o, Claude Sonnet, Gemini, or any other model powering Copilot.

**MCP servers (`mcp-create`):** Use `.copilot/commands/mcp-create.md` to add an MCP server interactively. Copilot asks whether the server is remote (HTTP) or local (npx/command), collects the details, and generates the correct entry in `.vscode/mcp.json` without hardcoding secrets (uses `${env:VAR}` references).

### Suggested use

1. Copy `.AIAgents/` into a target project.
2. Run `./.AIAgents/scripts/bootstrap-commands.sh --repo <project-path> --agent all --mode copy`.
3. Start every new session with the `scan` skill to populate `project-context.md`.
4. Use workflow skills in order: `scan` → `spec` → `plan` → `tasks` → `implement` → `spec-review`.
5. For each implementation task, load only the domain skill that matches your work.
6. Keep `project-context.md` updated whenever stack, integrations, or standards change.

```bash
# All agents
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/project --agent all --mode copy

# Single agent
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/project --agent copilot

# Symlink mode (changes in .AIAgents propagate automatically)
./.AIAgents/scripts/bootstrap-commands.sh --repo /path/to/project --agent all --mode link
```

---

## Español

Módulo Markdown reutilizable para importar en cualquier proyecto de software.
Provee skills de workflow para el pipeline de planificación y skills por dominio para minimizar el uso de tokens por tarea.
Compatible con cuatro agentes de IA: Claude, Codex, Gemini y GitHub Copilot.

### Estructura

```
.AIAgents/
├── COMMANDS.md                    # Referencia de comandos (legacy)
├── ROUTING.md                     # Mapeo de agente a carpeta
│
├── _shared/templates/             # Plantillas base
│   ├── project-context-template.md
│   ├── command-template.md
│   ├── skill-template.md
│   └── spec-template.md
│
├── Claude/                        # Archivos fuente de Claude
│   ├── commands/                  # Slash commands (legacy, mantenidos por compatibilidad)
│   └── skills/
│       ├── scan/                  # Workflow: poblar project-context.md
│       ├── spec/                  # Workflow: escribir spec de feature o bug
│       ├── plan/                  # Workflow: plan de implementación por fases
│       ├── tasks/                 # Workflow: lista de tareas atómicas
│       ├── implement/             # Workflow: ejecutar tareas por dominio
│       ├── spec-review/           # Workflow: validar implementación vs spec
│       ├── fix/                   # Workflow: bug fix mínimo
│       ├── status/                # Workflow: snapshot del pipeline
│       ├── switch/                # Workflow: cambiar spec activa
│       ├── mkskill/               # Workflow: crear/actualizar un skill del proyecto
│       ├── harness/               # Workflow: configurar hooks de Claude Code
│       ├── backend/               # Dominio: tareas de backend
│       ├── frontend/              # Dominio: tareas de frontend
│       ├── data/                  # Dominio: capa de datos
│       ├── testing/               # Dominio: escritura de tests y cobertura
│       ├── devops/                # Dominio: CI/CD e infraestructura
│       └── architecture-review/   # Dominio: decisiones de arquitectura
│
├── Codex/                         # Archivos fuente de Codex
│   ├── commands/                  # Slash commands (mecanismo principal de Codex)
│   └── skills/                    # Skills por dominio
│
├── Gemini/                        # Archivos fuente de Gemini
│   ├── commands/                  # Slash commands (mecanismo principal de Gemini)
│   └── skills/                    # Skills por dominio
│
├── Copilot/                       # Archivos fuente de GitHub Copilot
│   ├── commands/                  # Plantillas de prompt (pegar en Copilot Chat)
│   │   ├── scan.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── fix.md
│   │   ├── status.md
│   │   ├── switch.md
│   │   └── mcp-create.md          # Configurador interactivo de servidores MCP
│   └── skills/                    # Skills por dominio (model-agnostic, con frontmatter YAML)
│
└── scripts/
    └── bootstrap-commands.sh
```

### Skills de workflow

> **Agentes:** Claude Code (Skill tool nativo) · Codex (slash commands) · Gemini (slash commands) · Copilot (plantillas de prompt — pegar en el chat)

Cada skill de workflow cubre un paso del pipeline de planificación. Claude Code los invoca nativamente via el Skill tool. Codex y Gemini usan slash commands. Copilot usa plantillas de prompt desde `.copilot/commands/`.

| Skill          | Propósito                                                          |
|----------------|--------------------------------------------------------------------|
| `scan`         | Poblar `.ai/project-context.md` a partir del repo                 |
| `spec`         | Escribir spec de feature o bug, setear `.ai/current`              |
| `plan`         | Plan de implementación por fases a partir de la spec              |
| `tasks`        | Lista de tareas atómicas con asignación de dominio                |
| `implement`    | Ejecutar tareas dominio por dominio con sub-agentes               |
| `spec-review`  | Validar implementación contra criterios de la spec                |
| `fix`          | Bug fix mínimo; `--trace` para trazabilidad en specs/bugs         |
| `status`       | Snapshot del pipeline (solo lectura)                              |
| `switch`       | Cambiar spec activa sin volver a correr spec                      |
| `mkskill`      | Crear o actualizar un skill específico del proyecto               |
| `harness`      | Configurar hooks y permisos de Claude Code                        |

### Skills por dominio

> **Agentes:** Los cuatro — Claude, Codex, Gemini, Copilot

Cada skill de dominio carga solo una sección de `project-context.md`, no el archivo completo.
Esto mantiene bajo el uso de tokens y mínimo el ruido de contexto.
Todos los skills de dominio incluyen frontmatter YAML (`name` + `description`) para auto-discovery nativo en Copilot Agent Mode.

| Skill      | Lee                    |
|------------|------------------------|
| `backend`  | `[context.backend]`    |
| `frontend` | `[context.frontend]`   |
| `data`     | `[context.data]`       |
| `testing`  | `[context.testing]`    |
| `devops`   | `[context.devops]`     |

### Mecanismos por agente

| Agente  | Comandos de workflow   | Skills de dominio     | Archivo de config                 |
|---------|------------------------|-----------------------|-----------------------------------|
| Claude  | `.claude/skills/`      | `.claude/skills/`     | `CLAUDE.md`                       |
| Codex   | `.codex/commands/`     | `.codex/skills/`      | `AGENTS.md`                       |
| Gemini  | `.gemini/commands/`    | `.gemini/skills/`     | `GEMINI.md`                       |
| Copilot | `.copilot/commands/` ¹ | `.github/skills/` ²   | `.github/copilot-instructions.md` |

¹ Copilot no tiene slash commands nativos — estos son plantillas de prompt para pegar en Copilot Chat.  
² Los skills en `.github/skills/` son auto-descubiertos por Copilot Agent Mode (VS Code). En chat regular, pegá el contenido del skill manualmente.

### GitHub Copilot — features

> **Agentes:** Solo Copilot

**Skills (auto-discovery):** Los skills de dominio en `.github/skills/` son activados automáticamente por Copilot Agent Mode cuando tu prompt es relevante a un dominio. No hace falta cargarlos manualmente.

**Comandos (plantillas de prompt):** Son archivos Markdown que abrís y pegás en Copilot Chat para ejecutar un paso del pipeline. Son model-agnostic — funcionan con GPT-4o, Claude Sonnet, Gemini, o cualquier otro modelo que use Copilot.

**Servidores MCP (`mcp-create`):** Usá `.copilot/commands/mcp-create.md` para agregar un servidor MCP de forma interactiva. Copilot pregunta si es remoto (HTTP) o local (npx/command), recolecta los datos y genera el entry correcto en `.vscode/mcp.json` sin hardcodear secrets (usa referencias `${env:VAR}`).

### Uso sugerido

1. Copiá `.AIAgents/` en un proyecto destino.
2. Corré `./.AIAgents/scripts/bootstrap-commands.sh --repo <ruta-proyecto> --agent all --mode copy`.
3. Empezá cada sesión nueva con el skill `scan` para poblar `project-context.md`.
4. Usá los skills de workflow en orden: `scan` → `spec` → `plan` → `tasks` → `implement` → `spec-review`.
5. Para cada tarea de implementación, cargá solo el skill de dominio que corresponda a tu trabajo.
6. Actualizá `project-context.md` cuando cambien el stack, las integraciones o los estándares del proyecto.

```bash
# Todos los agentes
./.AIAgents/scripts/bootstrap-commands.sh --repo /ruta/proyecto --agent all --mode copy

# Un solo agente
./.AIAgents/scripts/bootstrap-commands.sh --repo /ruta/proyecto --agent copilot

# Modo symlink (los cambios en .AIAgents se propagan automáticamente)
./.AIAgents/scripts/bootstrap-commands.sh --repo /ruta/proyecto --agent all --mode link
```
