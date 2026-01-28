#import "@preview/hydra:0.6.2": hydra
#import "@preview/cetz:0.4.1"
#import "@preview/showybox:2.0.4": showybox
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/glossy:0.8.0": *
#import "@preview/oxifmt:1.0.0": strfmt
#import fletcher.shapes: house, hexagon
#set text(lang: "fr", size: 12pt)
#set par(justify: true)
// #set par.line(numbering: "1", numbering-scope: "page")

#show heading.where(level: 1, outlined: true): it => {
    pagebreak(weak: true)
    state("blank-page").update(true)
    pagebreak(to: "odd", weak: true)
    state("blank-page").update(false)
    it
}
#set page(footer: context {
    if not state("blank-page", false).get() {
      align(center, counter(page).display())
    }
 })

// Boxes
#let metabox(color: gray, header: "", title, content) = {
  showybox(
    title-style: (
      weight: 900,
      color: color.darken(40%),
      sep-thickness: 0pt,
      align: center
    ),
    frame: (
      title-color: color.lighten(80%),
      border-color: color.darken(40%),
      thickness: (left: 1pt),
      radius: 0pt
    ),
    title: [#header: #title]
  )[#content]
}

#let howto(title, content) = {
  metabox(color: green, header: "Tutoriel", title, content)
}

#let warning(title, content) = {
  metabox(color: yellow, header: "Attention", title, content)
}

#let aside(title, content) = {
  metabox(color: blue, header: "Aparté", title, content)
}

#set heading(numbering: "1.1", supplement: [])

#show heading: it => {
  set block(above: 1.5em, below: 0.8em)
  it
}

#let definition(t) = {
  text(style: "oblique")[#t]
}

// #show raw.where(block: true): set text(font: "FiraCode Nerd Font Mono")

#show raw.where(block: true, lang: "console"): set block(fill: luma(240), inset: 1em, radius: 0.5em, width: 100%)

#show raw.where(block: true, lang: "console"): code => {
  show raw.line: line => {
    "$"
    h(0.3em)
    line.body
  }
  code
}

#show figure: set block(breakable: true)

#show raw.where(block: true, lang: "output"): set block(fill: luma(240), inset: 1em, radius: 0.5em, width: 100%)

#let snippet_raw(content, lang:none) = {
  show raw: code => {
    show raw.line: line => {
      text(fill: gray)[#line.number]
      h(1em)
      line.body
    }
    code
  }
  box(
    stroke: 1pt + black,
    fill: luma(250),
    radius: 4pt,
    pad(
      left: 10pt,
      right: 16pt,
      top: 10pt,
      bottom: 10pt,
      raw(lang:lang, block: true, content)))
}

#let snippet(file, lang:none) = snippet_raw(read(file), lang:lang)

// Table style
#show table: set par(justify: false)
#set table(
  align: left + horizon,
  fill: (x, y) =>
    if x == 0 or y == 0 { rgb("#e5e5e5") })

// Page de garde
#page(margin: 2cm)[
  // Logos en haut - alignés et centrés
  #align(center)[
    #grid(
      columns: (auto, 3cm, auto),
      align: (center + horizon, center, center + horizon),
      image("imgs/Logo_OCamlPro_officiel_transparent (Bleu).png", height: 2cm, fit: "contain"),
      [],
      image("imgs/Logo carré bleu - fond transparent.png", height: 2cm, fit: "contain")
    )
  ]

  #v(3cm)

  // Ligne décorative
  #align(center)[
    #line(length: 60%, stroke: 3pt + rgb("#0066CC"))
  ]

  #v(1cm)

  // Titre au centre avec style moderne
  #set par(justify: false)
  #align(center)[
    #text(size: 26pt, weight: "bold", fill: rgb("#003366"))[Étude comparative de systèmes d'exploitations]

    #v(0.5cm)

    #text(size: 20pt, weight: "regular", fill: rgb("#0066CC"))[dans un contexte critique et temps-réel]
  ]
  #v(1cm)

  // Ligne décorative
  #align(center)[
    #line(length: 60%, stroke: 3pt + rgb("#0066CC"))
  ]

  #v(2cm)

  // Boîte d'informations avec style moderne
  #align(center)[
    #box(
      fill: rgb("#0066CC").lighten(95%),
      stroke: 2pt + rgb("#0066CC"),
      radius: 8pt,
      inset: 1.5em,
      width: 70%,
      [
        #grid(
          columns: (auto),
          row-gutter: 0.8em,
          align: center,
          [#text(size: 12pt, weight: "bold", fill: rgb("#003366"))[Version :] #text(size: 12pt, fill: rgb("#0066CC"))[git-3181113]],
          [],
          [#text(size: 12pt, weight: "bold", fill: rgb("#003366"))[Référence CNES :] #text(size: 12pt, fill: rgb("#0066CC"))[DLA-SF-0000000-211-QGP]],
          [#text(size: 11pt, fill: rgb("#003366"))[Édition 2 - Révision 0]],
          [],
          [#text(size: 11pt, style: "italic", fill: rgb("#003366"))[#datetime.today().display("[day]/[month]/[year]")]]
        )
      ]
    )
  ]

  #v(1fr)

  // Logo de licence en bas
  #align(center + bottom)[
    #image("imgs/by.png", width: 12%)
  ]
]


#set page(paper: "a4", margin: (y: 4em), numbering: "1", header: context {
  if calc.odd(here().page()) {
    align(right, emph(hydra(1)))
  } else {
    align(left, emph(hydra(2)))
  }
  line(length: 100%)
})

#pagebreak()
#outline(depth: 1)
#pagebreak()

#let dark-blue = rgb("#1a2f62")

#show link: set text(dark-blue)
#show ref: set text(dark-blue)

// Glossary
#let emph-term(term-body) = { emph(term-body) }

#let format-term(mode, short-form, long-form) = {
  if mode == "short" {
    short-form
  } else if mode == "long" {
    long-form
  } else {
    strfmt("{} ({})", short-form, long-form)
  }
}

#show: init-glossary.with(
  yaml("glossary.yaml"),
  term-links: true,
  show-term: emph-term,
  format-term: format-term,
)

// Figures

#let blob(pos, label, tint: white, width: 45mm, ..args) = node(
	pos, align(center)[#text(size: 11pt)[#label]],
	width: width,
	fill: gradient.radial(white, tint, center: (40%, 20%), radius: 150%),
	corner-radius: 3pt,
 	stroke: 1pt + tint.darken(20%),
	..args,
)

= Introduction <introduction>

L'usage de logiciels dans les systèmes critiques est de nos jours monnaie
courante. Ils se retrouvent dans des systèmes critiques de nombreuses
industries comme l'aéronautique, l'automobile et le nucléaire. Ainsi, la
sûreté des logiciels devient un enjeu crucial et en
particulier celle du système d'exploitation sur lequel tourne les logiciels
applicatifs. Le développement et la maintenance
d'un système d'exploitation étant complexe et coûteux, il est souhaitable
d'utiliser une solution informatique sur étagères #footnote[On parle
parfois de _COTS_ pour _Commercial off-the-shelf_.], c'est-à-dire dans le cas présent
un système d'exploitation ayant été conçu pour les systèmes critiques.

Ce document est une étude comparative de systèmes d'exploitation utilisés
dans un contexte critique ou temps réel. Nous étudions les systèmes suivants#footnote[
Nous nous sommes efforcés de fournir des informations valables pour les
versions spécifiées. Notez que les entreprises développant ProvenVisor et
XtratuM ne communiquent pas de numéros de version pour leurs systèmes
d'exploitation.]: Linux 6.15.2, MirageOS 4.9.0, PikeOS 5.1.3, ProvenVisor,
RTEMS 6.1, seL4 13.0.0, Xen 4.20 et XtratuM.

Les systèmes critiques sont exposés à deux types de menaces:
- #box[_Les défaillances_: elles ne sont pas dues à un agent extérieur. L'ensemble
des mesures prises pour y remédier relève de la @safety du système.]
- #box[_Les attaques_: elles sont causées par une entité malveillante. L'ensemble
des mesures prises pour les contrecarrer font parties de la @security du système.]

L'étude met d'abord l'accent sur l'aspect @safety. Toutefois certains des
systèmes étudiés sont dédiés à la @security et des concepts liés à la sécurité
seront donc abordés lorsque nous
les examinerons. De plus il existe une certaine porosité entre ces deux concepts
car des contremesures pour la sécurité s'avèrent pertinents aussi
du point de vue de la sureté et vice versa.

Avant de plonger plus avant dans les systèmes étudiés, il est important de
cerner davantage le sujet et notamment certaines notions de base dans les
sous-sections @kezako_os, @why_os et @criticity_real_time ci-dessous.

== Qu'est-ce qu'un système d'exploitation? <kezako_os>

La diversité des besoins et des systèmes informatiques existant a conduit à un
foisonnement de systèmes d'exploitation et en faire une zoologie complète serait
hors sujet. Il est en fait difficile de caractériser rigoureusement ce qu'est
un système d'exploitation et nous adoptons ici l'approche retenue dans
@tanenbaum2015modern @tanenbaum1997operating @silberschatz2013operating pour
définir ce concept. Nous appelons donc #definition[système d'exploitation]#footnote[En anglais
_Operating System_, souvent abrégé _OS_.] un ensemble de routines gérant
les ressources matérielles d'un système informatique et s'exécutant dans un mode
privilégié du processeur.

Le système en question peut être un serveur, un ordinateur personnel ou un
système embarqué. Le rôle principal du système d'exploitation est de fournir
une couche d'abstraction logicielle entre le
matériel et les logiciels applicatifs. Il permet ainsi de masquer la complexité
et la diversité des interfaces matérielles en fournissant des interfaces stables,
unifiées et parfois standardisées.

En pratique, la majorité des systèmes d'exploitation fournissent au moins trois
services:
- Un ordonnanceur de tâche qui décide quel programme doit être exécuté à un
  instant donné,
- Une gestion de la mémoire principale,
- Un protocole de communication entre les programmes en cours d'exécution.

== Pourquoi utiliser un système d'exploitation? <why_os>

Bien que l'usage des systèmes d'exploitation dans les composants critiques se
généralise, il n'est pas sans alternative. Une autre approche consiste à
exécuter l'application directement sur la couche matérielle. On parle alors de
programme @baremetal.

Néanmoins, l'adoption d'un système d'exploitation procure des avantages considérables,
principalement en facilitant la conception et la portabilité des applications.
Le tableau @compare_os_baremetal livre quelques éléments de comparaison entre
ces deux approches. Notez cependant que les bénéfices apportés par un OS varient
considérablement d'un système à l'autre. Comparer ces apports est l'un des
enjeux de cette étude.

#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    stroke: 1pt + black,
    align: left + horizon,
    [Caractéristique], [Système d'exploitation], [Environnement _bare metal_],

    [Portabilité],
    [Élevée, grâce à des interfaces logicielles et des pilotes.],
    [Faible.],

    [Débogage],
    [Facilité par de nombreux outils, parfois intégrés dans l'OS.],
    [Souvent plus complexe.],

    [Isolation en espace/temps],
    [Fourni par l'OS avec différents niveaux de garantie.],
    [Support absent.],

    [Multi-tâche],
    [Souvent supporté via le concept de processus/thread/partition.],
    [Nécessite un support du @rte.],

    [Latence],
    [Induite par l'exécution de routines et les basculement de contextes.],
    [Performance maximale offerte par le matériel.],

    [Certification],
    [Facilité dans le cas où l'OS a fait l'objet d'une certification. Dans le
    cas contraire la tâche peut-être plus complexe encore.],
    [À refaire de zéro. Toutefois le code a certifié peut être considérablement
    réduit par l'absence de l'OS.]
  ),
  caption: [Comparaison OS et _bare metal_.]
) <compare_os_baremetal>

== Criticité et temps réel <criticity_real_time>

Nous étudions les systèmes d'exploitation dans un contexte critique et temps réel.
Donnons une définition brève de ces deux qualificatifs.

Un système est dit #definition[critique] si sa défaillance peut
entraîner des conséquences indésirables. Ses défaillances varient considérablement
en nature et en gravité:
- #box[Elles peuvent se limiter à la simple perte de données, comme dans le cas
d'une base de données bancaire.]
- #box[Elles peuvent aller jusqu'à des destructions matérielles, comme celles
qui peuvent subvenir dans une centrale nucléaire ou une usine.]
- #box[Dans les cas les plus graves, elles peuvent engendrer des pertes humaines,
comme dans un accident d'avions ou dans la défaillance d'un système médical comme
un pacemaker.]
La criticité d'un système est généralement évalué lors de sa conception et le
choix d'une solution informatique adaptée en est une étape importante.

Un système informatique est qualifié de #definition[temps réel] s'il est capable
de piloter un système physique à une vitesse adaptée à l'évolution de ce dernier. Pour
parvenir à ce résultat, les logiciels qu'il embarque doivent être capable de
répondre à des stimuli dans un temps imparti. L'enjeu n'est donc par la performance
mais le respect d'échéances.

== Organisation de l'étude

L'étude est organisée de la façon suivante:
- #box[Un chapitre est dédié à chaque système d'exploitation. Ce chapitre comprend
une description succincte du système et une brève note historique. Puis une section
est dédiée à chacun des critères de comparaison énumérés en sous-secton @criteria.]
- #box[Une série de tableaux comparatifs qui résument les informations détaillés
dans les chapitres précédents et de comparer simplement les systèmes.]

== Critères de comparaison <criteria>

Au travers de cette étude, les systèmes d'exploitation ont été étudiés et
comparés suivant les critères suivants:
- Type de système d'exploitation
- Architectures supportées
- Support multi-processeur
- Isolation temporelle et spatiale
- Corruption mémoire
- Perte du flux d'exécution
- Écosystème
- Gestion des interruptions
- Support _watchdog_
- Programmation @baremetal
- Temps de démarrage
- Maintenabilité

Chaque critère est détaillé dans la sous-section ci-dessous. Il est à noter que
certains critères n'étaient pas pertinents pour l'ensemble des systèmes, auquel
cas la section correspondante pour ce système justifie son élision.

=== Type de systèmes d'exploitation
Nous classons les systèmes d'exploitation étudiés en quatre grandes catégories:
- #box[Les _systèmes d'exploitation généralistes_ @gpos constituent la
classe la plus connue du grand public. Ils sont le plus souvent
exécutés au-dessus de la couche matérielle et offrent un large éventail de
services. Leur domaine d'application est particulièrement vaste puisqu'on les
retrouve aussi bien sur les ordinateurs personnels, les smartphones que les
serveurs et les systèmes embarqués. Parmi les systèmes les plus connus, on
peut citer _Linux_, _FreeBSD_, _NetBSD_, _Windows_ et _macOS_.]
- #box[Les @hypervisor:pl sont des systèmes de virtualisation qui permettent
l'exécution de plusieurs systèmes exploitations sur une même machine. Dans
cette étude, nous n'examinerons que des @hypervisor:pl de type 1#footnote[On parle
également d'@hypervisor @baremetal.], c'est-à-dire des systèmes d'exploitation
dédiés à la virtualisation. Parmi les @hypervisor:pl les plus connus, on peut
citer _Xen_, _Oracle VM_, _Hyper-V_, _KVM_.]
- #box[Les _systèmes d'exploitation temps-réels_ (en anglais @rtos) sont des
systèmes dédiés au temps réel. Ils offrent de fortes garanties en matière de
déterminisme grâce à des ordonnanceurs de tâches et des protocoles de
synchronisation spécifiques.]
- #box[Les _bibliothèques d'OS_ (_LibOS_ pour _Library Operating System_)
ne sont pas à proprement parler des systèmes d'exploitation mais plutôt des
collections de bibliothèques permettant d'exécuter des logiciels sans avoir
recours à un @gpos. Le développeur lie les modules indispensables à son
programme, afin de produire une image appelée un _unikernel_. Celui-ci peut
ensuite être exécuté sur un @hypervisor ou en @baremetal.]

Cette nomenclature n'exclut pas qu'un système d'exploitation soit dans
plusieurs catégories simultanément. Nous verrons par exemple que de nombreux
@hypervisor:pl dédiés à l'embarqué critique proposent nativement des
fonctionnalités temps réel. De même beaucoup de @gpos intègrent un @hypervisor
de type 1.

=== Architectures supportées <criteria_architectures>
Pour chacun des systèmes d'exploitation étudiés, nous donnons une liste des
différentes architectures supportées. Afin que cet effort soit tenable,
nous avons sélectionné les architectures avec les critères suivants:
- #box[L'architecture doit être utilisée dans de véritables systèmes critiques,]
- #box[L'architecture doit être supportée nativement, c'est-à-dire que le
système d'exploitation doit pourvoir s'exécuter sur une telle architecture
sans avoir recours à un mécanisme d'émulation,]
- #box[Certains systèmes ont une longue histoire rendant une documentation
exhaustive en pratique très difficile. Nous nous bornons à un sous-ensemble
des architectures et renvoyons le lecteur à la documentation officielle pour les
architectures plus exotiques,]

Avec ces critères à l'esprit, nous avons retenu l'architectures
suivantes: `ARM`, `x86`, `PowerPC`, `MIPS`, `RISC-V` et `SPARC`. Notez que
ces dernières existent dans des versions 32 bits et 64 bits qui sont listées
dans @table_architectures ci-dessous.

#figure(
  table(
    columns: (1fr, 2fr, 2fr),
    stroke: 1pt + black,
    align: left + horizon,
    [Famille], [32 bits], [64 bits],

    [`ARM`],
    [`ARMv7-A`],
    [`ARMv8-A`],

    [`x86`],
    [`x86-32`],
    [`x86-64`],

    [`PowerPC`],
    [`PPC 32 bits`],
    [`PPC 64 bits`],

    [`MIPS`],
    [`MIPS32`],
    [`MIPS64`],

    [`RISC-V`],
    [`RV32`],
    [`RV64`],

    [`SPARC`],
    [`SPARC v8`],
    [`SPARC v9`]
  ),
  caption: [Architectures considérées dans l'étude.]
) <table_architectures>

#aside[][Le support d'une architecture donnée n'est en général pas suffisant pour
que le système puisse s'exécuter sur une carte de cette architecture. Cela signifie
en général que le programme peut être compilé vers le jeu d'instructions mais il
reste un effort important à fournir si l'OS ne fournit pas un @bsp pour la carte
considérée. Cet aspect n'est pas abordé en profondeur dans l'étude.]

=== Support multi-processeur

Au début du XXI#super[e] siècle, les architectures multi-processeurs se sont
imposées dans l'ensemble des secteurs de l'informatique. Jusqu'au milieu des
années 2000, la croissance exponentielle de la puissance de calcul était
principalement soutenue par l'augmentation rapide des fréquences d'horloges
des monoprocesseurs. Cette stratégie a cependant rencontré des limites physiques
(mur thermique, courants de fuite, ...). L'industrie des
microprocesseurs s'est alors tournée vers le parallélisme offert par
les architectures multi-processeurs pour maintenir la progression de la
puissance de calcul.

La diffusion de ces technologie dans les systèmes critiques a été freinée par
d'importants défis @saidi2015shift. En effet, les architectures multi-processeur
introduisent de nombreuses sources de non-déterminisme (interférences
temporelles, prédiction de branche, ...). In fine, ce non-déterminisme rend
les analyses statiques plus complexes et donc la certification de
tels systèmes plus difficiles. Ces difficultés sont majorées dans les systèmes
critiques mixtes @burns2017survey.

Toutefois leur usage dans les systèmes critiques est désormais généralisé,
principalement motivé par la nécessité d'accroître la puissance de calcul tout
en permettant une meilleure intégration et une réduction de poids et de taille
des systèmes embarqués, notamment dans les secteur de l'avionique et du spatial.

Il existe deux catégories d'architectures multiprocesseur utilisées dans les
systèmes critiques:
- #box[Les architectures @smp sont constituées le plus souvent d'un ensemble
de cœurs homogènes. Les cœurs partagent la mémoire principale et la majorité
des caches et des bus mémoires. Elles offrent d'excellentes
performances, à condition que le système d'exploitation sache en tirer parti.
En contrepartie, leur programmation est plus complexe. Par exemple le masquage
des interruptions seul ne suffit pas à garantir l'isolation de sections critiques
du noyau. En effet, plusieurs cœurs peuvent exécuter en parallèle ces sections, ce qui
multiplie les occasions de courses critiques. Il faut alors avoir recours à des
mécanisme de synchronisation tels que les @spinlock:pl et les verrous atomiques.
Ces architectures sont répandues aussi bien sur les serveurs que les ordinateurs personnels
mais sont aussi en usage dans des systèmes critiques récents.]
- #box[Les architectures @amp sont constituées le plus souvent d'un
ensemble de cœurs hétérogènes. Ces cœurs ne partagent pas leurs caches ou leur
bus mémoire. Ces architectures sont conçues pour exécuter des instances distinctes de
programmes @baremetal sur chaque cœur. Cette isolation des cœurs offre un
très bon déterminisme du système et une meilleure isolation des tâches. En
contrepartie, les mécanismes de communication interprocesseur sont à la charge
du développeur. Ces architectures sont depuis longtemps présentes dans
l'embarqué critique, notamment sous la forme de @mpsoc.]

Le @smp_vs_amp récapitule les différences entre ces deux architectures
multiprocesseur.

#let diagonal(body1, body2, width: auto, height: auto, inset: 5pt) = {
  table.cell(inset: 0pt,
    box(
    width: width,
    height: height)[
      #place(top+right,body1, dx: -inset, dy: inset)
      #place(bottom+left,body2, dx: inset, dy: -inset)
      #line(start: (0%,0%),end: (100%,100%),stroke: 0.5pt)
  ])
}

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    [#diagonal([Architecture],[Caractéristique], width: 6cm, height:1cm)], [_SMP_], [_AMP_],

    [Nature des cœurs],
    [Le plus souvent homogènes],
    [Le plus souvent hétérogènes],

    [Gestion logicielle],
    [Un unique système d'exploitation gère tous les cœurs et partage dynamique
      les tâches entre eux],
    [Instance indépendante exécutée sur chaque cœur],

    [Partage de Ressources],
    [Mémoire principale, périphériques et caches partagés],
    [Ressources partitionnées entre les cœurs],

    [Objectif & Performance],
    [Excellent débit],
    [
      - Déterminisme accru
      - Meilleure isolation des tâches
    ],

    [Domaines d'application],
    [
      - Ordinateurs personnels
      - Serveurs
    ],
    [Systèmes embarqués critiques],

    [Prix],
    [Très bon marché],
    [Élevé]
  ),
  caption: [Différences entre les architectures _SMP_ et _AMP_.],
) <smp_vs_amp>

=== Isolation <criteria_isolation>

Les systèmes d'exploitation modernes permettent l'exécution de plusieurs
tâches simultanément sur une même machine. Les ressources matérielles étant
limitées, ces systèmes doivent partager ces ressources de façon sûre et
sécurisée entre les tâches en cours d'exécution.

Pour chaque système étudié, nous examinons d'une part l'isolation de la mémoire
principale et d'autre part du temps _CPU_. Pour la mémoire principale, nous
parlerons d'_isolation spatiale_ et pour le temps _CPU_ d'_isolation
temporelle_.

Notez que le terme _tâche_ doit être compris ici dans un sens large car
le vocabulaire varie d'un système à l'autre. Par exemple, les @gpos comme
_Linux_ proposent généralement des abstractions tels que les _processus_ ou les
_threads_, tandis qu'un hyperviseur comme _Xen_ parlera de _domaine_.

Nous ferons également la distinction entre deux types de mécanisme d'isolation:
- Un mécanisme d'isolation _statique_ assure la non interférence des tâches via
  des _partitions_ créées à la configuration du système. Ce type de mécanisme
  est déterministe et offre les garanties requises par bon nombre de
  certifications pour les systèmes critiques. En contrepartie, la quantité
  de ressource disponible pour une tâche ne s'adapte pas à ses besoins durant
  l'exécution.
- Un mécanisme d'isolation _dynamique_ assure qu'une interférence entre deux
  tâches sera remontée au noyau lors de l'exécution. Contrairement aux
  mécanismes statiques, la quantité de ressource allouée par tâche peut
  varier dans le temps (allocation dynamique de mémoire, politique
  d'ordonnancement, ...). En contrepartie, un tel mécanisme est plus difficile
  à certifier.

Il est tout à fait possible de combiner des mécanismes d'isolation statique
avec des mécanismes d'isolation dynamique. Par exemple, un système invité dans
une partition d'un hyperviseur peut gérer ses ressources dynamiquement alors
que l'hyperviseur adopte une approche statique pour isoler ses partitions.

==== Isolation spatiale <spatial_isolation>

Un mécanisme d'isolation spatiale vise à prévenir les deux scénarios suivants:
- Un bogue dans un programme peut conduire à une corruption des données en
  mémoire. On souhaite que cette corruption soit circonscrite à l'état mémoire
  du programme bogué.
- Un attaquant malveillant peut chercher à lire ou modifier les données
  d'une tâche à partir d'une autre tâche dont il a pris le contrôle.

Autrefois l'isolation spatiale était entièrement assurée par une couche
logicielle dans le noyau. De nos jours, cette isolation est le plus souvent
assurer par une combinaison de matériel et de logiciel.
Dans cette étude, nous examinons deux mécanismes d'isolation spatiale:
- Certains systèmes informatiques sont équipés de puces matérielles facilitant
  l'isolation spatiale. Dans cette catégorie, les microcontrôleurs les plus
  répandus sont les @mmu et @mpu. Le @mmu permet l'utilisation d'un espace
  d'adressage virtuel au-dessus de la mémoire physique. Lors de l'exécution
  d'une instruction par le _CPU_, les adresses virtuelles sont traduites à la
  volée en adresses physiques. Le @mmu vérifie également les accès suivant une
  politique programmable. Ainsi chaque tâche a l'illusion de disposer de sa
  propre mémoire principale et les accès interdits sont remontés au système
  d'exploitation via des interruptions matérielles. Le @mpu se cantonne à
  la vérification des accès mémoires sans l'utilisation d'adresses virtuelles.
- Certains hyperviseurs permettent la configuration de partitions statiques
  de la mémoire. Lors de la conception du système, on alloue une plage
  mémoire fixe pour chaque partition. Il est alors possible de configurer
  un @mmu ou un @mpu pour interdire tout accès en dehors de cette plage pour
  les tâches s'exécutant dans cette partition.

Dans le monde de l'embarqué critique, il est fréquent de rencontrer des systèmes
sans @mmu (_MMU-less systems_). Ce choix est principalement motivé par le fait
qu'un @mmu introduit une source importante d'indéterminisme
dans les systèmes multi-cœur du fait de caches matériels comme le _TLB_
(_Translation Lookaside Buffer_) @paun2013determinism.

Pour chaque système, nous examinerons le support pour les architectures
@mmu et _MMU-less_ et la possibilité de configurer des partitions
mémoire.

==== Isolation temporelle <time_isolation>

Un mécanisme d'isolation temporelle vise à prévenir qu'une tâche ne dégrade
la qualité de services des autres tâches en s'octroyant une part trop importante
du temps _CPU_.

Il existe une multitude de qualités pour décrire les mécanismes d'isolation
temporelle. Nous retenons les qualités suivantes:
- _Throughput_: quantité de travail accomplie par unité de
  temps,
- _Latency_: délai qui s'écoule entre le réveil d'une tâche
  et son exécution sur un cœur,
- _Fairness_: équité quant au temps de calcul en tenant compte
  des priorités des tâches,
- _Déterminisme_: capacité à prédire l'ordre d'exécution des tâches et les
  tranches de temps allouées.

Dans cette étude, nous examinons les mécanismes d'isolation temporelle suivants:
- Les systèmes d'exploitation disposent généralement de politiques
  d'ordonnancement. Ces politiques sont appliquées par un ordonnanceur de
  tâches (_scheduler_) qui détermine la prochaine tâche à exécuter suivant cette
  politique. L'ordonnancement peut être dynamique, c'est-à-dire qu'il s'adapte
  au besoin des tâches au cours du temps ou statique. Les politiques
  d'ordonnancement poursuivent des objectifs variés et parfois incompatibles.
  En général, la politique d'ordonnancement d'un @gpos cherchera à maximiser le
  _throughput_ tout en restant équitable. Tandis que dans un @rtos, elle
  cherchera à être aussi déterministe que possible et à minimiser la latence,
  même si cela réduit parfois le _throughput_.
- Certains hyperviseurs permettent la configuration de partitions statiques
  du temps _CPU_. Lors de la conception du système, on définit des tranches
  de temps pour chaque partition. À l'exécution un ordonnanceur cyclique
  garantit que chaque partition dispose de sa tranche de temps dans un ordre
  prédéterminé. La préemption est assurée par une horloge matérielle.

Étant donné le sujet de cette étude, nous nous concentrons sur le déterminisme
de ces systèmes d'isolation temporelle. Ainsi, pour chaque système, on
examinera la présence de politiques d'ordonnancement temps réel et les mesures
implémentées pour en garantir le déterminisme.

Pour les hyperviseurs destinés aux systèmes critiques, on examinera aussi la
possibilité de configurer des partitions temporelles statiques.

#aside[déterminisme][
Afin d'offrir ces garanties temps réel, le système d'exploitation doit être
aussi déterministe que possible. Ce déterminisme permet en pratique d'estimer
le temps d'exécution de ses routines dans le pire cas#footnote[Ce concept est
souvent appelé _WCET_ (_Worst Case Execution Time_) dans la littérature.]. Le
déterminisme est souvent assuré par le caractère préemptible du
noyau#footnote[Nous verrons toutefois avec l'exemple de _seL4_ que ce n'est
pas toujours la bonne approche pour obtenir le déterminisme.] et des
éventuelles autres tâches. En effet, lorsqu'une tâche critique doit commencer
son exécution aussi vite que possible, il ne faut pas que celle-ci doive
attendre la fin de l'exécution d'une longue routine du noyau ou la fin de la
tranche de temps d'une tâche de plus faible priorité. La latence du système
d'exploitation est donc une mesure importante pour assurer le respect des
échéances.
]

== Corruption mémoire <memory_corruption_criteria>

Nous avons étudié le support logiciel des différents systèmes visant à prévenir
la corruption mémoire. On distingue deux types d'erreurs:
- #box[Les @soft_error:pl sont dues à un événement exceptionnel et transitoire qui
corrompt des données. Par exemple le rayonnement de fond peut produire un basculement
de bits (_bit flips_). Ces erreurs peuvent être souvent corrigées à condition
de mettre en places des mesures préventives.]
- #box[Les @hard_error:pl sont dues à un dysfonctionnement matériel au niveau de la
puce mémoire. Ces erreurs ne peuvent pas être corrigées et nécessitent un remplaçant
de la puce ou, à défaut, une isolation de celle-ci.]

Dans cette étude nous nous sommes limités à la mémoire principale et plus
précisément aux mémoires @dram équipées de
puces supplémentaire pour gérer des codes correcteurs. On parle de mémoire @ecc.

#aside[support matériel de l'@ecc][
  Les mémoires @ecc nécessitent un support spécifique par le contrôleur mémoire,
  le _CPU_ et le _BIOS_. Si ce support est rare sur le matériel grand public,
  il est en revanche commun dans celui destiné aux serveurs.
]

== Perte du flux d'exécution <flow_hijacking_criteria>

La perte du flux d'exécution (_control flow hijacking_) est une vulnérabilité
majeure dans les systèmes d'exploitation, où un attaquant modifie le flux
d'exécution normal d'un programme pour exécuter du code malveillant. Cette
attaque exploite généralement des dépassements de tampon ou d'autres corruptions
mémoire pour modifier les adresses de retour ou les pointeurs de fonction.

Les techniques d'attaques sont nombreuses et plusieurs contremesures peuvent
être mises en place pour atténuer le risque, notamment:
- #box[
  Des mécanismes de _Control-Flow Integrity_ (_CFI_) @cfi_survey_embedded. Les
  _CFI_ visent à garantir que le flux d'exécution d'un programme suit uniquement
  les chemins d'exécution légitimes définis par le graphe de flot de contrôle
  du programme. Dans les systèmes embarqués et temps-réel, l'application du
  _CFI_ présente des défis particuliers liés aux contraintes de ressources
  (taille, poids, puissance, coût) et aux exigences temporelles strictes. Les
  mécanismes de _CFI_ doivent minimiser leur surcoût en temps d'exécution tout
  en offrant des garanties de sécurité robustes.]
- #box[La randomisation de l'espace d'adressage (_Adress Space Layout
  Randomization_ (_ASLR_)). Elle consiste à introduire de l'aléa dans les
  adresses des segments code afin de rendre difficile leur localisation
  par un attaquant. _ASLR_ offre une excellente protection sur les plateforme
  64 bits.]
- #box[Les _canaris_ de pile. Il s'agit d'une protection ajouté à la
  compilation du programme et prévient les attaques par écrasement de piles
  en insérant des valeurs aléatoires. Si un attaquant tente de modifier la
  pile pour modifier une adresse de retour, il écrase un canari et l'attaque
  peut ainsi être détectée.]
- #box[L'utilisation de méthodes comme le _bound checking_ pour prévenir
  les dépassements de tampon.]
- #box[Des analyses statiques ou dynamiques pour détecter la présence
  de vulnérabilités induites par des erreurs de programmation. Certaines de ces
  analyses peuvent être intégrées directement dans le langage de programmation,
  par exemple sous la forme d'un _typechecker_. D'autres utilisent des outils
  externes, voire des assistants à la démonstration.]

Nous avons donc examiné la présence de telles contremesures pour chacun des
systèmes étudiés.

== Écosystème <ecosystem_criteria>

Pour chacun des systèmes d'exploitation étudiés, nous avons effectué une revue
des outils de son écosystème utiles durant le cycle de vie des applications.
Plus précisément, notre analyse s'est concentrée sur l'offre logicielle suivant
trois aspects: le _monitoring_, le _profilage_ et le _débogage_.

Le _monitoring_ vise à surveiller l'activité d'un système informatique. Les
outils de _monitoring_ permettent le plus souvent la journalisation
d'événements. Ces outils étant utilisés en production, il est
important qu'ils ne grèvent pas la performance ou compromettent la sûreté ou
la sécurité du système.

Le _profilage_ est un ensemble de techniques utilisées pour mesurer et
analyser les performances d'un programme. Il est le plus souvent employée
durant la phase de développement à des fins d'optimisation en permettant de
localiser des points chauds. Toute mesure ayant un impact sur l'objet mesuré,
il est crucial que cette instrumentation soit faite de la façon la moins
intrusive possible.

Le _débogage_ est un ensemble de techniques permettant d'analyser un bogue
pour en comprendre l'origine. La technique la plus répandue consiste, via un
débogueur, à exécuter le programme pas à pas et explorer l'état de la mémoire,
des registres et la piles d'exécution.

== Gestion des interruptions <interrupt_managing_criteria>

Une _interruption_ est un événement matériel qui altère le flot d'exécution
normal d'un programme. Au niveau matériel, elle se manifeste par
un signal électrique émit par un périphérique ou le processeur lui-même et à
destination du processeur. Lorsque le processeur reçoit l'interruption,
l'exécution courante est suspendue et le contexte est sauvegardé puis une
routine du noyau appelée @isr est lancée pour gérer l'interruption.

La programmation en présence d'interruptions est rendue difficile par leur
nature asynchrone. En effet, rien n'interdit qu'une interruption soit levée
pendant l'exécution de l'@isr d'une autre interruption. C'est même le scénario
le plus courant. La présence d'interruptions asynchrones induit
deux grandes difficultés:
- #box[La correction du noyau repose sur la préservation d'invariants pour
ses structures de données. Ainsi, certaines sections de code sont critiques car
elles ne peuvent être interrompues sans briser ces invariants,]
- #box[La possibilité d'avoir une cascade d'interruption rend difficile
l'estimation du temps d'exécution en @kernelspace. Elle peut même être non
bornée dans les pires cas. Cette latence doit être contrôlée pour garantir
des bonnes performances et le déterminisme du système.]

Une solution consiste à masquer les interruptions lors de l'exécution de
sections critiques. À cette fin, les architectures matérielles modernes sont
équipées de microcontrôleurs dédiés à la programmation des interruptions.
Ainsi les architectures _x86_ sont munies de puce _I/O APIC_
(_Input/Output Advanced Programmable Interrupt Controller_) pour gérer les
interruptions provenant des périphériques. Pour les architectures multi-cœur,
chaque cœur est muni d'un _Local APIC_ pour gérer les interruptions entre cœurs.
De même, les architectures _ARM_ diposent d'un système dévolue à la
programmation des interruptions appelé _GIC_ (_Generic Interrupt Controller_).
Des contrôleurs similaires existent pour les autres architectures considérées
dans la sous-section @criteria_architectures. Pour simplifier, nous désignons
ces puces sous l'appellation @pic.

Dans tous les cas, un périphérique ou un cœur qui souhaite envoyer une
interruption matérielle commence par envoyer une @irq à un microcontrôleur
@pic. Ce dernier décide ou non d'envoyer une interruption au cœur concerné.
Cette décision est programmable, le plus souvent sous la forme d'un vecteur
stocké dans un registre du _PIC_ et accessible par une adresse physique ou
virtuelle.

Si masquer les interruptions résout drastiquement la première difficulté,
elle doit être fait avec une granularité suffisante pour ne pas grever les
performances de l'OS et en particulier la latence. De plus, la désactivation
des interruptions rend les sections concernées non-préemptibles puisque la
préemption est souvent gérée par une interruption matérielle levée par
une horloge. Masquer les interruptions longtemps n'est donc pas non plus
souhaitable dans un scénario temps réel.

Dans le cas d'un hyperviseur, le travail est double puisqu'il doit à la fois
gérer les interruptions pour lui-même mais également proposer une interface
pour que ses systèmes invités fassent de même de façon contrôlée. Pour atteindre
ce but, l'hyperviseur peut adopter trois approches:
- Virtualiser totalement les contrôleurs _PIC_, c'est-à-dire capturer les
  requêtes du systèmes invités en insérant des interruptions dans
  son flot d'exécution puis en émulant ces requêtes lorsqu'elles sont
  autorisées,
- Paravirtualiser les contrôleurs _PIC_, c'est-à-dire exposer une @api aussi
  proche du matériel que possible pour que le système invité puisse implémenter
  un pilote pour celle-ci,
- Utiliser un support matériel pour la virtualisation des interruptions.
  Les architectures _x86_ et _ARM_ modernes disposent d'un support matériel
  pour la virtualisation de leurs microcontrôleurs _PIC_ (_VGIC_ pour _ARM_,
  _Intel APICv_ pour _Intel x86_ et _AMD AVIC_ pour _AMD x86_).

Pour chacun des systèmes étudiés, nous avons examinés les mécanismes de
virtualisation et de masquage des interruptions matérielles.

== _Watchdog_ <criteria_watchdog>

Un _watchdog_ est un dispositif matériel ou logiciel conçu
pour détecter le blocage d'un système informatique, et de réagir
de manière autonome pour ramener ce système dans un état normal. Qu'il s'agisse
d'un dispositif matériel ou logiciel, le principe du watchdog consiste le plus
souvent à demander au système surveillé d'envoyer régulièrement un signal à
un système surveillant. Le système surveillé dispose d'une fenêtre temporelle
pour cette action. S'il n'effectue pas la tâche dans le temps imparti, il est
présumé dysfonctionnel. Le système surveillant peut alors tenter de remédier
à la situation. Le plus souvent cela consiste à redémarrer la machine.

Les appareils embarqués et les serveurs à haute disponibilité ont souvent
recours aux _watchdogs_ pour améliorer leur fiabilité. Pour chacun des systèmes
nous avons étudiés le support des _watchdog_ logiciels et matériels et avons
fourni un exemple d'utilisation de l'@api lorsque cela était possible.

== Programmation @baremetal <criteria_baremetal_programming>

La programmation @baremetal demeure commune dans les systèmes critiques.
Cependant, l'adoption d'un @cots pour le système d'exploitation offre beaucoup
d'avantages. Il est donc fréquent de vouloir porter une application @baremetal
vers un hyperviseur.

C'est dans cette optique que nous avons examiné les solutions proposées en
matière de programmation @baremetal pour les différents hyperviseurs étudiés.
Notre analyse se borne aux langages de programmation _Ada_, _C_, _OCaml_ et
_Rust_. Le principal défi d'un tel portage est d'adapter un @rte de ces
langages pour l'hyperviseur donné.

Dans le cas de _Ada_, _C_ et _Rust_ se portage est grandement facilité par la
la taille du @rte de ces langages et de se passer de la majorité de la
bibliothèque standard ou encore de la remplacer par une bibliothèque dédiée au
@baremetal.

Pour le langage _OCaml_, la difficulté est plus importante car son @rte
contient un @gc, ce qui implique de devoir porter un plus grand nombre d'appels
systèmes.

== Temps de démarrage

Pour les hyperviseurs, le temps de démarrage des @vm est une métrique importante
de leur performance. En cas de défaillance d'une @vm, on espère
que celle-ci soit relancée aussi rapidement que possible. Un autre usage
courant, notamment dans le cloud computing, est de lancer des @vm à la demande
pour s'adapter au mieux aux variations de la charge de travail. Ces @vm doivent
se lancer rapidement pour garantir des temps de réponse acceptables.

== Maintenabilité <criteria_maintainability>

La _maintenabilité_ d'une solution informatique est un facteur essentiel à
analyser afin de faire un choix éclairé. Si l'usage d'un @cots offre des
avantages indéniables durant la phase développement, il introduit une dépendance
technologique significative sur le long terme. La maintenance du @cots peut
cesser ou ses conditions d'utilisation peuvent changées, entrainant une
transition vers une solution alternative, souvent coûteuses et complexes.

Nous avons comparé la maintenabilité des différents systèmes avec les critères
suivants:
- _Licence_: une licence libre ou _Open Source_ présente l'avantage
  d'un accès facile au code source. Même si le @cots n'est plus maintenu, il est
  toujours possible de le faire évoluer et d'appliquer des correctifs,
- _Taille de l'écosystème_: un grand écosystème facilite le développement et
  assure que d'autres utilisateurs contribuent à son maintien,
- _Taille du code source_: la taille du code source n'est pas toujours gage de
  complexité mais cela reste un indice important,
- _Certification_: les certifications de systèmes critiques exigent une
  certaine qualité logicielle. La possibilité de certifier un produit utilisant
  le @cots est donc un gage de qualité de ce dernier.
- _Ancienneté_: un @cots ancien est souvent plus mature mais il embarque aussi
   davantage de dette technique,
- _Support commercial_: la présence d'un support commercial assure de recevoir
  une aide, au moins sur le moyen terme.

= Linux <linux>

#showybox(
  title: "Linux en bref",
  frame: (
    border-color: blue.darken(20%),
    title-color: blue.lighten(80%),
    body-color: blue.lighten(95%)
  )
)[
  - *Type* : GPOS, noyau modulaire + Hyperviseur (KVM) + RTOS (PREEMPT_RT)
  - *Langage* : C (98%)
  - *Architectures* : 30+ architectures (x86, ARM, RISC-V, PowerPC, MIPS, SPARC, ...)
  - *Usage principal* : Serveurs, embarqué, supercalculateurs, desktop
  - *Points forts* : Maturité, large écosystème, flexibilité, support matériel étendu, documentation précise
  - *Limitations* : Complexité élevée, surface d'attaque importante, déterminisme limité (sans PREEMPT_RT)
  - *Licences* : GPL v2 + exception _syscall_
]

Le noyau _Linux_ est un @gpos libre de type _UNIX_. Son développement
débute en 1991 sous la forme d'un projet personnel de Linus Torvalds, alors
étudiant en informatique à l'université
d'Helsinki en Finlande. Linus entreprit d'écrire un noyau après avoir
constaté qu'il n'existait pas de système _UNIX_ bon marché capable d'exploiter
pleinement les capacités de son nouveau processeur 32 bits _Intel 80386_.
Le projet prend alors rapidement de l'ampleur, notamment après l'adoption en
1992 de la licence _GPLv2_ pour distribuer le code source. Ce changement
de licence a permis au noyau d'utiliser les outils du projet @gnu afin de
fournir un système d'exploitation complet. La première version majeure `1.0`
est publiée en 1994 avec un support pour l'interface graphique via le projet
_XFree86_. Les distributions _GNU/Linux_ _Red Hat_ et _SUSE_ publient
leur première version majeure la même année. À partir de 1995 avec la
version `1.1.85`, le noyau passe d'une architecture @monolithic à une approche
modulaire, permettant le chargement à chaud de modules. La version `2.0` publiée
en 1996 propose un support pour les architecture @smp. En 2007, la version
`2.6.20` intègre un hyperviseur baptisé _KVM_. En 2024, la totalité des
patchs du projet _PREEMPT_RT_ sont intégrés dans le noyau, faisant de _Linux_
un _RTOS_.

De nos jours le noyau _Linux_ est développé par une communauté décentralisée de
développeurs. De très nombreuses entreprises contribuent au noyau, notamment aux
pilotes (_Intel_, _Google_, _Samsung_, _AMD_, ...).

== Tutoriel <linux_tutorial>

Certaines des fonctionnalités présentées dans ce chapitre ne font pas
parties des noyaux distribués par défaut par les distributions _GNU/Linux_
grand public. Le noyau _Linux_ est configuration à la compilation à travers
de très nombreuses options. Malheureusement, il ne semble pas exister
une méthode standard pour connaître la configuration du noyau en cours
d'exécution. Certaines distributions le permettent via la commande:
```console
zgrep OPTION /proc/config.gz
```
où `OPTION` désigne une option de compilation du noyau.
Tandis que d'autres placent un tel fichier dans la partition de démarrage:
```console
grep OPTION /boot/config-$(uname -r)
```
Nous laissons le soin au lecteur de se reporter à la documentation de sa
distribution si les commandes ci-dessus ne fonctionnent pas.

== Architectures supportées <linux_architectures>

À l'origine, le noyau _Linux_ était uniquement développé pour
l'architecture _x86-32_. Il a depuis été porté sur de très nombreuses autres
architectures @linux_arch. Il fonctionne notamment sur les architectures
suivantes: _x86-32_, _x86-64_, _ARM v7_, _ARM v8_, _PowerPC_, _MIPS_, _RISC-V_
et _SPARC_.

Quant à l'hyperviseur _KVM_, il supporte la virtualisation assistée par
le matériel sur certaines architectures. Sur architecture _x86_, il supporte
les extensions de virtualisation _Intel VT-x_ et _AMD-V_. Sur architecture
_ARM_, il supporte l'extension de virtualisation de _ARM v7_ à partir
de _Cortex-A15_ et de _ARMv8-A_. Enfin il supporte certaines architectures
_PowerPC_ comme _BookE_ et _Book3S_.

== Support multi-processeur <linux_multiprocessor>

Cette section aborde le support d'architectures multi-processeur sous _Linux_.

=== Architectures @smp <linux_smp>

Le support pour les architectures @smp est ajoutée dans _Linux 2.0_ en 1996.
Toutefois les premières versions du noyau supportant les architectures @smp avaient
recours à un verrou global appelé @bkl. Ce dernier assurait que
les sections critiques du noyau ne pouvaient pas s'exécuter en parallèle.
Cette technique avait l'avantage d'être simple à mettre en place mais
conduisait à des performances médiocres, notamment lorsque le système avait
de nombreux cœurs. Le _BKL_ a été progressivement remplacé par des mécanismes
de synchronisation plus fins comme les _spin locks_ et les _mutexes_, puis
totalement supprimé à partir de la version _2.6.39_. Le noyau propose aussi
depuis la version 2.5 des structures de données synchronisées de type _RCU_
(_Read-Copy-Update_) @linux_what_is_rcu qui permettent la lecture et l'écriture
simultanée sans mécanisme de verrouillage pour les lecteurs. Ces structures
sont donc particulièrement pertinentes lorsque la majorité des accès sont
en lecture. Quant à l'ordonnanceur de tâche, il est conçu pour répartir aussi
équitablement que possible le temps _CPU_ entre les processus avec une faible
latence.

Pour vérifier que votre noyau a été compilé avec ce support, il faut vérifier
la présence de l'option `CONFIG_SMP`.

#aside[`CONFIG_SMP` obligatoire][
  Le support @smp ne sera plus optionnel à partir de _Linux 6.17_ pour la
  majorité des architectures @linux_unconditional_smp. Les monoprocesseurs sont
  de plus en plus rares et les primitives introduites pour le support @smp
  n'engendrent qu'un surcoût mineur. Cette décision permettra de simplifier le
  code source du noyau.
]

=== Architectures @amp <linux_amp>

Depuis la branche `3.x`, le noyau _Linux_ offre un support pour les processeurs
distants via les sous-systèmes `remoteproc` @linux_remoteproc et `RPMsg`
@linux_rpmsg. Vous pouvez vérifier que votre noyau est compilé avec le support
pour ces systèmes avec les options respectivement `CONFIG_REMOTEPROC` et
`CONFIG_RPMSG`.

Le cas d'usage typique est l'exécution d'un _RTOS_ sur un processeur secondaire
dans un système embarqué hétérogène sous la forme d'un @mpsoc. Avant l'apparition
de `remoteproc`, le contrôle des processeurs secondaires se faisait via des @api
propriétaires et non standardisées. Quant au système _RPMsg_
(_Remote Processor Messaging_), il permet la intercommunication avec un
processeur distant via un protocole asynchrone à la _virtio_.

== Isolation <linux_isolation>

Dans cette section, nous décrivons les principaux mécanismes d'isolation de
partitionnement des ressources disponibles sous _Linux_. Ces mécanismes sont
aujourd'hui utilisés aussi bien pour la virtualisation via _KVM_ que pour les
conteneurs des logiciels tels que _systemd_, _Docker_ ou _Kubernetes_.

=== Isolation spatiale <linux_isolation_space>

À l'origine _Linux_ était conçu uniquement pour s'exécuter en présence d'un
@mmu. Le projet _μCLinux_ @linux_uclinux était une branche modifiée du noyau
_Linux_ visant à supporter des architectures sans @mmu. Ce support a finalement
été ajouté à la branche officielle du noyau. L'option de compilation
`CONFIG_NOMMU` permet d'activer le support sans @mmu de _Linux_.

=== Isolation temporelle <linux_isolation_time>

==== Politiques d'ordonnancement

_Linux_ utilise un système sophistiqué pour décider quelle tâche doit
s'exécuter sur le _CPU_ lorsque le noyau retourne dans l'@userspace. Ce
mécanisme repose sur une hiérarchie de politiques d'ordonnancement et de
priorités.

Chaque tâche se voit attribuer une politique d'ordonnancement et une priorité
statique allant de 0 à 99. Les _threads_ d'un même processus possèdent la même
priorité au lancement d'un processus. La politique et la priorité d'une tâche
peuvent être changée via une @api ou une ligne de commande _POSIX_.

À l'heure actuelle _Linux_ implémente six politiques d'ordonnancement, trois
temps réel _SCHED_FIFO_, _SCHED_RR_, _SCHED_DEADLINE_ et trois normales
_SCHED_OTHER_, _SCHED_BATCH_ et _SCHED_IDLE_. Les trois politiques
_SCHED_OTHER_, _SCHED_FIFO_ et _SCHED_RR_ font en fait
partie de la norme _POSIX_ et _Linux_ expose également une @api C _POSIX_
pour contrôler les politiques d'ordonnancement. Par défaut, les processus
utilisent la politique _SCHED_OTHER_. Une description détaillée de ces
politiques est disponible dans la page de manuel `sched` accessible avec la
commande:
```console
man sched
```

Le noyau décide qu'elle tâche doit s'exécuter en suivant les trois règles
suivantes:
- #box[S'il y a une tâche prête dont la priorité statique est la plus élevée de
toutes les tâches en attente, elle s'exécutera toujours en premier.]
- #box[S'il y a plusieurs tâches prêtes de priorité maximale, celle dont la
politique est la plus prioritaire est exécutée en premier. L'ordre de priorité
entre les politiques est par ordre décroissant: _SCHED_FIFO_, _SCHED_RR_,
_SCHED_OTHER_, _SCHED_BATCH_ et _SCHED_IDLE_.]
- #box[S'il y a plusieurs tâches prêtes de priorité maximale et de même
politique, le comportement dépend de la politique en question comme détaillé
ci-dessous.
- #box[_SCHED_DEADLINE_.]
- #box[_SCHED_FIFO_ (_First In First Out_) est une politique d'ordonnancement
temps réels. Lorsque plusieurs tâches ordonnancées par _SCHED_FIFO_ ont la
même priorité statique, la première tâche s'exécute jusqu'à relâcher
volontairement le _CPU_ où qu'une tâche de plus haute priorité arrive.]
- #box[_SCHED_RR_ (_Round Robin_) est une politique d'ordonnancement temps
réels. Lorsque plusieurs tâches ordonnancées par _SCHED_RR_ ont la même
priorité statique, elles s'exécutent à tour de rôle pendant un laps de temps
configuration.]
- #box[_SCHED_OTHER_ et _SCHED_BATCH_ sont les politiques
d'ordonnancement normales. Elles ont une priorité statique nulle. Autrement dit
les tâches temps réel sont toujours plus prioritaires que les tâches normales.
Les trois politiques normales sont implémentées grâce à l'ordonnanceur de tâches
_CFS_ (_Completely Fair Scheduler_) introduit dans _Linux 2.6.23_.. Il s'agit
d'un ordonnanceur à priorité dynamique, c'est-à-dire que la priorité d'une
tâche dépend de son comportement dans le passé et il est possible d'aider
l'ordonnanceur à faire un meilleur choix via un mécanisme de pondération.]
- #box[_SCHED_IDLE_ est la politique des tâches qui ne sont exécutées que
lorsqu'aucune autre tâche n'est prête.]]

#aside[La commande `sched`][
Il est possible de déterminer la politique d'un processus via la commande
_POSIX_ `sched`. Par exemple pour obtenir la politique utilisées pour les
_threads_ du processus _PID_ 1:
```console
sched -p 1
```
produit la sortie:
```output
pid 1's current scheduling policy: SCHED_OTHER
pid 1's current scheduling priority: 0
pid 1's current runtime parameter: 2800000
```
Cette commande permet également de changer la politique d'ordonnancement
d'un processus en cours. Par exemple pour utiliser la politique _SCHED_RR_ avec
le processus 1000 et la priorité statique 10:
```console
sudo sched -r -p 10 1000
```
]

=== Déterminisme <linux_determinism>

Au tournant du #smallcaps[XXI]#super[e] siècle, des initiatives ont visées à doter
_Linux_ de capacités temps réel. Le noyau de l'époque avait été développé dans
l'optique de maximiser les performances de son ordonnanceur de tâches, au
détriment du déterminisme. Les changements pour rendre l'ordonnanceur déterministe
étaient donc considérés trop complexes, et des approches alternatives ont
émergées. L'une de ces approches consiste à contourner la difficulté en
exécutant les tâches temps réel et le noyau _Linux_ directement au-dessus d'un
micronoyau temps réel. Le noyau devient ainsi une tâche de faible
priorité pour ce micronoyau et peut être préempté par ce dernier. On parle alors
d'architecture _cokernel_ ou _dual kernel_, voir la figure @architecture_cokernel.
#figure(
  diagram(
    spacing: 10pt,
    cell-size: (8mm, 10mm),
    edge-stroke: 1pt,
    edge-corner-radius: 5pt,
    mark-scale: 70%,

    blob((2.25, 4.5), [Proc 1], tint: green, width:20mm, name: <proc1>),
    blob((2.52, 4.5), [Proc 2], tint: green, width:20mm, name: <proc2>),
    blob((2.79, 4.5), [Proc ...], tint: green, width:20mm, name: <proc3>),

    node(
      [#align(left)[#pad(-1.8em)[#rotate(-90deg)[
        #text(size: 11pt)[Linux]]]]],
      inset:15pt,
      corner-radius: 3pt,
      enclose: (<proc1>, <proc2>, <proc3>),
      stroke: blue, fill: blue.lighten(90%),
      name: <linux>),
    edge(<linux>, <microkernel>, "-|>"),

    blob((1.26, 4.5), [Tâche RT 1], tint: red, width:20mm, name: <rt_task1>),
    blob((1.55, 4.5), [Tâche RT 2], tint: red, width:20mm, name: <rt_task2>),
    blob((1.84, 4.5), [Tâche RT ...], tint: red, width:20mm, name: <rt_task3>),
    edge(<rt_task1>, <microkernel>, "-|>"),
    edge(<rt_task2>, <microkernel>, "-|>"),
    edge(<rt_task3>, <microkernel>, "-|>"),
    blob((2,5.8), [Micronoyau temps réel], tint: red, width:140mm, name: <microkernel>),
    edge("-|>"),
    blob((2,6.8), [Couche matérielle], tint: gray, width:140mm),
  ),
  caption: [Architecture _cokernel_.]
) <architecture_cokernel>


#let cell(x, y, body, color: white) = cetz.draw.content(
  x, y,
  box(
    align(center)[#body],
    stroke: 1pt + black,
    radius: 3pt,
    fill: gradient.radial(white, color, center: (40%, 20%), radius: 150%),
    width: 100%,
    height: 100%,
    inset: 1em))

En particulier, les projets open-sources _RTLinux_, _RTAI_ et _Xenomai_
adoptèrent cette approche avec succès. Ces principaux avantages sont ses bonnes
garanties quant aux respects des _deadlines_ et une latence très faible. En
contrepartie, le développeur de l'application temps réel ne peut pas utiliser
l'écosystème _UNIX_, rendant le développement plus ardu et coûteux. Par exemple
cette architecture conduit à une duplication des pilotes puisque les tâches
temps réel ne peuvent pas utiliser les pilotes du noyau _Linux_. Il faut
également maintenir une couche d'abstraction dans le noyau _Linux_ pour lui
permettre d'interagir avec le micronoyau. Cette contrainte a motivé le développement
de patchs visant à doter le noyau _Linux_ de capacités temps réel. Le plus connu
et utilisé est _PREEMPT_RT_.

Le projet _PREEMPT_RT_ vise à rendre la majorité des routines du noyau
_Linux_ préemptibles afin de rendre l'ordonnancement des tâches aussi prédictible
que possible. Contrairement aux _cokernels_, cette approche conduit à une modification en
profondeur du noyau. Du fait de sa complexité, le projet, initié par Thomas
Gleixner et Ingo Molnár
en 2005, s'est étalé sur une vingtaine d'années sous la forme d'une succession
de patchs. Ces modifications ont été progressivement intégrées à la branche principale
du noyau _Linux_, jusqu'aux derniers patchs qui ont été appliqués en septembre 2024.
_Linux_ est ainsi devenu un _RTOS_ complet à partir de sa version _6.12_.

#figure(
  cetz.canvas({
    import cetz.draw: *
    cell((-3, 0), (12, 3.5), color: blue, [])
    cell((-3, -1.5), (12, -0.5), color: gray, [Couche matérielle])
    cell((-2, 0.5), (0, 2), color: green, [Proc])
    cell((0.5, 0.5), (2.5, 2), color: red, [Proc RT])
    cell((3, 0.5), (5, 2), color: green, [...])
    content((-2, 0.8), (10, 2.8),
      [Noyau Linux + _PREEMPT_RT_])
  })
  ,
  caption: [Architecture de _Linux_ avec _PREEMPT_RT_]
) <architecture_preempt_rt>

#aside[installation][
  Bien que _PREEMPT_RT_ soit désormais distribué avec la branche principale du
  noyau, il est nécessaire de compiler ce dernier avec l'option de compilation
  `CONFIG_PREEMPT_RT` activée pour obtenir un noyau préemptible. Certaines
  distributions comme _Fedora_ ou _Ubuntu_ proposent également des noyaux
  alternatifs avec cette option activée, rendant l'installation de _PREEMPT_RT_
  plus simple.

  Une fois installée, le noyau offre une nouvelle politique d'ordonnancement
  baptisée _PREEMPT_FULL_, qui comme son nom l'indique, maximise l'ensemble
  du code préemptible dans le noyau.
]

Les modifications apportées au noyau par le projet _PREEMPT_RT_ sont trop
complexes et techniques pour en faire ici une révue détaillée. Toutefois, il
est intéressant de comprendre certains de leurs aspects afin de cerner les
forces et les limites du temps réel dans ce noyau. Plus d'informations sont
disponibles dans la documentation officielle @preempt_rt_doc.

==== _Timers_ hautes résolutions

Historiquement, le noyau _Linux_ utilisait une interruption matérielle
périodique pour exécuter l'ordonnanceur de tâches.
Cette conception impliquait que la précision des _timers_ ne pouvaient
excéder la durée d'un _tick_, qui était de l'ordre de 1 à 10ms. L'adoption
d'une approche _tickless_ à partir de la branche 2.6 du noyau a permis
d'implémenter des _timers_ haute résolution (appelés _hrtimer_ dans la
terminologie linuxienne pour _High-Resolution Timers_)
@gleixner2006hrtimers.

Malgré cette amélioration, les _hrtimers_ soulèvent toujours des problèmes
dans un contexte temps réel. De part la conception actuelle du noyau, les
@isr appelés lors de l'expiration de ces _timers_ sont exécutés avec
la plus haute priorité afin de minimiser leur latence. Cela implique qu'une
tâche de faible priorité peut retarder l'exécution d'une tâche de plus haute
priorité en produisant un grand nombre de _timers_.

Un correctif baptisé _TimerShield_ a été proposé dans @patel2017timershield et
implémenté dans un prototype mais n'est pas intégré dans la branche principale
du noyau.

==== Mutex temps réels

Chaque fois qu'un processus de faible priorité B à la main sur le _CPU_
alors qu'un processus de plus haute priorité A souhaite s'exécuter, on parle
d'_inversion de priorité_. Dans le cadre du temps réel, on doit s'assurer que le temps
pendant lequel une telle inversion se produit est prédictible. Autrement dit,
on doit pouvoir borner cet événement dans le temps. Une vigilance particulière est
accordée aux mécanismes de synchronisation, puisqu'une inversion se produit
en particulier lorsque que le processus A attend la libération
d'une ressource par le processus B. Dans un scénario catastrophe,
le processus B n'est jamais ordonnancé, bloquant pendant un temps indéterminé
l'exécution de A.

À fin de rendre prédectible la durée de ces inversions de priorité, _PREEMPT_RT_
a introduit dans le noyau des _mutex_ temps réel (_rt-mutex_). Ceux-ci reposent sur la
méthode dîte d'héritage de priorité (_Priority Inheritance_). Dans notre
exemple, cela signifie que si le processus B possède une ressource verrouillée
par un _mutex_ temps réel et que le processus A essaie d'acquérir ce _mutex_, alors
la priorité du processus B est augmenté afin qu'il libère cette ressource le plus
vite possible.

Plus de détails sur ces _mutex_ temps réel sont fournis dans la documentation
officielle @linux_rt_mutex_design @linux_rt_mutex_subsystem.

==== Gestionnaires d'interruption

Lors de l'exécution d'un @isr, il est pratique de désactiver les interruptions
car l'@isr exécute généralement du code critique et que rien n'empêche
d'autres interruptions de subvenir durant son exécution. Cette stratégie a été
abondamment utilisée dans le noyau _Linux_. Les @isr constituaient
donc une partie importante du code non-préemptible du noyau. Afin de réduire
la portion de code non-préemptible, l'idée est de diviser en deux étapes le
gestionnaire @linux_threaded_interrupt_handler. La première étape (_Top Half_)
est exécutée avec les interruptions désactivées et ne fait que le strict
nécessaire pour que l'interruption puisse être prise en compte plus tard. La
seconde étape (_Bottom Half_) est exécutée dans un _thread_ noyau préemptible.
Les _threads_ noyaux étant planifiés par l'ordonnanceur de tâches, il devient
possible d'attribuer des priorités sur l'exécution de ces _threads_.

==== Remplacement de @spinlock:pl

En l'absence de _PREEMPT_RT_, une tâche qui attend la libération d'un @spinlock
effectue une attente active. Durant cette attente, la tâche n'est pas
préemptible. En présence de _PREEMPT_RT_, ces @spinlock:pl sont donc remplacés
par des _rt-mutex_.

== KVM <linux_kvm>

Depuis la version `2.6.20` publiée 2007, _Linux_ intègre un hyperviseur
baptisé _KVM_ (_Kernel-based Virtual Machine_)  @linux_kvm_website. Il s'agit
d'un hyperviseur de type 1 assisté par le matériel. Il offre également un
support pour la paravirtualisation.

=== Les _control croups_

Les _cgroups_ (_control groups_) sont un mécanisme du noyau _Linux_
qui permet une gestion fine et configurable des ressources.
Il existe deux versions de ce mécanisme dans le noyau actuel:
- #box[La version `v1`, introduite en 2008 dans le noyau _Linux 2.6.24_,]
- #box[La version `v2` est une refonte complète de la `v1`, introduite en 2016
dans le noyau _Linux 4.5_. Elle est aujourd'hui la version recommandée.]
Dans cette section, nous ne décrivons que le fonctionnement de la version `v2`.
Le lecteur intéressé par la première version de l'API pourra se référer à sa
documentation @linux_cgroups_v1.

Les _cgroups_ forment une structure arborescente et chaque processus appartient
à un unique _cgroup_. À leur création, les processus héritent du _cgroup_
de leur parent. Ils peuvent par la suite migrer vers un autre _cgroup_, s'ils ont les
privilèges adéquates. Ces migrations n'affectent pas leurs enfants déjà existants,
mais seulement ceux créés par la suite. Quant aux _threads systèmes_,
ils appartiennent généralement au _cgroup_ de leur processus mais on peut
mettre en place une hiérarchie de _cgroup_ pour eux.

La répartition des ressources se fait via des _contrôleurs_ spécialisés.
Chaque contrôleur permet d'appliquer des restrictions sur un _cgroup_ et
ses descendants. Une politique appliquée sur un enfant doit être au moins aussi
restrictive que celle de son parent.

Les principaux contrôleurs sont:
- `cpu`: contrôle l'utilisation du CPU,
- `memory`: contrôle l'utilisation de la mémoire vive et de la mémoire d'échange,
- `io`: contrôle les opérations d'entrée/sortie sur les périphériques de stockage,
- `pids`: limite le nombre de processus et de threads,
- `cpuset`: affecte un groupe de processus à des cœurs CPU spécifiques,
- `hugetlb`: contrôle l'utilisation des _huge pages_.

Plus d'informations sur les _cgroups_ sont disponibles dans la documentation
officielle @linux_cgroups_v2.

==== Exemple d'utilisation

La hiérarchie des _cgroups_ est accessible dans l'espace utilisateur via un
pseudo système de fichiers de type `cgroup2`. Il est généralement monté dans le dossier
`/sys/fs/cgroup`. La création et la suppression de _cgroups_ se fait alors grâce
aux commandes habituelles pour la gestion de fichiers sous UNIX.

Supposons que nous souhaitions limiter la consommation de mémoire d'un processus
à 5 Mio. On commence par créer deux#footnote[Il n'est pas possible
de le faire avec un seul _cgroup_ dû à une règle de l'API appelée
«no internal processes».] _cgroups_ `foo` et `bar`:

```console
sudo mkdir -p /sys/fs/cgroup/foo/bar
echo "+memory" | sudo tee /sys/fs/cgroup/foo/cgroup.subtree_control
echo "5 * 2^20" | bc | sudo tee /sys/fs/cgroup/foo/bar/memory.max
```

Désormais la mémoire totale occupée par les processus du _cgroup_ `bar` ne
doit pas excéder les 5 Mio.
#figure(
  snippet("./linux/limited.c", lang:"c"),
  caption:[`limited.c`]
) <limited>

À titre d'exemple, compilons et lançons le programme dont le code source
est donné dans //@limited:
```console
gcc -O0 limited.c -o limited
./limited
```
et dans une autre console, on ajoute le processus au cgroup `bar`:

```console
pgrep limited | sudo tee /sys/fs/cgroup/foo/bar/cgroup.procs
```

Finalement, on demande plus de mémoire que la limite autorisée et le processus
est tué:
```output
How many bytes do you want to allocate? 6000000
fish: Job 1, './limited' terminated by signal SIGKILL (Forced quit)
```

Notez que pour obtenir l'erreur escomptée, il faut prendre garde à deux aspects:
- #box[Le message d'erreur `Cannot allocate` ne s'affiche pas car _Linux_ n'alloue la
mémoire que lorsqu'elle est véritablement utilisée. C'est donc lorsque l'on remplit
le tampon de zéros avec `memset` que la mémoire est réclamée.]
- #box[Si certaines optimisations sont activées, le compilateur `gcc` supprime
l'appel à la fonction `malloc` car il constate qu'on ne lit pas
le buffer et donc son contenu est inutile. Il faut donc désactiver ces
optimisations avec l'option `-O0`.]

=== Chroot <linux_chroot>

L'appel système `chroot` permet de changer le dossier racine de l'arborescence
vue par le processus appelant. Cette fonction était parfois utilisée pour
isoler le système de fichiers d'un démon et ainsi prévenir un accès frauduleux à
des fichiers sensibles. De nos jours, cette méthode n'est plus recommandée
car cette protection peut être contournée sous certaines conditions. Un exemple
d'attaque est détaillé dans sa page de manuel @linux_manual_page_chroot.
D'autre part cet appel n'offre pas le même degré d'isolation que les
_namespaces_ abordés dans la section @linux_namespaces.

=== Les namespaces <linux_namespaces>

Les _namespaces_ sont des outils permettant d'isoler des ressources pour des processus.
Cette isolation permet de créer des environnements sécurisés et indépendants.

Les principaux namespaces sont:
- `PID Namespace`: isole l'arborescence des processus.
- #box[`Network Namespace`: isole la pile réseau, permettant à un conteneur d'avoir ses propres
interfaces, tables de routage et règles de pare-feu.]
- #box[`Mount Namespace`: isole l'arborescence des fichiers.]
- `UTS Namespace` (_Unix Time-sharing System_): isole le nom d'hôte et le nom de domaine.
- `User Namespace`: isole les identifiants utilisateurs et les groupes.

==== Exemple d'utilisation avec `systemd`
Le gestionnaire de services `systemd` intègre l'outil `systemd-nspawn` pour faciliter
l'utilisation des _namespaces_. Il constitue une alternative à `chroot` plus sûre.
En plus d'isoler l'aborescence des fichiers, cette commande isole celle des
processus, le réseau et les utilisateurs. Par exemple, considérons le
programme _C_ suivant:

#figure(
  snippet("./linux/alone.c", lang:"c"),
  caption: [`alone.c`]
)

En le compilant puis le liant statiquement à la bibliothèque C, il est possible
de le lancer dans un conteneur de _systemd_ ainsi:
```console
gcc -static ./foo/alone.c -o ./foo/alone
sudo systemd-nspawn -D ./foo ./alone
```
On obtient alors la sortie suivante:
```output
░ Spawning container foo on /foo.
░ Press Ctrl-] three times within 1s to kill container.
My pid: 1
1
Container foo exited successfully.
```
révélant que `alone` est le seul processus visible dans le conteneur `foo` et
qu'il a le PID 1.

=== _Capabilities_ <linux_capabilities>

Les implémentations UNIX traditionnelles distinguent deux catégories
de processus: les processus #definition[privilégiés] et les processus
#definition[non privilégiés]. Les processus privilégiés contournent toutes les
vérifications de permission du noyau, tandis que les processus non
privilégiés sont soumis à ces vérifications en se basant sur des identifiants
associés au processus#footnote[Ces identifiants sont le plus souvent l'UID
(_User IDentifier_) effectif, le GID (_Group IDentifier_) effectif ou les
groupes supplémentaires du processus.]. Par exemple la commande suivante:
```console
ps -U root -u root
```
affiche tous les processus ayant pour UID réel ou effectif `root`. Ils constituent
l'essentiel des processus privilégiés en cours d'exécution. Vous devriez obtenir
une sortie similaire à celle-ci:
```output
    PID TTY          TIME CMD
      1 ?        00:00:03 systemd
      2 ?        00:00:00 kthreadd
      3 ?        00:00:00 pool_workqueue_release
      4 ?        00:00:00 kworker/R-rcu_gp
      5 ?        00:00:00 kworker/R-sync_wq
      6 ?        00:00:00 kworker/R-kvfree_rcu_reclaim
      7 ?        00:00:00 kworker/R-slub_flushwq
      8 ?        00:00:00 kworker/R-netns
     10 ?        00:00:00 kworker/0:0H-events_highpri
     13 ?        00:00:00 kworker/R-mm_percpu_wq
     ...
```
Sans surprise `systemd` et un grand nombre de workers et de threads noyaux
sont des processus privilégiés. La commande suivante:
```console
ps -U $(whoami)
```
vous donnera la liste des processus qui s'exécutent avec l'UID effectif de
votre utilisateur. Vous devriez y retrouver vos logiciels. Par exemple,
sur mon ordinateur j'obtiens la sortie:
```output
    PID TTY          TIME CMD
   2512 ?        00:00:00 systemd
   2514 ?        00:00:00 (sd-pam)
   2523 ?        00:00:00 devmon
   2524 ?        00:00:00 gamemoded
   2530 tty1     00:00:00 fish
   2537 ?        00:00:00 mpd
   2541 ?        00:00:00 dbus-daemon
   2652 ?        00:00:44 pipewire
   2653 ?        00:00:11 wireplumber
   2683 ?        00:00:00 udevil
   2715 ?        00:17:47 niri
  29113 pts/3    00:00:02 typst
  ...
```
Les logiciels `niri`, `fish` et `typst` sont en cours d'exécution avec mes
droits utilisateurs. En particulier, ils ne peuvent pas modifier n'importe
quel fichier du disque ou faire tous les appels systèmes car ils ont des
privilèges limités.

Cette distinction en deux catégories n'offre pas toujours suffisamment de
granularité. Il est fréquent de ne vouloir exécuter que quelques appels
systèmes avec les privilèges `root` dans un processus. Or exécuter un programme
avec les droits `root` constitue un risque de sécurité car s'il présente une
faille exploitable, un intrus pourrait obtenir les droits `root` à travers lui.

==== SetUID
Les processus peuvent être privilégiés parce qu'ils ont été lancé par
l'utilisateur _root_ ou via le mécanisme du _setUID_ qui permet à processus
d'avoir certains des privilèges du propriétaire du binaire plutôt que de
l'utilisateur qui l'a lancé. Ainsi le binaire `passwd` appartient à _root_
mais permet à n'importe qui de changer son propre mot de passe.

== Corruption mémoire <linux_memory_corruption>

Le noyau _Linux_ intègre un sous-système nommé _EDAC_ (_Error Detection and Correction_)
@linux_edac qui permet la journalisation des erreurs mémoires. La journalisation s'effectue
grâce au démon _rasdaemon_.

Certains processeurs AMD nécessitent l'utilisation d'un pilote pour que _EDAC_
fonctionne.

Le noyau fournit également une interface logicielle commune @linux_scrub via
_sysfs_#footnote[Le système de fichiers _sysfs_ est un pseudo système de
fichiers disponible sous Linux. Il permet aux logiciels tournant dans le
_user space_ de lire et de modifier des paramètres des pilotes et
des périphériques via des fichiers. Il est généralement monté dans le dossier
`_/sys_`.]. Cette interface permet le pilotage du _scrubbing_.

== Perte du flux d'exécution <linux_flow_hijacking>

_Linux_ peut bénéficier de plusieurs mécanismes de protection du flux d'exécution,
notamment via les extensions matérielles modernes comme _Intel CET_ (_Control-flow
Enforcement Technology_) sur _x86_ ou _ARM BTI_ (_Branch Target Identification_)
sur _ARM_. Ces mécanismes matériels offrent une protection efficace avec un
surcoût minimal.

== Écosystème <linux_ecosystem>

_Linux_ dispose d'un écosystème riche et mature d'outils de monitoring et
d'observabilité @linux_perf_brendan @linux_monitoring_tools_2024. Ces outils
permettent de surveiller les performances, l'état du système et d'identifier les
problèmes en temps-réel. Parmi les outils de monitoring les plus utilisés:

- #box[_top/htop_ @htop_website: Moniteurs système interactifs affichant
  l'utilisation du CPU, de la mémoire et des processus en temps réel.]

- #box[_netdata_ @netdata_website: Solution de monitoring temps-réel légère et
  performante, collectant automatiquement plus de 5000 métriques sans
  configuration. Particulièrement adaptée aux environnements embarqués grâce à
  sa faible empreinte.]

- #box[_eBPF_ (_Extended Berkeley Packet Filter_) @ebpf_website : Technologie moderne
  permettant l'exécution de code personnalisé dans le noyau sans modification
  ni ajout de modules. _eBPF_ offre une observabilité en temps réel avec un
  impact minimal sur les performances, devenant l'outil de référence pour le
  monitoring avancé en 2024.]

- #box[_SystemTap_ @systemtrap: Permet l'instrumentation dynamique du noyau
  pour l'analyse approfondie du comportement système.]

- #box[_Prometheus/Grafana_ @prometheus_website @grafana_website : Solutions
  d'observabilité distribuée largement adoptées pour le monitoring de systèmes
  critiques.]

- #box[_strace/ptrace_: .]

- #box[_perf_ @perf_wiki: Outil d'analyse de performance intégré dans le noyau
  _Linux_ depuis sa version 2.6.31. À l'origine _perf_ permettait de tracer
  l'activité du _CPU_ via des compteurs @pmu. Depuis, ses fonctionnalités ont
  été considérablement étendues et il permet maintenant d'instrumenter avec un
  faible surcoût aussi bien le noyau que les programmes exécutés dans
  l'@userspace.]

- #box[_oprofile_ @oprofile_website: Outil d'analyse de performance. Il permet
  le profilage d'une application ou du système tout entier. Il permet
  également la collecte d'événements via les @pmu.]

- #box[_kgdb/kdb_ @kgdb_documentation: _Linux_ intègre des interfaces pour
  déboguer le code du noyau.]

Pour les systèmes embarqués, la simplicité et la légèreté des outils sont
prioritaires. _Monitorix_ est particulièrement adapté à ces contraintes, ayant
été conçu pour les serveurs mais utilisable sur dispositifs embarqués grâce à
sa taille réduite.

=== Exemple de profilage

Afin d'illustrer certains outils de profilage, nous allons utiliser le programme
suivant qui parcourt des cases d'un tableau d'entiers soit dans de façon
séquentielle, soit dans un ordre aléatoire.

#figure(
  snippet("./linux/miss.c", lang:"c"),
  caption: [Parcours d'un tableau et _cache misses_]
) <miss_source>

Le mot clé `volatile` sur le tableau `arr` assure que `gcc` ne supprimera pas
les accès en lecture sur ce dernier bien que son contenu soit prévisible
et jamais utilisé. Vous pouvez le compiler avec la commande `gcc miss.c -o miss`.

Examinons les performances de notre programme @miss_source à l'aide de la
sous-commande `perf stat`. Cette dernière retourne des statistiques issues
des registres @pmu du processeur. En lançant `perf stat ./miss`, on obtient
la sortie:
```output
Performance counter stats for './miss':

       116.46 msec task-clock:u            #    0.991 CPUs utilized
            0      context-switches:u      #    0.000 /sec
            0      cpu-migrations:u        #    0.000 /sec
        1,028      page-faults:u           #    8.827 K/sec
  270,371,076      cycles:u                #    2.322 GHz
1,100,144,340      instructions:u          #    4.07  insn per cycle
  100,029,819      branches:u              #  858.891 M/sec
        2,352      branch-misses:u         #    0.00% of all branches
                   TopdownL1               #  25.1 %  tma_backend_bound
                                           #   1.2 %  tma_bad_speculation
                                           #   0.2 %  tma_frontend_bound
                                           #  73.6 %  tma_retiring

  0.117552543 seconds time elapsed

  0.113162000 seconds user
  0.003969000 seconds sys
```
Tandis que parcourir le tableau `arr` dans un ordre aléatoire conduit à un
résultat très différent en terme de performance. En effet la commande
`perf stat ./miss random` donne la sortie:
```output
Performance counter stats for './miss random':

     1,974.28 msec task-clock:u            #    0.999 CPUs utilized
            0      context-switches:u      #    0.000 /sec
            0      cpu-migrations:u        #    0.000 /sec
        2,003      page-faults:u           #    1.015 K/sec
5,945,316,708      cycles:u                #    3.011 GHz
7,896,922,743      instructions:u          #    1.33  insn per cycle
1,600,032,861      branches:u              #  810.440 M/sec
    3,229,770      branch-misses:u         #    0.20% of all branches
                   TopdownL1               #  60.4 %  tma_backend_bound
                                           #   2.7 %  tma_bad_speculation
                                           #   2.8 %  tma_frontend_bound
                                           #  34.1 %  tma_retiring

  1.975546187 seconds time elapsed

  1.968594000 seconds user
  0.001981000 seconds sys
```
Le parcours est nettement plus lent et le nombre de `cache-misses` explose.

== Masquage des interruptions <linux_masking>

Le noyau _Linux_ propose une @api en langage C pour masquer les interruptions
@linux_kernel_irq_api. Les principales primitives sont `local_irq_disable`,
`local_irq_save` et `disable_irq` qui permettent de désactiver toutes les
interruptions du _CPU_ ou une interruption spécifique au niveau du contrôleur.

Pour les systèmes temps réel, le projet _PREEMPT_RT_ introduit le concept
d'_interruptions threadées_ où le gestionnaire matériel se limite à masquer
l'interruption, acquitter le contrôleur et réveiller un thread noyau qui
effectue le traitement réel de façon préemptible. Cette approche résout les
problèmes d'_inversion d'interruptions_ et réduit la latence.

_KVM_ fournit un support pour la virtualisation des interruptions matérielles
via les interfaces _VGIC v2/v3_ @linux_kvm_vgic_v2 @linux_kvm_vgic_v3 sur _ARM_
et _Intel APICv_/_AMD AVIC_ sur _x86_. Le _VGIC v3_ offre notamment le support
de l'_affinity routing_ (jusqu'à 512 _VCPUs_) et de l'_ITS_ (_Interrupt Translation
Service_) pour les interruptions _MSI_.

== Watchdog <linux_watchdog>

Cette section décrit le support pour des _watchdogs_ matériels dans le noyau
_Linux_ ainsi que le support pour des _watchdogs_ logiciels par _systemd_.

=== API bas niveau <linux_watchdog_api>

_Linux_ offre une _API_ unifiée pour interagir avec les _watchdogs_
matériels directement dans l'espace utilisateur @linux_watchdog_driver_api.
Cette communication se fait via un pseudo-périphérique `/dev/watchdog`.
À l'ouverture ce périphérique, le _watchdog_ s'active et attend
d'être réinitialisé dans un certain délai de réponse. Une façon simple de le
réinitialiser est d'écrire des données quelconques dans le périphérique `/dev/watchdog`.
Quant au délai de réponse, il est configurable via l'appel système `ioctl`.
Lorsque le périphérique est fermé, le _watchdog_ est désactivé. La
@linux_watchdog_example contient un exemple simple d'utilisation de _watchdog_.

#figure(
  snippet("./linux/watchdog.c", lang:"c"),
  caption: [Exemple d'interaction avec un _watchdog_ sous _Linux_.]
) <linux_watchdog_example>

Toutefois, dans un usage réel, il est souhaitable que le _watchdog_ ne puisse pas
être désactivé accidentellement. En effet, si par exemple l'appel système `write`
échoue dans le code ci-dessus, le descripteur de fichier `fd` sera libéré, ce qui
provoquera l'arrêt du watchdog. Pour cette raison, certains pilotes de _watchdogs_
permettent de ne pas être désactivables ou seulement par l'écriture d'une séquence
de caractères magique sur le périphérique `/dev/watchdog`.

=== Support dans _systemd_

Pour la plupart des distributions _GNU/Linux_ modernes, l'utilisation des
watchdogs est simplifiée via le gestionnaire de services _systemd_. Ce dernier
permet aussi d'utiliser des _watchdogs_ logiciels dans les services.
Pour ce faire, il suffit de modifier le démon afin qu'il
notifie régulièrement _systemd_ via l'appel `sd_notify("WATCHDOG=1")`. Le délai
de réponse est quant à lui transmis par la variable d'environnement `WATCHDOG_USEC`.
La @linux_systemd_watchdog_example contient un exemple d'un démon `/usr/bin/foo`
ainsi modifié qui sera automatiquement relancé par _systemd_ s'il ne notifie
pas ce dernier dans un délai de 30 secondes.

#figure(
  snippet("./linux/foo.ini", lang:"ini"),
  caption: [Exemple de service _systemd_ avec _watchdog_.]
) <linux_systemd_watchdog_example>

== Programmation @baremetal <linux_baremetal>

_KVM_ permet l'exécution d'applications @baremetal sous forme d'_unikernels_
dans ses machines virtuelles. Ces _unikernels_ regroupent l'application et un
@rte minimal, sans système d'exploitation complet.

En _Rust_, _RustyHermit_ @rustyhermit_github est un _unikernel_ qui peut
s'exécuter sur _KVM_ via l'hyperviseur _uhyve_ ou _QEMU_ @rustyhermit_running.

Pour _OCaml_, _MirageOS_ supporte l'exécution d'_unikernels_ sur _KVM_/_QEMU_
via _Solo5_ @mirageos_solo5.

Nous n'avons pas trouvé de solution documentée permettant d'exécuter des
applications _Ada_ en @baremetal dans une partition _KVM_.

== Temps de démarrage <linux_booting>

Il existe de nombreuses techniques pour réduire le temps de démarrage d'un système
_Linux_. Ces techniques concernent aussi bien le @bootloader (initialisation
uniquement des périphériques indispensables, optimisation du code assembler,
...), l'initialisation du noyau (image non compressée, désactivation des
fonctionnalités inutiles, désactivation du profilage, ...) ou l'initialisation
de l'@userspace qui est généralement l'étape la plus longue.

Dans l'article @singh2011optimizing, les auteurs étudient des méthodes
d'optimisation pour le temps démarrage d'un système _Android_ exécuté sur
un dispositif embarqué dans une automobile. Ils parviennent à réduire de 65% le
temps de démarrage en passant de 29,7s à 10,1s. Sur le noyau _Linux_ lui-même,
ils obtiennent une amélioration d'un facteur 4.

Dans le mémoire @AlAbduallah2023Decreasing, les auteurs comparent et optimisent
différents @initsystem:pl à la fois dans un environnement émulé avec _QEMU_ et
dans une distribution _GNU/Linux_ dédiée à l'embarqué. Leur conclusion est
qu'une réduction substantielle du temps démarrage de l'@userspace est possible via
leurs méthodes d'optimisation et que le choix du @initsystem est déterminant
mais dépendant de l'environnement d'exécution.

=== Profilage de `systemd` <linux_systemd_analyze>

Comme expliqué ci-dessus, l'initialisation de l'@userspace est souvent l'étape
la plus longue au démarrage.

Le programme _systemd_ fournit un outil intéressant de profilage baptisé
`systemd-analyze`. Il permet d'analyser le temps de démarrage du système et
des sessions utilisateurs afin d'identifier des goulots d'étranglement. Détaillons
quelques unes des ses commandes:
- #box[`systemd-analyze time`: affiche différents temps relatifs au démarrage du
système.]
- #box[`systemd-analyze blame`: affiche le temps de démarrage des différents services. Il
est à noter que certains services pouvant s'exécuter en parallèle, l'analyse de sa sortie
requière une certaine prudence.]
- #box[`systemd-analyze dot`: produit un graphe de dépendance des services.]
- #box[`systemd-analyze plot`: produit une frise chronologique du démarrage des services.]

Par exemple, la commande suivante:
```console
systemd-analyze time
```
produit une sortie de la forme:
```output
Startup finished in 7.274s (firmware) + 3.428s (loader) + 1.007s (kernel) + 11.451s (initrd) + 7.587s (userspace) = 30.749s
multi-user.target reached after 7.321s in userspace.
```
Le dernier temps indique le délais écoulé avant que l'@userspace ne soit disponible,
ce qui correspond en général à l'affichage d'un prompteur pour ouvrir une session.
On retrouve aussi d'autres informations intéressantes:
- _Firmware_: Temps de chargement des firmwares via le BIOS,
- _Load_: Temps écoulé dans le @bootloader,
- _Kernel_: Temps de chargement et d'initialisation du noyau,
- _Initrd_: Temps d'initialisation de la _RAM disk_,
- _Userspace_: Temps écoulé pour lancer tous les services de l'@userspace.

== Maintenabilité <linux_mainability>

_Linux_ est un logiciel libre distribué sous licence `GPL-2.0` avec
l'exception _syscall_. Cette exception stipule qu'un logiciel utilisant le noyau
_Linux_ au travers de ses appels systèmes n'est pas considéré comme une œuvre
dérivée et peut être distribué sous une licence qui n'est pas compatible avec
la licence _GPL_, y compris une licence propriétaire. Plus d'informations sont
disponibles dans le dossier `LICENSES` des sources du noyau.

Le développement du noyau a débuté en 1991, ce qui fait plus de 34 ans
d'existence. Cette longue histoire a permis à _Linux_ et à son écosystème
d'atteindre un niveau de maturité exceptionnel. Des milliers de développeurs
contribuent au noyau au travers de centaines d'entreprises (_Intel_, _Google_,
_Samsung_, _AMD_, _Red Hat_, ...).

Toutefois avec plus de 26 millions de lignes de code (et 18,9 millions de plus
pour les pilotes seulement), le noyau _Linux_ est une d'une complexité rarement
atteinte dans l'histoire du développement logiciel. Cette taille colosse
constitue un défi pour la vérification du noyau ou la certification
de solutions logicielles intégrant _Linux_.

De nombreuses entreprises proposent un support commercial pour _Linux_,
notamment _Red Hat_, _SUSE_ et _Canonical_. Ce support couvre aussi bien les
distributions grand public que les versions temps réel pour l'embarqué.

= MirageOS <mirageos>

#showybox(
  title: "MirageOS en bref",
  frame: (
    border-color: purple.darken(20%),
    title-color: purple.lighten(80%),
    body-color: purple.lighten(95%)
  )
)[
  - *Type* : LibOS
  - *Langage* : OCaml (99%)
  - *Architectures* : x86-64, ARM v8, PowerPC#footnote[Support limité à
    l'environnement d'exécution _spt_ du projet _solo5_.]
  - *Usage principal* : Cloud computing, applications réseau, systèmes embarqués,
    spatial
  - *Points forts* : Sécurité renforcée (surface d'attaque réduite, langage
    sûr), taille minimale, temps de démarrage rapide, modularité
  - *Limitations* : Portabilité limitée sans hyperviseur, débogage complexe,
    pas d'interface POSIX
  - *Licences* : ISC (majoritaire) + LGPLv2 (certaines parties)
  - *Projet notable* : SpaceOS (déployé dans l'espace en 2025)
]

Au tournant des années 2010, le _cloud computing_ s'impose comme une solution
pour réduire le coût et externaliser la maintenance des services web. Cette
innovation a été rendue possible par la démocratisation au début du siècle de
la virtualisation sur architecture _x86_. À cette époque, la majorité des
@vm:pl exécutent un service web dans un _GPOS_ complet. Cette approche présente
l'avantage de circonscrire au système d'exploitation les modifications
nécessaires pour la virtualisation, tout en bénéficiant de l'isolation offerte
par l'hyperviseur. En contre partie, la pile logicielle est grandement
complexifiée comme l'illustre la @comparison_unikernel_gpos.

#figure(
grid(
  columns: (1fr, 1fr),
  column-gutter: -4cm,
  [
    #diagram(
      spacing: 10pt,
      cell-size: (8mm, 10mm),
      edge-stroke: 1pt,
      edge-corner-radius: 5pt,
      mark-scale: 70%,

      blob((2,0), [Application], tint: blue),
      edge("-|>"),
      blob((2,1), [Fichier de configuration], tint: red),
      edge("-|>"),
      blob((2,2), [Environnement d'exécution du langage], tint: blue, name: <runtime>),
      blob((2,3.5), [Bibliothèques partagées], tint: red, name: <bib>),
      edge("-|>"),
      blob((2,4.5), [Noyau], tint: red, name: <kernel>),
      edge(<runtime>, <gpos>, "-|>"),
      node(
        [#align(left)[#pad(-1.8em)[#rotate(-90deg)[
          #text(size: 11pt)[GPOS]]]]],
        inset:15pt,
        corner-radius: 3pt,
        enclose: (<bib>, <kernel>),
        stroke: red, fill: red.lighten(90%),
        name: <gpos>),
      edge(<gpos>, <hypervisor>, "-|>"),
      blob((2,5.8), [Hyperviseur], tint: green, name: <hypervisor>),
      edge("-|>"),
      blob((2,6.8), [Couche matérielle], tint: gray),
    )
  ],
  [
    #diagram(
      spacing: 8pt,
      cell-size: (8mm, 10mm),
      edge-stroke: 1pt,
      edge-corner-radius: 5pt,
      mark-scale: 70%,

      blob((2,0), [Application], tint: blue, name: <app>),
      edge("-|>"),
      blob((2,1), [Environnement d'exécution du langage], tint: blue, name: <runtime>),
      node(
        [#align(left)[#pad(-2.7em)[#rotate(-90deg)[
          #text(size: 11pt)[Unikernel]]]]],
        inset:15pt,
        corner-radius: 3pt,
        enclose: (<app>, <runtime>),
        stroke: blue, fill: blue.lighten(90%),
        name: <unikernel>),
      edge(<unikernel>, <hypervisor>, "-|>"),
      blob((2,2.5), [Hyperviseur], tint: green, name: <hypervisor>),
      edge("-|>"),
      blob((2,3.5), [Couche matérielle], tint: gray),
    )
  ]),
  caption: [Comparaison entre l'approche _GPOS_ et l'approche _unikernel_.]
) <comparison_unikernel_gpos>

En particulier, certains mécanismes d'isolation comme l'ordonnanceur de tâches
sont dupliqués entre l'hyperviseur et le noyau exécuté dans la @vm. De plus,
l'introduction d'un _GPOS_ augmente considérablement la surface d'attaque
@tcb et les sources de bugs potentiels. Cela est d'autant plus
vrai que ces @gpos sont souvent écrits dans un langage de
programmation#footnote[La vaste majorité de la programmation système est en
langage C qui n'offre pratiquement aucune garantie mémoire et dont la sémantique
est complexe, notamment sur les architectures @smp.] n'offrant que peu de
garantie du point de vue des types et de la mémoire. C'est de ces deux constats
que naît le projet _MirageOS_.

Le projet est initié en 2009 au sein du laboratoire
_Computer Laboratory_ de l'université de Cambridge sous la houlette de
Anil Madhavapeddy @mirageos_unikernels. Il est de nos jours maintenu par la
_MirageOS Core Team_ composée d'universitaires et d'ingénieurs du secteur privé
(_Tarides_, _IBM Research_, ...).
_MirageOS_ fait parti des projets soutenus par le _Xen Project_
@mirageos_xen_project et un grand nombre de ces contributeurs ont également
participé au projet _Xen_.

_MirageOS_ adopte une approche de type _LibOS_. Au lieu de fournir un
environnement d'exécution préconfiguré pour les services, _MirageOS_ se
présentent sous la forme d'une collection de bibliothèques. Ces dernières sont
écrites majoritairement en _OCaml_, un langage de programmation de haut niveau
offrant la sûreté des types et équipé d'un ramasse-miette. La configuration et
l'ensemble des bibliothèques nécessaires au service sont liés durant la
compilation pour produire une image appelée _unikernel_. Cet _unikernel_ peut
alors être exécuté dans divers environnements, voir la sous-section
@mirageos_environments. Cela conduit à une simplification de la pile logicielle
comme illustré dans @comparison_unikernel_gpos. L'approche _unikernel_ présente
de nombreux avantages:
- #box[Une plus petite @tcb à la fois par la réduction de le taille du
code source et l'utilisation d'un langage de programmation sûr,]
- #box[Une amélioration des performances et notamment du temps de démarrage,]
- #box[Une réduction de la taille des exécutables produits,]
- #box[Un profilage simplifié par la suppression d'une couche logicielle
  volumineuse.]

== Tutoriel <mirageos_tutorial>
Pour faciliter l'exécution des exemples de ce chapitre, une image `docker` est
disponible dans le dossier `miragos/` du dépôt. Cette image contient tout le
nécessaire pour compiler des images avec MirageOS. Pour installer l'image, tapez:
```console
make -C mirageos setup
```
Vous pouvez accéder au shell du `docker` en tapant:
```console
make -C mirageos shell
```

== Architectures supportées <mirageos_architectures>

Pour qu'une architecture soit supportée par _MirageOS_, il est nécessaire
qu'elle soit une cible de compilation du compilateur OCaml. Le compilateur
_OCaml 4_ supporte les architectures suivantes: _x86-32_, _x86-64_, _ARMv7_,
_ARMv8_, _PowerPC_, _SPARC_ et _MIPS_. Toutefois le support en natif#footnote[
Il subsiste en _bytecode_, ce qui n'est pas pertinent ici puisqu'il faudrait
porter la machine virtuelle d'OCaml pour obtenir probablement des performances
médiocres.] pour les architectures 32-bits a été supprimé à partir
d'_OCaml 5_. Il n'est donc pas recommandé d'utiliser _MirageOS_ sur de telles
plateformes.

En pratique, les _unikernels_ produits par _MirageOS_ sont rarement exécutés
en @baremetal mais plutôt dans une partition d'un hyperviseur. Il est donc
nécessaire que cet hyperviseur supporte une des architectures ci-dessus et
que l'environnement d'exécution de _MirageOS_ ait été porté dessus.

Porter une _LibOS_ sur un hyperviseur étant une tâche répétitive, le projet
_solo5_ vise à mutualiser les efforts en fournissant une couche d'abstraction
logicielle entre le @rte de _MirageOS_ et les différentes @api d'hyperviseurs
et de @gpos. À l'heure actuelle, _solo5_ semble n'offrit qu'un support pour les
systèmes sur _x86-64_, _ARMv8_ et _PowerPC_ (limité à l'environnement
d'exécution _spt_).

Nous considérons donc que seuls ces architectures sont officiellement supportées
par le projet _MirageOS_.

== Support multi-processeur <mirageos_multiprocessors>

Les _unikernels_ de _MirageOS_ étant souvent exécutés au-dessus d'un
hyperviseur, la question du support d'architectures multi-processeur revient
à déterminer si ces images peuvent tirer parti du parallélisme de ces
processeurs. En premier lieu, le @rte d'_OCaml_ doit permettre le parallélisme
du code _OCaml_.

Jusqu'à _OCaml 4_, le @runtime _OCaml_ utilisait un verrou global assurant
que le code _OCaml_ ne puisse jamais être exécuté en parallèle. Ce verrou
permettait de garantir la préservation d'invariants internes, notamment au
niveau du ramasse-miette. Un moyen de bénéficier malgré tout du parallélisme
était d'écrire le code à paralléliser en C puis de l'interfacer avec le code
_OCaml_.

Cette solution n'a pas été retenue par les développeurs de _MirageOS_ qui
souhaitaient bénéficier de la sûreté des types du langage _OCaml_.
Les services web étant généralement des applications _I/O bound_#footnote[Une
application est qualifiée _I/O bound_ si son temps d'exécution est dominé la
vitesse de traitement des entrées/sorties.], une approche à base de
programmation asynchrone a été retenue pour permettre l'entrelacement de fils
d'exécutions. _MirageOS_ a donc été implémenté avec la bibliothèque de _threads_
coopératifs _Lwt_ @vouillon2008lwt @lwt_manual.

#aside[Bibliothèque _Lwt_][
  _Lwt_ est une bibliothèque de _threads_ coopératifs écrite en _OCaml_ dans
  le cadre du projet _Ocsigen_ @mirageos_ocsigen. Elle simplifie la
  programmation asynchrone en proposant un style de programmation monadique
  via des promesses.

  Par exemple, dans le code suivant, deux _threads_ légers sont lancés pour
  afficher un message après un décompte grâce à la fonction `Mirage_sleep.ns`:
  ```ocaml
  open Lwt.Infix

  let start () =
    Lwt.join
      [
        ( Mirage_sleep.ns (Duration.of_sec 1) >|= fun () ->
          Logs.info (fun m -> m "Heads") );
        ( Mirage_sleep.ns (Duration.of_sec 2) >|= fun () ->
          Logs.info (fun m -> m "Tails") );
      ]
    >|= fun () -> Logs.info (fun m -> m "Finished")
  ```
  La fonction `Lwt.join` crée une promesse qui ne sera résolue que lorsque
  les deux _threads_ auront terminé leur travail. Lorsque cette promesse
  est résolue, on peut afficher le message _Finished_ dans le terminal.
]

Lorsque le parallélisme est vraiment nécessaire, par exemple si un service doit
effectuer une tâches lourdes en calcul, une solution est d'exécuter plusieurs
instances du même _unikernel_ et de les synchroniser via les @ipc de
l'hyperviseur sous-jacent. Cette solution a été mise en pratique sur
l'hyperviseur _Xen_ @madhavapeddy2015jitsu @vchan_low_latency.

La version 5 d'_OCaml_ introduit deux nouvelles fonctionnalités utiles pour
_MirageOS_:
- #box[D'une part le verrou global du @rte d'_OCaml_ a été supprimé.
L'exécution en parallèle de code _OCaml_ est donc possible via le concept de
_domaine_ @retrofitting_parallelism. Cet ajout s'est fait aux prix d'une
complexification du modèle mémoire d'OCaml mais néanmoins maîtrisé
@mirageos_ocaml_memory_model,]
- #box[D'autre part l'introduction des effets algébriques facilite la création
d'une bibliothèque de _threads_ coopératifs. Il est désormais possible de
réaliser une telle bibliothèque sans utiliser un style monadique, ni allouer
des clôtures sur le tas pour représenter les piles d'exécution des _threads_.]

Un effort est en cours pour porter _MirageOS_ sur _OCaml 5_ @mirageos_on_ocaml5,
ce qui devrait conduire à une amélioration des performances des _unikernels_
sur les architectures @smp et à une simplification de leur architecture lorsque
le parallélisme est nécessaire pour des raisons de performance.

== Environnements d'exécution <mirageos_environments>

Les _LibOS_ souffrent généralement d'un problème de portabilité car elles doivent
être adaptées à chaque environnement matériel spécifique. Cette problématique est
largement atténuée par l'usage d'un hyperviseur qui offre une couche d'abstraction
matérielle standardisée, facilitant ainsi le déploiement des _unikernels_ sur
différentes plateformes.

Les _unikernels_ produits par _MirageOS_ peuvent tourner sur les hyperviseurs
_Xen_, _KVM_ de _Linux_, _BHyve_ de _FreeBSD_ et _OpenBSD VMM_. Il
supporte également le noyau de séparation _Muen_. Finalement, il est possible
d'exécuter une image dans un environnement _UNIX_ comme une distribution
_GNU/Linux_ ou _macOS_, ce qui est particulièrement utile pour débogage.

À l'origine _MirageOS_ n'était supporté que par _Xen_. Lors de son portage
vers _KVM_ par _IBM Research_, le projet _solo5_ a été lancé afin de mutualiser
les efforts d'un tel portage. Aujourd'hui _solo5_ propose un environnement
d'exécution standardisé pour différentes _LibOS_ et ciblant différents
_hyperviseurs_.

#howto[choisir l'environnement d'exécution][
Le choix de l'environnement d'exécution se fait au moment de la configuration
du projet via la commande:
```console
mirage configure -t ENV
```
où `ENV` peut désigner les valeurs suivantes:
`unix`, `macosx`, `xen`, `virtio`, `hvt`, `muen`, `qubes`, `genode`, `spt`,
`unikraft-firecracker` ou `unikraft-qemu`.
- #box[L'option `xen` permet l'exécution dans un domaine de _Xen_. Il s'agit
de l'environnement original du projet _MirageOS_. En production, on exécute
généralement le noyau minimaliste _Mini-OS_ dans le _dom0_ de _Xen_ @xen_minios.]
- #box[L'option `unix` permet d'exécuter l'_unikernel_ dans _KVM_.]
- #box[Les options `unix` et `macosx` permettent d'exécuter
l'_unikernel_ dans une distribution _GNU/Linux_, respectivement _macOS_. C'est
un atout précieux pour le débogage et le profilage de l'application mais ne
correspond généralement pas à l'environnement d'exécution en production.]
- #box[Les options `unikraft-firecracker` et `unikraft-qemu` ont été ajoutées
récemment au projet @mirageos_unikraft. Elles permettent d'exécuter l'_unikernel_
dans un environnement _unikraft_.]
]

Dans les sections suivantes, nous exécuterons les exemples dans l'hyperviseur
_Xen_. Ce choix est motivé par le fait qu'il s'agit aujourd'hui du cas d'usage
fréquent.

== Partitionnement <mirageos_isolation>

_MirageOS_ n'offre pas de partitionnement temporel ou spatial. Cette tâche
incombe à un noyau de séparation dans lequel l'_unikernel_ est exécuté,
typiquement un hyperviseur comme _Xen_. Lorsque l'on souhaite isoler plusieurs
services _MirageOS_, l'usage est d'exécuter ces services dans des _unikernels_
distincts et de les faire communiquer via les @ipc de l'hyperviseur.

En particulier, si vous utiliser _Xen_ comme noyau de séparation, vous pouvez
utiliser la bibliothèque _ocaml-vchan_ @mirageos_ocaml_vchan de _MirageOS_ pour
communiquer entre deux _unikernels_.

À notre connaissance, _MirageOS_ n'a jamais été utilisé dans un contexte temps
réel. Le principal obstacle vient du ramasse-miette d'OCaml qui n'offre pas de
garanties déterministes. Quant à la bibliothèque _Lwt_, elle n'a pas été
conçue pour cet usage puisque les tâches doivent rendre la main volontairement
à l'ordonnanceur _Lwt_. Si vous souhaitez exécuter une tâche temps réel en
parallèle d'un _unikernel_ _MirageOS_, il faudra avoir recours à un hyperviseur
temps réel et exécuter cette tâche dans une partition distincte.

== Corruption mémoire <mirageos_memory_corruption>

La gestion de la corruption mémoire est généralement déléguée à
l'environnement d'exécution de l'_unikernel_.

Pour la journalisation des événements, il suffirait de se reposer sur le support
offert par le système exécuté dans _dom0_. Par exemple, dans le cas de _Xen_
avec un noyau _Linux_ dans _dom0_, on pourrait utiliser les sous-systèmes
décrits dans la sous-section @linux_memory_corruption et les @ipc de _Xen_ pour
récupérer ces informations dans l'_unikernel_.

== Perte du flux d'exécution <mirageos_hijacking_criteria>

Le _typechecker_ _OCaml_ garantit à la compilation la sûreté des types. Une
donnée d'un type A ne peut pas être accédée par une série d'instructions
attendant une donnée d'un autre type B. En particulier la représentation machine
des données est compatible avec celle attendue par les instructions qui y
accèdent.

Le @runtime _OCaml_ garantie à l'exécution l'absence de dépassement de tampon
en insérant des vérifications aux endroits appropriés. En cas d'erreur, une
exception est levée par le @runtime et met généralement fin à l'exécution du
programme.

Ces deux garanties éliminent une grande partie des vecteurs d'attaques de
la pile d'exécution. Bien sûr, d'autres stratégies d'atténuation peuvent être
mise en place au niveau de l'hyperviseur.

== Écosystème <mirageos_ecosystem>

Le profilage et le débogage d'un _unikernel_ dépend fortement de
l'environnement dans lequel il est exécuté. Pour _MirageOS_, le cas le plus
favorable est celui d'une distribution _GNU/LINUX_, puisqu'il y existe pléthore
d'outils, voir la sous-section @linux_ecosystem. Le manuel _OCaml_ contient
également un guide pour le profilage avec _perf_ de programmes _OCaml_
@ocaml_profiling.

Il existe aussi quelques outils spécifiques à _MirageOS_ ou au langage _OCaml_:
- #box[_mirage-monitoring_ @mirageos_mirage_monitoring: Outil de monitoring
  pour les _unikernels_ produits par _MirageOS_. Il supporte le _dashboard_
  _Telegraph_ de _Grafana_,]
- #box[_memtrace_ @memtrace_github: Profileur mémoire pour le langage _OCaml_
  développé par l'entreprise _Janestreet_. Il permet de générer une trace
  compacte de l'utilisation de la mémoire par un programme _OCaml_. La trace
  produite peut ensuite être explorée avec _memtrace_viewer_
  @memtrace_viewer_github. Il existe une bibliothèque _MirageOS_
  _memtrace-mirage_ @mirageos_memtrace_mirage qui offre un support pour cet
  outil dans un _unikernel_,]
- #box[_memtrace_viewer_ @memtrace_viewer_github: Outil d'exploration de
  traces produites par _memtrace_,]
- #box[_mirage-profile_ @mirageos_mirage_profile: Profileur pour les programmes
  _OCaml_ utilisant la bibliothèque _Lwt_ et en particulier les _unikernels_ de
  _MirageOS_. Sa conception et des exemples d'utilisation sont exposés dans un
  article de blog @mirageos_visualising_lwt. Le projet ne semble plus être
  maintenu,]
- #box[_mirage-trace-viewer_ @mirageos_mirage_trace_viewer: Outil de
  visualisation des traces produites par _mirage-profile_ ou
  _mirage-trace-dump-xen_.]

=== Profilage mémoire avec `memtrace-mirage`

L'exemple @example_memtrace_mirage illustre l'utilisation de `memtrace-mirage`
dans un _unikernel_. La fonction `start` est le point d'entrée de l'_unikernel_.
Cette fonction commence par établir un socket `TCP` à l'adresse `10.0.0.1:24`
#footnote[L'adresse `10.0.0.1` est l'adresse _IP_ par défaut utilisée par la
bibliothèque `mirage-tcp-ip`.]. Lorsqu'un client établit une connexion,
`memtrace` est lancé jusqu'à ce que la connexion soit interrompue. La fonction
`alloc` est exécutée de façon concurrentielle afin de produire un grand
nombre d'allocations. L'exécution de l'_unikernel_ se termine après 100 secondes.

#figure(
  snippet("./mirageos/examples/memtrace/config.ml", lang: "ocaml"),
  caption: [Configuration de l'_unikernel_]
)

#figure(
  snippet("./mirageos/examples/memtrace/unikernel.ml", lang: "ocaml"),
  caption: [Exemple d'utilisation de `memtrace-mirage`]
) <example_memtrace_mirage>

Voyons comment exécuter cet exemple pas à pas. On commence par créer
l'unikernel à l'aide de l'image docker, puis on lance cet unikernel dans un
domaine de _Xen_:
```console
make -C mirageos build-memtrace
cd mirageos/unikernels/memtrace
sudo xl create memtrace.xl -c
```
On peut alors récupérer la trace produite par `memtrace` en établissant dans
autre terminal une connexion sur `10.0.0.2:1234`:
```console
nc 10.0.0.2 1234 > mirageos/trace
```
Finalement, on peut lancer une instance de `memtrace-view`:
```console
make -C mirageos memtrace-viewer
```
Cette commande lance un serveur web écoutant sur l'adresse `localhost:8080`.

#warning[incompatibilité avec OCaml 5][
  Le module `Gc.Memprof` nécessaire à `memtrace` ne fonctionne plus en OCaml 5
  car le fonctionnement du ramasse-miette a été changé en profondeur. Des
  efforts sont en cours pour restaurer cette fonctionnalité dans une version
  ultérieure du compilateur OCaml.
]

== Masquage des interruptions <mirageos_interrupt_masking>

Il ne semble pas exister de bibliothèque MirageOS pour le masquage
d'interruption. Cela n'est pas étonnant puisque le masquage des interruptions
est plutôt utilisé dans un contexte multi-thread avec de la préemption. Or
le modèle de concurrence de MirageOS est souvent mono-thread et sans préemption.
La préemption est assurée au niveau de l'hyperviseur sur lequel l'_unikernel_
s'exécute.

== Watchdog <mirageos_watchdog>

_MirageOS_ ne semble pas offrir d'@api en OCaml pour interagir avec un _watchdog_.
Le support est donc dépendant de l'environnement dans lequel l'image est exécutée.

Dans le cas de l'hyperviseur _Xen_, il suffit d'appeler les fonctions C de la
bibliothèque _xencontrol_ comme illustré dans la @xen_watchdog_example à travers
des _bindings_ en OCaml. De tels _bindings_ existent déjà dans le dossier
`tools/ocaml/` du dépôt _Xen_.

== Temps de démarrage <mirageos_boot_time>

Le temps de démarrage de _MirageOS_ est un enjeu important pour ses applications
dans le _cloud computing_. Ainsi le temps de démarrage d'un _unikernel_ produit
par _MirageOS_ a fait l'objet de plusieurs études.

Dans l'article fondateur @madhavapeddy2013unikernels, les auteurs ont étudiés
le temps de démarrage d'_unikernels_ _MirageOS_ et d'un serveur _Apache_ sous
_Debian_ virtualisés dans des partitions _Xen_. Les _unikernels_ démarraient
deux fois plus vite que la combinaison _Debian/Apache_. Un gain substantiel
vient de l'optimisation de la _toolstack_ de _Xen_, permettant aux
_unikernels_ de démarrer en seulement 50ms.

Dans @madhavapeddy2015jitsu, les auteurs ont étudié le temps de démarrage
d'_unikernels_ _MirageOS_ sur un hyperviseur _Xen_ avec une pile logicielle
optimisée. Ils sont parvenus sur des temps de démarrage à froid inférieurs à
350 ms sur _ARM_ et 30ms sur _x86_.

En conclusion, le temps de démarrage de _MirageOS_ peut être rendu très faible
et négligeable face du démarrage de la partition elle-même. L'enjeu est donc
d'optimiser le temps de démarrage de cette dernière.

== Qualifications et certifications <mirageos_certifications>

À notre connaissance, _MirageOS_ n'a pas fait l'objet de certifications.
L'objectif premier de _MirageOS_ est davantage la sécurité que la sûreté de
fonctionnement, il pourrait faire donc l'objet de certifications comme celles
décrites dans les Critères Communs (niveau _EAL_) mais rien de tel semble avoir
été entrepris jusqu'à présent.

== Maintenabilité <mirageos_maintainability>

Le code de _MirageOS_ est publié sous la licence _ISC_ avec certaines parties
sous licence _LGPLv2_. L'utilisation d'une licence _Open Source_ permissive
comme _ISC_ est nécessaire car l'_unikernel_ produit par _MirageOS_ est lié
statiquement avec les bibliothèques. Grâce à cette licence, l'utilisateur n'a
pas les contraintes des licences _GPL_ lorsqu'il distribue son _unikernel_.

Le projet a été initié en 2009, ce qui en fait un projet relativement
jeune avec environ 16 ans d'existence.

_MirageOS_ est en majorité écrit en OCaml, un langage de haut niveau qui offre
de bonne garantie du point de vue de la sûreté des types et de la mémoire.
À ce jour le dépôt https://github.com/mirage/mirage est constitué à 99% de code
OCaml pour un total de 9075 _SLOC_.

Cette valeur doit être considérée avec prudence puisqu'un véritable projet devra
certainement utiliser d'autres bibliothèques de _MirageOS_ pour fonctionner.

De plus la totalité de l'_unikernel_ produit ne provient pas de la compilation
de codes _OCaml_. Il subsiste plusieurs parties en langage C et notamment:
- L'environnement d'exécution du langage OCaml est écrit en C. Cela inclut
  en particulier son ramasse-miette,
- Quelques bibliothèques en C comme _GMP_ au travers de _Zarith_. Leur
  réécriture en OCaml est théoriquement possible mais nécessiterait un effort
  considérable en pratique,
- Les pilotes doivent être écrits dans un langage bas niveau comme le langage C.

_MirageOS_ bénéficie d'un support commercial de l'entreprise _Tarides_, qui
maintient activement le projet et propose des services de conseil et de
développement autour de la technologie _MirageOS_. La _MirageOS Core Team_,
composée d'universitaires et d'ingénieurs du secteur privé, assure la
maintenance continue du projet.

_MirageOS_ a été utilisé dans plusieurs projets d'envergures. Récemment
l'entreprise _Tarides_ a développé le système d'exploitation _SpaceOS_ pour
des applications spatiales et satellitaires @spaceos_tarides @spaceos_satellite.
Il s'agit d'une solution sécurisée et efficace pour les satellites
multi-utilisateurs et multi-missions, construite sur la technologie des
_unikernels_.

_SpaceOS_ a été conçu en partenariat avec plusieurs organisations du secteur
spatial (L'_ESA_ (_European Space Agency_), Le _CNES_, _Thales Alenia Space_
,_OHB_ , _Eutelsat_, Le _Singapore Space Agency_).

Le 15 mars 2025, _OCaml_ a été lancé dans l'espace à bord de la mission
_Transporter-13_. _DPhi Space_ a embarqué son ordinateur _Clustergate_ sur ce
vol, et l'équipe _SpaceOS_ a déployé un logiciel basé sur _OCaml 5_ sur le
satellite. Cette mission a démontré la viabilité des _unikernels_ _MirageOS_
pour les applications spatiales en conditions réelles.

Les principaux avantages de _SpaceOS_ incluent notamment:
- Une réduction de taille d'un facteur 20 par rapport à un déploiement basé sur
  des conteneurs _Linux_,
- Une sécurité accrue grâce à l'utilisation d'un langage à gestion mémoire
  sûre (_OCaml_),
- Une architecture modulaire permettant de compiler uniquement les
  fonctionnalités nécessaires du système d'exploitation.

Ces résultats ont valu à _SpaceOS_ une reconnaissance industrielle
significative, notamment le prestigieux _Airbus Innovation Award_ lors de la
_Paris Space Week_ 2024.

= PikeOS <pikeos>

#showybox(
  title: "PikeOS en bref",
  frame: (
    border-color: orange.darken(20%),
    title-color: orange.lighten(80%),
    body-color: orange.lighten(95%)
  )
)[
  - *Type* : RTOS + Hyperviseur type 1 (inspiré du micronoyau L4)
  - *Langage* : C
  - *Architectures* : x86-64, ARMv7/v8, PowerPC, RISC-V, SPARC
  - *Usage principal* : Systèmes critiques (aéronautique, automobile, défense,
    médical)
  - *Points forts* : Conçu pour la certification, paravirtualisation + HVM,
    support multi-criticité
  - *Limitations* : Propriétaire, coût de licence
  - *Licences* : Propriétaire (SYSGO/Thalès)
  - *Certifications* : Kits disponibles pour DO-178B/C, IEC 61508, ISO 26262
]

_PikeOS_ est un hyperviseur temps réel dédié à l'embarqué.

À la fin des années 90, l'entreprise _SYSGO_ développait son propre
micronoyau baptisé _P4_ et inspiré du noyau _L4_ de Jochen Liedtke
@kaiser2007evolution. À cette époque, l'usage de micronoyaux dans l'embarqué
est envisagé du fait de l'augmentation des performances et du besoin croissant
de fiabilité dans les logiciels embarqués. Contrairement à la majorité des
implémentations du micronoyau _L4_ de l'époque, _P4_ était donc conçu pour
l'embarqué et était totalement préemptif pour des usages temps réel. Cette
expérience a permis aux ingénieurs de _SYSGO_ d'identifier
des limites dans la conception du noyau _P4_, principalement héritées de l'@api
de _L4_. Ces limites concernaient notamment l'isolation temporelle et spatiale.

Les ingénieurs de _SYSGO_ ont alors développé un nouveau micronoyau _PikeOS_
avec pour objectif de garantir l'isolation des tâches afin de l'utiliser dans
des systèmes de criticité mixte. L'idée était de développer un hyperviseur
pour assurer l'isolation de partition. La plateforme a également été pensée pour
faciliter la certification des produits finaux. La première version est
commercialisée en 2005.

En 2006, _SYSGO_ ajoute le support de l'architecture _ARM_.

En 2008, l'avioneur _Airbus_ choisit _PikeOS_ comme plateforme de référence
_DO-178B_ pour le système _FSA-NG_ de l'_A350_.

En 2012, l'entreprise _Thales_ acquière _SYSGO_.

En 2022, _PikeOS 5.1.3_ obtient la certification de sécurité _Critères Communs_ au
niveau _EAL 5+_ pour les architectures _x86-64_, _ARMv8_ et _PowerPC_ @pikeos_cc_eal5_cert.

== Architectures supportées <pikeos_architectures>

_PikeOS_ supporte les architectures suivantes: _x86-64_, _ARMv7_, _ARMv8_,
_PowerPC_, _RISC-V_ et _SPARC_ @pikeos_architectures_page. Le support pour
l'architecture _ARM_ existe depuis 2006. En particulier, _PikeOS_ supporte les
architectures _SPARC_ _LEON3_ et _LEON4_ utilisés dans le spatial.

Quant à son hyperviseur, il propose un support pour la virtualisation matérielle
sur les architectures _ARM v7_ @pikeos_hwvirt_armv7 et _x86-64_
@pikeos_hwvirt_x86.

Le support matériel se fait via des @bsp et _SYSGO_ propose le développement
de nouveau @bsp à la demande.

== Support multi-processeur <pikeos_multiprocessor>

=== Architectures @smp <pikeos_smp>

_PikeOS_ dispose d'un support les architectures @smp.

Le support @smp a été amélioré dans _PikeOS 4.2_. Afin de garantir un
déterminisme suffisant et des estimations @wcet suffisamment fines, _PikeOS_
avait recours à un verrou global similaire au @bkl de _Linux_
(voir la sous-section @linux_smp). Ce verrou assurait que
les sections critiques du micronoyau ne pouvaient pas s'exécuter en parallèle.
Depuis la version _4.2_, _PikeOS_ utilise un système de verrouillage plus fin
qui permet aux appels systèmes de s'exécuter en parallèle s'ils n'utilisent pas
des ressources en commun @pikeos_granularity.

_PikeOS_ peut également être configuré pour invalider les caches et la @tlb
lorsqu'il bascule d'une partition temporelle à une autre
@pikeos_safe_real_time_scheduling.

=== Architectures @amp <pikeos_amp>

L'entreprise _SYSGO_ propose une version spéciale de _PikeOS_ baptisée _PikeOS
for MPU_. Cette édition de l'hyperviseur est dédiée aux plateformes @mpsoc équipées
de _MPU_ et offre en particulier un support pour des architecture @amp. Il supporte les
architectures _ARMv7-R_, _ARMv8-R_ et dispose de @bsp les @mpsoc _NG-Ultra_ et
_AMD Zynq Ultrascale+_.

== Partitionnement <pikeos_space>

_PikeOS_ offre une solide isolation spatiale et temporelle de ses partitions.
Sa conception est inspirée de la norme avionique _ARINC 653_ pour les systèmes
temps réel. Toutefois _PikeOS_ ne se conforme pas à celle-ci.

=== Partitionnement spatial <pikeos_space_isolation>

Le noyau de séparation de _PikeOS_ garantit une isolation stricte de la
mémoire entre les partitions @pikeos_security_target_v5. Cette isolation a
fait l'objet d'une vérification formelle au niveau du code source
@pikeos_memory_separation. La séparation mémoire a été prouvée formellement en
décomposant les exigences de haut niveau en propriétés fonctionnelles du
gestionnaire de mémoire sous forme d'assertions vérifiables.

La version standard de _PikeOS_ utilise un @mmu pour créer des espaces
d'adressages virtuels et contrôler les accès mémoires. Pour les systèmes
embarqués dépourvus de @mmu, _SYSGO_ propose _PikeOS for MPU_. Cette version
fonctionne sur des architectures _ARM_ de type @mpsoc. À notre connaissance,
il n'y a pas de support pour des architectures dépourvues de tout contrôle
mémoire.

=== Partitionnement temporel <pikeos_temporal_isolation>

_PikeOS_ utilise un ordonnanceur hiérarchique breveté à double niveau inspiré de
la norme _ARINC 653_ @pikeos_safe_real_time_scheduling. Cette architecture combine
un partitionnement temporel strict au niveau des partitions avec une flexibilité
d'ordonnancement au niveau des threads.

Au premier niveau, l'ordonnanceur distribue statiquement le temps _CPU_ selon un
schéma cyclique _TDM_ (_Time Division Multiplexing_). Le cycle complet est
subdivisé en fenêtres temporelles de durées variables, chacune allouée à une
partition spécifique. Cette configuration statique garantit un ordonnancement
déterministe avec une granularité jusqu'à 250 µs.

Au second niveau, _PikeOS_ propose plusieurs politiques d'ordonnancement pour
les threads au sein de chaque partition:
- #box[_Fixed-priority preemptive scheduling_: l'ordonnanceur sélectionne
  toujours le thread avec la plus haute priorité et permet la préemption,]
- #box[_Earliest Deadline First_ (_EDF_): permet de prioriser dynamiquement les
  threads selon leurs échéances.]

Cette architecture à deux niveaux permet de supporter simultanément des
applications de criticités différentes tout en garantissant l'isolation
temporelle nécessaire pour les systèmes temps réel.

=== Déterminisme <pikeos_determinism>

_PikeOS_ a été conçu dès l'origine pour offrir un comportement déterministe
adapté aux exigences temps réel dur. Contrairement aux premiers micronoyaux de
la famille _L4_, le micronoyau _PikeOS_ est totalement préemptif
@kaiser2007evolution, éliminant les sections non préemptibles qui pouvaient
introduire de la gigue et empêcher une estimation précise du @wcet.

Le déterminisme de _PikeOS_ repose sur des latences bornées, inhérentes à sa
conception microkernel. En limitant les fonctionnalités du noyau aux services
essentiels, _PikeOS_ élimine les éléments non déterministes tels que
l'allocation dynamique de mémoire dans les chemins d'exécution critiques. Le
partitionnement temporel @pikeos_safe_real_time_scheduling garantit un
ordonnancement déterministe avec une précision de l'ordre de la microseconde.

L'ordonnancement au sein des partitions utilise un mécanisme préemptif à
priorités fixes et supporte également des politiques d'ordonnancement de type
_EDF_ (_Earliest Deadline First_).

Enfin, _PikeOS_ peut être configuré pour invalider les caches et la @tlb lors
des changements de partition temporelle @pikeos_safe_real_time_scheduling afin
d'éliminer les interférences entre partitions, ce qui améliore la prévisibilité
des temps d'exécution pour des analyses @wcet très conservatrices.

=== OS invités supportés

L'hyperviseur de _PikeOS_ supporte les OS invités#footnote[Ils sont appelés
_GuestOS_ dans la documentation.] suivants:
- #box[_ELinOS_ est supporté par _PikeOS_. Il s'agit d'une distribution
_Linux_ pour l'embarqué temps réel développé par _SYSGO_ @pikeos_elinos.
Elle peut être exécutée aussi bien dans une partition paravirtualisée qu'une
partition virtualisée par le matériel. _SYSGO_ offre un support pour chaque
version d'une durée de 5 ans extensible,]
- #box[_RTEMS_ est supporté par _PikeOS_ depuis 2010 @pikeos_rtems_leon. Il
est en particulier possible de l'utiliser sur la plateforme _LEON_,]
- #box[Les systèmes qui se conforment à _POSIX_ comme _Linux_ ou _Android_,]
- #box[_Windows_ est supporté dans les partitions assistées par le matériel
sur _x86_ @pikeos_windows.]

== Corruption mémoire <pikeos_memory_corruption>

_PikeOS_ ne semble pas fournir d'@api unifiée pour la gestion des erreurs mémoire
@ecc au niveau du noyau de séparation. La documentation publique de _SYSGO_ ne
détaille pas de mécanisme centralisé de journalisation des erreurs mémoire
comparable à _EDAC_ sous _Linux_ ou au _Health Monitor_ d'_XtratuM_ pour les
erreurs mémoire.

La gestion de la corruption mémoire dans _PikeOS_ s'effectue à plusieurs
niveaux:
- #box[Le @bsp (_Board Support Package_) peut intégrer un support pour les contrôleurs
mémoire @ecc spécifiques à la plateforme. Par exemple, pour les processeurs _LEON_ _SPARC_
que _PikeOS_ supporte @pikeos_rtems_leon, les versions durcies comme le _LEON3FT_
et le _LEON5_ intègrent des mécanismes matériels de correction d'erreurs et de
_scrubbing_ automatique de la mémoire cache pour prévenir l'accumulation d'erreurs
dues aux radiations spatiales @leon_radiation. Ces fonctionnalités sont accessibles
via l'@api du @bsp _LEON_ de _PikeOS_.]
- #box[Les systèmes d'exploitation invités (_GuestOS_) peuvent implémenter leur propre
gestion des erreurs mémoire. Ainsi, lorsque _PikeOS_ exécute _ELinOS_ (une distribution
_Linux_ embarqué développée par _SYSGO_) dans une partition, ce système invité peut
utiliser le sous-système _EDAC_ de _Linux_ pour détecter et journaliser les erreurs
mémoire @ecc, comme décrit dans @linux_memory_corruption.]
- #box[Le _Health Monitor_ de _PikeOS_ permet la détection d'erreurs et la gestion
des fautes au niveau des partitions @pikeos_health_monitor. Bien que les détails
techniques ne soient pas publiquement documentés, ce mécanisme peut être configuré
pour réagir aux erreurs matérielles, y compris potentiellement les erreurs mémoire
critiques.]

Cette approche décentralisée est cohérente avec l'architecture de noyau de séparation
de _PikeOS_, où chaque partition est isolée et peut avoir des exigences différentes
en matière de gestion d'erreurs selon son niveau de criticité.

== Écosystème <pikeos_ecosystem>

_PikeOS_ est livré avec un ensemble d'outils de développement, incluant
un @ide, des outils de débogage et de simulation. _SYSGO_ a également
noué un certain nombre de partenariats avec d'autres entreprises
pour développer des outils pour _PikeOS_ @pikeos_partenariat. Nous
avons ainsi pu identifier les outils suivants: _CODEO_, _RVS_ et _TRACE32_.

_PikeOS_ étant propriétare, son écosystème est limité à cette offre
logicielle.

=== _CODEO_
La société _SYSGO_ propose un @ide baptisé _CODEO_ @pikeos_codeo
@pikeos_codeo_pikeos et basé sur l'@ide Eclipse. Il permet entre autres de:
- Développer une application en _C_ ou _C++_ pour _PikeOS_,
- Configurer les partitions et la politique d'ordonnancement statiquement,
- #box[Visualiser les partitions en cours d'exécution et les activer ou les
désactiver,]
- #box[Débogueur une application tournant sur _PikeOS_ à distance via un
support du débogueur du plugin _CDT_ d'Eclipse,]
- #box[Tracer des événements provenant du noyau _PikeOS_ ou de l'application
utilisateur,]
- #box[Émulation via _QEMU_ pour le prototypage.]

L'outil est également compatible avec _ELinOS_ @pikeos_codeo_elinos.

=== _Rapita Verification Suite_

La suite logicielle _RVS_ (_Rapita Verification Suite_) développée par
_Rapita Systems_ permet la vérification de logiciels embarqués critiques
directement sur la cible. En particulier, la suite comprend des analyses pour:
- Le temps d'exécution @wcet,
- La couverture d'un jeu de tests,
- Couplage des données et du flot de contrôles.
Il produit des preuves pour les certifications _DO-178C_ et _ISO 26262_. À ce
titre _SYSGO_ propose un partenariat avec _RVS_ afin de faciliter ces
certifications @pikeos_rapita_systems @pikeos_rapita_systems2.

=== _TRACE32_

L'outil _TRACE32_ développé par l'entreprise _Lauterbach_ comprend un
débogueur et un traceur @pikeos_trace32. Il permet un débogage de l'intégralité
de la pile logicielle, de l'application utilisateur jusqu'au pilotes. L'outil
supporte _PikeOS_ depuis plus de 15 ans.

== Gestion des interruptions <pikeos_interrupt_managing>

== Perte du flux d'exécution <pikeos_flow_hijacking>

_PikeOS_ n'utilise pas les contremesures classiques (_ASLR_, _DEP_, _stack
canaries_, _CFI_) car il adopte une approche de sécurité par isolation
architecturale via un noyau de séparation certifié _Common Criteria EAL 5+_
@pikeos_security_target_v5 @pikeos_wikipedia. La protection repose sur:
- La séparation spatiale et temporelle stricte via des partitions
  logicielles @pikeos_security_target @pikeos_cc_eal5_cert,
- L'utilisation de _MMU_/_MPU_ pour l'isolation matérielle
  @pikeos_security_target_v5,
- Une politique de liste blanche pour la communication inter-partition
  @pikeos_security_target,
- La prévention de propagation d'erreurs entre partitions
  @pikeos_security_target_v5.

== _Watchdog_ <pikeos_watchdog>

Nous n'avons pas trouvé d'informations sur un support _watchdog_ dans _PikeOS_.
Il est probable que ce support est relatif à chaque @bsp et présent pour
certains d'entre eux étant donné le domaine d'application de ce système
d'exploitation.

== Programmation @baremetal <pikeos_baremetal>

Il est possible d'exécuter des applications @baremetal dans les partitions
de _PikeOS_ à condition d'adapter un @rte du langage de programmation pour
l'@api _PikeOS native_. Cette @api n'étant pas librement accessible, de
tels @rte n'existent que via des projets internes à _SYSGO_ ou des partenariats
avec d'autres entreprises. Nous avons pu recenser les @rte suivants:
- #box[Les langages _C_ et _C++_ sont supportés via respectivement les @rte
_CENV_ et _CPPENV_. Ces environnements sont livrés avec _CODEO_.]
- #box[Le langage _Ada_ est supporté via des @rte développés en partenariat
avec d'autres entreprises @pikeos_aonix @pikeos_adacore. Le @rte développé par
_AdaCore_ supporte le profile _Ravenscar_. Il s'agit d'un sous-ensemble strict
du langage _Ada_ pour le temps réel, limitant le parallélisme afin de permettre
des analyses plus fines @pikeos_adacore.]
- #box[Le langage _Rust_ est supporté @pikeos_rust.]
- #box[Le langage _SCADE_ est supporté via un partenariat avec l'entreprise
_Ansys_ @pikeos_scade.]

Nous n'avons pas trouvé d'information concernant _OCaml_ sur _PikeOS_ et ce
support n'existe probablement pas.

== Temps de démarrage <pikeos_boot_time>

Nous n'avons pas trouvé d'informations concernant le temps de démarrage de
l'hyperviseur _PikeOS_ ou de ses partitions. L'usage de _PikeOS_ dans
l'embarqué laisse présager des temps de démarrage réduits.

== Maintenabilité <pikeos_maintainability>

_PikeOS_ est un logiciel propriétaire aux sources fermées. L'entreprise _SYSGO_
ne semble pas communiquer sur ses licences. Les modalités et les tarifs des
licences sont certainement à négocier au cas par cas.

_PikeOS_ a été commercialisé pour la première fois en 2005, ce qui en fait un
système avec environ 20 ans d'existence.

Le système d'exploitation bénéficie d'un écosystème solide dans les domaines
critiques, notamment l'aéronautique (avec _Airbus_ qui l'a choisi comme
plateforme de référence pour l'_A350_), l'automobile, le ferroviaire et le
médical.

Le noyau _PikeOS_ a été conçu pour faciliter la certification des systèmes qui
l'intègrent. Il propose de nombreux kits de certification pour différents
secteurs industriels critiques @pikeos_certkits:
- Pour l'aéronautique et le spatial avec _DO-178C_ jusqu'au niveau
  _DAL A_ (_Design Assurance Level A_),
- Pour le ferroviaire avec _EN 50128_, _EN 50657_ jusqu'au niveau _SIL 4_
  (_Safety Integrity Level 4_) et _EN 50716_,
- Pour l'automobile avec _ISO 26262_ jusqu'au niveau _ASIL D_ (_Automotive
  Safety Integrity Level D_),
- Pour l'industrie avec _IEC 61508_ jusqu'au niveau _SIL 3_
  (_Safety Integrity Level 3_).

_PikeOS_ 5.1.3 a obtenu la certification Critères Communs (_ISO 15408_)
au niveau _EAL 5+_ pour les architectures _ARMv8_, _x86-64_ et _PowerPC_
@pikeos_cc_eal5_cert.

Ces kits impliquent l'existence d'une documentation technique détaillée. En
effet, ces normes exigent une traçabilité complète des exigences, une
documentation du cycle de vie du logiciel, ainsi que des manuels de sûreté et
de sécurité. _SYSGO_ fournit d'ailleurs des kits de certification incluant une
aide documentaire complète pour le développement et les tests.

Nous n'avons pas pu évaluer la taille de la base de code, faute d'informations
librement accessibles. Toutefois, au vu des nombreuses certifications et de sa
conception inspirée du micronoyau _L4_, nous spéculons que le noyau de
_PikeOS_ est probablement de petite taille, c'est-à-dire de l'ordre quelques
dizaines de milliers de lignes de code.

Le support commercial de _PikeOS_ est assuré par _SYSGO_, filiale du groupe
_Thales_ depuis 2012. Cette acquisition par un acteur majeur de la défense et
de l'aérospatial est un gage de pérennité du produit.

= ProvenVisor <provenvisor>

#showybox(
  title: "ProvenVisor en bref",
  frame: (
    border-color: green.darken(20%),
    title-color: green.lighten(80%),
    body-color: green.lighten(95%)
  )
)[
  - *Type* : Hyperviseur type 1 vérifié formellement (+ micronoyau ProvenCore)
  - *Langage* : C
  - *Architectures* : ARM v8-A (avec support MMU)
  - *Usage principal* : Systèmes embarqués critiques, IoT sécurisé, isolation forte
  - *Points forts* : TCB minimal, vérification formelle, intégration ProvenCore (micronoyau prouvé), conteneurs sécurisés
  - *Limitations* : Propriétaire, ARM uniquement
  - *Licences* : Propriétaire (ProvenRun)
  - *Certifications* : Processus de certification en cours
]

_ProvenVisor_ est un hyperviseur de type 1 développé par l'entreprise _ProvenRun_.
Il se place comme un concurrent de _Xen_ avec pour différence d'avoir un @tcb plus
réduit et d'être vérifié grâce à des méthodes formelles. Sa cible est le marché de
l'@ido sur des microprocesseurs _ARM_.

_ProvenVisor_ a été développé pour être combiné avec _ProvenCore_. _ProvenCore_
est un noyau sécurisé et prouvé. @tee

À ce titre _ProvenVisor_ est comparable à _seL4_ car tous les deux cherchent à
offrir le plus petit @tcb possible.

_ProvenCore_ est un micronoyau qui cherche à la fois à minimiser la taille du code
et la surface d'attaque (les deux allant souvent de pair). Il propose des containeurs
sécurisé avec la possibilité de communiquer de façon sécuriser entre eux. Il a
fait l'objet d'une vérification formelle @lescuyer2015provencore.

_ProvenVisor_ est développé par l'entreprise _ProvenRun_ qui est spécialisée
dans la sécurité et les systèmes embarqués critiques.

== Architectures supportées <provenvisor_architectures>

L'hyperviseur est disponible sur l'architecture _ARM v8-A_. Il offre un support
pour le _MMU_ sur cette architecture.

_ProvenCore_ est conçu pour fonctionner avec le @tee _TrustZone_ de
l'architecture _ARM_.

== Certifications <provenvisor_certifications>

_ProvenVisor_ a été conçu dès le départ avec les certifications de haut niveau en
tête. L'hyperviseur bénéficie d'une vérification formelle, ce qui facilite grandement
le processus de certification pour les niveaux les plus exigeants des _Critères Communs_.

_ProvenVisor_ permet d'atteindre le niveau _EAL5_ (_Evaluation Assurance Level 5_) des
_Critères Communs_ @provenrun_homepage. Ce niveau nécessite une conception semi-formelle et
une analyse rigoureuse de la sécurité. Le fait que _ProvenVisor_ soit vérifié
formellement le place dans une position favorable pour les certifications de haut niveau.

Il est important de noter que _ProvenCore_, le micronoyau prouvé qui accompagne
_ProvenVisor_, a obtenu la certification _Common Criteria EAL7_ @provencore_eal7, le
niveau d'assurance le plus élevé. Cette certification démontre la maturité des
méthodes de vérification formelle employées par _ProvenRun_ et renforce la confiance
dans l'ensemble de leur écosystème de sécurité

== Support multi-processeur <provenvisor_multiprocessor>

_ProvenVisor_ est conçu pour fonctionner sur des architectures _ARM_ modernes qui
incluent généralement plusieurs cœurs de processeur. L'hyperviseur tire parti des
extensions de virtualisation de l'architecture _ARMv8-A_ qui sont présentes sur les
processeurs multi-cœurs.

Bien que les détails techniques spécifiques du support multi-processeur ne soient pas
largement documentés publiquement, l'architecture _ARM Cortex-A_ ciblée par
_ProvenVisor_ supporte nativement les configurations @smp. L'hyperviseur utilise les
capacités du _GICv2_ ou _GICv3_ (_Generic Interrupt Controller_) avec extensions de
virtualisation @provenrun_homepage, qui sont essentielles pour la gestion des
interruptions dans un environnement multi-cœur.

Le support du _PSCI_ (_Power State Coordination Interface_) version 1 indique également
que _ProvenVisor_ peut gérer l'allumage et l'extinction des cœurs individuels, une
fonctionnalité importante pour les systèmes multi-processeurs @provenrun_homepage.

== Partitionnement <provenvisor_isolation>

=== Partitionnement spatial <provenvisor_spatial_isolation>

_ProvenVisor_ assure un partitionnement spatial strict entre ces machines
virtuelles en se reposant sur les mécanismes matériels des architectures _ARM_.
L'hyperviseur supporte les @mmu de _ARM_ @provenrun_homepage.

La technologie _TrustZone_ d'_ARM_ assure la séparation entre le _Normal world_
(VMs sous _ProvenVisor_) et le _Secure world_ (processus sous _ProvenCore_),
fournissant un environnement d'exécution de confiance complètement isolé.

Les communications inter-invités ne sont autorisées qu'après autorisation
explicite @provenrun_homepage, garantissant qu'aucune fuite d'information ne
peut se produire entre les VMs sans configuration intentionnelle.

=== Partitionnement temporel <provenvisor_temporal_isolation>

Les informations publiquement disponibles sur le partitionnement temporel de
_ProvenVisor_ sont très limitées. Étant un hyperviseur, il est certain qu'il
dispose de mécanismes pour partager le temps d'exécution entre ses partitions.

=== Déterminisme <provenvisor_determinism>

Le déterminisme dans _ProvenVisor_ découle de sa conception minimale et de sa
vérification formelle. Un @tcb réduit signifie moins de chemins d'exécution possibles
dans le code de l'hyperviseur, ce qui facilite l'analyse du comportement temporel.

La vérification formelle de _ProvenVisor_ contribue également au déterminisme. En
prouvant mathématiquement les propriétés du système, on s'assure que le comportement de
l'hyperviseur est prévisible et conforme à sa spécification. Cela est particulièrement
important pour les systèmes critiques où un comportement non déterministe pourrait
conduire à des défaillances catastrophiques.

L'utilisation des extensions de virtualisation matérielle d'_ARM_ aide également à
maintenir un comportement déterministe. Ces extensions permettent aux VMs de s'exécuter
avec un minimum d'interventions de l'hyperviseur, réduisant ainsi les sources de
variabilité temporelle.

Cependant, il convient de noter que les informations publiques sur les analyses @wcet
ou les garanties temps réel spécifiques de _ProvenVisor_ sont limitées. Pour des
applications nécessitant des garanties temps réel strictes, il serait nécessaire de
consulter la documentation technique détaillée de _ProvenRun_.

== Corruption mémoire <provenvisor_memory_corruption>

_ProvenVisor_ intègre plusieurs mécanismes pour prévenir la corruption mémoire:

La vérification formelle de _ProvenVisor_ est le premier rempart contre la corruption
de la mémoire. En prouvant mathématiquement l'absence de certaines classes de bugs, on
élimine les erreurs de programmation qui pourraient conduire à des corruptions
mémoire, telles que les dépassements de tampon, les utilisations après libération
(_use-after-free_), ou les double libérations.

Le @tcb minimal réduit la surface d'attaque. Moins il y a de code, moins il y a
d'opportunités pour des bugs de corruption mémoire. Cette approche minimaliste est un
principe fondamental de la conception de _ProvenVisor_.

Les mécanismes matériels de protection mémoire de l'architecture _ARM_ sont pleinement
exploités. Le support du _MMU_ et du _SMMU_ permet de configurer des permissions
d'accès granulaires pour chaque région mémoire. Les tentatives d'accès non autorisées
déclenchent des exceptions qui peuvent être interceptées par l'hyperviseur.

L'isolation fournie par _TrustZone_ ajoute une couche supplémentaire de protection. Le
_Secure world_ et le _Normal world_ ont des espaces d'adressage physiques séparés, et
le code s'exécutant dans le _Normal world_ ne peut pas accéder à la mémoire du _Secure
world_. Cela protège les composants critiques exécutés sous _ProvenCore_ contre les
corruptions provenant des VMs moins fiables.

Le langage de développement utilisé pour _ProvenVisor_ est le _C_. Bien que ce langage
soit sujet aux erreurs de gestion mémoire, la vérification formelle compense cette
faiblesse en prouvant que le code implémenté ne contient pas ces erreurs.

== Perte du flux d'exécution <provenvisor_flow_hijacking>

La protection contre la perte du flux d'exécution dans _ProvenVisor_ repose sur
plusieurs piliers:

La vérification formelle garantit que le code de l'hyperviseur ne contient pas de
vulnérabilités permettant de détourner le flux d'exécution. Cela inclut les bugs
classiques comme les dépassements de tampon qui pourraient être exploités pour
écraser l'adresse de retour sur la pile.

Les extensions de sécurité de l'architecture _ARMv8-A_ offrent plusieurs protections
matérielles contre le détournement du flux d'exécution. Le bit _NX_ (_No-eXecute_),
également connu sous le nom de bit _XN_ (_eXecute Never_) sur _ARM_, permet de marquer
des pages mémoire comme non exécutables. Cela empêche l'exécution de code injecté dans
des zones de données.

Le _PAN_ (_Privileged Access Never_) sur _ARMv8.1-A_ empêche le code privilégié
d'accéder accidentellement ou malicieusement à la mémoire de l'utilisateur. Bien que
cette fonctionnalité soit principalement destinée aux noyaux de systèmes d'exploitation,
elle peut également être pertinente pour un hyperviseur.

Le _Pointer Authentication_ introduit dans _ARMv8.3-A_ fournit une protection
cryptographique contre la falsification des pointeurs. Chaque pointeur est signé
cryptographiquement lorsqu'il est stocké et vérifié lorsqu'il est utilisé. Toute
tentative de modifier un pointeur sans connaître la clé cryptographique sera détectée.

Le @tcb minimal réduit également le risque de vulnérabilités exploitables. Moins il y a
de code, moins il y a de surface d'attaque pour un adversaire cherchant à détourner le
flux d'exécution.

L'isolation stricte entre les VMs signifie qu'un compromis dans une VM ne permet pas
directement d'attaquer l'hyperviseur ou les autres VMs. Un attaquant devrait d'abord
s'échapper de la VM compromise, ce qui nécessiterait d'exploiter une vulnérabilité
dans _ProvenVisor_ lui-même – une tâche rendue extrêmement difficile par la vérification
formelle.

== Écosystème <provenvisor_ecosystem>

L'écosystème de _ProvenVisor_ est intrinsèquement lié à celui de _ProvenCore_. Les deux
produits sont conçus pour fonctionner ensemble et forment un système de sécurité complet
pour les applications embarquées critiques.

=== Intégration avec _ProvenCore_

_ProvenCore_ est un micronoyau formellement vérifié qui s'exécute dans le _Secure world_
de _TrustZone_ @lescuyer2015provencore. Il fournit des conteneurs sécurisés avec la
possibilité de communiquer de façon sécurisée entre eux. _ProvenVisor_ et _ProvenCore_
collaborent pour offrir une solution complète de sécurité et d'isolation.

L'architecture illustrée dans la montre comment _ProvenVisor_
gère les VMs dans le _Normal world_ tandis que _ProvenCore_ gère les processus
sécurisés dans le _Secure world_. Un moniteur de sécurité coordonne les interactions
entre ces deux mondes.

=== Compatibilité avec les systèmes d'exploitation invités

_ProvenVisor_ est conçu pour s'intégrer de manière transparente avec les systèmes
d'exploitation généralistes courants @provenrun_homepage. Il supporte notamment:

- _Linux_: le système d'exploitation le plus répandu dans l'embarqué peut s'exécuter
comme VM sous _ProvenVisor_.
- _Android_: important pour les applications IoT et les dispositifs connectés.
- D'autres systèmes d'exploitation compatibles _ARM_ peuvent également être hébergés.

Cette compatibilité permet de réutiliser des logiciels existants tout en bénéficiant de
l'isolation et de la sécurité fournies par _ProvenVisor_.

=== Partenariats et support matériel

_ProvenRun_ collabore avec plusieurs acteurs de l'industrie des semi-conducteurs. Leur
partenariat avec _STMicroelectronics_ démontre l'intégration de leurs solutions dans
des plateformes matérielles concrètes @provenrun_st. Des démonstrations sur des modules
_Toradex_ ont également été réalisées @toradex_provenvisor, montrant la portabilité de
la solution sur différentes plateformes _ARM_.

=== Documentation et support

Étant un produit commercial propriétaire, la documentation détaillée et le support
technique de _ProvenVisor_ sont réservés aux clients de _ProvenRun_. Les informations
publiquement disponibles se limitent principalement aux documents marketing et aux
présentations techniques de haut niveau.

== Gestion des interruptions <provenvisor_interrupt_management>

La gestion des interruptions dans _ProvenVisor_ s'appuie sur les capacités de
virtualisation des contrôleurs d'interruptions _ARM_.

_ProvenVisor_ requiert un _GICv2_ ou _GICv3_ (_Generic Interrupt Controller_) avec
extensions de virtualisation @provenrun_homepage. Ces extensions permettent à
l'hyperviseur de présenter des interruptions virtuelles aux VMs invitées sans
intervention logicielle pour chaque interruption, ce qui améliore considérablement les
performances.

Le _GIC_ avec extensions de virtualisation fournit:
- Des interruptions virtuelles qui peuvent être injectées directement dans les VMs par le
matériel, réduisant la latence.
- La capacité de router les interruptions physiques vers les VMs appropriées.
- L'isolation des interruptions entre les VMs, garantissant qu'une VM ne peut pas
voir ou manipuler les interruptions d'une autre VM.

L'hyperviseur peut configurer quelles interruptions physiques sont routées vers quelles
VMs. Certaines interruptions peuvent être réservées à l'hyperviseur lui-même, tandis
que d'autres sont déléguées aux VMs invitées.

Le support du _PSCI_ (_Power State Coordination Interface_) permet également de gérer
les événements liés à l'alimentation et à la gestion des cœurs, qui sont souvent
déclenchés par des interruptions ou des événements similaires.

== Support _watchdog_ <provenvisor_watchdog>

Les informations spécifiques sur le support _watchdog_ de _ProvenVisor_ ne sont pas
documentées publiquement. Dans un environnement virtualisé, le support _watchdog_ peut
toutefois s'organiser à plusieurs niveaux. Les plateformes _ARM_ modernes intègrent
généralement des _watchdogs_ matériels que l'hyperviseur pourrait gérer pour assurer
la disponibilité du système. _ProvenVisor_ pourrait potentiellement présenter des
_watchdogs_ virtualisés aux VMs invitées, une fonctionnalité commune dans les
hyperviseurs modernes, ou agir lui-même comme _watchdog_ en surveillant l'activité
des VMs. Dans l'architecture combinée _ProvenVisor_/_ProvenCore_, des mécanismes de
surveillance sophistiqués depuis le _Secure world_ pourraient offrir une couche
supplémentaire de résilience. Pour des informations détaillées, il serait nécessaire
de consulter la documentation technique propriétaire de _ProvenRun_.

== Programmation @baremetal <provenvisor_baremetal>

_ProvenVisor_ étant un hyperviseur de type 1, il s'exécute directement sur le matériel
nu (@baremetal) mais n'est pas conçu pour héberger directement des applications
@baremetal. Son rôle est de fournir un environnement virtualisé pour des systèmes
d'exploitation invités. Pour des applications nécessitant un accès @baremetal au
matériel, plusieurs approches sont possibles: le _passthrough_ de périphériques
permettant à une VM d'accéder directement à certains périphériques, l'utilisation de
_ProvenCore_ dans le _Secure world_ pour un accès direct et contrôlé, ou une VM dédiée
avec accès privilégié aux ressources matérielles. L'ajout d'un hyperviseur introduit
une certaine latence par rapport à une exécution purement @baremetal, mais les
bénéfices en termes d'isolation et de sécurité compensent généralement ce surcoût.

== Temps de démarrage <provenvisor_boot_time>

Les informations publiquement disponibles sur les temps de démarrage spécifiques de
_ProvenVisor_ sont limitées. Cependant, plusieurs facteurs suggèrent que l'hyperviseur
devrait avoir un temps de démarrage relativement rapide:

Le @tcb minimal implique moins de code à initialiser au démarrage. Un hyperviseur de
petite taille peut généralement démarrer plus rapidement qu'un système d'exploitation
complet ou qu'un hyperviseur aux fonctionnalités étendues.

La documentation indique que _ProvenVisor_ nécessite moins de 1 Mo de mémoire flash et
RAM pour une configuration simple @provenrun_homepage. Cette empreinte mémoire réduite
suggère un système épuré qui devrait démarrer rapidement.

Le temps de démarrage total du système dépendra également du temps nécessaire pour
démarrer les VMs invitées. _ProvenVisor_ lui-même pourrait démarrer rapidement, mais si
une VM _Linux_ doit ensuite être lancée, le temps de démarrage perçu par l'utilisateur
inclurait le temps de démarrage de _Linux_.

Pour des applications critiques nécessitant des temps de démarrage garantis, il serait
nécessaire de consulter la documentation technique détaillée de _ProvenRun_ pour obtenir
des chiffres précis et des garanties formelles.

== Maintenabilité <provenvisor_maintainability>

_ProvenVisor_ est un produit propriétaire développé par l'entreprise française
_ProvenRun_. Le code source n'est pas disponible publiquement et nécessite une
licence commerciale dont les conditions doivent être négociées directement avec
l'éditeur.

La certification _Common Criteria EAL5_ visée par _ProvenVisor_ (et _EAL7_
obtenue par _ProvenCore_) implique l'existence d'une documentation technique
rigoureuse. Les niveaux _EAL5_ et supérieurs des _Critères Communs_ exigent une
conception semi-formelle documentée, une modélisation détaillée des menaces et
une présentation structurée des preuves de sécurité. Cette documentation est
indispensable pour démontrer la conformité aux exigences de sécurité.

L'écosystème de _ProvenVisor_ est ciblé et spécialisé, concentré principalement
sur le marché de l'@ido et des systèmes embarqués critiques nécessitant une sécurité
renforcée, avec un focus sur les architectures _ARM v8-A_.

La taille exacte du code source n'est pas communiquée publiquement, mais est
vraisemblablement de petite taille en raison de la conception minimale et du focus
sur un @tcb réduit, caractéristique typique des hyperviseurs formellement vérifiés.

Le support est assuré exclusivement par _ProvenRun_, créant une dépendance à un
fournisseur unique. Les clients ne peuvent pas effectuer leurs propres modifications
ou corrections urgentes. Le support à long terme doit être négocié dans le contrat
de licence.

La vérification formelle a un double impact sur la maintenabilité. D'une part, elle
garantit une qualité de code exceptionnelle avec très peu de bugs découverts en
production, réduisant les besoins de correctifs urgents. D'autre part, toute
modification nécessite de re-prouver les propriétés du système, ralentissant
l'évolution et l'adaptation du produit.

La pérennité du produit est directement liée à la santé de l'entreprise _ProvenRun_.

= RTEMS <rtems>

#showybox(
  title: "RTEMS en bref",
  frame: (
    border-color: red.darken(20%),
    title-color: red.lighten(80%),
    body-color: red.lighten(95%)
  )
)[
  - *Type* : RTOS libre
  - *Langage* : C (96%)
  - *Architectures* : 20+ architectures (ARM, PowerPC, RISC-V, SPARC, x86,
    MIPS, ...)
  - *Usage principal* : Systèmes embarqués temps-réel (spatial, militaire,
    médical, industriel)
  - *Points forts* : Libre (GPL/BSD), API POSIX, support SMP, modulaire, mature,
    utilisé par NASA/ESA
  - *Limitations* : Documentation parfois limitée, configuration complexe
  - *Licences* : BSD 2-clause + exceptions (permettant code propriétaire)
  - *Missions notables* : Galileo, James Webb Space Telescope, Mars rovers
]

_RTEMS_ (_Real-Time Executive for Multiprocessor Systems_) est un _RTOS_ libre
conçu pour les systèmes embarqués.

Le projet est initié en 1988 par l'entreprise _OAR_ (_On-Line Appications
Research Corporaton_) sous contrat de l'_U.S. Army Missile Command_
@rtems_history_timeline. Cette dernière voulait un système d'exploitation
temps-réel basé sur des normes libres et exempt de redevances @rtems_oar. À
cette époque, le système est destiné à un usage militaire, en particulier dans
des missiles#footnote[Le sigle _RTEMS_ signifiait alors _Real-Time Executive
for Missile Systems_.]. En 1993, une première version du projet est rendue
publique. À partir de 1995, la gestion du projet est entièrement confiée à
_OAR_ qui assure la maintenance et le développement de _RTEMS_, ainsi que la
maintenance de son infrastructure web. Pendant les années 90, _RTEMS_ commence
à être utilisé dans le civil, notamment par la _NASA_ et l'@esa. Le projet est
alors renommé _Real-Time Executive for Multiprocessor Systems_ pour souligner
ce changement ainsi que le support des systèmes multiprocesseurs. De nos jours,
il est utilisé dans des missions spatiales et notamment la constellation de
satellites _Galileo_.

== Tutoriel <rtems_tutoriel>

Les exemples de ce chapitre ont été réalisés sur une carte _Raspberry PI 4_.
En plus de cette carte, vous aurez sans doute besoin d'un adaptateur _UART_ vers
_USB_ afin d'interagir avec le noyau installé sur la carte via ses pins `TX`,
`RX` et `Ground`.

#warning[][
  Prenez garde à ce que l'adapteur _USB/UART_ fonctionne avec un voltage de
  3,3V, sans quoi vous détruirez votre _Raspberry_.
]

Vous pouvez générer la chaîne de compilation _RTEMS_ pour _Raspberry_ à partir
d'un fichier _Docker_ en tapant la commande suivante:
```console
make setup -C ./rtems
```
ce qui prend environ une demie heure pour terminer la compilation. Finalement,
notez que les images produites par cette chaîne de compilation nécessite un
@bootloader. Le plus simple est de réutiliser le @bootloader de
_Raspberry OS lite_ et de remplacer le fichier `/boot/kernel8.img` par l'image
produite.

Après avoir branché le _Raspberry_ sur votre ordinateur et avant de le mettre
sous tension, vous pouvez lancez la commande suivante afin d'interagir avec
l'interface _UART_:
```console
minicom -D /dev/ttyUSB0
```
Notez que le nom de l'interface _TTY_ peut varier suivant l'adaptateur utilisé.

== Architectures supportées <rtems_architectures>

Du fait de sa longue histoire, _RTEMS_ a supporté et supporte encore aujourd'hui
un grand nombre d'architectures. Nous nous concentrons ici sur les architectures
énumérées dans la sous-section @criteria_architectures.

D'après @rtems_architectures_website, _RTEMS_ supporte les familles
d'architectures suivantes: _x86-32_, _x86-64_ _ARMv7_, _ARMv8_, _PowerPC_,
_MIPS_, _RISC-V_ et _SPARC_.

Le support se fait via des @bsp. En particulier, le projet distribue
un @bsp pour les processeurs _LEON2_ et _LEON3_ ayant pour architectures
_SPARC v8_ et conçus pour des applications dans le spatial.

== Support multi-processeur <rtems_multiprocessors>

Cette section aborde le support d'architectures multi-processeur sous _RTEMS_.
_RTEMS_ offre à la fois un support pour les architectures @smp @rtems_smp,
mais également pour les architectures @amp.

=== Architectures @smp <rtems_smp_2>

Depuis la version _4.11.0_, _RTEMS_ offre un support pour les architectures
@smp des processeurs _x86_, _ARM_, _PowerPC_, _RISC-V_ et _SPARC_. Ce support
est toutefois relatif à chaque @bsp. Il est par exemple disponible pour les
processeurs _LEON3_ et _LEON4_.

Ce support inclut entre autres:
- #box[Des ordonnanceurs de tâches dédiés comme _EDF_ (_Earliest Deadline First_)
qui tient compte d'échéances via le mécanisme de _deadline_
(voir la sous-section @rtems_determinism) et se comporte comme un ordonnanceur à
priorité fixe en l'absence de _deadlines_.]
- #box[La possibilité de circonscrire une tâche à un sous-ensemble de _CPU_ via
un mécanisme d'affinité.]
- #box[Un support pour la migration de tâches.]
- #box[Des mécanismes de synchonisations fins via des protocoles de verrouillage
comme _OMIP_ et _MrsP_.]

#aside[Activation @smp][
Le support @smp n'est pas activé par défaut. Il requière d'être activé durant
la phase de compilation du noyau via l'option `--enable-smp`.
]

Le support @smp a fait l'objet de vérifications et de pré-qualifications comme
nous le verrons dans la sous-section @rtems_certifications.

=== Architectures @amp <rtems_amp>

Il est possible d'utiliser _RTEMS_ sur des @mpsoc. Par exemple, il existe un
@bsp pour le @mpsoc _Xilinx Zynq UltraScale+_ @rtems_xilinx_bsp.

== Partitionnement <rtems_isolation>

_RTEMS_ fournit un partitionnement temporel temps réel avec de nombreux
ordonnanceurs et des protocoles de synchronisation fins. En revanche, il
n'offre pas d'isolation spatiale forte par défaut.

=== Partitionnement spatial <rtems_spatial_isolation>

Contrairement à un @gpos ou un hyperviseur, _RTEMS_ n'offre pas de séparation
traditionnelle entre @userspace et @kernelspace. Cette absence de séparation
permet de meilleures performances et un meilleur déterminisme au prix
d'une isolation spatiale faible. Ce choix de conception résulte d'un compromis
entre le caractère déterministe du noyau et l'isolation spatiale.

Les versions récentes de _RTEMS_ prennent en charge les @mmu ou @mpu de
processeurs récents. Le support est relatif à chaque @bsp et il est possible de
pas activer le @mmu ou le @mpu et de disposer d'un modèle mémoire plat
(_flat memory model_) afin de bénéficier des avantages précités. En présence
d'un microcontrôleur de gestion de la mémoire, son initialisation est à la
charge du @bsp @rtems_system_initialization @rtems_memory_model.

Lorsqu'une isolation spatiale est requise, l'usage est d'exécuter _RTEMS_ dans
une partition d'un noyau de séparation, typiquement dans l'hyperviseur de
_XtratuM_.

=== Partitionnement temporel <rtems_time_isolation>

_RTEMS_ est distribué avec quatre ordonnanceurs différents:
- #box[_Deterministic Priority Scheduler_ est un ordonnanceur préemptif basé
sur des niveaux de priorités (jusqu'à 256 niveaux). Il offre de très bonnes
performances mais il peut requérir trop de mémoire pour les configurations
les plus minimaliste. Il existe une version de cet ordonnanceur pour les
multi-processeur @rtems_smp_schedulers.]
- #box[_Simple Priority_ est un ordonnanceur préemptif similaire au précédent
mais avec un compromis temps/mémoire différent. Il privilégie une empreinte
mémoire plus petite au prix de structures de données plus lentes. Il existe
une version de cet ordonnanceur pour les multi-processeur @rtems_smp_schedulers.]
- #box[_EDF_ (_Earliest Deadline First_) est un ordonnanceur préemptif basé
sur les échéances (_deadlines_). L'échéance la plus proche est prioritaire. Cet
ordonnanceur existe pour les architectures @smp @rtems_smp_schedulers.]
- #box[_CBS_ (_Constant Bandwidth Server_) est un ordonnanceur préemptif orienté
sur l'isolation temporelle. Chaque tâche dispose d'un budget strict et ne peut
pas influencer l'exécution des autres.]

Il est possible d'implémenter son propre ordonnanceur et de rendre
non-préemptible une tâche.

=== Déterminisme <rtems_determinism>

_RTEMS_ est avant tout un _RTOS_. Sa conception est donc guidée par le souci
de préserver le déterminisme autant que possible.

=== Protocols de synchonisation

Afin d'assurer la synchronisation des sections critiques et de prévenir les
inversions de priorité, _RTEMS_ propose quatre protocoles de verrouillage:
- _ICPP_ (_Immediate Ceiling Priority Protocol_) pour les architectures
  monoprocesseur,
- _PIP_ (_Priority Inheritance Protocol_) pour les architectures
  monoprocesseur. La prorité d'une tâche est élevée au niveau de la plus haute
  priorité d'une tâche qui attend un verrou. C'est une approche similaire aux
  verrous _rt-mutex_ de _Linux_ vu en sous-section @linux_determinism,
- _MrsP_ (_Multiprocessor Resource Sharing Protocol_) pour les architectures
  @smp. Il généralise les verrous _ICPP_ aux multiprocesseur @smp et utilise de
  l'attente active,
- _OMIP_ (_O(m) Independence Preserving Protocol_) pour les architectures
  @smp. Il généralise le protocol _PIP_ aux architectures @smp.

=== Rate Monotonic Manager

_Rate Monotonic Manager_ permet la gestion de tâches périodiques via
l'algorithme _RMS_ (_Rate Monotinic Scheduling_). C'est un algorithme qui
attribut statiquement une priorité à chaque tâche périodique
inversement proportionnel à la période. Cette politique d'attribution
des priorités peut être combiné avec les ordonnanceurs décrits dans la
sous-section précédente.

== Corruption mémoire <rtems_memory_corruption>

_RTEMS_ ne semble pas fournir d'@api unifié pour journaliser les erreurs
mémoires ou gérer le _scrubbing_.

Dans le cas du _scrubbing_, le support est relatif au @bsp utilisé.
Par exemple, il existe une @api pour gérer le _scrubbing_ dans le fichier
`bsps/include/grlib/memscrub.h`. Ce dernier fait parti du @bsp pour les
microprocesseurs _LEON_. L'usage du _scrubbing_ étant rendu nécessaire par le
rayonnement inhérent aux missions spatiales, il est très probable qu'un tel
support est développé dans un @bsp chaque fois que celui-ci est nécessaire pour
une telle mission.

== Perte du flux d'exécution <rtems_hijacking_flow>

_RTEMS_ étant principalement écrit en langage _C_, il est exposés aux
vulnérabilités classiques par corruption mémoire afin de détourner le
flux d'exécution.

Nous n'avons pas trouvé de mécanisme de protection face à ce type d'attaques
dans _RTEMS_. Cette absence s'explique par le fait que le noyau n'offre pas
d'isolation spatiale forte. Les applications s'exécutant dans _RTEMS_ doivent
donc être de confiance et leur développement nécessite une attention accrue
pour éviter les erreurs de programmation. À défaut, il faut recourir à un
hyperviseur pour assurer l'isolation spatiale.

== Écosystème <rtems_ecosystem>

Les développeurs de _RTEMS_ offrent plusieurs outils de monitoring et de
profilage:
- #box[_profreport_ @rtems_profreport: Outil de profilage pour le noyau. Il
  nécessite que ce dernier soit compilé avec l'option `RTEMS_PROFILING` afin
  d'activer le profilage du noyau lui-même @rtems_bsp_build_system. Il produit
  un rapport au format _XML_ sur sa sortie standard.]
- #box[_rtrace_ @rtems_tracing: Outil pour afficher et sauvegarder les traces
  produites par le sous-système _RTEMS Tracing Framework_. Ce dernier est
  conçu pour minimiser l'impact sur le système. Il permet de tracer des
  événements de l'ordonnanceur de tâches (création/destruction d'une tâche,
  basculement de contexte, ...), des @ipc, des protocoles de
  synchronisation et des appels systèmes en général.]
- #box[_RTEMS shell_ @rtems_shell_guide: Shell qui comprend de nombreuses
  commandes affichant des informations sur les tâches en cours d'exécution
  @rtems_specific_commands et permet l'exploration de l'état mémoire
  @rtems_memory_commands.]
- #box[_CPU Usage Statistics_ @rtems_cpu_usage_statistics: @api de _RTEMS_
  permettant de collecter des statistiques de l'usage _CPU_ par tâche. La
  granularité des mesures peut être de l'ordre de la nanoseconde sur
  les versions récentes de _RTEMS_ et à condition que le @bsp le supporte.]

_RTEMS_ ne semble pas offrir d'outil ou d'@api unifiée pour suivre les registres
_PMU_. Un support existe dans certains @bsp.

== Gestion des interruptions <rtems_interrupt_managing>

_RTEMS_ fournit un _Interrupt Manager_ qui offre les primitives nécessaires
pour masquer les interruptions et installer des gestionnaires d'interruption
@rtems_interrupt_manager @rtems_interrupt_intro.

=== Masquage des interruptions

_RTEMS_ propose plusieurs directives pour masquer les interruptions. En
configuration uniprocesseur, `rtems_interrupt_disable()` et
`rtems_interrupt_enable()` désactivent et restaurent les interruptions
masquables. Pour garantir la portabilité entre configurations uniprocesseur et
@smp, les directives `rtems_interrupt_local_disable()` et
`rtems_interrupt_local_enable()` sont disponibles dans toutes les
configurations @rtems_interrupt_directives.

En configuration @smp, le masquage local des interruptions ne garantit pas
l'exclusion mutuelle à l'échelle du système. _RTEMS_ fournit donc des
_interrupt locks_, implémentés sous forme de _ticket locks_, pour assurer la
synchronisation entre cœurs tout en garantissant l'équité _FIFO_ nécessaire à
la prévisibilité des systèmes temps réel @rtems_smp_services
@rtems_interrupt_locks. Dans les configurations uniprocesseur, ces verrous se
réduisent à de simples séquences de désactivation/activation d'interruptions.

_RTEMS_ permet également de contrôler des vecteurs d'interruption individuels
via `rtems_interrupt_vector_enable()` et `rtems_interrupt_vector_disable()`
@rtems_interrupt_directives.

=== Gestionnaires d'interruption

Les directives `rtems_interrupt_catch()` et `rtems_interrupt_handler_install()`
permettent d'installer des @isr pour des vecteurs d'interruption spécifiques.
_RTEMS_ sauvegarde automatiquement le contexte et garantit un ordonnancement
correct des tâches à la sortie d'une interruption @rtems_interrupt_intro.

La latence d'interruption est bornée en minimisant la durée des sections
critiques. Des mesures sur processeur _SPARC Leon 2_ montrent des latences
typiques de 10 à 40 µs @rtems_perf_measurements. En configuration @smp, les
interruptions peuvent être affectées à des cœurs spécifiques pour gérer la
latence sous charge @rtems_smp_core_affinity.

== _Watchdog_ <rtems_watchdog>

_RTEMS_ ne fournit pas à notre connaissance d'API unifiée pour gérer les
_watchdogs_ matériels. Le support est implémenté au niveau du
@bsp. Ce support est disponible pour le _Raspberry PI 4_ comme nous l'illustrons
dans la sous-section @rtems_watchdog_raspberry.

D'après la documentation, il est également possible d'implémenter un _watchdog_
logiciel via le _Timer Manager_. Plus précisément, on peut mettre en place un
_timer_ avec la fonction `rtems_timer_fire_after` pour implémenter la logique
d'un tel _watchdog_.

=== Watchdog matériel avec un _Raspberry PI 4_ <rtems_watchdog_raspberry>

Le dossier `./rtems/examples/watchdog` contient un exemple d'interaction avec
le watchdog d'un Raspberry.

#figure(
  snippet("./rtems/examples/watchdog/src/init.c", lang:"c"),
  caption: [Interaction avec un _watchdog_ sur un _Raspberry PI 4_.]
) <rtems_watchdog_example>

La commande suivante compile et produit une image dans
`./rtems/artifacts/watchdog.img`.
```console
make  -C ./rtems/watchdog watchdog
```

Il suffit alors de copier cette image sur le _Raspberry_ puis de lancer
`minicom` pour écouter le port série et observer les messages émis par
le noyau.

== Qualifications & certifications <rtems_certifications>

Du fait de son usage dans le spatial, il est nécessaire de pouvoir qualifier
_RTEMS_ afin de l'intégrer dans des missions.

=== Kit de qualifications par l'ESA

L'@esa offre un kit de @qualification pour des applications de _RTEMS_
dans le domaine spatial @rtems_qdp. Il est disponible pour les cartes
_Cobham Gaisler GR712RC_ (architecture _LEON3_ double-cœur) et _GR740_
(architecture _LEON4_ quadri-cœur). Ce kit est disponible sous licence
_Creative Common Attribution-ShareAlike 4.0_.

L'ESA (_European Space Agency_) offre un kit de @qualification pour des
applications de _RTEMS_ dans le spatial @rtems_qdp dans sa version @smp.

- QDP kit de préqualification.
- Le kit est sous licence Creative Common Attribution-ShareAlike 4.0.
- Plateforme supportée Cobham Gaisler GR712RC (double-cœur LEON3) et GR740 (quadri-cœur LEON4).
- Utilise GCC (v10.2.1) et la bibliothèque mathématique pour les systèmes critiques (libmcs).
- L'application est liée statiquement à RTEMS. Il faut donc une qualification conjointe de l'application et de RTEMS.
- Conformité @ecss

Il y a une qualification de RTEMS dans un cadre mono-cœur par Edisoft.

Un effort important a été livré pour appliquer des méthodes formelles sur RTEMS.
C'est une activité sponsorisé par @ecss afin de s'assurer de la fiabilité de RTEMS
dans un cadre @smp. Ils ont utilisé Promela/SPIN @butterfield2023applying,
un model-checker. Edisoft a encore contribué sur cette version.

- Promela est le langage de formalisation tandis que SPIN est le model checker.


=== Model checking avec _Promela/SPIN_

La correction fonctionnelle de certaines parties de l'@api de _RTEMS_ ont
été vérifié par _model checking_ @butterfield2023applying grâce à un
financement de l'@esa. Cette vérification concerne en particulier les
primitives de synchronisation utilisées sur les architectures @smp.

L'approche retenue fut la génération automatique de tests en utilisant le langage de
spécification _Promela_ (_PROtocol MEta LAnguage_) et le vérificateur
de modèles _SPIN_ pour vérifier la correction et générer les tests à partir
de la spécification en _Promela_. Les auteurs envisagent d'étendre cette
vérification aux ordonnanceurs de _RTEMS_.

Plus d'informations sont disponibles dans la documentation officielle
@rtems_formal_verification_overview.

== Programmation @baremetal <rtems_baremetal>

_RTEMS_ n'étant un hyperviseur, nous n'avons pas examiné ce critère.

== Temps de démarrage <rtems_booting_time>

Nous n'avons pas trouvé d'informations précises sur le temps de démarrage
du noyau _RTEMS_.

== Maintenabilité <rtems_maintening>

Le projet _RTEMS_ est développé et maintenu depuis plus de 30 ans. Il est
écrit en langage C à plus de 96% pour 1 990 023 _SLOC_.

_RTEMS_ est un logiciel libre distribué sous une multitude de licences libres
et open-sources avec pour licence principale _BSD 2-Clause_. Le point commun de
ces licences est qu'elles autorisent l'utilisateur a lié son programme avec le
code source de _RTEMS_ sans devoir redistribuer son propre code source
@rtems_licenses_website.

_RTEMS_ bénéficie d'un écosystème particulièrement important dans le domaine
spatial, où il est utilisé par la _NASA_ et l'@esa dans de nombreuses missions,
notamment la constellation de satellites _Galileo_, le _James Webb Space Telescope_,
et les rovers martiens. Cette adoption par des agences spatiales de premier plan
témoigne de la maturité et de la fiabilité du système.

Le support commercial de _RTEMS_ est assuré principalement par l'entreprise _OAR_
(_On-Line Applications Research Corporation_), qui maintient et développe le
projet depuis 1995. Un support est disponible pour les entreprises européennes
et américaines. La communauté active du projet offre également un support gratuit,
bien que sans garantie formelle.

= seL4 <sel4>

#showybox(
  title: "seL4 en bref",
  frame: (
    border-color: teal.darken(20%),
    title-color: teal.lighten(80%),
    body-color: teal.lighten(95%)
  )
)[
  - *Type* : Micronoyau temps-réel + Hyperviseur type 1 (3ème génération L4)
  - *Langage* : C
  - *Architectures* : ARM (32/64-bit), x86 (32/64-bit), RISC-V
  - *Usage principal* : Systèmes critiques (défense, médical, automobile,
    aérospatial)
  - *Points forts* : Vérifié formellement (Isabelle/HOL), capabilities,
    partitions mixtes, certifiable Critères Communs EAL7, absence prouvée de
    bugs critiques
  - *Limitations* : Courbe d'apprentissage élevée, écosystème limité,
    documentation technique avancée
  - *Licences* : GPL v2 (noyau), code utilisateur sous licence libre au choix
  - *Caractéristique unique* : Seul OS avec correction prouvée formellement du
    code C au binaire
]

Le noyau _seL4_ est un micronoyau temps-réel de troisième génération de la
famille _L4_. Il intègre également un hyperviseur de type 1. Sa conception
débute en 2006 à l'institut de recherche _NICTA_#footnote[Acronyme pour
_National Information and Communications Technology Australia_.], aujourd'hui
connu sous le nom de Trustworthy Systems. C'est un noyau orienté sécurité dont
l'un des premiers objectifs était d'être entièrement vérifié à l'aide de
méthodes formelles. Grâce à ces efforts, il peut aujourd'hui être certifié avec
le niveau le plus exigent dès Critères communs.

Le noyau _seL4_ est un micronoyau de troisième génération. Il inclut un
hyperviseur de type 1 et un _RTOS_. Sa conception a débuté en 2006 à
l'institut de recherche _NICTA_. L'objectif était de créer un
système d'exploitation capable de satisfaire les exigences de sécurité et de
sûreté des @cc. À ce titre, les contraintes induites par la vérification
formelle du noyau ont été prises en compte dès le départ du projet. Comme son
nom le suggère, dans son design, _seL4_ est fortement inspiré du micronoyau de
seconde génération _L4_. Ainsi, il fournit des abstractions pour la mémoire
virtuelle, les _threads_ et la communication inter-processus. Toutefois,
contrairement à la majorité des autres micronoyaux de la famille _L4_, il
fournit également des _capabilities_ pour gérer les autorisations.

== Tutoriel <sel4_tutorial>

Le site de _seL4_ fournit un tutoriel détaillé et une image _docker_ contenant
tout le nécessaire pour tester le micronoyau dans une machine virtuelle.
En supposant que vous avez installé _docker_ sur votre machine, il vous suffit
de récupérer l'image docker de la façon suivante:
```console
git clone https://github.com/seL4/seL4-CAmkES-L4v-dockerfiles.git
cd seL4-CAmkES-L4v-dockerfiles
make user
```

== Architectures supportées <sel4_architectures>

Le développement initial de _seL4_ s'est fait uniquement sur l'architecture
_ARM v7_. Le projet a depuis été porté sur les plateformes _x86_ et _RISC-V_.
La dernière version du micronoyau supporte les architectures suivantes:
_x86-32_, _x86-64_, _ARM v7_, _ARM v8_ et _RISC-V_.

Sur l'architecture _x86_, il est possible d'utiliser les instructions _VT-X_ pour
la virtualisation assistée par le matériel.

Plus d'informations sur le support des différentes plateformes sont
disponibles sur leur site @sel4_supported_platforms.

== Support multi-processeur <sel4_multiprocessor>

_seL4_ offre un support aussi bien pour les architectures multiprocesseur
@smp que @amp.

== Support @smp

Le noyau _seL4_ dispose d'un support @smp pour les architectures _x86_ et
_ARM_. La fonctionnalité pour _x86_ semble avoir été ajouté lors de l'introduction
du support _x86-64_. Quant à _ARM v7_, le support @smp date de la version majeure
6.0.0 et était d'abord limité à la plateforme @mpsoc _Sabre_ avec au plus quatre
cœurs.

Le micronoyau utilise un verrou global @bkl de type _CLH_ comme mécanisme de i
synchronisation @sel4_multiprocessing.
Cela signifie que deux sections critiques du noyau ne peuvent pas s'exécuter en
parallèle. Cette approche a été adoptée pour sa simplicité et comme une étape
intermédiaire avant de mettre en œuvre des mécanismes de synchronisation plus
fins. De plus les appels systèmes de _seL4_ étant courts, cela n'engendre pas
une dégradation des
performances comme c'était le cas dans le noyau _Linux_. Toutefois l'utilisation
d'un tel verrou donne des estimations du @wcet pessimistes @sel4_update_research.

#aside[][
  Le support @smp n'est pas activé par défaut.
]

Quelque soit la configuration utilisée, le support @smp n'a pas fait l'objet
de vérification formelle @sel4_multiprocessing. Cette vérification est d'autant
plus difficile que les architectures @smp modernes ont des modèles de mémoire
faible @colvin2024practicalrelyguaranteeverificationefficient @sel4_multiprocessing.
C'est le cas notamment de l'architecture _ARM_ qui reste
l'architecture de référence pour le développement _seL4_ du fait de son omniprésence
dans l'embarqué. L'implémentation des verrous _CLH_ a fait récemment l'objet de
vérification formelle @colvin2024practicalrelyguaranteeverificationefficient.

== Support @amp

_seL4_ offre un support pour des architectures @amp sur @mpsoc. L'avantage de
cette approche est de bénéficier de la vérification formelle dans ce cas
contrairement aux architectures @smp comme expliqué dans la section précédente.

Il y a également un support pour _OpenAMP_.

Quelques projets qui utilisent _seL4_ sur des architectures @amp: @solox_amp_rust.

== Les capacités <sel4_capabilities_sec>

Une particularité importante de la conception de _seL4_ au sein de la famille
des noyaux _L4_ est l'utilisation de capacités (_capabilities_) pour rendre
compte des droits d'accès.

Les capacités sont des jetons donnant à leur possesseur des droits d'accès à
des ressources du systèmes @sel4_capabilities. De façon plus concrète, une
capacité se présente sous la forme d'un pointeur immutable qui
combine un objet du noyau et des informations de contrôle d'accès. La possession
d'une capacité constitue en elle-même l'autorisation d'accès à la ressource
associée. Ainsi, une capacité adéquate doit être passée à chaque appel système
afin que le micronoyau accepte de l'exécuter.

À chaque tâche (_thread_) est associée un ensemble de capacités (_CSpace_ pour
_Capability-Space_) qui représente les ressources accessibles de la tâche.

Il existe plusieurs types de capacités. Certaines représentes des structures
de données du noyau ou encore des ressources abstraites, tandis que d'autres
représentent des zones mémoires contiguës inutilisées
@sel4_tutorial_capabilities.

== Partitionnement spatial <sel4_spatial_isolation>

Le micronoyau _seL4_ se distingue par une approche radicalement différente pour
le partitionnement spatial. Habituellement, la gestion de la mémoire est
effectuée en @kernelspace. Une tâche en @userspace n'a pas accès à la mémoire
physique et effectue des allocations dynamiques via des appels systèmes sans
pouvoir décider de l'agencement des zones allouées dans son propre espace
d'adressage virtuel. À l'inverse l'@api de _seL4_ n'expose que quelques
primitives pour manipuler les structures de pagination du @mmu, laissant le
soin aux applications de gérer leur propre espace d'adressage @sel4_whitepaper
@sel4_capabilities.

Le mécanisme des capacités assure l'isolation mémoire entre les tâches. Il y
a une correspondance biunivoque entre la mémoire utilisée par une tâche A et
les capacités qu'elle possède pour manipuler cette mémoire. Une autre tâche B
ne peut accéder à une certaine plage mémoire de A sans posséder également cette
capacité. Ainsi chaque tâche peut implémenter sa propre politique de gestion de
la mémoire. Cette propriété a été formellement vérifiée
@sel4_verified_protection.

Au démarrage la majorité des capacités sont confiées à une tâche spéciale _root_.
Cette tâche peut en créer des nouvelles et leur céder une partie de ses
capacités. Ce système est rendu possible par l'absence d'allocation dynamique et
facilite également la vérification formelle.

À notre connaissance, _seL4_ nécessite la présence d'un @mmu complet pour
fonctionner car son modèle mémoire repose entièrement sur la possibilité de
virtualiser la mémoire physique.

== Partitionnement temporel <sel4_time_isolation>

_seL4_ propose deux modes de partitionnement temporel: un mode standard et des
extensions _MCS_ (_Mixed-Criticality System_).

L'ordonnanceur standard de _seL4_ combine deux niveaux d'ordonnancement
@sel4_whitepaper:
- #box[Un ordonnanceur hiérarchique de haut niveau basé sur des _domaines_:
les domaines sont ordonnancés de manière cyclique et déterministe selon un
planning statique configuré à la compilation. Chaque domaine reçoit une tranche
de temps fixe et les communications @ipc entre domaines sont différées.]
- #box[Un ordonnanceur de _threads_ au sein de chaque domaine: ordonnanceur
préemptif à priorités fixes (256 niveaux) avec _round-robin_ pour les threads
de même priorité.]

Les extensions _MCS_ @lyons2018scheduling introduisent les _contextes
d'ordonnancement_ qui permettent d'allouer un budget de temps _CPU_ à chaque
_thread_ sur une période donnée. L'isolation temporelle est assurée par un
algorithme de serveur sporadique. Ces extensions offrent des garanties temps
réel renforcées et sont en cours de vérification formelle @sel4_mcs_release.

== Déterminisme <sel4_determinism>

_seL4_ se distingue par une approche originale pour garantir le déterminisme
nécessaire aux systèmes temps réel. Alors que la plupart des @rtos privilégient
un noyau entièrement préemptible pour minimiser la latence, _seL4_ adopte une
approche événementielle largement non préemptible. Le noyau s'exécute avec les
interruptions matérielles désactivées, ce qui simplifie sa conception et sa
vérification formelle. Pour offrir de bonnes garanties temps réel malgré cette
non-préemptibilité, tous les appels système ont un temps d'exécution borné:
_seL4_ évite les boucles infinies, élimine l'allocation dynamique et introduit
des points de préemption explicites dans les rares appels longs.

Le déterminisme de _seL4_ est renforcé par une analyse @wcet formellement
vérifiée @blackham2011timing @sewell2016complete. C'est à ce jour le seul noyau
en mode protégé disposant d'une telle analyse complète et rigoureuse, fournissant
des bornes supérieures certifiées pour tous les appels système. Cette analyse
permet d'estimer précisément le temps d'exécution des routines du noyau dans le
pire cas, garantissant ainsi le respect des échéances temporelles critiques.
Combiné aux extensions _MCS_ qui offrent une isolation temporelle stricte, _seL4_
peut fournir des garanties de temps réel strict tout en maintenant l'isolation
spatiale, ce qui n'est pas le cas de nombreux autres @rtos.

== Corruption mémoire <sel4_memory_corruption>

_seL4_ étant un micronoyau qui se concentre sur l'isolation, il ne semble pas
proposer d'@api ou de logiciel de journalisation pour les erreurs mémoires.
Ce support doit être implémenté par pilote en espace utilisateur.

== Perte du flux d'exécution

Bien que le noyau _seL4_ soit écrit en _C_, il est moins exposé aux attaques
par corruption de mémoire qu'un programme _C_ usuel. En effet, sa vérification
formelle a permis de prouver l'absence d'un certains nombres d'erreurs de
programmation @klein2009sel4. Certaines de ces erreurs, comme par exemple
le dépassement de tampon, sont des vecteurs d'attaques très commun et notamment
de détournement du flux d'exécution.

== Écosystème <sel4_ecosystem>

Le micronoyau _seL4_ offre un écosystème limité. Les outils de haut niveau
classiques pour la surveillance et le profilage des applications ne semblent
pas être disponibles. Toutefois, il existe un kit de développement
_seL4 Microkit_ @sel4_microkit_manual
offrant une couche logicielle au-dessus du micronoyau et visant à simplifier
le développement sur cette plateforme. En particulier ce kit inclut:
- #box[Un moniteur qui journalise les erreurs systèmes comme les accès
mémoire erroné ou les instructions invalides. Il est possible d'implémenter
son propre moniteur.]
- #box[Une console de débogage permettant une communication avec le système
embarqué via une interface série _UART_,]
- #box[Un mode _benchmark_ qui permet de collecter des informations via les
registres @pmu.]

== Gestion des interruptions <sel4_interrupt_managing>

Les interruptions sont gérées en espace utilisateur via le système de _capabilities_
@sel4_interrupts. La tâche racine reçoit `seL4_CapIRQControl` permettant de dériver
des _capabilities_ `IRQHandler` pour des @irq spécifiques. Les applications reçoivent
les interruptions via des objets notification associés aux `IRQHandler`. Le masquage
est implicite : aucune interruption n'est livrée jusqu'à l'acquittement explicite via
`seL4_IRQHandler_Ack`.

Pour la virtualisation, _seL4_ exploite les extensions matérielles comme le _VGIC_
sur _ARM_ (support _GICv2_, _GICv3_ en développement) permettant l'injection
d'interruptions virtuelles sans piégeage systématique. La bibliothèque `libsel4vm`
fournit une interface de haut niveau avec des fonctions comme `vm_inject_irq` et
`vm_register_irq`.

== Watchdog <sel4_watchdog>

_seL4_ n'offre pas une @api unifiée pour la gestion de _watchdog_ matériel.
Toutefois nous avons trouvé un support pour de tels _watchdog_ dans certains
@bsp.

== Programmation @baremetal <sel4_baremetal>

_seL4_ dispose d'un support pour la programmation @baremetal en langage _C_ et
_Rust_. À notre connaissance, il n'existe pas de support officiel pour les
langages _Ada_ et _OCaml_ sur _seL4_.

Pour le langage _C_, le projet fournit la bibliothèque _libsel4_
@sel4_api_doc pour interagir avec le micronoyau et un @rte _sel4runtime_
@sel4_runtime minimaliste.

Le langage _Rust_ bénéficie d'un support officiel et documenté pour _seL4_
@sel4_rust_docs @sel4_crate_rust.

== Temps de démarrage <sel4_boot_time>

Nous n'avons pas trouvé d'informations précises sur le temps de démarrage
du noyau _seL4_.

== Maintenabilité <sel4_maintainability>

Le noyau _seL4_ est un logiciel libre distribué principalement sous licence
_GPLv2_. Le code utilisateur et les pilotes peuvent être distribués sous
n'importe quelle licence @sel4_licensing.

Le projet a débuté en 2006, ce qui en fait un projet d'environ 19 ans.

La base de code est écrite en langage C à 87% pour un total de 68 175 _SLOC_.
Cette petite taille est le gage d'une @tcb réduite. Cependant, ce chiffre ne
tient pas compte de la difficulté importante à maintenir des démonstrations
tout en continuant à faire évoluer le logiciel.

_seL4_ bénéficie d'un écosystème actif dans les domaines critiques et son code
librement accessible facilite le développement de nouveaux logiciels.

Le support commercial de _seL4_ est assuré par plusieurs organisations, dont
la _seL4 Foundation_ et _Trustworthy Systems_.

= Xen <xen>

#showybox(
  title: "Xen en bref",
  frame: (
    border-color: aqua.darken(20%),
    title-color: aqua.lighten(80%),
    body-color: aqua.lighten(95%)
  )
)[
  - *Type* : Hyperviseur type 1
  - *Langage* : C (majoritaire)
  - *Architectures* : x86 (32/64-bit), ARM (32/64-bit)
  - *Usage principal* : Cloud computing, hébergement, data centers,
    virtualisation d'entreprise
  - *Points forts* : Mature et éprouvé, paravirtualisation + HVM, largement
    adopté (AWS, Citrix), dom0less pour boot rapide, stub domains pour sécurité
  - *Limitations* : TCB important, complexité, dépendance au dom0 (Linux)
  - *Licences* : GPL v2 (majoritaire) avec exceptions pour compatibilité
  - *Utilisateurs notables* : Amazon AWS, Citrix, OVH, Rackspace
]

_Xen_ est un hyperviseur de type 1 développé par le consortium d'entreprises
#link("https://xenproject.org")[Xen Project]. Ces un pionnier de la
@paravirtualization mais il offre aussi un support étendu pour la
virtualisation assistée par le matériel. Il est aujourd'hui très utilisé
dans le monde de l'hébergement et du cloud computing.

L'histoire de _Xen_ est étroitement liée à l'évolution de la virtualisation et
du cloud computing. Elle débute en 1999 avec le projet de recherche
_XenoServers_ à l'université de Cambridge. Le chercheur
Ian Pratt, entouré de plusieurs étudiants, propose une infrastructure pour
exécuter plusieurs services sur des @vm:pl Java.
L'idée fondatrice était de garantir l'isolation des services,
même lorsqu'ils n'étaient pas dignes de confiance et d'assurer équité quant à
la répartition des ressources.

En 2003, une première version de l'hyperviseur _Xen_ est publié sous licence
libre. Contrairement à son prédécesseur _XenoServers_, il permet d'exécuter
n'importe quelle application dans une @vm tournant sur un noyau
_Linux_ modifié. Ces modifications contournent les limites
de performances de la virtualisation complète sur architecture _x86_ en permettant
au noyau virtualisé de collaboré avec l'hyperviseur. C'est la naissance de la
@paravirtualization.

En 2005, le support pour la virtualisation assistée par le matériel est ajoutée
en étroite collaboration avec Intel qui développait alors sa technologie
_Intel VT-X_. Cette technologie permet la virtualisation de systèmes
d'exploitation à sources fermées comme _Windows_.

Cette même année, la société _XenSource Inc_ est fondée pour continuer le
développement de _Xen_ et faire face à la concurrence. Elle est racheté en 2007
par _Citrix_ qui propose toujours une version commerciale de _Xen_ baptisé
_Citrix Hypervisor_.

Aujourd'hui le développement de _Xen_ se concentre sur le support d'autres
architectures que _x86_, et notamment _ARM_ (voir la sous-section
@xen_architectures) et l'utilisation combinée de la @paravirtualization et
de la virtualisation assistée par le matériel (voir la sous-section
@xen_isolation).

== Tutoriel <xen_tutoriel>

Les exemples de cette section ont été lancé sur une machine _x86_ avec _Xen_.
L'installation de _Xen_ est grandement simplifié par son support dans certaines
distributions _GNU/Linux_. Il vous suffit d'installer les paquets appropriés
puis de redémarrer en choisissant l'hyperviseur _Xen_ au démarrage.

Afin de pouvoir illustrer certaines fonctionnalités de _Xen_, cette section
explique comment mettre en place une machine virtuelle faisant tourner la
distribution _GNU/Linux_ _Alpine_. Nous partons du principe que vous êtes parvenu
à installer correctement _xen_ et _qemu_ sur votre machine. Le fichier ci-dessous
donne un exemple de configuration d'une VM en paravirtualisation:
#figure(
  snippet("./xen/alpine/alpine.cfg", lang:"cfg"),
  caption: [Configuration d'une VM Alpine]
)

Plus d'options sont documentées dans la page de manuel `xl.cfg`.
Téléchargez l'image d'_Alpine_ sur son site officiel:
```console
wget https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-standard-3.22.1-x86_64.iso
```
et extrayez les deux fichiers `/boot/vmlinuz-lts` et `/boot/initramfs-lts` de l'image iso:
```console
mkdir iso
mount -t iso9660 -o ro ./alpine-standard-3.22.1-x86_64.iso ./iso
cp ./iso/boot/vmlinuz-lts ./iso/initramfs-lts .
umount iso
rm iso
```
Il vous faut également créer un disque virtuel à l'aide de l'outil `qemu-img`:
```console
qemu-img create -f qcow2 ./alpine.qcow2 50G
```
Finalement vous pouvez lancer la VM avec la commande suivante:
```console
sudo xl create alpine.cfg -c
```
Le login par défaut est `root` sans mot de passe. Pour quitter la console de
la VM, tapez `CTRL-]`.


== Architectures supportées <xen_architectures>

#warning[][
  Dans cette section nous utiliserons les abréviations _PV_, _HVM_ et _PVH_
  qui désignent des types de partitions sous _Xen_. Ces notions sont détaillées
  dans la section @xen_isolation.
]

À l'origine _Xen_ ne supportait que l'architecture _x86_ pour des partitions de
type _PV_. Par la suite, la virtualisation assistée par le matériel a été ajoutée
pour les technologies _Intel VT-X_ puis _AMD V_ sous la forme de partitions de
type _HVM_. Aujourd'hui _Xen_ supporte les architectures suivantes: _x86-32_,
_x86-64_, _ARM v7_, _ARM v8_. Il existe aussi un support préliminaire pour les
architectures _PowerPC_ et _RISC-V_ @xen_project_4_20. _Xen_ supporte
également la virtualisation assistée par le matériel sur _ARM_ @xen_arm_hvm.

#let scell(color: white, txt) = table.cell(fill: color.lighten(40%), [#txt])

#let supported(txt) = scell(color:green, txt)
#let notsupported(txt) = scell(color:red, txt)
#let partiallysupported(txt) = scell(color:yellow, txt)
#let deprecated(txt) = scell(color:black, txt)

== Support multi-processeur <xen_multiprocessor>

_Xen_ offre un support pour les architectures @smp et @amp. Ce support se fait
via l'abstraction offerte pour les _CPU_ virtuels et des ordonnanceurs
adaptés aux architectures multi-processeur.

=== Support @smp

_Xen_ offre un support @smp pour toutes les architectures vues en sous-section
@xen_architectures. En particulier les ordonnanceurs _Credit Scheduler_ et
_Credit2 Scheduler_ sont capables de répartir automatiquement la charge sur les
différents cœurs.

Lorsqu'un système invité supporte lui-même les architectures @smp, il peut
en tirer parti dès lors qu'il dispose de plusieurs _vCPU_.

=== Support @amp

Nous n'avons pas d'informations précises sur l'usage de _Xen_ sur des plateformes
@amp. Toutefois la documentation de _RTEMS_ mentionne l'usage de _Xen_ sur
un @mpsoc _Xilinix Zynq UltraScale+_ @vanvossenxen.

== Partitionnement <xen_isolation>

_Xen_ propose trois types de partitions différentes:
- #box[Les partitions de type #definition[PV] permettent la @paravirtualization totale du
système invité. Elles nécessitent une adaptation de ce dernier mais aucun support matériel
n'est _a priori_ requis. Ces partitions offrent de bonnes performances. Il s'agit
du mode originel de _Xen_ pour l'architecture _x86_.]
- #box[Les partitions de type #definition[HVM] permettent la virtualisation assistée
par le matériel. Elles nécessitent des extensions matérielles (voir la sous-section
@xen_architectures) mais aucune modification du système d'exploitation
hôte#footnote[Ce dernier point est crucial pour support des systèmes d'exploitation
à sources fermées, comme par exemple _Windows_]. Les performances
sont généralement moindre que pour les partitions de type _PV_.]
- #box[Les partitions #definition[PVH] cherchent à offrir le meilleur des deux types
de partitions décrits ci-dessus. Certaines parties du systèmes (les entrées/sorties par
exemples) sont paravirtualisées et d'autres (comme le _CPU_) reposent sur de la
virtualisation assisté par le matériel. Ce type de partition offre souvent de meilleures
performances que les partitions _PV_ et _HVM_ sans avoir besoin de modifiant autant
le noyau hôte.]

// #figure(
//   cetz.canvas({
//     import cetz.draw: *
//     cell((-3, -1.5), (12, -0.5), color: blue, [Xen])
//     cell((-3, -3), (12, -2), color: gray, [Couche matérielle])
//     cell((-3, 0.5), (0, 6), color: green, [Dom0])
//     cell((0.5, 0.5), (3.5, 6), color: green, [DomU#sub[1]])
//     cell((4, 0.5), (7, 6), color: green, [DomU#sub[2]])
//     cell((9, 0.5), (12, 6), color: green, [DomU#sub[n]])
//   })
//   ,
//   caption: [Architecture de _Xen_]
// ) <architecture_xen>

_Xen_ utilise le terme de _domaine_ pour qualifier les conteneurs des machines
virtuelles en cours d'exécution. Il existe trois types de domaines:
- #box[Le domaine 0 (abrégé _dom0_) désigne un domaine privilégié qui est automatiquement
lancé au démarrage de l'hyperviseur. Le système d'exploitation hôte est généralement
une distribution _Linux_ modifiée ou _Mini-OS_.]
- #box[Les domaines utilisateurs (abrégé _domU_) sont les domaines qui contiennent les
OS invités. Il existe deux types de tels domaines. Les domaines de paravirtualisation
et les domaines _HVM_.]
- #box[_dom0less_.]

=== Stub domains <xen_stubdomains>

#aside[Qu'est-ce qu'un stub domain?][
  Un #definition[stub domain] (ou _stubdomain_) est une mini-machine virtuelle
  légère dédiée à exécuter un seul service isolé dans Xen (comme l'émulateur
  QEMU pour un invité). Au lieu d'exécuter ces services dans le dom0 privilégié
  où une faille compromettrait tout le système, on les isole dans des stub
  domains avec des privilèges minimaux. Cela améliore considérablement la sécurité.
]

Un _stub domain_ (ou _stubdomain_) est un domaine système spécialisé utilisé
pour désagréger le domaine de contrôle (_dom0_) @xen_stubdomain
@xen_device_model_stubdomains. Il s'agit d'un domaine léger dédié à l'exécution
de services ou de pilotes spécifiques, notamment le modèle de périphérique _QEMU_
associé à un domaine HVM.

L'avantage principal des _stub domains_ réside dans l'amélioration de la sécurité
par isolation. Traditionnellement, _QEMU_ et d'autres services critiques s'exécutent
dans le _dom0_ avec des privilèges élevés. En cas de vulnérabilité de sécurité
dans _QEMU_, un attaquant pourrait obtenir un accès privilégié au _dom0_ et
compromettre l'ensemble du système. En exécutant _QEMU_ dans un _stub domain_, ce
dernier est automatiquement déprivilégié (via `XEN_DOMCTL_set_target`) de sorte qu'il
n'a de privilèges que sur le domaine HVM spécifique auquel il est associé.

La plupart des _stub domains_ sont basés sur le système d'exploitation minimaliste
_Mini-OS_ @xen_minios, bien que des travaux aient été menés sur des _stub domains_
basés sur _Linux_.

=== Isolation spatiale <xen_isolation_space>

_Xen_ assure l'isolation mémoire entre les domaines en utilisant différentes
techniques selon le type de virtualisation. Pour les domaines paravirtualisés,
le système _direct paging_ impose que les mises à jour des tables de pages
passent par des hypercalls vérifiés par l'hyperviseur @xen_paravirt_memory. Pour
les domaines HVM, _Xen_ utilise soit des _shadow page tables_ sur les
processeurs anciens, soit une traduction en deux étapes (_EPT_/_NPT_) sur les
processeurs récents, offrant de meilleures performances. Sur _ARM_, _Xen_
s'appuie sur la traduction d'adresses en deux étapes du matériel @xen_arm_mmu.
Pour les systèmes critiques, le mode _dom0less_ permet un partitionnement
statique et une isolation stricte @xen_dom0less_doc. L'hyperviseur suit une
architecture minimale et poursuit une conformité _MISRA C_ pour la certification
@xen_project_4_17_safety.

=== Isolation temporelle <xen_isolation_time>

_Xen_ offre une abstraction des processeurs physiques appelée _vCPU_ (_Virtual
CPU_). La correspondance entre processeur physique et _vCPU_ est souple puisqu'il
n'est pas nécessaire qu'un _vCPU_ corresponde toujours au même processeur
physique, ni même qu'il y ait un processeur physique disponible pour chaque
_vCPU_ à un instant donné. En particulier, il est possible d'avoir davantage
de _vCPU_ que de processeurs physiques. On parle alors d'_oversubscription_.
Toutefois une @vm ne peut pas avoir plus de _vCPU_ que le nombre de
processeurs physiques disponibles.

L'allocation des _vCPU_ sur les processeurs
physiques est géré par un ordonnanceur similaire à ceux utilisés pour des
processus dans un @gpos. La distribution officielle de _Xen_ offre deux
ordonnanceurs généralistes:
- #box[_Credit Scheduler_ est l'ordonnanceur historique du projet _Xen_ et il est
encore à ce jour l'ordonnanceur par défaut @xen_credit_scheduler. Il permet une
répartition juste des processeurs physiques entre les @vm. Plus précisément
chaque @vm dispose d'une fraction du temps _CPU_ total qui est proportionnel à
un poids configuré à l'avance. De plus l'ordonnanceur garantit qu'un processeur
physique ne restera pas inactif s'il y a une tâche
pouvant y être exécutée#footnote[On dit que l'ordonnanceur est _work-conserving_.].]
- #box[_Credit2 Scheduler_ est une évolution de _Credit Scheduler_ @xen_credit2_scheduler.
Il est conçu pour être plus juste et offrir de meilleures performances sur les
serveurs dotés d'un grand nombres de processeurs. Il est disponible depuis la
version _4.8_ de _Xen_.]

Depuis sa version _4.5_, _Xen_ distribue également un ordonnanceur temps réel
baptisé _RTDS_. Nous donnons plus d'informations sur ce dernier dans la sous-section
@xen_determinism.

=== Déterminisme <xen_determinism>

À ses débuts _Xen_ a été conçu pour le _cloud computing_. En particulier,
le projet met l'accent sur les garanties que les ressources louées par des
clients seront effectivement disponibles lorsque leurs @vm:pl les requerront.
Les ordonnanceurs que nous avons vus dans
la sous-section @xen_isolation_time cherchent donc à être aussi juste que
possibles. Cette garantie est en contradiction avec les besoins du temps
réel. En effet une tâche critique peut avoir soudainement besoin de beaucoup
de ressources, si ce n'est la totalité des ressources.

Le projet _RT-Xen_ visait à dôter _Xen_ d'un ordonnanceur temps réel pour ces
_vCPU_. À l'origine le projet est développé à partir d'un _fork_ de la branche
_4.3_ de _Xen_. Il a été intégré dans _Xen_ à partir de la version _4.5_ sous
la forme d'un nouvel ordonnanceur baptisé _RTDS_ (_Real-Time Deferrable Server_)
@xi2014real. L'objectif de _RTDS_ est d'assurer que les @vm:pl reçoivent un
temps _CPU_ minimal garanti. Cet ordonnanceur supporte les plateformes @smp.

Il est donc possible d'exécuter dans une @vm un _RTOS_. Par exemple _RTEMS_
peut être exécuté dans une telle configuration sur architecture _ARM_.

== Corruption mémoire <xen_memory_corruption>

L'hyperviseur _Xen_ ne dispose pas d'un système de journalisation des erreurs
mémoires. En revanche, il transmet ces erreurs au système d'exploitation
exécuté dans le domaine privilégié _Dom0_. Il est alors possible d'utiliser
les outils livrés avec ce système pour journaliser ces erreurs. Il est par
exemple possible d'exécuter un noyau _Linux_ dans le domaine _Dom0_ et
d'utiliser les fonctionnalités de pilotage de la mémoire @ecc décrites en
sous-section @linux_memory_corruption.

== Perte du flux d'exécution <xen_hijacking_criteria>

Comme pour les autres systèmes d'exploitation, _Xen_ est susceptible aux
attaques visant à détourner le flux d'exécution. La protection contre ces
attaques repose principalement sur:
- L'utilisation de langages de programmation sûrs pour certaines composantes,
- Les mécanismes de protection matériels (_Intel CET_, _ARM BTI_) lorsqu'ils
  sont disponibles sur la plateforme cible,
- Les pratiques de développement sécurisé et les revues de code approfondies.

La nature critique de l'hyperviseur _Xen_ en fait une cible privilégiée pour les
attaquants. Une compromission du flux d'exécution au niveau de l'hyperviseur peut
potentiellement affecter tous les domaines hébergés, d'où l'importance cruciale
de ces mécanismes de protection @cfi_survey_embedded.

== Écosystème <xen_ecosystem>

_Xen_ propose plusieurs outils pour le monitoring des performances et de l'état
du système @xen_monitoring_tools @xenserver_monitor_performance:

- _xentop_ @xentop_documentation: Utilitaire similaire à _top_ pour afficher des informations sur tous
  les domaines s'exécutant sur un système _Xen_. Il permet d'identifier les domaines
  responsables des charges les plus élevées en I/O ou en traitement.

- _xenmon_ @xenmon_documentation: Outil utile pour surveiller les performances des domaines _Xen_,
  particulièrement pour identifier les domaines responsables des charges I/O ou
  processeur les plus importantes.

- _RRD (_Round Robin Databases_)_: _Xen_ expose des métriques de performance via
  des bases de données RRD. Ces métriques peuvent être interrogées via HTTP ou
  à travers l'outil _RRD2CSV_. _XenCenter_ utilise ces données pour produire des
  graphes de performance système affichant l'utilisation du CPU, de la mémoire,
  du réseau et des I/O disque.

- _Intégration avec des outils tiers_: _Xen_ supporte l'intégration avec des outils
  de monitoring via _NRPE_ (_Nagios Remote Plugin Executor_) et _SNMP_ (_Simple
  Network Management Protocol_), permettant l'utilisation de solutions de monitoring
  tierces.

- _xl_ @xl_documentation: Outil livré avec _Xen_ qui offre des fonctionnalités basiques pour
  observer l'état des domaines en cours d'exécution.

- _xentrace_ @xentrace_documentation: Outil distribué dans _Xen_ qui permet de tracer l'activité des CPU
  virtuels et ainsi de savoir ce que fait une machine virtuelle sur un CPU donné.
  Ces données sont collectées grâce à des _tracepoints_ positionnés à des endroits
  clés du code de _Xen_. Ils sont activés via _xentrace_ lorsqu'il est exécuté
  dans le domaine _dom0_. Ce dernier produit alors un fichier binaire qui peut
  ensuite être analysé par _xenanalyze_#footnote[Contrairement à _xentrace_,
  _xenanalyze_ n'est pas distribué avec _Xen_.].

- #box[_Xen Orchestra_ est un solution de monitoring pour l'écosystème XenServer
et _XCP-ng_.]
- #box[_Zabbix_ est un système de monitoring open source qui peut surveiller
les performances des domaines.]

== Programmation @baremetal <xen_baremetal>

Il est possible d'exécuter des applications @baremetal dans les domaines
de _Xen_ pour les langages _C_, _Rust_ et _OCaml_.

Pour le langage _C_, _Mini-OS_ @xen_minios est un noyau minimaliste distribué
avec _Xen_ qui fournit une base pour le développement d'applications @baremetal.
Il est principalement utilisé pour les _stub domains_ @xen_stubdomain, des
domaines légers dédiés à l'exécution de composants isolés.

Pour le langage _Rust_, il existe des crates _xen_ et _xen-sys_.

Le projet _MirageOS_ a développé un environnement d'exécution complet pour
le langage de programmation _OCaml_ sur des partitions de type _PVH_
@mirageos_xen_project.

== Watchdog <xen_watchdog>

_Xen_ permet la mise en place d'un _watchdog_ dans _dom0_ ou dans des domaines
utilisateurs. L'exemple ci-dessous met en place un _watchdog_ qui doit être
réinitialisé d'en un laps de temps de 30 secondes:
#figure(
  snippet("./xen/examples/watchdog/init.c", lang:"c"),
  caption: [Exemple d'interaction avec un _watchdog_ sous _Xen_.]
) <xen_watchdog_example>

Pour compiler ce programme, tapez:
```console
make watchdog -C ./xen
```
et pour lancer le programme dans le domaine utilisateur, tapez:
```console
./xen/artifacts/watchdog
```
Il suffit alors de fermer ce programme avec `CTRL-C` pour cesser de réinitialiser
le _watchdog_. Par défaut, _Xen_ terminera le domaine utilisateur. Ce
comportement peut être changé avec l'option `on_watchdog` du fichier de
configuration de _xenlight_. Par exemple, l'option `on_watchdog='reboot'`
provoquera le redémarrage du domaine.

_Xen_ distribue un service _xenwatchdogd_ pour lancer les _watchdogs_
@xen_watchdog_man_page. Le service est lancé en précisant un _timeout_ et un
_sleep_ ainsi:
```console
xenwatchdogd 30 15
```

Notez que l'outil `xl` permet de choisir quelle stratégie appliquer lorsque
le _watchdog_ est déclenché via le paramètre `on_watchdog`. Plus d'informations
sont disponibles dans la page de manuelle `xl.cfg`.

_Linux_ dispose d'un pilote _xen_wdt_ pour le _watchdog_ virtuel de _Xen_ qui
implèmente l'API décrit dans la section @linux_watchdog_api.

== Masquage des interruptions <xen_masking>

Les mécanismes de gestion des interruptions dépendent du type de partitions
considérées.

Dans les partitions _PV_, les interruptions matérielles sont
virtualisées via le concept d'_event PIRQ_ @xen_event_channel_internals.
Plus précisément des _upcall_ sont utilisés en guise de notifications,
c'est-à-dire que l'hyperviseur appelle une routine du système invité pour
l'informer de la survenue d'un événement. Il est possible de masquer ces
événements @xen_event_channel_internals.

Dans le cas d'une partition _HVM_, le système invité a un accès direct
aux interruptions matérielles. Tout ce qui est possible en @baremetal devrait
être également possible dans une telle partition.

Finalement dans le cas d'une partition _PVH_, _Xen_ utilise le support matériel
pour la majorité des interruptions matérielles comme en _HVM_ mais il est
toujours possible d'utiliser des périphériques paravirtualisés et les
_events PIRQ_ pour gérer les interruptions matérielles @xen_misc_pvh.

== Temps de démarrage <xen_booting>

#aside[Qu'est-ce que dom0less?][
  Le mode _dom0less_ est une fonctionnalité _Xen_ permettant de démarrer
  des machines virtuelles invitées directement depuis l'hyperviseur, sans attendre
  que le _dom0_ soit complètement initialisé. Cela réduit drastiquement le
  temps de démarrage (de plusieurs secondes à moins d'une seconde)
  pour les systèmes embarqués et temps-réel où chaque milliseconde compte.
]

Le mode _dom0less_ est une fonctionnalité de _Xen_ permettant d'accélérer
significativement le démarrage des domaines @xen_dom0less_doc
@xen_dom0less_partitioning. Cette optimisation répond à un besoin critique dans
les systèmes embarqués et temps-réel où le temps de démarrage est déterminant.

Traditionnellement, le démarrage d'un domaine depuis l'initialisation du système
nécessite plusieurs étapes séquentielles prenant plusieurs secondes:
1. Démarrage de l'hyperviseur _Xen_
2. Démarrage du noyau _dom0_
3. Initialisation de l'espace utilisateur du _dom0_
4. Disponibilité de l'outil `xl` pour créer les domaines

Avec _dom0less_, _Xen_ démarre les domaines sélectionnés directement depuis
l'hyperviseur au moment du boot, en parallèle sur différents cœurs physiques.
Cette approche permet d'obtenir des temps de démarrage sous-secondes pour les
systèmes temps-réel. Le temps de démarrage total devient approximativement égal
à: temps_xen + temps_domU, éliminant ainsi le surcoût du démarrage du _dom0_ et
de son espace utilisateur.

Cette fonctionnalité est particulièrement adaptée aux systèmes à partitionnement
statique où plusieurs domaines doivent démarrer rapidement lors de l'initialisation
de l'hôte. Elle s'intègre désormais dans le projet _Hyperlaunch_ qui généralise
cette approche.

== Maintenabilité <xen_maintainability>

_Xen_ est un logiciel libre distribué majoritairement sous licence `GPLv2`.
Certaines portions sont distribuées sous des licences plus permissives afin
de ne pas contraindre le choix de licence pour l'utilisateur. Ces exceptions
sont spécifiées dans les en-têtes des fichiers concernés. Plus d'informations
sont disponibles dans le fichier `COPYING` du dépôt git de _Xen_ @xen_licensing.

Il est écrit à 93% en langage _C_ pour un total de 581 193 _SLOC_ dont
45 220 _SLOC_ pour les pilotes. Ces chiffres inclus toutes les architectures
et modes de virtualisation (_PV_, _HVM_ et _PVH_). _Xen_ est donc réputé avoir
une @tcb importante du fait de ce volume de code. Cependant, il faut noter que
la taille du code varie beaucoup suivant l'architecture et le mode de
virtualisation considéré. Ainsi, l'implémentation du mode _PVH_ pour _ARM_
est d'une taille nettement plus réduite.

Le projet _Xen_ a débuté en 1999, ce qui en fait un système d'environ 26 ans.
_Xen_ bénéficie d'un écosystème large dans le domaine du cloud computing
et de l'hébergement.

Le support commercial de _Xen_ est assuré principalement par _Citrix_ à travers
sa distribution _Citrix Hypervisor_. Le _Xen Project_, hébergé par la _Linux
Foundation_, coordonne le développement Open Source et fédère la communauté.

= XtratuM <xtratum>

#showybox(
  title: "XtratuM en bref",
  frame: (
    border-color: maroon.darken(20%),
    title-color: maroon.lighten(80%),
    body-color: maroon.lighten(95%)
  )
)[
  - *Type* : Hyperviseur temps-réel type 1 qualifié ECSS
  - *Langage* : C
  - *Architectures* : x86-32, SPARC/LEON (LEON2/3/4), ARM v7/v8, RISC-V
  - *Usage principal* : Spatial, aéronautique (IMA - Integrated Modular Avionics)
  - *Points forts* : Qualifié ECSS catégorie B, 1000+ satellites déployés,
    ordonnancement cyclique ARINC-653, isolation temporelle et spatiale forte,
    _health monitoring_
  - *Limitations* : Version NG propriétaire, écosystème limité, principalement
    orienté spatial et avionique
  - *Licences* : GPL v2 (version libre) + version propriétaire XtratuM/NG
    (fentISS)
]

_XtratuM_ est un hyperviseur temps-réel qualifié pour un usage dans
l'avionique ou le spatial.

Le projet est initié en 2004 au sein de l'institut _Automática e Informática
Industrial_ (ai2) de l'_Universidad Politécnica_ de Valence en Espagne
@masmano2005overview @red5gespacial. Ces travaux universitaires ont abouti à la
création de l'entreprise _fentISS_ @fentiss_website en 2010 avec le soutien du
_CNES_ et du groupe _Airbus_ @red5gespacial. L'hyperviseur _XtratuM_ est
désormais maintenu et développé par _fentISS_. _XtratuM_ a été conçu pour être
exécuté sur de l'embarqué critique en donnant de fortes garanties quant à
l'isolation spatiale et temporaire de ses partitions @masmano2005overview.

Le succès de _XtratuM_ dans le spatial est remarquable: son hyperviseur temps-réel
est désormais déployé dans plus d'un millier de satellites et engins spatiaux
@xtratum_milestone_1000 @xtratum_missions @fentiss_1000_deployments, en faisant
l'un des logiciels système les plus largement adoptés en orbite. Cette présence
massive témoigne de la maturité et de la fiabilité du système dans des
environnements opérationnels critiques.

== Architectures supportées <xtratum_architectures>

Les premières versions de _XtratuM_ ont supporté les architectures _x86-32_,
_PowerPC_ et _LEON2_. Toutefois les documents récentes ne mentionnent
plus les architectures _x86_ et _PowerPC_, ce qui laisse à penser que leur
support n'a pas été maintenu et nous n'avons pas trouvé de mention de
l'architecture _x86-64_.

D'après les dernières brochures @xtratum_flyer, _XtratuM_ supporte les
architectures suivantes: _ARMv7_, _ARMv8_, _SPARC_, _RISC-V_. En particulier,
il supporte les architectures _SPARCv8_, _LEON3_ et _LEON4_ qui sont utilisées
dans des missions spatiales. Le support se fait via des @bsp.

== Support multi-processeur <xtratum_multiprocessor>

_XtratuM_ était originellement développé sur des architectures
monoprocesseur _x86_ et _LEON_. Le support multi-cœur a donc nécessité de
profondes modifications. C'est une approche à base de @spinlock qui fut
adopter pour assurer la synchronisation des sections critiques du noyau
@xtratum_leon4. Chaque partition peut allouer plusieurs cœurs via une couche
d'abstraction sous forme de _CPU_ virtuels @xtratum_leon4.

== Partitionnement <xtratum_isolation>

Le partitionnement de _XtratuM_ est conforme à la norme _ARINC-653_. Il est donc
conçu pour assurer une excellente isolation temporelle et spatiale de ses
partitions. Chaque partition peut contenir un système d'exploitation ou une
application @baremetal.

=== Partitionnement spatial

Les partitions _XtratuM_ sont exécutés en mode utilisateur.

La plateforme _LEON2_ ne disposait pas nécessairement de _MMU_. Ce n'est plus
le cas des architectures _LEON3_ et _LEON4_ qui incluent un tel dispositif.
_XtratuM_ intègre donc un support pour ce dispositif. En plus d'améliorer
l'isolation spatiale en prévenant les lectures non autorisées, les _MMU_
permettent d'implémenter des @ipc plus rapides @masmano2010xtratum.

=== Partitionnement temporel

_XtratuM_ implémente une politique d'ordonnancement cyclique conforme à la norme
_ARINC-653_. Dans le domaine temporel, _XtratuM_ alloue le CPU aux partitions
selon un plan défini lors de la configuration @lithos_arinc653_xtratum. Il s'agit
d'un ordonnancement cyclique statique (_static cyclic scheduling_) où tous les
intervalles d'exécution des partitions sont déterminés avant l'exécution.

Chaque partition est ordonnancée pour un créneau temporel (_time slot_) défini
par un temps de démarrage et une durée. Durant ce créneau, _XtratuM_ alloue les
ressources système à la partition. Lorsque le créneau de la partition est écoulé,
_XtratuM_ force un changement de contexte vers la partition suivante selon le plan
cyclique défini.

Le système utilise un ordonnancement hiérarchique à deux niveaux: _XtratuM_ gère
l'ordonnancement des partitions au niveau supérieur, tandis que chaque partition
peut exécuter son propre ordonnanceur pour ses tâches internes.

=== Communication inter-partition <xtratum_ipc>

_XtratuM_ fournit un mécanisme de communication inter-partition (_IPC_) conforme
à la norme _ARINC-653_ @xtratum_arinc653_ipc @lithos_arinc653_xtratum. Ce
mécanisme permet l'échange de messages entre les partitions _ARINC_ s'exécutant
sur la même carte.

Un _canal_ (_channel_) est un lien logique entre une partition source et une ou
plusieurs partitions de destination. Les partitions peuvent envoyer et recevoir
des messages via plusieurs canaux à travers des points d'accès définis appelés
_ports_. _XtratuM_ utilise deux interruptions virtuelles pour notifier les
partitions de la disponibilité de nouveaux messages dans les ports de destination.

La norme _ARINC-653_ définit deux modes de transfert de messages:

- *Mode échantillonnage* (_sampling mode_): Supporte les messages multicast
  envoyés d'une seule source vers plusieurs destinations. La transmission d'un
  message sur un canal copie le message du port d'échantillonnage source vers
  les tampons de tous les ports d'échantillonnage de destination. Ce mode convient
  aux données périodiques où seule la dernière valeur est pertinente.

- *Mode file d'attente* (_queuing mode_): Ne supporte que les messages unicast.
  Les messages sont mis en file d'attente et traités séquentiellement. Ce mode
  convient aux événements sporadiques qui nécessitent un traitement ordonné.

=== Déterminisme

=== OS invités supportés

L'hyperviseur de _XtratuM_ offre un support pour les _OS_ suivants:
- Le @rtos LithOS développé par _fentISS_ et conforme _ARINC-653_
  @xtratum_lithos @lithos_arinc653_xtratum,
- Le @rtos _RTEMS_, notamment sur les plateformes _LEON_ @xtratum_homepage,
- Le noyau _Linux_ @xtratum_homepage,
- Le micronoyau temps réel _ORK+_ (_Open Ravenscar Kernel_).
  Il a été porté sur _XtratuM_ en 2011 @esquinas2011ork. Il permet le
  développement d'applications en _Ada_ avec le profile _Ravenscar_.

== Programmation @baremetal <xtratum_baremetal>

Il est possible d'exécuter des applications @baremetal dans les partitions
de _Xtratum_ à condition d'adapter un @rte du langage
de programmation pour l'@api de _Xtratum_. Il est possible de programmer en
@baremetal avec les langages suivants:
- #box[_C_ grâce au @rte _XRE_ (_XUL Runtime Environment_) développé par _fentISS_,]
- #box[_Ada_ avec le profile _Ravenscar_,]
- #box[_Rust_ peut être utilisé en @baremetal en interfaçant avec l'@abi _C_
de _XtratuM_. Une _crate_ est disponible @xtratum_xng_rs.]

== Corruption mémoire <xtratum_memory_corruption>
Le _Health Monitor_ d'_XtratuM_ est capable de journaliser les @mce en cas
d'erreur de mémoire non corrigible. Comme pour les autres erreurs, il est possible
de configurer un paliatif.

== Écosystème <xtratum_ecosystem>

L'entreprise _fentISS_ commercialise une suite d'outils pour faciliter le
développement avec _XtratuM_. Cette suite inclus les outils suivants:
- _SKE_ @xtratum_ske: simulateur _XtratuM_ sur serveurs,
- _XPM_ @xtratum_homepage: plugin Eclipse pour la gestion de projets _XtratuM_,
- _Xoncrete_ @xtratum_homepage: analyse et génération d'ordonnancement,
- _Xmcparser_ @xtratum_user_manual_esa: configuration de l'hyperviseur,
- _Xtraceview_ @xtratum_fentiss_the_xtratum_hypervisor: support d'observabilité.

=== _Health monitoring_

_XtratuM_ intègre un service de _health monitoring_ conforme à la norme _ARINC-653_
@lithos_arinc653_xtratum. Ce service permet la détection et la gestion des
défaillances des partitions.

Lorsqu'un événement de _health monitoring_ est déclenché, le système peut entreprendre
des actions correctives telles que des changements de mode. Par défaut, le Plan 1
(mode maintenance) est le plan exécuté lorsqu'un événement sélectionne un changement
de mode comme action.

Le principe d'isolation des partitions garantit que la défaillance d'une partition
n'affecte pas les autres partitions. Cependant, bien qu'une partition ne puisse
pas affecter les autres partitions, la défaillance peut toujours se produire et
potentiellement conduire à une défaillance du système global. Le service de _health
monitoring_ permet de limiter ces risques par une détection précoce et des actions
de récupération appropriées.

== Support de _watchdog_ <xtratum_watchdog>

Nous n'avons pas trouvé d'informations sur le support de _watchdog_. Toutefois
étant donné le domaine d'application de cet hyperviseur, il est très probable
qu'un tel support existe.

== Temps de démarrage <xtratum_boot_time>

Nous n'avons pas trouvé d'informations sur le temps de démarrage de
l'hyperviseur _XtratuM_.

== Qualifications et certifications <xtratum_qualifications>

ECSS-Qualified?

_XtratuM_ est qualifié selon la norme _ECSS_ (_European Cooperation for Space Standardization_)
catégorie B @xtratum_ecss_qualification. Cette qualification en fait un hyperviseur
adapté aux missions spatiales critiques.

L'hyperviseur a été qualifié initialement pour les processeurs _SPARC-Leon_ et
_ARM Cortex-R4/R5_ et _A9_. L'entreprise _fentISS_ continue de travailler sur la
qualification de nouvelles versions, notamment _XtratuM Next Generation_ pour
lequel un processus de qualification ECSS niveau B est en cours.

== Masquage des interruptions <xtratum_interrupt_masking>

_XtratuM_ virtualise les interruptions matérielles pour garantir l'isolation
spatiale et temporelle des partitions conformément à la norme _ARINC-653_. Les
partitions ne peuvent pas accéder directement à la table des interruptions ni
interagir avec les interruptions matérielles natives. Toute tentative
d'activation ou de désactivation directe des interruptions matérielles déclenche
un _trap_ géré par l'hyperviseur @xtratum_user_manual @xtratum_tsp_aerospace.

=== Virtualisation des interruptions

L'hyperviseur définit ses propres interruptions virtuelles qui sont délivrées
aux partitions @xtratum_user_manual. Toutes les interruptions matérielles sont
directement gérées par _XtratuM_ et, lorsque nécessaire, propagées aux
partitions qui définissent leur propre table d'interruptions virtuelles
@xtratum_virtual_interrupts. Le sous-système d'interruptions virtuelles a été
réécrit de zéro dans la version 3.1 de _XtratuM_.

Durant l'exécution d'une partition, seules les interruptions allouées à cette
partition sont activées au niveau matériel, ce qui minimise les interférences
entre partitions grâce à un mécanisme d'isolation matériel
@xtratum_leon3. Lorsqu'une partition est dans l'état suspendu, son _CPU_ virtuel
n'est pas ordonnancé et les interruptions ne sont pas délivrées. Les
interruptions survenues pendant cet état restent en attente
@xtratum_tsp_aerospace.

=== @api de masquage des interruptions

_XtratuM_ fournit une @api basée sur des _hypercalls_ pour permettre aux
partitions de masquer et démasquer les interruptions virtuelles
@xtratum_libxm. Les principaux _hypercalls_ disponibles sont:
- #box[`XM_mask_irq()` : masque une interruption virtuelle spécifique,]
- #box[`XM_unmask_irq()` : démasque une interruption virtuelle.]

Ces _hypercalls_ vérifient que le numéro d'interruption est dans les plages
autorisées (interruptions matérielles ou interruptions étendues) et utilisent
des opérations atomiques (`XMAtomicSetMask` et `XMAtomicClearMask`) pour
modifier les masques d'interruption dans la _Partition Control Table_ (pct)
@xtratum_libxm. Une partition ne peut masquer que les interruptions matérielles
qui lui ont été allouées, ce qui fait partie de la stratégie de _XtratuM_ pour
maintenir l'isolation temporelle et spatiale entre les partitions dans les
systèmes critiques @xtratum_libxm.

=== _Health Monitor_

_XtratuM_ intègre un module appelé _Health Monitor_ qui gère de façon étendue
les _traps_, les interruptions et les erreurs @xtratum_leon3. Ce module permet
la détection et la gestion centralisée des événements liés aux interruptions,
contribuant à la robustesse du système dans un contexte critique.

== Maintenabilité <xtratum_maitainability>

À l'origine _XtratuM_ était un projet open source sous licence _GPLv2_
@xtratum_mirror_source. Cette version ne semble plus être développée et
_fentISS_ distribue une réécriture du noyau appelée _XNG_ (_XtratuM Next
Generation_) sous licence propriétaire @xtratum_derisc @xtratum_metasat.
L'entreprise _fentISS_ ne semble pas communiquer sur ses licences. Les modalités
sont donc probablement à négocier avec _fentISS_ au cas par cas.

Nous n'avons pas pu évaluer la taille de la base de code, faute d'informations
librement accessibles. _XtratuM_ étant un noyau de séparation certifiable, sa
base de code doit être réduite afin de rendre la certification possible.

La qualification _ECSS_ catégorie B et la conformité à la norme _ARINC-653_
impliquent l'existence d'une documentation technique structurée. La norme _ECSS_
pour les systèmes spatiaux exige une documentation complète du cycle de vie
logiciel, incluant les spécifications, la conception, les tests et la
validation. De même, la conformité _ARINC-653_ nécessite une documentation
détaillée des interfaces de partitionnement et des mécanismes de communication
inter-partitions.

Le projet _XtratuM_ a été initié en 2004, ce qui en fait un système d'environ
21 ans. Ayant été réécrit au alentour de , sa base de code aurait en fait .

Le projet _XtratuM_ a été initié en 2004 au sein de l'institut _Automática e
Informática Industrial_ (ai2) de l'_Universidad Politécnica_ de Valence en
Espagne, ce qui en fait un système d'environ 21 ans. Le projet a connu une
transition majeure avec le passage de la version open-source originale à la
version propriétaire _XNG_ (_XtratuM Next Generation_) développée par _fentISS_.

_XtratuM_ s'inscrit dans l'écosystème aérospatial européen, notamment à travers
le projet _SAFEST_ qui vise à faire collaborer différents acteurs du secteur
pour améliorer les performances et réduire les coûts. Le système cible
particulièrement l'_IMA_ (_Integrated Modular Avionics_), une approche visant
à consolider des fonctions logicielles auparavant dispersées sur des calculateurs
dédiés.

Le support commercial de _XtratuM_ est assuré par l'entreprise _fentISS_ qui
développe et maintient la version _XNG_.

= Tableaux comparitifs <comparison_tables>

#let scell(color: white, txt) = table.cell(fill: color.lighten(40%), [#txt])


#let good(txt) = scell(color:green, txt)
#let mediocre(txt) = scell(color:yellow, txt)
#let bad(txt) = scell(color:red, txt)
#let unknown(txt) = scell(color:black, txt)

#let supported(txt) = scell(color:green, txt)
#let notsupported(txt) = scell(color:red, txt)
#let partiallysupported(txt) = scell(color:yellow, txt)
#let deprecated(txt) = scell(color:black, txt)

Ce dernier chapitre regroupe des tableaux récapitulatifs et comparatifs suivant
les différents critères de l'étude.

== Type de système d'exploitation <table_kind>

#figure(
table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  align: (x, _) => { if x == 0 { left } else { center } },
  table.header[OS][Temps réel][Hyperviseur][LibOS][GPOS][RTOS][Noyau de sép.],
  [Linux],
  good([]), good([]), bad([]), good([]), bad([]), bad([]),

  [MirageOS],
  bad([]), bad([]), good([]), bad([]), bad([]), bad([]),

  [PikeOS],
  good([]), good([]), bad([]), bad([]), bad([]), good([]),

  [ProvenVisor],
  good([]), good([]), bad([]), bad([]), bad([]), good([]),

  [RTEMS],
  good([]), bad([]), bad([]), bad([]), good([]), bad([]),

  [seL4],
  good([]), good([]), bad([]), bad([]), bad([]), good([]),

  [Xen],
  mediocre([]), good([]), bad([]), bad([]), bad([]), mediocre([]),

  [XtratuM],
  good([]), good([]), bad([]), bad([]), bad([]), good([]),
),
caption: [Type de systèmes d'exploitation]
)

== Architectures supportées <table_supported_architectures>

Le tableau ci-dessous résume le support des architectures par système
d'exploitation.

#figure(
table(
  columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
  align: center + horizon,
  table.header(
    [OS],
    [x86-32],
    [x86-64],
    [ARMv7],
    [ARMv8],
    [PowerPC],
    [MIPS],
    [RISC-V],
    [SPARC]
  ),

  [Linux],
  good([]), good([]), good([]), good([]), good([]), good([]), good([]), good([]),

  [MirageOS],
  mediocre([OCaml < 5]), good([]), mediocre([OCaml < 5]), good([]),
  mediocre([spt]), bad([]), bad([]), bad([]),

  [PikeOS],
  bad([]), good([]), good([]), good([]),
  good([]), bad([]), good([]), good([]),

  [ProvenVisor],
  bad([]), bad([]), bad([]), good([]),
  bad([]), bad([]), bad([]), bad([]),

  [RTEMS],
  good([]), good([]), good([]), good([]),
  good([]), good([]), good([]), good([]),

  [seL4],
  good([]), good([]), good([]), good([]),
  bad([]), bad([]), good([]), bad([]),

  [Xen],
  good([]), good([]), good([]), good([]),
  mediocre([]), mediocre([]), bad([]), bad([]),

  [XtratuM],
  deprecated([?]), bad([?]), good([]), good([]),
  good([]), bad([]), good([]), good([]),
),
caption: [Architectures supportées par système d'exploitation.]
)

Quelques remarques pour l'interprétation de ces informations:
- Pour les hyperviseurs, il faut un support matériel supplémentaire pour tirer
  le meilleur du matériel. Le lecteur peut se rapporter à la section du système
  concerné pour trouver ces informations,
- Pour les hyperviseurs, il faut que le système invité supporte également
  l'architecture, à moins d'avoir recours la virtualisation complète,
- Le support de l'architecture ne suffit pas à supporter n'importe quelle carte
  de cette architecture. _PikeOS_, _ProvenVisor_, _RTEMS_, _seL4_ et
  _XtratuM_ publient des @bsp pour des cartes et des architectures spécifiques.
  En dernier terme, seul l'existence de ce @bsp fait foi pour le support d'une
  carte donnée.

== Partitionnement temporel <table_time_isolation>

== Programmation @baremetal <table_baremetal_programming>

#figure(
table(
  columns: (1.5fr, 1.5fr, 1.5fr, 1.5fr, 1.5fr),
  align: center + horizon,
  table.header(
    [Hyperviseur],
    [Ada],
    [C],
    [OCaml],
    [Rust]
  ),

  [KVM (Linux)],
  bad([]), good([]), good([]), good([]),

  [PikeOS],
  good([Ravenscar]), good([]), bad([]), good([]),

  [ProvenVisor],
  unknown([]), unknown([]), unknown([]), unknown([]),

  [seL4],
  bad([]), good([]), bad([]), good([]),

  [Xen],
  bad([]), good([]), good([]), good([]),

  [XtratuM],
  good([Ravenscar]), good([]), bad([]), good([]),
)
)

== Maintenabilité <table_maintainability>

Le tableau ci-dessous rassemble les informations relatives à la maintenabilité
des différents systèmes d'exploitation de l'étude.

#figure(
table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  align: center + horizon,
  table.header(
    [OS],
    [Licence(s)],
    [Écosystème],
    [Taille (SLOC)],
    [Doc],
    [Support commercial],
    [Ancienneté (années)]
  ),

  [Linux],
  good([GPLv2]), good([Très large]), bad([~27M]), good([Excellente]), [Red Hat, SUSE, Canonical, ...], [~34],

  [MirageOS],
  good([ISC/LGPLv2]), mediocre([Moyen]), good([< 10k]), good([Bonne]), [Tarides], [~16],

  [PikeOS],
  bad([Propriétaire]), mediocre([Moyen]), unknown([]), mediocre([Limitée]), [SYSGO], [~20],

  [ProvenVisor],
  bad([Propriétaire]), bad([Limité]), unknown([]), unknown([]), [ProvenRun], [~10],

  [RTEMS],
  good([BSD 2-Clause]), good([Large]), bad([~2M]), mediocre([limitée]), [OAR], [~32],

  [seL4],
  good([GPLv2]), (mediocre[Moyen]), good([~70k]), mediocre([Technique]), [seL4], [~19],

  [Xen],
  good([GPLv2]), good([Large]), bad([~500k]), mediocre([Datée]), [Citrix, Xen Project], [~22],

  [XtratuM],
  bad([Propriétaire]), bad([Limité]), unknown[], unknown([]), [fentISS], [~21]
),
caption: [Comparaison de la maintenabilité des systèmes d'exploitation.]
)

Quelques remarques pour l'interprétation de ces données:
- Les tailles des bases de code ont été estimées en utilisant le logiciel
  `SLOCCount` @sloccount_website. Ce dernier utilise le _SLOC_ (_source line of
  code_) comme unité et n'inclut pas les commentaires dans le comptage. De plus,
  nous n'avons pas pris les pilotes en compte dans la mesure. Cela explique
  certaines divergences avec des chiffres trouvables sur le web. Par exemple
  _Linux_ distribue une quantité colossale de pilotes pour un total de l'ordre
  de dizaines de millions de _SLOC_. La majorités de ces lignes de code
  n'aboutissent pas dans l'exécutable final et il serait injuste de les prendre
  en compte,
- Pour _MirageOS_, la taille de la base de code ne concerne que le noyau
  irréductible de l'OS. En pratique, il faut utiliser d'autres bibliothèques
  du projet _MirageOS_ pour développer son application,
- Pour _seL4_, le tableau comparatif ne prend pas en compte la maintenance
  des preuves qui constituent en réalité une part importante des efforts
  de développement,
- Si l'ancienneté est souvent un gage de stabilité, elle entraîne aussi une
  dette technique plus importante. On constate que les systèmes les plus anciens
  sont également ceux ayant la base de code la plus volumineuse. En
  contrepartie, ils sont un écosystème plus développé et mature.

#glossary(
  title: "Glossaire",
  sort: true,
  ignore-case: false,
)

#bibliography("references.bib")
