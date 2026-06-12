# MachineBlocks — MBML, MBOM und SCAD Reference Compiler

Version: 0.1
Status: Concept Draft

## 1. Zielbild

MachineBlocks soll von einer OpenSCAD-zentrierten Bibliothek zu einem modellgetriebenen System erweitert werden.

OpenSCAD bleibt zunächst das wichtigste Reference Render Target, aber nicht mehr die primäre semantische Beschreibungsebene. Die eigentliche Beschreibung erfolgt künftig über:

1. **MBML** — MachineBlocks Markup Language
2. **MBOM** — MachineBlocks Object Model
3. **SCAD Reference Render Target**
4. **MBOM → SCAD Reference Compiler**

Das Ziel ist eine klare Trennung zwischen Autorensprache, typisiertem Objektmodell und konkretem Renderziel.

```text
MBML/XML
   ↓ parse + validate
MBOM
   ↓ compile
SCAD Reference Target
   ↓ render
OpenSCAD / STL / 3MF
```

MBML ist dabei die menschen- und editorfreundliche Beschreibungssprache. MBOM ist das strikte, typisierte Zwischenmodell. SCAD ist ein Zielsystem.

---

## 2. MBML

MBML ist die deklarative Beschreibungssprache von MachineBlocks.

Sie ist zunächst XML-basiert, soll aber langfristig auch in JSON oder anderen Serialisierungen ausdrückbar sein. XML ist die Referenzsyntax, weil sie Namespaces, strukturierte Dokumente und Schema-Validierung gut unterstützt.

### 2.1 MBML-Dateitypen

MBML kennt drei primäre Dokumenttypen:

```text
1. Block Definition
2. Set Definition
3. Parameter Presets
```

### 2.2 Block Definition

Eine Block Definition beschreibt einen wiederverwendbaren Blocktyp.

Sie definiert:

* Name
* Package
* Base Type
* Properties
* Aggregations
* Compositions
* Associations
* Events, später
* Dokumentation

Beispiel:

```xml
<block xmlns="http://www.machineblocks.com/mbml/block"
       xmlns:mb="mb.core"
       xmlns:bricks="mb.bricks"
       package="martianmicro.anyclosure"
       name="Wall">

  <baseType>mb.core.Block</baseType>

  <properties>
    <property name="size" type="mb.types.Size" defaultValue="[1, 1, 1]">
      <documentation>The size of the Block.</documentation>
    </property>

    <property name="offset" type="mb.types.GridPosition3D" defaultValue="[0, 0, 0]">
      <documentation>The position of the Block in the Grid.</documentation>
    </property>

    <property name="direction" type="mb.types.Direction" defaultValue="West">
      <documentation>The Direction of the Block.</documentation>
    </property>

    <property name="align" type="mb.types.Alignment" defaultValue="Start">
      <documentation>The Alignment of the Block.</documentation>
    </property>
  </properties>

  <aggregations>
    <aggregation name="_parts"
                 cardinality="0..n"
                 type="mb.bricks.StandardBrick"
                 visibility="hidden">
      <documentation>Internal block parts.</documentation>
    </aggregation>
  </aggregations>

  <compositions>
    <composition aggregation="_parts">

      <bricks:StandardBrick
          id="bottom"
          render-group="bottom"
          namespace="bottom"
          size="${[size[0], size[1], size[2] - 1]}"
          recess="true"
          tongue="true"
          recess-wall-gaps="x+" />

      <bricks:StandardBrick
          id="top"
          render-group="top"
          namespace="top"
          size="${[size[0], size[1], 1]}"
          recess="true"
          base-cutout-type="groove"
          recess-wall-gaps="x+" />

    </composition>
  </compositions>

</block>
```

### 2.3 Set Definition

Eine Set Definition beschreibt eine konkrete Zusammenstellung von Blockinstanzen.

Sie entspricht konzeptionell einer SAPUI5 View:

```text
UI5 View → MachineBlocks Set
UI5 Control Instance → Block Instance
```

Ein Set definiert:

* Package
* Name
* Properties
* Bounds
* Instances
* Steps
* Views

Views können verschiedene Darstellungen desselben Sets beschreiben:

```text
total     → vollständig montiert
print     → Drucklayout
step      → Bauanleitungsschritt
instance  → Einzelinstanz
```

### 2.4 Parameter Presets

Parameter Presets sind wiederverwendbare Parametersammlungen.

Sie dienen dazu, Varianten eines Blocks oder Sets zu definieren, ohne die eigentliche Blockdefinition zu verändern.

Beispiele:

```text
color presets
printer presets
material presets
device presets
view presets
calibration presets
```

Presets sind keine Blöcke und keine Sets. Sie sind parametrisierte Konfigurationen.

---

## 3. Namespaces und Typauflösung

MBML muss Namespaces verwenden.

Beispiel:

```xml
<set
    xmlns="http://www.machineblocks.com/mbml/set"
    xmlns:ac="martianmicro.anyclosure"
    xmlns:mb="mb.core"
    package="martianmicro.anyclosure.default_enclosure">
```

Eine Instanz:

```xml
<ac:Wall id="00003" size="[1, 8, 9]" />
```

wird aufgelöst zu:

```text
martianmicro.anyclosure.Wall
```

oder abhängig vom Namespace-Mapping:

```text
mm.anyclosure.Wall
```

Die Schreibweise im MBOM ist immer die vollständige FQN.

---

## 4. MBOM

MBOM steht für MachineBlocks Object Model.

MBOM ist das strikte, typisierte Laufzeit- und Compiler-Modell von MachineBlocks. Es ist an SAPUI5 angelehnt, aber auf physische, parametrisierte Blockstrukturen übertragen.

### 4.1 Grundidee

```text
SAPUI5 Control            → MBOM Block
SAPUI5 Composite Control  → MBOM Composite Block
SAPUI5 View               → MBOM Set
SAPUI5 Property           → MBOM Property
SAPUI5 Aggregation        → MBOM Aggregation
SAPUI5 Association        → MBOM Association
SAPUI5 Event              → MBOM Event
```

MBOM beschreibt nicht OpenSCAD-Code, sondern semantische MachineBlocks-Objekte.

### 4.2 Fully Qualified Names

Jede MBOM-Klasse besitzt einen Fully Qualified Name.

Beispiele:

```text
mb.core.Block
mb.bricks.StandardBrick
mb.enclosures.Panel
martianmicro.anyclosure.Wall
martianmicro.anyclosure.Corner
martianmicro.anyclosure.DefaultEnclosureSet
```

Diese Typen werden in Properties, Aggregations, Associations und Compositions verwendet.

### 4.3 Properties

Properties sind typisierte Parameter.

Beispiel:

```text
property size: mb.types.Size = [1, 1, 1]
property direction: mb.types.Direction = West
property baseColor: mb.types.Color = "#EAC645"
```

Properties können native `mb_block()`-Parameter oder blockeigene semantische Parameter sein.

### 4.4 Parameter Types

Parameter Types sind ein zentraler Bestandteil von MBOM.

Beispiele:

```text
mb.types.Size
mb.types.GridPosition3D
mb.types.Direction
mb.types.Alignment
mb.types.Color
mb.types.AssemblyMode
mb.types.Integer
mb.types.Boolean
mb.types.String
mb.types.Enum
mb.types.Expression
```

Der SCAD Renderer darf Legacy- und Shortcut-Formate unterstützen. MBOM selbst ist aber eindeutig und typisiert.

Beispiel:

```text
MBML:  direction="West"
MBOM:  Direction.West
SCAD:  "west" oder 0, je nach Target-Regel
```

### 4.5 Aggregations

Aggregations beschreiben Besitzverhältnisse.

Beispiel:

```text
Wall
 └─ _parts: mb.bricks.StandardBrick[0..n]
```

Eine Aggregation definiert:

```text
name
type
cardinality
visibility
defaultAggregation
documentation
```

Typen in Aggregations müssen FQNs sein.

Beispiel:

```xml
<aggregation
    name="_parts"
    type="mb.bricks.StandardBrick"
    cardinality="0..n"
    visibility="hidden" />
```

### 4.6 Compositions

Compositions füllen Aggregations mit konkreten Kindobjekten.

Eine Composition ist die interne Bauanleitung eines Composite Blocks.

Beispiel:

```text
Wall._parts:
  - bottom: mb.bricks.StandardBrick
  - top: mb.bricks.StandardBrick
```

Compositions können Expressions enthalten:

```xml
size="${[size[0], size[1], size[2] - 1]}"
```

Diese Expressions werden nicht direkt als SCAD-Code verstanden, sondern zunächst in MBOM Expression Nodes übersetzt.

### 4.7 Associations

Associations beschreiben lose Verweise auf andere Objekte.

Sie sind für später vorgesehen.

Mögliche Anwendungen:

```text
PCB component reference
external device module
connector partner
instruction asset
render profile
material profile
```

Associations besitzen kein Ownership-Verhältnis.

### 4.8 Events

Events sind ebenfalls für später vorgesehen.

Sie sind wichtig, wenn MachineBlocks nicht nur statische Geometrie, sondern interaktive, editor- oder device-nahe Logik beschreiben soll.

Beispiele:

```text
onAssemble
onRender
onSelect
onParameterChange
onConnect
onValidate
```

Events gehören zunächst nicht zum SCAD Reference Target, können aber im Editor oder späteren Device-System relevant werden.

---

## 5. SCAD Reference Render Target

OpenSCAD bleibt das erste und wichtigste Renderziel.

Das SCAD Reference Target ist jedoch nicht mehr die semantische Quelle. Es ist ein Compiler-Ziel.

### 5.1 Ziel

Der SCAD Renderer erzeugt gültige MachineBlocks-v3-SCAD-Dateien.

Diese Dateien sollen weiterhin:

* standalone in OpenSCAD lauffähig sein
* den Customizer unterstützen
* `config` und `settings` verwenden
* `mb_block()` als Low-Level-Primitive nutzen
* Composite Blocks korrekt abbilden
* Set Views wie `total`, `print`, `step`, `instance` erzeugen können

### 5.2 SCAD-Ausgabeformen

Der SCAD Renderer erzeugt je nach MBOM-Dokument:

```text
Block File
Set Helper File
Preset-expanded Block File
Generated Preview File
```

### 5.3 Mapping FQN → SCAD Modulname

MBOM-Typ:

```text
martianmicro.anyclosure.Wall
```

SCAD-Modul:

```scad
mb_block__martianmicro__anyclosure__wall
```

oder bei Kurznamespace:

```scad
mb_block__mm__anyclosure__wall
```

Dateiname:

```text
wall.scad
```

Pfad:

```text
martianmicro/blocks/anyclosure/wall/wall.scad
```

### 5.4 Mapping Properties → settings

MBOM:

```text
size = [1, 8, 9]
direction = Direction.West
baseColor = "#303D4E"
```

SCAD:

```scad
settings = [
  ["size", [1, 8, 9]],
  ["direction", "west"],
  ["baseColor", "#303D4E"]
]
```

### 5.5 Composite Blocks

Eine MBOM Composition wird zu verschachtelten SCAD-Modulaufrufen.

MBOM:

```text
Wall
 └─ _parts
    ├─ bottom: mb.bricks.StandardBrick
    └─ top: mb.bricks.StandardBrick
```

SCAD:

```scad
mb_block(
    config = config,
    settings = [
        ["id", blockId],
        ["base", false],
        ["studs", false],
        ["size", size],
        ["align", align],
        ["offset", offset],
        ["direction", direction]
    ]
){
    mb_block(
        config = config,
        settings = [
            ["id", mb_block_id(blockId, "bottom")],
            ["size", [size[0], size[1], size[2] - 1]],
            ["recess", true],
            ["tongue", true],
            ["recessWallGaps", "x+"]
        ]
    );

    mb_block(
        config = config,
        settings = [
            ["id", mb_block_id(blockId, "top")],
            ["size", [size[0], size[1], 1]],
            ["offset", [0, 0, size[2] - 1]],
            ["recess", true],
            ["baseCutoutType", "groove"],
            ["recessWallGaps", "x+"]
        ]
    );
}
```

---

## 6. MBOM → SCAD Reference Compiler

Der Compiler übersetzt MBOM nach SCAD.

Er muss in TypeScript geschrieben sein.

Er muss in zwei Umgebungen funktionieren:

```text
1. Browser / React
2. Standalone / Node.js CLI
```

Daraus folgt: Der Core darf keine Node-only APIs verwenden.

### 6.1 Compiler Pipeline

```text
MBML Source
   ↓
XML Parser
   ↓
Namespace Resolver
   ↓
MBOM Builder
   ↓
Type Validator
   ↓
Expression Parser
   ↓
Semantic Validator
   ↓
SCAD Renderer
   ↓
SCAD File(s)
```

### 6.2 Packages

Der Compiler soll in getrennte Komponenten aufgeteilt werden.

```text
@machineblocks/mbom
@machineblocks/mbml
@machineblocks/scad-renderer
@machineblocks/compiler
@machineblocks/cli-tools
```

### 6.3 Core: @machineblocks/mbom

Enthält:

```text
MBOM Klassen
Type Registry
Metadata Model
Property Model
Aggregation Model
Composition Model
Association Model
Event Model
Expression AST
Validation APIs
```

Darf keine SCAD-spezifische Logik enthalten.

### 6.4 MBML: @machineblocks/mbml

Enthält:

```text
XML Parser
Namespace Resolver
Schema Loader
MBML → MBOM Mapper
MBML Diagnostics
```

Darf keine SCAD-Ausgabe erzeugen.

### 6.5 SCAD Renderer: @machineblocks/scad-renderer

Enthält:

```text
MBOM → SCAD Renderer
SCAD AST oder String Builder
Module Name Resolver
Import Resolver
Customizer Generator
Settings Renderer
Expression Renderer
Set View Renderer
```

Der SCAD Renderer ist ein Target Backend.

Spätere Backends könnten sein:

```text
3MF Renderer
STL Batch Renderer
Web Preview Renderer
Unity Renderer
CAD Exporter
```

### 6.6 Compiler Facade: @machineblocks/compiler

Kombiniert die Schritte:

```ts
compileMbmlToMbom(source)
compileMbomToScad(model)
compileMbmlToScad(source)
```

Diese API muss im Browser und in Node funktionieren.

### 6.7 CLI Tools: @machineblocks/cli-tools

CLI Tools sind Node-spezifisch.

Funktionen:

```text
mbc compile input.mbml --target scad
mbc compile-set set.mbml --out dist/
mbc validate input.mbml
mbc inspect input.mbml
```

Später:

```text
mbc watch ./blocks --target scad --out ./generated
```

Der Watch-Modus beobachtet einen Ordner und kompiliert geänderte MBML-Dateien automatisch nach SCAD.

---

## 7. React Integration

Der Compiler muss direkt in React-Anwendungen verwendbar sein.

Beispiel:

```ts
import { compileMbmlToScad } from "@machineblocks/compiler";

const result = compileMbmlToScad(xmlSource, {
  target: "scad",
  packageRoot: "martianmicro"
});

setScadSource(result.files[0].content);
```

Wichtig:

```text
kein fs
kein path
kein child_process
keine Node-only Dependencies im Core
```

Dateisystemzugriffe gehören ausschließlich in CLI Tools.

---

## 8. Standalone / CLI Integration

Die CLI nutzt dieselben Core-Pakete, ergänzt aber Dateisystem, Watcher und Ausgabeordner.

Beispiel:

```bash
mbc compile blocks/wall.mbml --target scad --out generated/
```

Watch-Modus:

```bash
mbc watch blocks/ --target scad --out generated/
```

Ziel:

```text
MBML speichern → SCAD wird automatisch aktualisiert
```

Das entspricht konzeptionell TypeScript Watch Mode.

---

## 9. Wichtige Architekturregel

MBML ist nicht SCAD mit XML-Syntax.

MBML beschreibt semantische MachineBlocks-Objekte.

MBOM ist nicht SCAD AST.

MBOM ist das typisierte Objektmodell.

SCAD ist nur ein Render Target.

```text
Wrong:
MBML → SCAD Syntax Tree

Correct:
MBML → MBOM → SCAD Target
```

---

## 10. Offene Punkte

### 10.1 Namespace-Konvention

Zu klären:

```text
mm.anyclosure
martianmicro.anyclosure
martianmicro.anyclosure.Wall
mm.anyclosure.Wall
```

Vorschlag:

```text
FQN im MBOM immer vollständig
Namespace Prefix in MBML frei mappbar
SCAD Package Mapping konfigurierbar
```

### 10.2 Schreibweise von Typen

Aktuell im Draft:

```xml
<baseType>mb.core/Block</baseType>
```

Vorschlag für MBOM-Nähe:

```xml
<baseType>mb.core.Block</baseType>
```

Slash kann für Pfade verwendet werden, Punkt für Typen.

### 10.3 Attribute Naming

XML-Attribute sollten kebab-case verwenden:

```xml
base-cutout-type="groove"
recess-wall-gaps="x+"
render-group="top"
```

MBOM verwendet camelCase:

```text
baseCutoutType
recessWallGaps
renderGroup
```

SCAD verwendet ebenfalls camelCase.

### 10.4 Expressions

Expressions müssen definiert werden:

```text
Syntax
Scope
Allowed operations
Allowed functions
Type checking
Error handling
```

Beispiel:

```xml
size="${[size[0], size[1], size[2] - 1]}"
```

wird zu einem typisierten Expression AST, nicht zu ungeprüftem JavaScript.

---

## 11. Zusammenfassung

MachineBlocks erhält mit MBML und MBOM eine klare modellgetriebene Architektur.

```text
MBML = Autorensprache
MBOM = typisiertes Objektmodell
SCAD = Reference Render Target
Compiler = deterministische Übersetzung
```

Die Architektur bleibt kompatibel mit dem bestehenden `mb_block()`-System, löst aber die semantische Beschreibung von OpenSCAD.

Damit wird MachineBlocks langfristig editorfähig, validierbar, renderziel-unabhängig und geeignet für komplexe Composite Blocks, Sets, Presets und spätere Device-Workflows.
