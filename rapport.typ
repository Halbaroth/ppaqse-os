#import "@preview/hydra:0.6.2": hydra
#import "@preview/cetz:0.4.1"
#import "@preview/showybox:2.0.4": showybox
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/glossy:0.8.0": *
#import "@preview/oxifmt:1.0.0": strfmt
#import fletcher.shapes: house, hexagon
#set text(lang: "fr", size: 12pt)
#set par(justify: true)

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

#show raw.where(block: true): set text(font: "FiraCode Nerd Font Mono")

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
          [#text(size: 11pt, style: "italic", fill: rgb("#003366"))[#datetime.today().display()]]
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
	pos, align(center)[#text(font: "Fira Sans", size: 11pt)[#label]],
	width: width,
	fill: gradient.radial(white, tint, center: (40%, 20%), radius: 150%),
	corner-radius: 3pt,
 	stroke: 1pt + tint.darken(20%),
	..args,
)

= Introduction <introduction>

L'usage de composants informatiques dans les systèmes critiques
est de nos jours monnaie courante. De tels composants se retrouvent dans des
systèmes critiques de nombreuses industries comme l'aéronautique, l'automobile et
le nucléaire. Ainsi, la sûreté des logiciels devient un enjeu crucial et en
particulier celle du système d'exploitation. Le développement et la maintenance
d'un système d'exploitation étant complexe et coûteux, il est souhaitable
d'utiliser une solution informatique sur étagères #footnote[On parle
parfois de _COTS_ pour _Commercial off-the-shelf_.], c'est-à-dire dans le cas présent
un système d'exploitation ayant été conçu pour les systèmes critiques.

Le document présent est une étude comparative de systèmes d'exploitation utilisés
dans un contexte critique et temps réel.
Plus précisément, nous étudions les systèmes d'exploitation suivants#footnote[
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

L'étude met d'abord l'accent sur l'aspect @safety des systèmes d'exploitation,
toutefois certains des systèmes listés ci-dessus sont dédiés à la @security
informatique et des concepts liés à la sécurité seront donc abordés lorsque nous
les examinerons.

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

Le système en question
peut être un serveur, un ordinateur personnel ou un système embarqué. Le rôle
principal du système d'exploitation est de fournir une couche d'abstraction logicielle entre le
matériel et les logiciels applicatifs. Il permet ainsi de masquer la complexité
et la diversité des interfaces matérielles en fournissant des interfaces stables,
unifiées et parfois standardisées.

== Pourquoi utiliser un système d'exploitation? <why_os>

Bien que l'usage des systèmes d'exploitation dans les composants critiques se
généralise, il n'est pas sans alternative. Une autre approche consiste à
exécuter l'application directement sur la couche matérielle. On parle alors de
programme @baremetal.

Néanmoins, l'adoption d'un système d'exploitation procure des avantages considérables,
principalement en facilitant la conception et la portabilité des applications.
Le tableau @compare_os_baremetal livre quelques éléments de comparaison entre
ces deux approches. Notez cependant que les bénéfices apportés par un OS varient
considérablement d'un système. Comparer ces apports est l'un des enjeux de cette
étude.

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
    [Support absent.],

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

= Critères de comparaison

Au travers de cette étude, les systèmes d'exploitation ont été étudiés et comparés
suivant les critères détaillés ci-dessous. Il est noté que certains critères
n'étaient pas pertinent pour l'ensemble des systèmes, auquel cas la section
corresponde justifie son élision.

L'étude est organisée suivant le plan suivant:
- #box[Le chapitre @general_notions contient des généralités sur les systèmes
d'exploitations et les interfaces matérielles. Les notions abordées sont ensuite
librement utilisée dans les chapitres ultérieurs.]
- #box[Les chapitres @linux, @mirageos, @pikeos, @provenvisor, @rtems, @sel4,
@xen, @xtratum exposent chacun des OS étudiés.]
- #box[Le chapitre @comp contient des tableaux comparatifs.]

== Type de systèmes d'exploitation
Dans ce document, nous classons les systèmes d'exploitation étudiés en quatre
grandes catégories:
- #box[Les #definition[systèmes d'exploitation généralistes]
@gpos constituent la
classe la plus connue du grand public. Ils sont le plus souvent directement
exécutés au-dessus de la couche matérielle et offrent un large éventail de
services. Leur domaine d'application est particulièrement vaste puisqu'on les
retrouve aussi bien sur les ordinateurs personnels, les smartphones que les
serveurs et les systèmes embarqués. Parmi les systèmes les plus connus, on
peut citer _Linux_, _Windows_ et _macOS_.]
- #box[Les #definition[hyperviseurs]#footnote[On parle également de
_Virtual Machine Monitor_ abrégé _VMM_.] sont des systèmes d'exploitation dédiés à
la virtualisation, c'est-à-dire à l'exécution d'OS invités au-dessus d'une couche
logicielle. On les retrouve fréquemment sur des serveurs exécutant simultanément
plusieurs OS invités. Parmi les systèmes les plus utilisés, on peut citer
_VMware vSphere_, _Hyper-V_, _KVM_, _VirtualBox_ ou encore QEMU. Plus d'informations
sont disponibles dans la section @type_hypervisor.]
- #box[Les #definition[systèmes d'exploitation temps-réels] (_RTOS_ pour
_Real-Time Operating System_) sont des systèmes d'exploitation donnant des
garanties sur le temps d'exécution. Plus d'informations sont disponibles dans la
section @type_rtos.]
- #box[Les #definition[bibliothèques d'OS] (_LibOS_ pour _Library Operating System_)
ne sont pas à proprement parler des systèmes d'exploitation mais plutôt des collections de
bibliothèques permettant d'exécuter des logiciels sans avoir recours à un _GPOS_.
Le développeur lie les modules indispensables à son programme, afin de produire
une image appelée un #definition[unikernel]. Celui-ci peut ensuite être exécuté
sur un hyperviseur ou en _bare-metal_, c'est-à-dire
directement sur la couche matérielle.]

== Architectures supportées <architectures>
Pour chacun des systèmes d'exploitation étudiés, nous donnons une liste des
différentes architectures supportées. Afin que cet effort soit tenable,
nous avons sélectionné les architectures avec les critères suivants:
- #box[L'architecture doit être utilisé dans de véritables systèmes critiques,]
- #box[L'architecture doit être supportée nativement, c'est-à-dire que le
système d'exploitation doit pourvoir s'exécuter sur une telle architecture
sans avoir recours à un mécanisme d'émulation,]
- #box[Certain système ont une longue histoire rendant une documentation
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

== Support multi-processeur

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
- #box[Les architectures @amp sont constituées le plus souvent d'un
ensemble de cœurs hétérogènes. Ces cœurs ne partagent pas leurs caches ou leur
bus mémoire. Ces architectures sont conçues pour exécuter des instances distinctes de
programmes @baremetal sur chaque cœur. Cette isolation des cœurs offre un
très bon déterminisme du système et une meilleure isolation des tâches. En
contrepartie, les mécanismes de communication interprocesseur sont à la charge
du développeur. Ces architectures sont depuis longtemps présentes dans
l'embarqué critique, notamment sous la forme de @mpsoc.]
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

== Temps-réel

Comme nous l'avons expliqué dans la sous-section @criticity_real_time, les
logiciels, et en particulier le système d'exploitation, d'un système critique
doivent fournir des garanties sur le temps d'exécution de leurs routines. En informatique
usuelle, le temps d'exécution d'un programme ne fait généralement pas parti
de sa correction#footnote[Une exception notable est celle des applications multimédia.].
Ce n'est plus le cas dans un système temps réel où répondre après
un délai trop long conduit à un résultat erroné. On souhaite donc que les calculs
soient fait suffisamment vite en toute circonstance, tandis qu'en informatique
usuelle on cherche généralement à ce que les calculs soient fait le plus vite possible
en moyenne.

Afin d'offrir ces garanties temps réel, le système d'exploitation doit être
aussi déterministe que possible. Ce déterminisme permet en pratique d'estimer
le temps d'exécution de ses routines dans le pire cas#footnote[Ce concept est souvent appelé
_WCET_ (_Worst Case Execution Time_) dans la littérature.]. Le déterminisme est
souvent assuré par le caractère préemptible du noyau#footnote[Nous verrons
toutefois avec l'exemple de _seL4_ que ce n'est pas toujours la bonne approche
pour obtenir le déterminisme.] et des éventuelles autres tâches. En effet,
lorsqu'une tâche critique doit commencer son exécution aussi vite que
possible, il ne faut pas que celle-ci doive attendre
la fin de l'exécution d'une longue routine du noyau ou la fin de la tranche
de temps d'une tâche de plus faible priorité. La latence du système
d'exploitation est donc une mesure importante pour assurer le respect des échéances.

== Partitionnement

== Corruption de la mémoire

Nous avons étudié le support logiciel des différents systèmes visant à prévenir
la corruption de la mémoire. On distingue deux types d'erreurs:
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

#aside[support matériel de l'ECC][
  Les mémoires @ecc nécessitent un support spécifique par le contrôleur mémoire,
  le _CPU_ et le _BIOS_. Si ce support est rare sur le matériel grand public,
  il est en revanche commun dans celui destiné aux serveurs.
]

== Support de _watchdog_

Un #definition[watchdog] est un dispositif matériel ou logiciel conçu
pour détecter le blocage d'un système informatique, et de réagir
de manière autonome pour ramener ce système dans un état normal. Qu'il s'agisse
d'un dispositif matériel ou logiciel, le principe du watchdog consiste le plus
souvent à demander au système surveillé d'envoyer régulièrement un signal à
un système surveillant. Le système surveillé dispose d'une fenêtre de temps
pour cette action. S'il n'effectue pas la tâche dans le temps imparti, il est
présumé dysfonctionnel. Le système surveillant peut alors tenter de remédier
à la situation. Le plus souvent cela consiste à redémarrer la machine.

Les appareils embarqués et les serveurs à haute disponibilité ont souvent
recours aux _watchdogs_ pour améliorer leur fiabilité. Pour chacun des systèmes
nous avons étudiés le support des _watchdog_ logiciels et matériels et avons
fourni un exemple d'utilisation lorsque cela était possible.

== Support de langages de programmation en baremetal

La programmation @baremetal était et demeure commune dans les systèmes critiques.
Toutefois, comme mentionné dans la sous-section @why_os, l'adoption d'un système
d'exploitation offre de nombreuses avantages, notamment en permettant
l'isolation logicielle de plusieurs tâches critiques.
Il est donc fréquent de vouloir porter des applications @baremetal existantes
vers des architectures virtualisées pour bénéficier de l'isolation offertes
par ces dernières.

C'est dans cette optique que nous avons examiné les possibilités offertes en
matière de programmation @baremetal par les hyperviseurs étudiés. Notre analyse
est circonscrite aux langages de programmation _Ada_, _C_, _OCaml_ et _Rust_.

Le principal défi d'un tel portage est d'adapter le @runtime de ces langages pour
l'hyperviseur donné. Dans le cas de _Ada_, _C_ et _Rust_ se portage est grandement
faciliter par la possibilité de limiter la taille du @runtime et de se passer
de la majorité de la bibliothèque standard ou de la remplacer par une bibliothèque
dédiée au @baremetal. Pour le langage _OCaml_, la difficulté est plus importante
car son @runtime contient un @gc, ce qui implique de devoir porter un plus
grand nombre d'appels systèmes.

== Temps de démarrage

Pour les hyperviseurs, le temps de démarrage des @vm est une métrique importante
de leur performance. En cas de défaillance d'une @vm, on espère
que celle-ci soit relancée aussi rapidement que possible. Un autre usage
courant, notamment dans le cloud computing, est de lancer des @vm à la demande
pour s'adapter au mieux aux variations de la charge de travail. Ces @vm doivent
se lancer rapidement pour garantir des temps de réponse acceptables.

== Maintenabilité

L'usage d'un @cots présente le risque d'une rupture de la maintenance du système.

La maintenabilité du système d'exploitation est évalué à travers différents
sous-critères:
- La taille du code source.
- La modularité de la base de code et la complexité des invariants de celle-ci.
- L'organisation et le nombres de développeurs.

= Linux <linux>

Le noyau _Linux_ est un @gpos libre de type _UNIX_. L'ensemble des
fonctionnalités offertes par _Linux_ inclut:
- #box[Un ordonnanceur de tâches avec des politiques adaptées à un usage @gpos
ou temps-réel,]
- #box[Un excellent support des architectures @smp,]
- #box[Un support de très nombreux systèmes de fichiers,]
- #box[Une pile réseau supportant de nombreux protocoles,]
- #box[Un support matériel étendu grâces aux nombreux pilotes, souvent
écrits par les fabricants eux-mêmes,]
- #box[Une API stable respectant une grande partie de la norme _POSIX_
#footnote[Contrairement à d'autres systèmes _UNIX_, le noyau _Linux_ n'a pas
fait l'objet de certifications pour le standard _POSIX_.].]

Le développement du noyau débute en 1991 sous la forme d'un projet
personnel de Linus Torvalds, alors étudiant en informatique à l'université
d'Helsinki en Finlande. Linus entreprit d'écrire un noyau après avoir
constaté qu'il n'existait pas de système _UNIX_ bon marché capable d'exploiter
pleinement les capacités de son nouveau processeur 32 bits _Intel 80386_.
Le projet prend alors rapidement de l'ampleur, notamment après l'adoption en
1992 de la licence _GPLv2_ pour distribuer le code source. Ce changement
de licence a permis au noyau d'utiliser les outils du projet @gnu afin de
fournir un système d'exploitation complet. La première version majeure `1.0`
est publiée en 1994 avec un support pour l'interfaces graphiques via le projet
_XFree86_. Cette année là les distributions _GNU/Linux_ _Red Hat_ et _SUSE_ publient
leur première version majeure. À partir de 1995 avec la version `1.1.85`, le
noyau passe d'une architecture @monolithic à une approche modulaire, permettant
le chargement à chaud de modules. La version `2.0` publiée
en 1996 propose un support pour les architecture @smp. En 2007, la version
`2.6.20` intègre un hyperviseur baptisé _KVM_. En 2024, la totalité des
patchs du projet _PREEMPT_RT_ sont intégrés dans le noyau, faisant de _Linux_
un _RTOS_.

De nos jours le noyau _Linux_ est développé par une communauté décentralisée de
développeurs. De très nombreuses entreprises contribuent au noyau, notamment aux
pilotes (_Intel_, _Google_, _Samsung_, _AMD_, ...).

== Architectures supportées <linux_architectures>

À l'origine, le noyau _Linux_ était uniquement développé pour
l'architecture _x86-32_. Il a depuis été porté sur de très nombreuses autres
architectures @linux_arch. Il fonctionne notamment sur les architectures
suivantes: _x86-32_, _x86-64_, _ARM v7_, _ARM v8_, _PowerPC_, _MIPS_, _RISC-V_
et _SPARC_.

Quant à l'hyperviseur _KVM_, il supporte la virtualisation assistée par
le matériel sur certaines architectures. Sur architecture _x86_, il supporte
les extensions _Intel VT-x_ et _AMD-V_. Sur architecture _ARM_, il supporte
l'extension de virtualisation de _ARM v7_ à partir
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
en lecture. Quant à l'ordonnanceur de tâche _EEVDF_
(_Earliest Eligible Virtual Deadline First_), il
est conçu pour répartir aussi équitablement que possible le temps _CPU_
entre les processus avec une faible latence. C'est l'ordonnanceur par défaut depuis
la version _6.6_.

Pour vérifier que votre noyau en cours d'exécution a été compilé avec ce support,
tapez la commande suivante:
```console
zcat /proc/config.gz | grep CONFIG_SMP
```

#aside[`CONFIG_SMP` obligatoire][
  Le support @smp ne sera plus optionnel à partir de _Linux 6.17_ pour la
  majorité des architectures @linux_unconditional_smp. Les monoprocesseurs sont
  de plus en plus rares et les primitives introduites pour le support @smp
  n'engendrent qu'un surcoût mineur. Cette décision permettra de simplifier le
  code source du noyau.
]

=== Architectures @amp <linux_amp>

Depuis la branche `3.x`, le noyau _Linux_ offre un support pour les processeurs
distants via les sous-systèmes `remoteproc` @linux_remoteproc et `RPMsg` @linux_rpmsg.
Vous pouvez vérifier que votre noyau est compilé avec le support pour ces systèmes
via respectivement les commandes:
```console
zcat /proc/config.gz | grep CONFIG_REMOTEPROC
zcat /proc/config.gz | grep CONFIG_RPMSG
```

Le cas d'usage typique est l'exécution d'un _RTOS_ sur un processeur secondaire
dans un système embarqué hétérogène sous la forme d'un @mpsoc. Avant l'apparition
de `remoteproc`, le contrôle des processeurs secondaires se faisait via des @api
propriétaires et non standardisées. Quant au système _RPMsg_
(_Remote Processor Messaging_), il permet la intercommunication avec un
processeur distant via un protocole asynchrone à la _virtio_.

== Temps réel <linux_real_time>

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
        #text(font: "Fira Sans", size: 11pt)[Linux]]]]],
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
    align(center)[#text(font: "Fira Sans")[#body]],
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
      text(font: "Fira Sans")[Noyau Linux + _PREEMPT_RT_])
  })
  ,
  caption: [Architecture de _Linux_ avec _PREEMPT_RT_]
) <architecture_preempt_rt>

#aside[installation][
  Bien que _PREEMPT_RT_ soit désormais distribué avec la branche
  principale du noyau, il est nécessaire de compiler ce dernier avec l'option
  de compilation `CONFIG_PREEMPT_RT` activée pour obtenir un noyau préemptible.
  Pour vérifier que votre noyau en cours d'exécution a été compilé avec ce support,
  vous pouvez tapez la commande:
  ```console
  zcat /proc/config.gz | grep PREEMPT_RT
  ```
  Certaines distributions comme _Fedora_ ou _Ubuntu_ proposent également des
  noyaux alternatifs avec cette option activée, rendant l'installation de
  _PREEMPT_RT_ plus simple.

  Une fois installée, le noyau offre une nouvelle politique d'ordonnancement
  baptisée _PREEMPT_FULL_, qui comme son nom l'indique, maximise l'ensemble
  du code préemptible dans le noyau.
]

Les modifications apportées au noyau par le projet _PREEMPT_RT_ sont trop
complexes et techniques pour en faire ici une révue détaillée. Toutefois, il
est intéressant de comprendre certains de leurs aspects afin de cerner les
forces et les limites du temps réel dans ce noyau. Plus d'informations sont
disponibles dans la documentation officielle @preempt_rt_doc.

=== Mutex temps réels

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
par un mutex temps réel et que le processus A essaie d'acquérir ce _mutex_, alors
la priorité du processus B est augmenté afin qu'il libère cette ressource le plus
vite possible.

Plus de détails sur ces _mutex_ temps réel sont fournis dans la documentation
officielle @linux_rt_mutex_design @linux_rt_mutex_subsystem.

=== Gestionnaires d'interruption

Lors de l'exécution d'un @isr, il est pratique de désactiver les interruptions
car ce dernier exécute généralement du code critique et que rien n'empêche
d'autres interruptions de subvenir durant son exécution. Les @isr constituaient
donc une partie importante du code non-préemptible du noyau. Afin de réduire
la portion de code non-préemptible, l'idée est de diviser en deux étapes le
gestionnaire @linux_threaded_interrupt_handler. La première étape est exécutée
avec les interruptions désactivées
et ne fait que le stricte nécessaire pour que l'interruption puisse être prise
en compte plus tard. La seconde étape est exécutée dans un _thread_ noyau
préemptible.

=== Remplacement de @spinlock:pl

En l'absence de _PREEMPT_RT_, une tâche qui attend la libération d'un @spinlock
effectue une attente active. Durant cette attente, la tâche n'est pas
préemptible. En présence de _PREEMPT_RT_, ces @spinlock:pl sont donc remplacés
par des _rt-mutex_.

=== RCU

== Partitionnement

== Draft

== KVM <linux_kvm>

Depuis la version `2.6.20` publiée 2007, _Linux_ intègre un hyperviseur
baptisé _KVM_ (_Kernel-based Virtual Machine_)  @linux_kvm_website. Il s'agit
d'un hyperviseur de type 1 assisté par le matériel. Il offre également un support
pour la paravirtualisation.

== Partitionnement <linux_partitioning>

Dans cette section, nous décrivons les principaux mécanismes d'isolation de
partitionnement des ressources disponibles sous _Linux_. Ces mécanismes sont
aujourd'hui utilisés aussi bien pour la virtualisation via _KVM_ que pour les
conteneurs des logiciels tels que _systemd_, _Docker_ ou _Kubernetes_.

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
de leur parent. Par la suite, ils peuvent migrer vers un autre _cgroup_, s'ils ont les
privilèges adéquates. Cette migration n'affecte pas leurs enfants déjà existants,
mais seulement ceux créés par la suite. Quant aux _threads systèmes_,
ils appartiennent généralement au _cgroup_ du processus mais il est possible de
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

== Corruption de la mémoire <linux_memory_corruption>

Le noyau _Linux_ intègre un sous-système nommé _EDAC_ (_Error Detection and Correction_)
@linux_edac qui permet la journalisation des erreurs mémoires. La journalisation s'effectue
grâce au démon _rasdaemon_.

Certains processeurs AMD nécessitent l'utilisation d'un pilote pour que _EDAC_
fonctionne.

Le noyau fournit également une interface logicielle commune @linux_scrub via
_sysfs_#footnote[Le système de fichiers _sysfs_ est un pseudo système de
fichiers disponible sous Linux. Il permet aux logiciels tournant dans le
_user space_ de lire et de modifier des paramètres des pilotes et
des périphériques via des fichiers. Il est généralement monté dans le dossier _/sys_.]
pour les interfaces de pilotage du scrubbing décrites dans le @scrubbing_interfaces,
à l'exception de l'interface _ARS_ qui utilise son propre pilote.

== Perte du flux d'exécution

La perte du flux d'exécution (_control flow hijacking_) est une vulnérabilité
majeure dans les systèmes d'exploitation, où un attaquant modifie le flux
d'exécution normal d'un programme pour exécuter du code malveillant. Cette attaque
exploite généralement des dépassements de tampon ou d'autres corruptions mémoire
pour modifier les adresses de retour ou les pointeurs de fonction.

Les mécanismes de _Control-Flow Integrity_ (CFI) constituent une famille de
défenses contre ces attaques @cfi_survey_embedded. Le CFI vise à garantir que le
flux d'exécution d'un programme suit uniquement les chemins d'exécution légitimes
définis par le graphe de flot de contrôle du programme.

Dans les systèmes embarqués et temps-réel, l'application du CFI présente des défis
particuliers liés aux contraintes de ressources (taille, poids, puissance, coût)
et aux exigences temporelles strictes. Les mécanismes de CFI doivent minimiser
leur surcoût en temps d'exécution tout en offrant des garanties de sécurité robustes.

_Linux_ peut bénéficier de plusieurs mécanismes de protection du flux d'exécution,
notamment via les extensions matérielles modernes comme _Intel CET_ (_Control-flow
Enforcement Technology_) sur _x86_ ou _ARM BTI_ (_Branch Target Identification_)
sur _ARM_. Ces mécanismes matériels offrent une protection efficace avec un surcoût
minimal.

== Monitoring <linux_monitoring>

_Linux_ dispose d'un écosystème riche et mature d'outils de monitoring et
d'observabilité @linux_perf_brendan @linux_monitoring_tools_2024. Ces outils
permettent de surveiller les performances, l'état du système et d'identifier les
problèmes en temps-réel.

Parmi les outils de monitoring les plus utilisés:

- *top/htop*: Moniteurs système interactifs affichant l'utilisation du CPU, de
  la mémoire et des processus en temps réel.

- *netdata*: Solution de monitoring temps-réel légère et performante, collectant
  automatiquement plus de 5000 métriques sans configuration. Particulièrement
  adaptée aux environnements embarqués grâce à sa faible empreinte.

- *eBPF* (_Extended Berkeley Packet Filter_): Technologie moderne permettant
  l'exécution de code personnalisé dans le noyau sans modification ni ajout de
  modules. _eBPF_ offre une observabilité en temps réel avec un impact minimal
  sur les performances, devenant l'outil de référence pour le monitoring avancé
  en 2024.

- *perf*: Outil d'analyse de performance basé sur les compteurs de performance
  matériels (_PMU_), permettant un profilage détaillé avec un faible surcoût.

- *SystemTap*: Permet l'instrumentation dynamique du noyau pour l'analyse
  approfondie du comportement système.

- *Prometheus/Grafana*: Solutions d'observabilité distribuée largement adoptées
  pour le monitoring de systèmes critiques.

Pour les systèmes embarqués, la simplicité et la légèreté des outils sont
prioritaires. _Monitorix_ est particulièrement adapté à ces contraintes, ayant
été conçu pour les serveurs mais utilisable sur dispositifs embarqués grâce à
sa taille réduite.

== Profilage <linux_profiling>

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

=== Profileur _perf_ <linux_perf>
Depuis sa version 2.6.31, _Linux_ intègre un outil puissant de profilage
dénommé _perf_ @perf_wiki. À l'origine _perf_ permettait de tracer l'activité
du _CPU_ via des compteurs @pmu Depuis, ses fonctionnalités ont été considérablement
étendues et il permet maintenant d'instrumenter aussi bien le noyau que
les programmes exécutés dans l'espace utilisateur. Dans cette section, nous
allons voir trois méthodes d'instrumentation: les _tracepoints_,
les _kprobes_ et les _uprobes_.

==== PMU <linux_perf_pmu>

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

==== _Tracepoints_ <linux_perf_tracepoints>
Les _tracepoints_ sont des points d'intérêts du noyau qui ont manuellement été
instrumentés par ses développeurs. On peut ainsi récupérer des traces
d'exécution de ces routines.

==== _Kprobes_ <linux_perf_kprobes>
Les _kprobes_ sont un mécanisme permettant d'injecter du code
à une position arbitraire du noyau.

==== _Uprobes_ <linux_perf_uprobes>
Les _uprobes_ permettent d'instrumenter du code utilisateur.

=== Profileur _oprofile_ <linux_oprofile>

Le logiciel _oprofile_ est un profileur de performance à l'échelle du système
_Linux_ entier. Il utilise les compteurs _PMU_ du processeur pour collecter
les événements.

```console
sudo opcontrol --start --event=CPU_CYCLES
```

```console
sudo opcontrol --reset
```

== Profilage de `systemd` <linux_systemd_analyze>

Le programme `systemd` fournit un outil intéressant de profilage baptisé
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
- #box[_Firmware_: Temps de chargement des firmwares via le BIOS.]
- #box[_Load_: Temps écoulé dans le @bootloader.]
- #box[_Kernel_: Temps de chargement et d'initialisation du noyau.]
- #box[_Initrd_: Temps d'initialisation de la _RAM disk_.]
- #box[_Userspace_: Temps écoulé pour lancer tous les services de l'@userspace.]

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

== Masquage des interruptions <linux_masking>

== Licences <linux_licenses>

Le noyau `Linux` est un logiciel libre distribué sous licence `GPL-2.0` avec
l'exception _syscall_ qui stipule qu'un logiciel utilisant le noyau `Linux` au
travers des appels systèmes n'est pas considéré comme une œuvre dérivée et
peut être distribué sous une licence qui n'est pas compatible avec la GPL,
y compris une licence propriétaire. Plus d'informations sont disponibles dans
le dossier `LICENSES` des sources du noyau `Linux`.

== Temps de démarrage <linux_booting>

Il existe de nombreuses techniques pour réduire le temps de démarrage d'un système
_Linux_. Ces techniques concernent aussi bien le @bootloader, l'initialisation
du noyau ou l'initialisation de l'@userspace.
- #box[Pour le @bootloader, on peut n'initialiser que les périphériques
indispensables et optimiser le code assembleur.]
- #box[Pour l'initialisation du noyau, on peut utiliser une image non compressée, désactiver
les fonctionnalités inutiles pour notre usage et en particulier les outils de profilages.]
- #box[Pour l'initialisation de l'@userspace]

L'initialisation de l'@userspace
est généralement l'étape la plus longue et donc la phase à optimiser en priorité.

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

(MOVE)
Le project Yocto @yocto_project est un projet libre offrant la possibilité de
créer sa distribution _Linux_ dédiée à l'embarqué.

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
  - *Architectures* : x86-64, ARM v8, PowerPC#footnote[Support limité à l.]
  - *Usage principal* : Cloud computing, applications réseau, systèmes embarqués, spatial
  - *Points forts* : Sécurité renforcée (surface d'attaque réduite, langage sûr), taille minimale, temps de démarrage rapide, modularité
  - *Limitations* : Portabilité limitée sans hyperviseur, débogage complexe, pas d'interface POSIX
  - *Licences* : ISC (majoritaire) + LGPLv2 (certaines parties)
  - *Projet notable* : SpaceOS (déployé dans l'espace en 2025)
]


Au tournant des années 2010, l'usage de la virtualisation révolutionne le
déploiement des services, permettant de réduire les coûts et d'externaliser une
partie de la maintenance via le concept de _cloud computing_. À cette époque,
la majorité des @vm:pl exécutent un service dans un _GPOS_ complet. Cette
approche présente l'avantage de circonscrire au système d'exploitation les
modifications requises pour la virtualisation, tout en bénéficiant de
l'isolation offerte par l'hyperviseur. En contre partie, la pile
logicielle est grandement complexifiée comme l'illustre la
@comparison_unikernel_gpos.

En particulier, certains mécanismes
d'isolation comme l'ordonnanceur de tâches sont dupliqués entre l'hyperviseur et
le noyau exécuté dans la @vm. De plus, l'introduction d'un _GPOS_ augmente
considérablement la surface d'attaque (@tcb volumineuse) et les sources de bugs
potentiels. Cela est d'autant plus vrai que ces @gpos sont souvent écrits dans
un langage de programmation#footnote[La vaste majorité est écrit en langage C,
un langage n'offrant pratiquement aucune garantie mémoire et à la sémantique
complexe sur les architectures @smp.]
n'offrant que peu de garantie du point de vue des types
et de la mémoire. C'est de ces deux constats que naît le projet _MirageOS_.

Le projet est initié en 2009 au sein du laboratoire
_Computer Laboratory_ de l'université de Cambridge sous la houlette de
Anil Madhavapeddy @mirageos_unikernels. Il est de nos jours maintenu par la
_MirageOS Core Team_ composée d'universitaires et d'ingénieurs du secteur privé
(_Tarides_, _IBM Research_, ...).
_MirageOS_ fait parti des projets soutenus par le _Xen Project_
@mirageos_xen_project et bon nombre de ces contributeurs ont également contribué
au projet _Xen_.

_MirageOS_ adopte une approche de type _LibOS_. Au lieu de fournir un environnement
d'exécution pour les services, _MirageOS_ se présentent sous la forme d'une
collection de bibliothèques modulaires. Ces dernières sont écrites
majoritairement en _OCaml_, un langage de programmation de haut niveau offrant
la sûreté des types et équipé d'un ramasse-miette. La configuration et
l'ensemble des bibliothèques
nécessaires au service sont liés durant la compilation pour produire une image
appelée _unikernel_. Cet _unikernel_ peut alors être exécuté dans divers
environnements, voir la sous-section @mirageos_environments. Cela conduit à une
simplification de la pile logicielle comme illustré dans @comparison_unikernel_gpos.
L'approche _unikernel_ présente de nombreux avantages:
- #box[Une plus petite surface d'attaque à la fois par la réduction de le taille du
code source et l'utilisation d'un langage de programmation sûr.]
- #box[Une amélioration des performances et notamment du temps de démarrage.]
- #box[Une réduction de la taille des exécutables produits.]
- #box[Un profilage simplifié par la suppression d'une couche logicielle.]

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
          #text(font: "Fira Sans", size: 11pt)[GPOS]]]]],
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
          #text(font: "Fira Sans", size: 11pt)[Unikernel]]]]],
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

Pour qu'une architecture soit supportée par _MirageOS_, il est nécessaire que
celle-ci soit une cible de compilation du compilateur OCaml. Le compilateur pour
OCaml 4 supporte les architectures suivantes: _x86-32_, _x86-64_, _ARM v7_,
_ARM v8_, _PowerPC_, _SPARC_ et _MIPS_. Toutefois le support#footnote[Il subsiste
pour la compilation en _bytecode_, ce qui n'est pas pertinent ici puisqu'il
faudrait porter la machine virtuelle d'OCaml pour en définitif obtenir
des performances médiocres.] des architectures 32-bits a été supprimé à partir d'OCaml 5.

En pratique, les _unikernels_ produits par _MirageOS_ sont rarement exécutés
en @baremetal mais plutôt dans une partition d'un hyperviseur. Il est donc nécessaire
que l'hyperviseur supporte les architectures citées ci-dessus et que l'environnement
d'exécution de _MirageOS_ ait été porté dessus. Le projet _solo5_
vise à fournir une couche d'abstraction logicielle entre l'environnement
d'exécution de _MirageOS_ et les différentes @api d'hyperviseurs et de @gpos.
Il semble qu'à l'heure actuelle le projet _solo5_ n'offre qu'un support pour
des systèmes sur _x86-64_, _ARM v8_ et _PowerPC_.

Nous considérons donc ces architectures comme étant les seules bénéficiant d'un
support officiel par le projet _MirageOS_.

== Support multi-processeur <mirageos_multiprocessors>

Les _unikernels_ générés avec _MirageOS_ étant le plus souvent exécutés au-dessus
d'un hyperviseur, la question du support d'architectures multi-processeur revient
à déterminer si ces images peuvent tirer parti du parallélisme qu'offre ces
processeurs. À ce titre, l'environnement d'exécution d'_OCaml_ doit supporter
le parallélisme.

Jusqu'à _OCaml 4_, le @runtime _OCaml_ utilisait un verrou global assurant
que le code _OCaml_ ne puisse jamais être exécuté en parallèle. Ce verrou permettait
de garantir que certain invariants internes étaient préservés, notamment
au niveau du ramasse-miette. Un moyen de bénéficier malgré tout du parallélisme
était d'écrire le code à paralléliser en C puis de l'interfacer avec le code _OCaml_.
Cette solution n'a pas été retenue par les développeurs de _MirageOS_ qui souhaitaient
bénéficier de la sûreté des types offerte par le langage _OCaml_. Toutefois
un service Web implémenté en _MirageOS_ doit pouvoir servir plusieurs
utilisateurs simultanément. Lorsque cette application passe la majorité du
temps à attendre des entrées/sorties, la programmation
asynchrone s'avère un choix judicieux. À cette fin, le projet _MirageOS_ utilise
une bibliothèque de _threads_ coopératifs baptisé _Lwt_ @vouillon2008lwt
@lwt_manual. Lorsque le parallélisme est vraiment nécessaire, par exemple si
les services doivent effectuer des tâches lourdes en calcul, une solution est
d'exécuter plusieurs instances du même _unikernel_ et de les synchroniser via
les @ipc de l'hyperviseur. Cette solution a été mise en pratique sur
l'hyperviseur _Xen_.

#aside[Bibliothèque _Lwt_][
  La bibliothèque _Lwt_ est une bibiothèque _OCaml_ de _threads_ coopératifs.
  Elle simplifie la programmation aynchrone en proposant un style de programmation
  monadique via des promesses. Par exemple, dans le code suivant deux _threads_
  légers sont lancés pour afficher un message après un décompte grâce à la
  fonction `Mirage_sleep.ns`:
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
  les deux _threads_ auront terminé leur travail.
]

À partir de la version 5, le @runtime _OCaml_ permet l'exécution en parallèle
de code écrit en _OCaml_ via le concept de _domaine_ @retrofitting_parallelism.
Un effort est en cours pour porter _MirageOS_ sur _OCaml 5_ @mirageos_on_ocaml5,
ce qui devrait conduire à une amélioration des performances des _unikernels_
sur les architectures @smp et à une simplification de leur architecture lorsque
le parallélisme est nécessaire pour des raisons de performance.

#aside[Domaine][
  Les domaines sont un concept introduit en _OCaml 5_ pour permettre
  l'exécution parallèle de code _OCaml_. Elle permet également l'écriture de
  programme asynchrone mais sans avoir recours au style monadique comme _Lwt_.
]

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
- #box[L'option `unix` permet d'exécuter l'_unikernel_ dans _KVM_. L'environnement
requière]
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
le plus fréquent.

== Temps réel <mirageos_real_time>

À notre connaissance, _MirageOS_ n'a jamais été utilisé dans un contexte temps
réel. Le principal obstacle vient du ramasse-miette d'OCaml qui n'offre pas de
garanties déterministes. Quant à la bibliothèque _Lwt_, elle n'a pas du tout été
conçue pour cet usage puisque les tâches doivent rendre la main volontairement
à l'ordonnanceur _Lwt_. Si vous souhaitez exécuter une tâche temps réel, il faudra
avoir recours à un hyperviseur temps réel et exécuter cette tâche dans une
partition distincte.

== Partitionnement <mirageos_partioning>

_MirageOS_ n'offre pas de partitionnement temporel ou spatial. Cette tâche
incombe à un noyau de séparation dans lequel l'_unikernel_ est exécuté, typiquement
un hyperviseur comme _Xen_. En particulier, lorsque l'on souhaite isoler plusieurs
services _MirageOS_, l'usage est d'exécuter ces services dans des _unikernels_
distincts et de les faire communiquer via les @ipc de l'hyperviseur.

En particulier, si vous utiliser _Xen_ comme noyau de séparation, vous pouvez
utiliser la bibliothèque _vchan_ de _MirageOS_ pour communiquer entre deux
_unikernels_.

== Corruption de la mémoire <mirageos_memory_corruption>

La gestion de la corruption de la mémoire est généralement déléguée à
l'environnement d'exécution de l'_unikernel_.

Dans le cas de _Xen_ avec un noyau _Linux_ dans le domaine _dom0_, il suffira
d'utiliser les sous-systèmes décrits dans @linux_memory_corruption et
les @ipc de _Xen_ pour récupérer ces informations dans l'_unikernel_.

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
était possible en optimisant la _toolstack_ de _Xen_, permettant aux _unikernels_
de démarrer en seulement 50ms.

Dans @madhavapeddy2015jitsu, les auteurs ont étudié le temps de démarrage
d'_unikernels_ _MirageOS_ sur un hyperviseur _Xen_ avec une pile logicielle
optimisée. Ils sont parvenus sur des temps de démarrage à froid inférieurs à
350 ms sur _ARM_ et 30ms sur _x86_.

Dans l'étude récente @kuenzer2021unikraft, les auteurs affirment qu'un
_unikernel_ de _MirageOS_ peut démarrer en moins de 3ms en utilisant
l'environnement d'exécution _solo5_.

En conclusion, le temps de démarrage de _MirageOS_ peut être rendu très faible
et négligeable face à celui de la mise en place de la partition elle-même.

== Maintenabilité <mirageos_maintenability>

_MirageOS_ est en majorité écrit en OCaml, un langage de haut niveau qui offre
de bonne garantie du point de vue de la sûreté des types et de la mémoire.
À ce jour le dépôt https://github.com/mirage/mirage est constitué à 99% de code
OCaml pour un total de 9075 _SLOC_.

Toutefois la totalité de l'unikernel ne provient pas de la compilation de
codes _OCaml_. Il subsiste plusieurs parties en langage C et notamment:
- #box[L'environnement d'exécution du langage OCaml est écrit en C. Cela inclut en
particulier son ramasse-miette,]
- #box[Quelques bibliothèques en C comme _GMP_ au travers de _Zarith_. Leur réécriture
en OCaml est théorique possible mais nécessiterait un effort considérable en pratique,]
- #box[Les pilotes sont et doivent être écrit dans un langage bas niveau.]

== Qualifications et certifications <mirageos_certifications>

À notre connaissance, _MirageOS_ n'a pas fait l'objet de certifications. L'objectif
premier de _MirageOS_ est davantage la sécurité que la sûreté de fonctionnement.
Cet objectif est atteint en minimisant la surface d'attaque et en utilisant un
langage de programmation sûr.

== Licences

Le code de _MirageOS_ est publié sous la licence _ISC_ avec certaines parties
sous licence _LGPLv2_. L'utilisation d'une licence open-source permissive comme
_ISC_ est nécessaire car l'_unikernel_ produit par _MirageOS_ est lié statiquement
avec les bibliothèques. Grâce à cette licence, vous n'avez pas les contraintes
des licences _GPL_ lorsque vous distribuez le binaire de votre _unikernel_.

== Draft

== Profilage & traçage <mirageos_profiling>

Le profilage d'un unikernel dépend fortement de l'environnement dans lequel
il est exécuté. Le cas le plus favorable est celui de l'environnement _UNIX_ et
en particulier d'une distribution _GNU/LINUX_, puisque il existe pléthore
d'outils de profilage dans cette situation, voir la sous-section @linux_profiling
pour des exemples sous _Linux_. Toutefois il est également souhaitable de
profiler l'_unikernel_ en conditions réelles, ce qui ne correspond presque jamais
à l'environnement _UNIX_. Nous nous bordons à l'environnement _Xen_ dans ce qui
suit.

=== Flame graphs

=== Profilage mémoire avec `memtrace-mirage`

Le programme `memtrace` @memtrace_github développé par Janestreet est un
profiler mémoire pour le langage OCaml. Il permet de générer une trace
compacte de l'utilisation de la mémoire d'un programme écrit OCaml. La trace
produite peut-être explorée avec `memtrace-viewer` @memtrace_viewer_github.
Il existe une bibliothèque _MirageOS_ permettant d'utiliser `memtrace` dans un
_unikernel_.

#figure(
  snippet("./mirageos/examples/memtrace/config.ml", lang: "ocaml"),
  caption: [Configuration de l'_unikernel_]
)

#figure(
  snippet("./mirageos/examples/memtrace/unikernel.ml", lang: "ocaml"),
  caption: [Exemple d'utilisation de `memtrace-mirage`]
) <example_memtrace_mirage>

L'exemple @example_memtrace_mirage illustre l'utilisation de `memtrace-mirage`
dans un _unikernel_. La fonction `start` est le point d'entrée de l'_unikernel_.
Cette fonction commence par établir un socket `TCP` à l'adresse `10.0.0.1:24`
#footnote[L'adresse `10.0.0.1` est l'adresse _IP_ par défaut utilisée par la
bibliothèque `mirage-tcp-ip`.]. Lorsqu'un client établit une connexion,
`memtrace` est lancé jusqu'à ce que la connexion soit interrompue. La fonction
`alloc` est exécutée de façon concurrentielle afin de produire un grand
nombre d'allocations. L'exécution de l'_unikernel_ se termine après 100 secondes.

#howto[exécution de l'exemple @example_memtrace_mirage dans _Xen_][
  On commence par créer l'unikernel à l'aide de l'image docker, puis on lance
  cet unikernel dans un domaine de _Xen_:
  ```console
  make build-memtrace
  cd unikernels/memtrace
  sudo xl create memtrace.xl -c
  ```
  On peut alors récupérer la trace produite par `memtrace` en établissant dans
  autre terminal une connexion sur `10.0.0.2:1234`:
  ```console
  nc 10.0.0.2 1234 > trace
  ```
  Finalement, on peut lancer une instance de `memtrace-view`:
  ```console
  make mentrace-view
  ```
  Cette commande lance un serveur web écoutant sur l'adresse `localhost:8080`.
]


#warning[incompatibilité avec OCaml 5][
  Le module `Gc.Memprof` nécessaire à `memtrace` ne fonctionne plus en OCaml 5
  car le fonctionnement du ramasse-miette a été changé en profondeur. Des efforts
  sont en cours pour restaurer cette fonctionnalité dans une version ultérieure
  du compilateur OCaml.
]

=== Traçage

Il existe des `hooks` dans le code de _MirageOS_ qui permet un traçage de bout
en bout. On peut utiliser un backend spécifique comme `mirageos-trace-viewer`.
C'est un atout majeur en comparaison de _strace_ qui ne permet que de tracer
les appels systèmes.

== Draft

Les bibliothèques d'OS souffrent d'un problème de portabilité. Cette situation
est amendée par l'usage d'un hyperviseur plutôt qu'un exécution bare-metal.

Il est utilisé aussi bien sur des machines embarquées que dans le _cloud computing_.
Une particularité importante de _MirageOS_ est d'être écrit dans le langage
_OCaml_. Ce langage est de haut niveau et sûr. La majorité des systèmes
d'exploitations sont écrit en langage C. C'est un langage de programmation bas
niveau offrant peu de garantie de sûreté, notamment vis-à-vis de la mémoire.

En tant qu'_unikernel_, _MirageOS_ cherche à produire des exécutables de petite
taille et avec une empreinte mémoire minimale. Il offre également des temps de
démarrage réduit.

Une des motivations d'exécuter un unikernel dans un hyperviseur plutôt qu'un
système d'exploitation classique est de supprimer une couche logicielle volumineuse
qui contient beaucoup de fonctionnalité inutile comme le support pour du matériel
ancien, le support d'anciennes API, l'ordonnanceur pour les processus/threads en
plus de celui de l'hyperviseur.

_MirageOS_ ne cherche pas à proposer une interface _POSIX_ dans un souci
de minimalité et de clarté des _API_.

La majorité du code est écrit en OCaml. Toutefois il subsiste plusieurs parties
qui sont toujours en langage C. Il y a le runtime OCaml lui-même (ce qui inclut
le ramasse miette d'OCaml), un certain nombres de pilotes et quelques bibliothèques
(notamment GMP) dont la réécriture en OCaml est possible mais très laborieuse.

_MirageOS_ utilise un freestanding runtime pour OCaml @ocamlsolo5github.

Objectif réduire la complexité des systèmes actuels.

Quelques avantages:
- surface d'attaque réduite
- vérification et certification modulaire

== SpaceOS <mirageos_spaceos>

_SpaceOS_ est un système d'exploitation basé sur _MirageOS_ développé par _Tarides_
pour les applications spatiales et satellitaires @spaceos_tarides @spaceos_satellite.
Il s'agit d'une solution sécurisée et efficace pour les satellites multi-utilisateurs
et multi-missions, construite sur la technologie des _unikernels_.

_SpaceOS_ a été conçu en partenariat avec plusieurs organisations du secteur spatial :
- L'_ESA_ (_European Space Agency_)
- Le _CNES_
- _Thales Alenia Space_
- _OHB_
- _Eutelsat_
- Le _Singapore Space Agency_

Le 15 mars 2025, _OCaml_ a été lancé dans l'espace à bord de la mission _Transporter-13_.
_DPhi Space_ a embarqué son ordinateur _Clustergate_ sur ce vol, et l'équipe _SpaceOS_
a déployé un logiciel basé sur _OCaml 5_ sur le satellite. Cette mission a démontré
la viabilité des _unikernels_ _MirageOS_ pour les applications spatiales en conditions
réelles.

Les principaux avantages de _SpaceOS_ incluent:
- Une réduction de taille d'un facteur 20 par rapport à un déploiement basé sur
  des conteneurs _Linux_
- Une sécurité accrue grâce à l'utilisation d'un langage à gestion mémoire sûre (_OCaml_)
- Une architecture modulaire permettant de compiler uniquement les fonctionnalités
  nécessaires du système d'exploitation

Ces résultats ont valu à _SpaceOS_ une reconnaissance industrielle significative,
notamment le prestigieux _Airbus Innovation Award_ lors de la _Paris Space Week_ 2024.

= PikeOS <pikeos>
_PikeOS_ est un micronoyau temps réel dédié à l'embarqué critique. Ces
principales fonctionnalités sont:

== Draft

- Un noyau de séparation permettant la criticité mixte
- Déterminisme

_PikeOS_ est un @rtos et un hyperviseur de type 1 développé par l'entreprise
_SYSGO_ depuis 2005. En 2012, l'entreprise _SYSGO_ est rachetée par _Thalès_.
À l'origine _PikeOS_ était basé sur le micronoyau _L4_#footnote[Voir la section
@monolithic_vs_microkernel pour plus d'informations sur le micronoyau _L4_.].

Dès sa conception, _PikeOS_ a été pensé pour faciliter la certification de
logiciels. Les différents kit de certifications disponibles sont exposés dans la
section @pikeos_licenses.

== Architectures supportées <pikeos_architectures>

_PikeOS_ supporte les architectures suivantes: _x86-64_, _ARM v7_, _ARM v8_,
_PowerPC_, _RISC-V_ et _SPARC_.

Le support pour l'architecture _ARM_ existe depuis 2006.
Quant à son hyperviseur, il propose un support pour la virtualisation matérielle
sur les architectures _ARM v7_ @pikeos_hwvirt_armv7, _x86-64_ @pikeos_hwvirt_x86.

Le support matériel se fait via des @bsp. Il est
également possible de financer le développement de nouveaux _BSP_.

== Support multi-processeur

=== Architectures @smp <pikeos_smp>

Le support @smp a été amélioré dans _PikeOS 5.0_. Afin de garantir un
déterminisme suffisant et des estimations @wcet suffisamment fines, _PikeOS_
avait recours à un verrou global similaire au @bkl de _Linux_
(voir la sous-section @linux_smp). Ce verrou assurait que
les sections critiques du micronoyau ne pouvaient pas s'exécuter en parallèle.
Depuis la version _5.0_, _PikeOS_ utilise un système de verrouillage plus fin
qui permet aux appels systèmes de s'exécuter en parallèle s'ils n'utilisent pas
des ressources en commun.

=== Architectures @amp <pikeos_amp>

L'entreprise _SYSGO_ propose une version spéciale de _PikeOS_ baptisée _PikeOS
for MPU_. Cette édition de l'hyperviseur est dédiée aux plateformes @mpsoc équipées
de _MPU_ et offre en particulier un support pour des architecture @amp. Il supporte les
architectures _ARMv7-R_, _ARMv8-R_ et dispose de @bsp les @mpsoc _NG-Ultra_ et
_AMD Zynq Ultrascale+_.

== OS invités supportés

Les systèmes invités sont appelés _GuestOS_.

=== _ELinOS_

_ELinOS_ est une distribution _Linux_ pour l'embarqué temps réel maintenu par
la société _SYSGO_ @pikeos_elinos. Il pour être utilisé dans une partition de
_PikeOS_ aussi bien en paravirtualisation qu'avec la virtualisation assitée
par le matériel. _SYSGO_ offre un support pour chaque version d'une durée de
5 ans qui peut être étendu.

== Partitionnement

Son hyperviseur permet à la fois la paravirtualisation et la virtualisation
de assistée par le matériel.

- _HwVirt_ désigne la virtualisation assistée par le matériel.
- _Pv-virt_ désigne la paravirtualisation.

Il est possible d'avoir une certification pour une partition spécifique.

== Corruption de la mémoire

== Support de _watchdog_ <pikeos_watchdog>

== Temps de démarrage <pikeos_booting_time>

== Certifications <pikeos_certifications>

Certifications:
- RTCA DO-178B/C
- EN 50218
- EN 50657
- CEI 61508
- ISO 26262
- CEI 62304

Normes:
- Critères communs (quel niveau?)
- SAR

== Licences <pikeos_licenses>

La société SYSGO propose deux types de licences propriétaires:
- #box[Une licence de développement permettant de concevoir des systèmes basés
sur _PikeOS_.]
- Une licence de déploiement.

= ProvenVisor <provenvisor>

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

#figure(
  diagram(
    spacing: 10pt,
    cell-size: (8mm, 10mm),
    edge-stroke: 1pt,
    edge-corner-radius: 5pt,
    mark-scale: 70%,

    blob((2.25, 3.5), [Proc 1], tint: green, width:20mm, name: <proc1>),
    blob((2.52, 3.5), [Proc 2], tint: green, width:20mm, name: <proc2>),
    blob((2.79, 3.5), [Proc ...], tint: green, width:20mm, name: <proc3>),
    edge(<proc1>, "d", "-|>"),
    edge(<proc2>, "d", "-|>"),
    edge(<proc3>, "d", "-|>"),

    blob((2.53, 4.5), [ProvenCore], tint: blue, width:73mm, name: <provencore>),

    node(
      [#align(center)[#pad(-5.8em)[
        #text(font: "Fira Sans", size: 11pt)[Secure world]]]],
      inset:12pt,
      corner-radius: 3pt,
      enclose: (<proc1>, <proc2>, <proc3>, <provencore>),
      stroke: blue, fill: blue.lighten(90%),
      name: <secure>),
    edge(<secure>, "d", "-|>"),

    blob((1.38, 3.5), [VM 1], tint: yellow, width:20mm, name: <vm1>),
    blob((1.62, 3.5), [VM 2], tint: yellow, width:20mm, name: <vm2>),
    blob((1.86, 3.5), [VM ...], tint: yellow, width:20mm, name: <vm3>),
    edge(<vm1>, "d", "-|>"),
    edge(<vm2>, "d", "-|>"),
    edge(<vm3>, "d", "-|>"),

    blob((1.62, 4.5), [ProvenVisor], tint: blue, width:63mm, name: <provenvisor>),

    node(
      [#align(left)[#pad(-1.8em)[#rotate(-90deg)[
        #text(font: "Fira Sans", size: 11pt)[Normal world]]]]],
      inset:12pt,
      corner-radius: 3pt,
      enclose: (<vm1>, <vm2>, <vm3>, <provenvisor>),
      stroke: blue, fill: blue.lighten(90%),
      name: <normal>),
    edge(<normal>, "d", "-|>"),

    blob((2,5.8), [Moniteur], tint: green, width:140mm, name: <monitor>),
    edge("-|>"),
    blob((2,6.8), [Couche matérielle], tint: gray, width:140mm),
  ),
  caption: [Architecture de _ProvenVisor_.]
) <architecture_provenvisor>

== Architectures supportées <provenvisor_architectures>

L'hyperviseur est disponible sur l'architecture _ARM v8-A_. Il offre un support
pour le _MMU_ sur cette architecture.

_ProvenCore_ est conçu pour fonctionner avec le @tee _TrustZone_ de l'architecture _ARM_.

== Certifications <provenvisor_foo>

- Permet la certification critères communs EAL5

== Licences <provenvisor_leicuenses>

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
  - *Architectures* : 20+ architectures (ARM, PowerPC, RISC-V, SPARC, x86, MIPS, ...)
  - *Usage principal* : Systèmes embarqués temps-réel (spatial, militaire, médical, industriel)
  - *Points forts* : Libre (GPL/BSD), API POSIX, support SMP, modulaire, mature, utilisé par NASA/ESA
  - *Limitations* : Documentation parfois limitée, configuration complexe
  - *Licences* : BSD 2-clause + exceptions (permettant code propriétaire)
  - *Missions notables* : Galileo, James Webb Space Telescope, Mars rovers
]

_RTEMS_ (_Real-Time Executive for Multiprocessor Systems_) est un _RTOS_ libre conçu
pour les systèmes embarqués. L'ensemble des fonctionnalités
offertes par _RTEMS_ inclut:
- #box[Un ordonnanceur préemptif basé sur les priorités et les pilotés par les événements,]
- #box[Un support pour le multitâche avec des mécanismes de communications et de
synchronisation entre les tâches,]
- #box[Le support pour des architectures @smp et @amp (voir la sous-section @rtems_multiprocessors),]
- #box[Une modularité importante permettant de configurer statiquement l'image.]
- #box[Une @api _POSIX_ et une pile réseau _TCP/IP_ basée sur celle du projet _FreeBSD_.]

Le projet est initié en 1988 par l'entreprise _OAR_ (_On-Line Appications
Research Corporaton_) sous contrat de l'_U.S. Army Missile Command_. Cette
dernière voulait un système d'exploitation
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
  Prenez garde à ce que l'adapteur fonctionne en 3,3V, sans quoi vous détruirez
  votre _Raspberry_.
]

Un fichier _Docker_ pour générer la chaîne de compilation _RTEMS_ pour
_Raspberry_ est disponible dans le dossier `./rtems/dockers/`.
Vous pouvez lancer sa génération avec la commande suivante:
```console
make setup -C ./rtems
```
ce qui prend environ une demie heure pour terminer. Finalement, notez que
les images produites par cette chaîne de compilation nécessite un @bootloader.
Le plus simple est d'utiliser le @bootloader de _Raspberry OS lite_ et de remplacer
le fichier `/boot/kernel8.img` par l'image produire.

Après avoir branché le _Raspberry_ sur votre ordinateur et avant de le mettre
sous tension, vous pouvez lancez la commande suivante afin d'interagir avec l'interface _UART_:
```
minicom -D /dev/ttyUSB0
```
Le nom de l'interface _TTY_ peut varier suivant l'adaptateur utilisé.


== Architectures supportées <rtems_architectures>

Du fait de sa longue histoire, _RTEMS_ a supporté et supporte encore aujourd'hui
un grand nombre d'architectures. Nous nous concentrons ici sur les architectures
énumérées dans la sous-section @architectures. D'après @rtems_architectures_website,
_RTEMS_ supporte les familles d'architectures suivantes dans leur version 32bits
et 64bits: _x86_, _ARM_, _PowerPC_, _MIPS_, _RISC-V_, _SPARC_.
Le support se fait via des @bsp. En particulier, le projet distribue un @bsp pour
les processeurs _LEON2_ et _LEON3_ ayant pour architectures _SPARC v8_ et
conçus pour des applications dans le spatial.

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
(voir la sous-section @rtems_real_time) et se comporte comme un ordonnanceur à
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

== Temps réel <rtems_real_time>

En tant que _RTOS_, _RTEMS_ a été conçu pour être déterministe. À cette fin,
il dispose de plusieurs ordonnanceurs préemptifs couvrant différents cas d'usage.

Afin d'assurer la synchronisation des sections critiques et de prévenir les
inversions de priorité, _RTEMS_ propose quatre protocols de verrouillage:
- #box[_ICPP_ (_Immediate Ceiling Priority Protocol_) pour les architectures
monoprocesseur]
- #box[_PIP_ (_Priority Inheritance Protocol_) pour les architectures
monoprocesseur. La prorité d'une tâche est élevée au niveau de la plus haute
priorité d'une tâche qui attend un verrou. C'est une approche similaire aux
verrous _rt-mutex_ de _Linux_ vu en sous-section @linux_real_time.]
- #box[_MrsP_ (_Multiprocessor Resource Sharing Protocol_) pour les architectures
@smp. Il généralise les verrous _ICPP_ aux multiprocesseur @smp et utilise de
l'attente active.]
- #box[_OMIP_ (_O(m) Independence Preserving Protocol_) pour les architectures
@smp. Il généralise le protocol _PIP_ aux architectures @smp.]

(TODO: vérifier)

_RTEMS_ est un _RTOS_ ce qui signifie qu'il a été conçu pour avoir un
comportement déterministe. Il dispose d'un ordonnanceur préemptif basé
sur des priorités. Une tâche préempte immédiatement
une éventuelle autre tâche de plus faible priorité. Son ordonnanceur
propose deux modes de fonctionnement. Le mode _RMS_ (_Rate Monotonic Scheduling_)
avec des priorités statiques basée sur des périodes. La tâche avec la période
la plus courte est la plus prioritaire. L'autre mode est _EDF_ (_Earliest Deadline
First_). Cette fois c'est la tâche avec l'échéance la plus proche qui reçoit la plus
haute priorité. Les temps de latence sont courts et connus.

Le premier scheduler est plutôt appelé un _Deterministic Priority Scheduler_. D'après
la documentation il est plutôt approprié pour les architectures monoprocesseur.

_RTEMS_ offrent des ordonnanceurs pour monoprocesseur et pour multiprocesseur
de type @smp. En @smp, tous les ordonnanceurs sont basées sur des priorités.

#table(
  columns: (2fr, 2fr, 2fr),
  stroke: 0.5pt,
  align: center + horizon,

  [Ordonnanceur], [Algorithme / Logique], [Complexité et Impact RAM],

  // Ligne 1 : Déterministe
  [Déterministe Priorité],
  [Basé sur priorité préemptive (utilise un tableau de FIFO par priorité, géré par un *bitmap*).],
  [#box(fill: green.lighten(90%), "Déterministe et fixe en temps d'exécution.") Utilise ~3KB de RAM (pour 256 niveaux de priorité).],

  // Ligne 2 : Simple
  [Simple Priorité],
  [Même comportement que le déterministe, mais utilise une *seule liste chaînée* pour toutes les tâches prêtes.],
  [#box(fill: yellow.lighten(90%), "Complexité O(n) (n = tâches prêtes).") Utilise beaucoup moins de RAM (idéal pour petits systèmes).],

  // Ligne 3 : EDF
  [Earliest Deadline First (EDF)],
  [Basé sur l'échéance : la tâche avec l'échéance la plus proche est prioritaire. Supporte les tâches d'arrière-plan. Nécessite le *Rate Monotonic Manager* pour les échéances.],
  [Haute utilisation du CPU (jusqu'à 100% en théorie). Utilise un arbre *rouge-noir* pour la file d'attente unique.],

  // Ligne 4 : CBS
  [Constant Bandwidth Server (CBS)],
[Extension de l'EDF axée sur l'*isolation temporelle*. Le serveur (par tâche) est caractérisé par un budget/période (bande passante).],
  [Fournit une isolation stricte : une tâche ne peut pas influencer l'exécution des autres. Rétrograde les tâches qui dépassent leur budget.],
)

Il est possible d'implémenter son propre ordonnanceur.

Afin d'assurer la synchronisation et de prévenir les inversions de priorité,
_RTEMS_ propose quatre types de verrous.
- Immediate Ceiling Priority Protocol _ICPP_
- Priority Inheritance Protocol,
- Multiprocessor Resource Sharing Protocol _MrsP_
- O(m) Independence-Preserving Protocol _OMIP_

#figure(
table(
  columns: (1.5fr, 1.5fr, 1.5fr, 1.5fr),
  stroke: 0.5pt,
  align: center + horizon, // Alignement vertical et horizontal au centre

  [Acronyme], [Nom Complet], [Contexte Principal], [Mécanisme Clé Anti-Inversion],

  // Ligne ICPP
  [ICPP], [Immediate Ceiling Priority Protocol], [Uniprocesseur (Monocœur)], [Priorité immédiatement élevée au *Plafond* pré-défini.],

  // Ligne PIP
  [PIP], [Priority Inheritance Protocol], [Uniprocesseur (Monocœur)], [Priorité élevée au niveau de la *plus haute priorité* en attente.],

  // Ligne MrsP
  [MrsP], [Multiprocessor Resource Sharing Protocol], [Multiprocesseur (SMP, Ordonnancement en cluster)], [Généralisation de l'ICPP pour SMP ; utilise la priorité plafond et l'attente active (*busy wait*).],

  // Ligne OMIP
  [OMIP], [O(m) Independence-Preserving Protocol], [Multiprocesseur (SMP, Ordonnancement en cluster)], [Généralisation du PIP pour SMP ; *Ne nécessite aucune configuration* externe (pas de priorité plafond).],
),
caption: [Protocoles de verrouillage]
)

== Partitionnement

_RTEMS_ n'offre pas beaucoup de garantie quant au partionnement spatial.

== Corruption de la mémoire

== Monitoring

== Profilage & traçage

Il a existé également un projet baptisé _RTMA_ (_RTEMS Monitoring Application_)
développé par des chercheurs autour des années 2000.

_RTEMS_ offre un outil de traçage intégré @rtems_introduction_to_tracing.

== Support de _watchdog_

== Temps de démarrage <rtems_booting_time>

== Maintenabilité <rtems_maintening>

 Le projet _RTEMS_ est développé et maintenu depuis plus de 30 ans. Il est
 écrit en langage C à plus de 96% pour 1 990 023 _SLOC_.

== Licences <rtems_licenses>

_RTEMS_ est un logiciel libre distribué sous une multitude de licences libres
et open-sources avec pour licence principale _BSD 2-Clause_. Le point commun de
ces licences est qu'elles autorisent l'utilisateur a lié son programme avec le
code source de _RTEMS_ sans devoir redistribuer son propre code source
@rtems_licenses_website.

== Draft
- Il offre un support pour les architectures @smp et @amp.
- Il permet le cross-développement via d'autres OS: distributions GNU/Linux, Windows, BSD, Solaris, MacOS.
- Il est utilisé dans l'industrie spatiale, notamment chez les acteurs européens.
- ARINC 653 RTEMS
- Il existe un support commercial pour les entreprises européennes ou américaines et la communauté offre bien sûr un support gratuit sans garantie.

== Partionnement <rtems_partioning>

_RTEMS_ est un système à espace d'adressage unique. Le noyau et les tâches partagent
le même espace d'adressage et s'exécute en mode noyau (vérifier). Par conséquent _RTEMS_
n'offre pas les mêmes niveaux de sûreté qu'un noyau de séparation comme un hyperviseur.
C'est la raison pour laquelle il est parfois exécuté au-dessus d'un hyperviseur.

Il y a un support pour les MPU (memory protection unit) qui sont des version simplifiées
des MMU. Vérifier si cette info est valable.

_RTEMS_ propose aussi des mécanismes de partitionnement en mémoire.

_RTEMS_ propose un ordonnanceur en _cluster_ (_clustered scheduling_). Cet ordonnanceur
permet de partitionner l'ensemble des cœurs en des sous-ensembles appelés _cluster_.
L'objectif de cette conception est de limiter les migrations de tâches entre cœur pour des
raisons de performances#footnote[La migration excessive de tâche conduit à une invalidation
des caches des cœurs.] tout en préservant un bon contrôle sur la latence dans le pire cas
(_worst-case latencies_). _RTEMS_ propose également des primitives de synchronisation
inter-clusters. En utilisant des clusters et des mécanismes de synchronisation
adéquate, il est possible d'avoir des tâches temps réels et des tâches maximisant le
_throughput_.


== Profilage <rtems_profiling>

Il y a un support pour profiler les goulots d'étranglement, notamment
les verrous et le thread dispatch. Cela produit une sortie XML. @rtems_test_suites.

== Watchdog <rtems_watchdog>

_RTEMS_ ne fournit pas à notre connaissance d'API unifiée pour gérer les
_watchdogs_ matériels. Le support est implémenté au niveau du
@bsp. Ce support est disponible pour le _Raspberry PI 4_ comme nous l'illustrons
dans la sous-section @rtems_watchdog_raspberry.

=== Watchdog matériel avec un _Raspberry PI 4_ <rtems_watchdog_raspberry>

Le dossier `./rtems/examples/watchdog` contient un exemple d'interaction avec
le watchdog d'un Raspberry.

#figure(
  snippet("./rtems/examples/watchdog/src/init.c", lang:"c"),
  caption: [Interaction avec un _watchdog_ sur un _Raspberry PI 4_.]
) <rtems_watchdog_example>

La commande suivante compile et produit une image dans `./rtems/artifacts/watchdog.img`.
```console
make watchdog -C ./rtems/watchdog
```

=== Time Manager

Il est possible d'implémenter un _watchdog_ logiciel via le _Timer Manager_.
Plus précisément, on peut mettre en place un timer avec la fonction
`rtems_timer_fire_after`.

#figure(
  snippet("./rtems/examples/timer/src/init.c", lang:"c"),
  caption: [Exemple d'interaction avec un _watchdog_ logiciel.]
) <rtems_deadman_example>

== Qualifications & certifications <rtems_certifications>

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

= seL4 <sel4>

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
l'institut de recherche _NICTA_ #footnote[Acronyme pour _National Information
and Communications Technology Autralia_)]. L'objectif était de créer un
système d'exploitation capable de satisfaire les
exigences de sécurité et de sûreté des @cc. À ce titre, les
contraintes induites par la vérification formelle du noyau ont été prises
en compte dès le départ du projet. Comme son nom le suggère, dans son design,
_seL4_ est fortement inspiré du micronoyau de seconde génération _L4_. Ainsi, il
fournit des abstractions pour la mémoire virtuelle, les _threads_ et
la communication inter-processus. Toutefois, contrairement à la majorité des
autres micronoyaux de la famille _L4_, il fournit également des _capabilities_
pour gérer les autorisations.

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
La dernière version du micronoyau supporte les architectures suivantes: _ARM v7_,
_ARM v8_, _x86-32_, _x86-64_ et _RISC-V_.

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
contrairement aux architectures @smp.

Il y a également un support pour _OpenAMP_.

Quelques projets qui utilisent _seL4_ sur des architectures @amp: @solox_amp_rust.

== Support temps-réel <sel4_realtime>

En plus de disposer d'un ordonnanceur déterministe, _seL4_ a fait l'objet
d'une analyse de son @wcet approfondi @blackham2011timing @sewell2016complete.
Autrement dit, pour un certain nombre de configurations, on dispose d'une estimation
vérifiée du temps d'exécution de toutes les routines du micronoyau. Toutefois
cette analyse a été faite sur ARMv6 et ARM ne fournit pas les informations
nécessaires pour réitérer cette analyse sur les nouvelles architectures.
Il semble qu'il y ait un projet pour une telle analyse sur _RISC-V_.

Le noyau tourne avec les interruptions matérielles désactivées. Ce choix
simplifie grandement la conception et la vérification formelle.

Les appels systèmes sont généralement courts. Ceux qui sont trop longs sont
préemptible à des points clés ajoutés par les développeurs.

Il permet de faire du temps réel tout en ayant l'isolation spatiale, ce qui
n'est pas le cas de nombreux _RTOS_ (vérifier pour _RTEMS_).

Il semblerait qu'être préemptible ne soit pas un prérequis pour offrir de faible
latences!

== Corruption de la mémoire <sel4_memory_corruption>

== Support de watchdog <sel4_watchdog>

== Support de langages de programmation en baremetal

La documentation de _seL4_ détaille les manipulations nécessaires pour exécuter
du code C ou Rust en @baremetal.

Il y a une crate Rust @sel4_crate_rust.

== Temps de démarrage


== Partitionnement <sel4_partition>

#figure(
  cetz.canvas({
    import cetz.draw: *
    cell((-3, -1.5), (12, -0.5), color: blue, [seL4])
    cell((-3, -3), (12, -2), color: gray, [Couche matérielle])
    cell((-3, 0.5), (0, 1.6), color: purple, [Application])
    cell((0.5, 0.5), (3.5, 6), color: yellow, [VM 1])
    cell((0.7, 0.7), (3.3, 4), color: orange, [Linux])
    cell((0.9, 0.9), (3.1, 2), color: orange, [Pilote])
    cell((4, 0.5), (7, 6), color: yellow, [VM 2])
    cell((4.2, 0.7), (6.8, 4), color: orange, [Linux])
    cell((4.5, 0.9), (6.5, 2), color: orange, [FS])
    cell((9, 0.5), (12, 3), color: green, [Pilote])
  })
  ,
  caption: [Architecture de l'hyperviseur _seL4_.]
) <architecture_xen>

Lorsqu'il est utilisé en tant qu'hyperviseur, _seL4_ s'exécute dans le mode
d'exécution _hyperviseur_.

=== Capabilities

Les #definition[capabilities] de _seL4_ sont des jetons donnant à leur
possesseur des droits d'accès à une ressource spécifique. Il existe trois types
de _capabilities_:
- #box[Les _capabilities_ donnant accès à des objets du noyau comme le
_thread control block_. Ces _capabilities_ sont donnés à la tâche _root_ durant
l'initialisation du système.]
- #box[Les _capabilities_ donnant accès à des ressources abstraitres comme _IRQControl_.]
- #box[Les _capabilities untyped_.]

De façon plus concrète, les _capabilities_ se présentent sous la forme de
pointeurs constants contenant des informations supplémentaires pour encoder les
droits d'accès. Disposer d'un tel pointeur est la seule façon d'accéder à la
ressource qu'il pointe.

== Vérification formelle <sel4_formal_verification>

Le noyau _seL4_ a fait l'objet d'une vérification formelle profonde. L'approche
suppose la correction du compilateur, du code assembleur et du matériel mais
démontre la conformité du code C avec ses spécifications.

== Licences & brevets <sel4_licenses>

Le noyau de `seL4` est un logiciel libre distribué principalement sous licence
`GNU General Public License version 2 only (GPL-2.0)`. Le code utilisateur et
les pilotes peuvent être distribués sous n'importe quelle licence @sel4_licensing.

== draft

Il a l'avantage de supporté les partitions mixtes @vanderleest2016open.

`seL4` a fait l'objet d'une spécification et d'une vérification formelle à
l'aide de l'assistant de preuve _Isabelle/HOL_. La correction
#footnote[La correction d'un algorithme signifie qu'il a été démontré que cet
algorithme respecte sa spécification.] de l'implémentation
a été démontrée pour plusieurs configurations et il a été également démontré
que le code binaire est correct pour les architectures _ARM_ et _RISC-V_ @sel4_verification.
Cette vérification formelle implique en particulier que `seL4` est dépourvu de
certaines erreurs de programmation classiques @sel4_implication. Il est notamment
dépourvu de débordements de tampon, de déréférencements de pointeurs nuls, de
fuites mémoire et de dépassements d'entier.

= Xen <xen>

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
@xen_partitioning).

== Tutoriel <xen_tutoriel>

Les exemples de cette section ont été lancé sur une machine _x86_ avec _Xen_.
L'installation de _Xen_ est grandement simplifié par son support dans certaine
distribution _GNU/Linux_. Il vous suffit d'installer les paquets appropriés puis
de redémarrer en choisissant l'hyperviseur _Xen_ au démarrage.

== Architectures supportées <xen_architectures>

#warning[][
  Dans cette section nous utiliserons les abréviations _PV_, _HVM_ et _PVH_
  qui désignent des types de partitions sous _Xen_. Ces notions sont détaillées
  dans la section @xen_partitioning.
]

À l'origine _Xen_ ne supportait que l'architecture _x86_ pour des partitions de
type _PV_. Par la suite, la virtualisation assistée par le matériel a été ajoutée
pour les technologies _Intel VT-X_ puis _AMD V_ sous la forme de partitions de
type _HVM_.

L'hyperviseur _Xen_ supporte les architectures suivantes: _x86-32_ à partir de
la version P6#footnote[Cette version correspond à l'introduction des processeurs
_Intel Pro_ en 1995.], _x86-64_, _ARM v7_ et _ARM v8_. _Xen_ a également
supporté l'architecture _IA64_ jusqu'à la version 4.2. Il existe des travaux en
cours pour supporter les architectures _PowerPC_ et _RISC-V_. Un support
préliminaire de ces architectures est disponibles depuis _Xen 4.20_ @xen_project_4_20.
Quant à la virtualisation assistée par le matériel de type @hvm, elle nécessite les
extensions de virtualisation _Intel VT-X_ ou _AMD-V_ sur _x86_ et les
_Virtualization Extensions_ sur _ARM_ @xen_arm_hvm.

#let scell(color: white, txt) = table.cell(fill: color.lighten(40%), [#txt])

#let supported(txt) = scell(color:green, txt)
#let notsupported(txt) = scell(color:red, txt)
#let partiallysupported(txt) = scell(color:yellow, txt)
#let deprecated(txt) = scell(color:black, txt)

#figure(
  table(
    columns: 4,
    align: (left, left, left, left),
    [Architecture], [PV], [HVM], [PVH],
    [_x86-32_],  partiallysupported([$gt.eq$ P6]), notsupported([]), [],
    [_x86-64_],  supported([]), supported([$+$ _Intel VT-X_]), [],
    [_ARMv7_],   deprecated([]), notsupported([]), supported([$+$ _Virtualization Extensions_]),
    [_ARMv8_],   deprecated([]), notsupported([]), supported([$+$ _Virtualization Extensions_]),
    [_PowerPC_], partiallysupported[_Xen_ $gt.eq$ 4.20], [], [],
    [_RISC-V_],  partiallysupported[_Xen_ $gt.eq$ 4.20], [], []
  ),
  caption: [Récapitulatif des architectures supportées par l'hyperviseur _Xen_]
)

== Support multi-processeur <xen_multiprocessor>

== Processeurs virtuels <xen_vcpu>

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
@xen_real_time.

== Support @smp

_Xen_ offre un support @smp pour toutes les architectures vues en sous-section
@xen_architectures. En particulier les ordonnanceurs _Credit Scheduler_ et
_Credit2 Scheduler_ sont capables de répartir automatiquement la charge sur les
différents cœurs.

Lorsqu'un système invité supporte lui-même les architectures @smp, il peut
en tirer parti dès lors qu'il dispose de plusieurs _vCPU_.

== Support @amp

Nous n'avons pas d'informations précises sur l'usage de _Xen_ sur des plateformes
@amp. Toutefois la documentation de _RTEMS_ mentionne l'usage de _Xen_ sur
un @mpsoc _Xilinix Zynq UltraScale+_ @vanvossenxen.

== Temps réel <xen_real_time>

Comme nous l'avons vu dans la section introductive, _Xen_ a été conçu pour le
_cloud computing_. En particulier, le projet met l'accent sur les garanties
que les ressources louées par des clients seront effectivement disponibles lorsque
leurs @vm:pl les requerront. Les ordonnanceurs que nous avons vus dans la sous-section
@xen_vcpu cherchent donc à être aussi juste que possibles. Cette garantie est
en contradiction avec les besoins du temps réel. En effet une tâche critique
peut avoir soudainement besoin de beaucoup de ressources, si ce n'est la totalité
des ressources.

Le projet _RT-Xen_ visait à dôter _Xen_ d'un ordonnanceur temps réel pour ces
_vCPU_. À l'origine le projet est développé à partir d'un _fork_ de la branche
_4.3_ de _Xen_. Il a été intégré dans _Xen_ à partir de la version _4.5_ sous
la forme d'un nouvel ordonnanceur baptisé _RTDS_ (_Real-Time Deferrable Server_) @xi2014real.
L'objectif de _RTDS_ est d'assurer que les @vm:pl reçoivent un temps _CPU_ minimal
garanti. Cet ordonnanceur supporte les plateformes @smp.

Il est donc possible d'exécuter dans une @vm un _RTOS_. Par exemple _RTEMS_
peut être exécuté dans une telle configuration sur architecture _ARM_.

== Partitionnement <xen_partitioning>
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

_Xen_ utilise le terme de _domaine_ pour qualifier les conteneurs des machines
virtuelles en cours d'exécution. Il existe trois types de domaines:
- #box[Le domaine 0 (abrégé _dom0_) désigne un domaine privilégié qui est automatiquement
lancé au démarrage de l'hyperviseur. Le système d'exploitation hôte est généralement
une distribution _Linux_ modifiée (voir la section @xen_os).]
- #box[Les domaines utilisateurs (abrégé _domU_) sont les domaines qui contiennent les
OS invités. Il existe deux types de tels domaines. Les domaines de paravirtualisation
et les domaines _HVM_.]
- #box[_dom0less_.]

== Corruption de la mémoire <xen_memory_corruption>

== Perte du flux d'exécution

== Monitoring <xen_monitoring>

== Profilage <xen_profiling>

== Support de langages de programmation en @baremetal <xen_baremetal>

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

Les interruptions matérielles sont virtualisées via le concept
d'_event channels_. Il est possible de masquer ces évènements via des masques
@xen_event_channel_internals.

== Maintenabilité

_Xen_ est réputé pour avoir un @tcb plus important que d'autres hyperviseurs,
notamment dû à la taille importante de ces sources. Il est toutefois important
de souligner que le volume de code varie d'un facteur 10 entre les des architectures
les mieux supportées, à savoir _x86_ et _ARM_.

Un autre facteur important qui augmente la @tcb est l'usage d'un noyau _Linux_
dans le _dom0_. La compromission de ce système compromettant tout le système,
il ne peut en être exclu.

== Licences <xen_licenses>

_Xen_ est un logiciel libre distribué majoritairement sous licence `GPLv2`.
Toutefois certaines parties du projet sont distribuées sous des licences
plus permissives afin de pas contraindre les licences des logiciels applicatifs
ou des systèmes d'exploitation pouvant être portés sur _Xen_. Ces exceptions
sont spécifiés dans les en-têtes des fichiers concernés. Plus d'informations
sont disponibles dans le fichier `COPYING` du dépôt git @xen_licensing.

== Temps de démarrage <xen_booting>

== Draft

- C'est quoi un stubdomain?
- Il semble que les dom0less permettent d'accélérer le temps de démarrage
des domaines.

== Mise en place d'une machine virtuelle Alpine

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

=== Domaines

#figure(
  cetz.canvas({
    import cetz.draw: *
    cell((-3, -1.5), (12, -0.5), color: blue, [Xen])
    cell((-3, -3), (12, -2), color: gray, [Couche matérielle])
    cell((-3, 0.5), (0, 6), color: green, [Dom0])
    cell((0.5, 0.5), (3.5, 6), color: green, [DomU#sub[1]])
    cell((4, 0.5), (7, 6), color: green, [DomU#sub[2]])
    cell((9, 0.5), (12, 6), color: green, [DomU#sub[n]])
  })
  ,
  caption: [Architecture de _Xen_]
) <architecture_xen>


=== Driver domain <xen_driver_domain>

Un _driver domain_ est un domaine utilisateur de _Xen_ qui a pour responsabilité de
gérer un périphérique. Il exécute un noyau minimal avec uniquement le pilote pour
ce périphérique. Ainsi, si le pilote plante, les autres domaines et en particulier
_dom0_ continuent de fonctionner tandis que le _driver domain_ peut être relancé.

Le noyau minimal peut être _Mini-OS_.

== OS supportés <xen_os>

_Xen_ étant un paravirtualisateur, il nécessite un support
spécifique des OS invités, que ce soit pour les _VM_ s'exécutant dans le
domaine privilégié _dom0_ ou les _VM_ s'exécutant dans les domaines _domU_.
Pour le domaine _dom0_, il offre un support pour
de nombreuses distributions _GNU/Linux_ (voir @xen_gnu_linux_supported)
ainsi que quelques autres noyaux de type _UNIX_ (voir @xen_unix_supported).
Plus d'informations sont disponibles @xen_os_supported. Pour le domaine _domU_,
_Xen_ offre aussi un large support pour les OS invités @domU_support_for_xen.

#figure(
  table(
    columns: (2fr, 3fr),
    stroke: 0.5pt,
    align: left + horizon,
    [Distribution], [Version(s) supportée(s)],
    [Alpine Linux], [2.4.x (2012-05-02) et plus récent],
    [CentOS et autres clones RHEL], [5.x],
    [CentOS], [6.4 et plus récent (utiliser Xen4CentOS)],
    [Debian], [Depuis Debian 4.0 (Etch)],
    [Fedora], [Depuis Fedora 16],
    [Mageia], [Toutes les versions],
    [OpenEmbedded], [Depuis la version 1.3],
    [OpenSUSE], [Depuis la version 11],
    [Oracle VM for x86 (OVS)], [Toutes les versions],
    [Redhat Enterprise Linux (RHEL)], [5.x seulement],
    [SUSE Linux Enterprise (SLE)], [Toutes les versions depuis 11],
    [Ubuntu], [Toutes les versions depuis 11.10],
    [XenServer], [Toutes les versions, mais open source à partir de la 6.2 (XCP existait avant)],
    [XCP-ng], [Toutes les versions depuis son existence (succède à XCP)],
  ),
  caption: [Distributions _GNU/Linux_ supportées par _Xen_ pour _dom0_],
) <xen_gnu_linux_supported>

#figure(
  table(
    columns: (2fr, 3fr),
    stroke: 0.5pt,
    align: left + horizon,
    [Distribution], [Version(s) supportée(s)],
    [FreeBSD], [HEAD r280954],
    [NetBSD], [5.1, 6],
    [Hurd], [Depuis 2013],
    [OpenSolaris], [2009.06],
    [Illumos], [Incomplet],
  ),
  caption: [Autres _UNIX_ supportés par _Xen_ pour _dom0_]
) <xen_unix_supported>

== Corruption de la mémoire <xen_memory_corruption>

L'hyperviseur _Xen_ ne dispose pas d'un système de journalisation des erreurs mémoires.
En revanche, il transmet ces erreurs au système d'exploitation exécuté dans le domaine
privilégié _Dom0_. Il est alors possible d'utiliser les outils livrés avec ce système pour
journaliser ces erreurs. Il est par exemple possible d'exécuter un noyau _Linux_
dans le domaine _Dom0_ et d'utiliser ces fonctionnalités de pilotage de la mémoire _ECC_
décrites en section @linux_memory_corruption.

== Profilage <xen_profiling>

La couche logicielle introduite par la virtualisation peut introduire des
régressions de performance dans les logiciels applicatifs par rapport à
une exécution directement sur un OS _bare-metal_. Dans ce contexte, il est
nécessaire d'utiliser des outils de profilage dédiés à l'hyperviseur. Dans cette
section, on présente trois outils de profilage pour _Xen_: _Xenprof_,
_XenTune_ et _xentrace_.

=== _Xenoprof_ <xen_xenoprof>

=== _XenTune_ <xen_xentune>

=== Le traceur _xentrace_ <xentrace>

Le logiciel _xentrace_ @xentrace_documentation est un outil distribué dans _Xen_.
Il permet de tracer l'activité des CPU virtuels et ainsi de savoir ce que fait
une  machine virtuelle sur un CPU donné.
Ces données sont collectées grâce à des _tracepoints_ positionnés à des endroits
clés du code de _Xen_. Ils sont activés via  _xentrace_ lorsqu'il est exécuté
dans le domaine _dom0_. Ce dernier produit alors un fichier binaire qui peut
ensuite être analysé par _xenanalyze_#footnote[Contrairement à _xentrace_,
_xenanalyze_ n'est pas distribué avec _Xen_.].

= XtratuM <xtratum>

_XtratuM_ est un hyperviseur temps-réel de type 1 qualifié pour un usage dans
le spatial. Le projet est initié en 2004 au sein de l'institut
_Automática e Informática Industrial_ (ai2) de l'_Universidad Politécnica_ de
Valence en Espagne @masmano2005overview @red5gespacial. Ces travaux
universitaires ont abouti à la création de l'entreprise _fentISS_
@fentiss_website en 2010 avec le soutien du _CNES_ et du groupe
_Airbus_ @red5gespacial. L'hyperviseur _XtratuM_ est désormais maintenu et
développé par _fentISS_. _XtratuM_ a été conçu pour être exécuté sur de
l'embarqué critique en donnant de fortes garanties quant à l'isolation
spatiale et temporaire de ses partitions @masmano2005overview. L'entreprise
_fentISS_ propose deux versions de _XtratuM_:
- Une version libre,
- Une version propriétaire appelée _Xtratum/NG_ (abrégé _XNG_).

développé à l'origine
par une équipe de recherche de l'_Universidad Politécnica_ de Valence et
maintenant maintenu par l'entreprise _fentISS_ @fentiss_website.

_XtratuM_ est un hyperviseur temps-réel de type 1 qualifié pour l'usage dans
le spatial. Le projet est initié en 2004. Il est développé par l'entreprise
_fentISS_.

_XtratuM_ virtualises la mémoire, les timers et les interruptions.

Il est conçu pour permettre l'isolation temporelle et spatiale
d'applications critiques sur une même plateforme physique grâce à l'usage
des technologies de virtualisation matérielle.

_XtratuM_ fait parti du projet _SAFEST_ @safest_project. Il s'agit d'un projet
visant à faire collaborer différents acteurs du secteur aérospatial européen
afin d'améliorer les performances et de réduire les coûts.

Tools:
- XPM est un pluging Eclipse pour la gestion d'un projet sur XtratuM
- Xoncrete (schedule analysis and generation)
- Xcparser (hypervisor configuration)
- Xtraceview (observability support)
- SKE (XtratuM simulator on servers)

_IMA_ (_Integrated Modular Avionics_) est une tendance dans l'avionique à ramener
au niveau de calculateurs modulaires identiques des fonctions logicielles
auparavant prises en charge par des calculateurs dédiés.

TODO:
- C'est quoi `cyclic scheduling policy`?
- `inter-partition communication` avec sampling et queuing ARINC-653-like ports
- health monitoring service


L'hyperviseur a déjà été utilisé dans le spatial avec notamment les missions
suivantes:
- PLATiNO (XtratuM + RTEMS) 2020
- MERLIN (XtratuM + RTEMS) 2021
- SVOM (XtratuM + lithOS) 2021
- SWOT (XtratuM + RTEMS) 2021
- JUICE (XtratuM + lithOS) 2022

_XtratuM/NG_(abrégé _XNG_) est une version plus récente de l'hyperviseur qui offre un meilleur
support multi-cœur.

== Architectures supportées <xtratum_architectures>

_XtratuM_ supporte les architectures suivantes:
_x86-32_, _SPARC_, _ARM-v7_, _ARM-v8_.

Il supporte SPARC/LEON (LEON2, 3, 4).

== OS supportés <xtratum_invited_os>

Il permet l'exécution en bare-metal via un _runtime_ appelé _XRE_ (_XUL Runtime Environment_).

_XRE_ _LithOS_, _RTEMS_, _Linux_

ECSS-Qualified?

_lithOS_ est un système d'exploitation temps réel conçu pour être exécuté dans
une partition de _XtratuM_.

== Qualifications <xtratum_qualifications>

_XtratuM_ est qualifié selon la norme _ECSS_ (_European Cooperation for Space Standardization_)
catégorie B @xtratum_ecss_qualification. Cette qualification en fait un hyperviseur
adapté aux missions spatiales critiques.

L'hyperviseur a été qualifié initialement pour les processeurs _SPARC-Leon_ et
_ARM Cortex-R4/R5_ et _A9_. L'entreprise _fentISS_ continue de travailler sur la
qualification de nouvelles versions, notamment _XtratuM Next Generation_ pour
lequel un processus de qualification ECSS niveau B est en cours.

Le succès de _XtratuM_ dans le spatial est remarquable: son hyperviseur temps-réel
est désormais déployé dans plus de 1000 satellites et engins spatiaux
@xtratum_milestone_1000, en faisant l'un des logiciels système les plus largement
adoptés en orbite. Cette présence massive témoigne de la maturité et de la fiabilité
du système dans des environnements opérationnels critiques.

== Licences & brevets <xtratum_licenses>

- #box[La version originelle de l'hyperviseur `XtratuM` est distribuée sous
licence `GPL v2` @xtratum_github.]
- #box[Une nouvelle version `XtratuM New Generation` est développée et
distribuée par l'entreprise fentISS. Il s'agit d'un logiciel propriétaire.]

// = OS généralistes
//
// Leurs noyaux se répartissent en deux catégories:
// - #box[Les _noyaux monolithiques_ qui se caractérisent pas le fait que la majorité
// de leurs services s'exécutent en _mode noyau_.]
// - #box[Les _micronoyaux_ qui n'exécutent que le strict nécessaire en espace
// noyau, à savoir l'ordonnancement des processus, la communication
// inter-processus et la gestion de la mémoire.]
//
// = Types de système d'exploitation
//
// Les systèmes d'exploitation se distinguent par les mécanismes d'abstraction
// qu'ils offrent, leur organisation et leur modularité.
// Certaines tâches gérées par un noyau peuvent être dans une configuration
// différente déléguées à une autre couche logicielle, voire au matériel. Nous
// proposons dans cette section une classification en trois catégories: les
// _unikernels_, les _hyperviseurs_ et les _OS classiques_.
//
// == Les unikernels
//
// Les _unikernel_ sont des systèmes d'exploitation qui se présentent sous la
// forme d'une collection de bibliothèques. Le développeur sélectionne les modules
// indispensables à l'exécution de son application, puis crée une _image_ en
// compilant son application avec les modules choisis. Cette image est ensuite
// exécutée sur un _hyperviseur_ ou en _bare-metal_#footnote[C'est-à-dire directement
// sur la couche matérielle sans l'intermédiaire d'un système d'exploitation.]
//
// == Les OS classiques

= Tableaux comparitifs<comp>

#table(
  columns: 3,
  table.header[Type d'OS][Avantages][Inconvénients],
  [Unikernel], [
    - Petite surface d'attaque
    - Petite empreinte mémoire
    - Faible temps de démarrage
  ], [
    - Débogage difficile
    - Recompilation & déploiement pour chaque changement
  ],
  [Hyperviseur], [
    - Optimisation des resources
    - Isolation
  ], [
  ],
  [Classique], [
    - Support matériel
    - Outil de débogage
  ], [
  ],
)

- #box[_KVM_ est un hyperviseur de type 1 intégré dans le noyau Linux. Il fait de
la virtualisation assistée par le matériel.]

Les OS que nous étudions se répartissent ainsi dans cette classification:
- Unikernel: MirageOS
- Hyperviseur: _KVM_, _Xen_, _PikeOS_, _ProvenVisor_
- Classique: _Linux_ (monolithique modulaire), _seL4_ (micronoyau), _RTEMS_

= Architectures supportées & multi-cœur

== Architectures supportées

Le tableau suivant résume le support de ces architectures de processeur pour les
systèmes d'exploitation de cette étude. Lorsque l'OS est un hyperviseur, il
s'agit du support pour le matériel surlequel est exécuté l'hyperviseur.

#table(
  columns: 9,
  align: (center, center, center, center, center, center, center, center, center, center),
  [OS], [x86-32], [x86-64], [ARM v7],  [ARM v8],  [PowerPC], [MIPS], [RISC-V], [SPARC],
  [Linux @linux_arch],
        [Oui],    [Oui],    [Oui],     [Oui],     [Oui],     [Oui],  [Oui],    [Oui],
  [KVM @kvm_arch],
        [Oui],    [Oui],    [Oui],     [Oui],     [Oui],     [Non],  [Non],    [Non],
  [MirageOS @mirage_os_arm64 @mirage_os_installation],
        [Non],    [Oui],    [Non],     [Oui],     [Non],     [Non],  [Non],    [Non],
  [PikeOS @pikeos_homepage],
        [Oui],    [Oui],    [Oui],     [Oui],     [Oui],     [Non],  [Oui],    [Oui],
  [ProvenVisor @provenrun_homepage],
        [Non],    [Non],    [Non],     [Oui],     [Non],     [Non],  [Non],    [Non],
  [RTEMS @rtems_architectures],
        [Oui],    [Oui],    [Oui],     [Oui],     [Oui],     [Oui],  [Oui],    [Oui],
  [seL4 @sel4_supported_platforms],
        [Oui],    [Oui],    [Oui],     [Oui],     [Non],     [Non],  [Oui],    [Non],
  [Xen],
        [Non],    [Non],    [Oui],     [Non],     [Oui],     [Non],  [Non],    [Non],
  [XtratuM],
        [Non],    [Non],    [Oui],     [Non],     [Oui],     [Non],  [Non],    [Non],
)

== Linux & KVM

Le noyau `Linux` est un logiciel libre distribué sous licence
`GNU General Public License version 2 only (GPL-2.0)` avec l'exceptions
_syscall_ qui stipule qu'un logiciel utilisant le noyau `Linux` au travers des
appels systèmes n'est pas considéré comme une œuvre dérivée de celui-ci et
peut être distribué sous une licence qui n'est pas compatible avec la GPL,
y compris une licence propriétaire. Plus d'informations sont disponibles dans
le dossier `LICENSES` des sources du noyau `Linux`.

= Complexité et maintenabilité

Dans cette section, nous nous intéressons à la complexité et la maintenabilité des OS étudiés.

== SLOC

Une première mesure simple de la complexité d'un programme est donné par la métrique _SLOC_
(pour _source lines of code_) qui mesure la taille d'un programme informatique en nombres de lignes dans
son code source. Les sources de `PikeOS`, `ProvenVisor` and `XtratuM` étant fermées et n'ayant pas trouvé de
données concernant le _SLOC_ pour ces OS, nous les excluons de cette section.

Pour les OS open-sources, nous avons utilisé l'outil `SLOCCount`@sloccount_website pour effectuer ces mesures. Cet outil ne compte pas les commentaires.

#table(
  columns: 4,
  align: (center, center, center, center),
  [OS],          [Total (SLOC)],  [Pilotes (SLOC)], [Langage],
  [Linux & KVM], [26 927 724],    [18 920 036],     [C (98%)],
  [MirageOS],    [9,075],         [?],              [OCaml (99%)],
  [PikeOS],      [?],             [?],              [C (?)],
  [ProvenVisor], [?],             [?],              [C (?)],
  [RTEMS],       [1 990 023],     [71,238],         [C (96%)],
  [seL4],        [68 175],        [1 086],          [C (87%)],
  [Xen],         [581 193],       [45 220],         [C (93%)],
  [XtratuM],     [?],             [?],              [C (?)],
)

== Partitionnement temps et/ou mémoire

==== Linux

==== seL4

Le noyau permet de capturer les MCE lors de l'exécution d'un thread.

==== MirageOS

==== RTEMS

==== Cas des hyperviseurs

Les hyperviseurs n'intègrent généralement pas d'outils de journalisation des erreurs
matérielles. Ce n'est pas nécessaire car ce type d'erreurs est reporté à un système
d'exploitation invité via des interruptions matérielles transmises par l'hyperviseur
depuis la couche matérielle. MCE (Machine-check exception)

==== XtratuM

== Gestion des interruptions

==== Linux & KVM

==== MirageOS

L'unikernel est capable de contrôler les interruptions matérielles via le mécanisme
d'_Event channel_ de l'hyperviseur _Xen_ @mirageos_xen_events@mirageos_ocaml_evtchn.

==== PikeOS

==== ProvenVisor

_ProvenVisor_ est le seul à avoir accès aux interruptions matérielles. Il virtualise
ces interruptions, c'est-à-dire qu'il expose à chaque système invité une représentation
virtuelle du contrôleur d'interruption. Pour le système invité tout se passe comme
s'il avait accès à un véritable _APIC_.

==== RTEMS

_RTEMS_ étant un _RTOS_, la gestion des interruptions matérielles y est critique.
Le système permet une gestion fine des interruptions via l'_Interrupt Manager_
@rtems_interrupt_manager.

==== SeL4

@sel4_interrupts

==== Xen

En tant qu'hyperviseur, _Xen_ ne donne pas un accès direct au matériel et en
particuliers aux registres contrôlant le comportement des interruptions. Au lieu de cela,
les interruptions matérielles sont capturées par un système d'exploitation invité
tournant dans le domaine privilégié _Dom0_ et transmises aux domaines concernés via
un mécanisme abstrait appelé _Event channel_. Il est alors possible de masquer certains
événements via un champ _evtchn_mask_ @xen_event_channel_internals.

= Introduction2 <introduction2>

Un #definition[système d'exploitation]#footnote[En anglais _Operating System_,
souvent abrégé _OS_.] est un ensemble de routines gérant les ressources
matérielles d'un système informatique, qu'il s'agisse d'ordinateurs de bureau,
de serveurs ou de systèmes embarqués. Son rôle principal est de servir de
couche d'abstraction logicielle entre le matériel et les logiciels applicatifs.
Il permet ainsi de masquer la complexité et la diversité des interfaces matérielles en
fournissant des _API_ (_Application Programming Interface_) stables, unifiées et
parfois standardisées. Les systèmes d'exploitation se distinguent aussi bien
par les mécanismes d'abstraction qu'ils offrent, que leur organisation ou
leur modularité. Ainsi, un tâche gérée par un OS peut être dans une autre
configuration déléguée à une autre couche logicielle, voire au matériel.
Il est donc difficile de caractériser rigoureusement ce qu'est un système
d'exploitation autrement que par le fait qu'il s'exécute en
#definition[mode noyau] (_kernel mode_), c'est-à-dire dans un mode
d'exécution privilégié donnant accès à l'ensemble de la mémoire et des
instructions. A contrario, les logiciels applicatifs s'exécutent en
#definition[mode utilisateur] (_user mode_) et interagissent avec l'OS
lorsqu'ils ont besoin d'accéder au matériel.

Ce document est une étude comparative de plusieurs systèmes d'exploitation dans
le contexte de systèmes critiques ou temps réels. Afin de mieux cerner le sujet,
commençons par préciser ces deux termes.

On distingue le plus souvent trois modes d'exécutions sur les processeurs modernes:
- #box[Le #definition[mode noyau] (_kernel mode_) est un mode
d'exécution privilégié donnant accès à l'ensemble de la mémoire et des
instructions. C'est dans ce mode que sont exécutés la majorité des systèmes
d'exploitations.]
- #box[Le #definition[mode utilisateur] (_user mode_)
est a contrario un mode d'exécution qui n'a pas accès à toutes les
instructions. Les logiciels applicatifs sont généralement exécutés dans ce mode
et interagissent avec l'OS lorsqu'ils ont besoin d'exécuter des instructions
nécessitant des privilèges plus élevés.]
- #box[Le #definition[mode hyperviseur] (_hypervisor mode_)
est lui aussi un mode privilégié utilisé par les hyperviseurs. Nous verrons de
tels systèmes d'exploitation dans cette étude.]

=== Tutoriels

L'étude contient un certain nombres de tutoriels et exemples illustrant
le fonctionnement des différents systèmes étudiés. Pour que ces exemples
puissent s'exécuter sur votre machine, il faut un certains nombres de prérequis.

TODO: Dans le cadre @smp, le masquage des interruptions seuls ne suffit pas à
garantir l'isolation d'une section critique.


=== Xen & MirageOS
Nous supposons que vous êtes sous une distribution _GNU/Linux_ disposant
d'un support pour l'hyperviseur _Xen_.

#howto[mise en place d'un pont virtuel][
  Certains exemples nécessitent de pouvoir communiquer via le réseau entre
  le domaine _dom0_ et le domaine _domU_. Ces exemples partent du principe
  qu'un pont virtuel nommé `br0` existe avec comme adresse de sous-réseau
  `10.0.0.0` et comme gateway `10.0.0.1`. Si votre distribution utilise `systemd`,
  vous pouvez mettre en place un tel pont ainsi:
  ```console
  sudo ip link add br0 type bridge
  sudo ip link set br0 up
  sudo ip addr 10.0.0.1/24 dev br0
  ```
]


= Conceptions générales

Cette section regroupe davantage d'informations sur les designs généraux des
systèmes d'exploitations. À ce titre cet exposé peut être pertinent quant au
choix du design dans un projet.

== Noyau monolithique versus micronoyau <monolithic_vs_microkernel>

La notion de système d'exploitation est complexe à délimiter car
les tâches exécutées en mode noyau peuvent varier considérablement d'un système
à l'autre. Toutefois, les systèmes d'exploitation modernes partagent un ensemble
de services fondamentaux et notamment:
- La gestion de la mémoire principale.
- La gestion des _threads_ et des processus.
- #box[La communication inter-processus
#footnote[En anglais _Inter Process Communication_, abrégé _IPC_.].]
- La gestion des périphériques d'entrée/sortie.
- La pile réseau.
- Le système fichiers.
- La gestion des droits d'accès.

Deux approches extrêmes s'opposent dans la conception des noyaux:
- #box[Les noyaux #definition[monolithiques] intègrent un grand nombres de
services exécutés en mode noyau. Par exemple, le noyau _Linux_ gère
tous les services mentionnés ci-dessus dans ce mode.]
- #box[Les #definition[micronoyaux], au contraire, cherchent à minimiser la
quantité de code exécuter en mode noyau. La gestion de la mémoire, des
_threads_ et l'_IPC_ sont assurés par le micronoyau, tandis que les autres
services peuvent être exécutés en mode utilisateur.]

Les deux approches ont des avantages et inconvénients:
- #box[L'approche monolithique
est souvent de conception plus simple. Elle offre de très bonnes performances
en permettant une communication rapide entre les différents services, évitant
notamment les coûteuses commutations de contexte nécessaires lorsqu'on passe
d'un mode d'exécution à un autre. Cependant les noyaux monolithiques sont
souvent de maintenance plus difficile que les micronoyaux. Cela est notamment dû
à la taille nettement plus importante de leur base de code. Leur vérification et
certification est également plus complexe, tandis que la fiabilité du système
est compromise dès lors que l'un de ses services fait défaut.]
- #box[L'approche micronoyau est conceptuellement plus complexe. L'efficacité
de la communication _IPC_ est cruciale pour les performances étant donné qu'un
grand nombres de services tournent en mode utilisateur. En contrepartie, cette
approche offre une plus grande fiabilité et robustesse face aux pannes. La vérification
et la certification est facilité par la base de code plus réduite.]

On peut également citer une dernière conception qui est une variante de l'approche
monolithique. Il s'agit des noyaux #definition[modulaires].

=== Le noyau L4 <l4_kernel>
Un exemple notable de tel système est le micronoyau _L4_
développé au sein de l'université Karlsruhe. Ce projet visait à réduire les
écarts de performances entre les micronoyaux et les architectures monolithiques
de l'époque. Ce projet a servi de base à deux systèmes d'exploitations étudiés
dans ce rapport: _seL4_ et _PikeOS_.

Les _GPOS_ peuvent d'être divisé en trois grandes catégories:
- Les noyaux monolithique.
- #box[Les micronoyaux: au contraire du noyau monolithique, le micronoyau se
concentre sur les opérations fondamentales qui ne peuvent être effectuée que
dans le _kernel space_. Il s'agit généralement de la gestion de la mémoire
et des processus. Toutes les autres tâches sont déléguées à des services s'exécutant
dans le _user space_. ]
- #box[Les noyaux modulaires: ils constituent un intermédiaire entre les deux
designs précédents. Le noyau a la possibilité de charger ou décharger certaines
sous-systèmes de façon dynamique. C'est notamment le cas des pilotes.]

== Hyperviseur <type_hypervisor>

Avant de dresser une vue d'ensemble des hyperviseurs, rappelons brièvement leur
raison d'être. Lorsque l'on souhaite héberger plusieurs services  de façon fiable
et sûre, une première solution consiste
à héberger chaque service sur une machine individuelle. On obtient ainsi une
isolation totale des différents services. Cette solution présente
toutefois deux inconvénients majeurs, à savoir le coût prohibitif et une
maintenance plus complexe. Les _hyperviseurs_ ont été créés pour répondre à ces
besoins à moindre frais.

Les _hyperviseurs_ se divisent généralement en deux catégories:
- #box[Les _hyperviseurs de type 1_ s'installent directement sur la couche
matérielle. On parle aussi parfois d'_hyperviseurs bare-metal_.]
- #box[Les _hyperviseurs de type 2_ nécessitent une couche logicielle
intermédiaire entre eux et la couche matérielle. Nous n'étudions pas de tels
OS dans ce document.]

Un autre axe d'attaque pour comparer les _hyperviseurs_ est:
- #box[La _virtualisation total_: le comportement de la couche matérielle]
- #box[La _virtualisation partielle_]
- #box[La _paravirtualisation_]

La _virtualisation totale_ (_full virtualization_ en anglais) consiste à émuler
le comportement de la couche matérielle en exposant la même interface aux systèmes
invités. Cette méthode permet d'exécuter n'importe quel logiciel qui aurait pu être
lancé sur cette couche matérielle. On distingue deux sous-types de virtualisation
totale:
- la translation binaire (_binary translation_ en anglais)
- la virtualisation assistée par le matériel (_hardware-assisted virtualization_)

La _paravirtualisation_ est une technique de virtualisation qui consiste à
présenter une interface logicielle similaire au matériel mais optimisée pour
la virtualisation. Cette technique nécessite à la fois un support de l'hyperviseur
et du système d'exploitation invité. En contre partie, la paravirtualisation
permet généralement d'obtenir de meilleures performances.

== RTOS <type_rtos>

Un _RTOS_ est un système d'exploitation offrant des garanties sur le temps
d'exécution de ses tâches. Les contraintes temporelles sont d'autant plus
difficiles à garantir que le système est multi-tâche. On distingue
trois classes de contraintes temporelles suivant leur criticité:
- #box[Les contraintes _soft real time_ sont des contraintes nécessaires pour
offrir une certaine qualité de service. Par exemple le visionnage d'une vidéo
nécessite un _frame rate_ minimal. La violation de ces contraintes
n'occasionne qu'une dégradation de la qualité du service rendu.]
- #box[Les contraintes _firm real time_ sont similaires au cas précédent mais
leur violation peut conduire à un résultat invalide.]
- #box[Les contraintes _hard real time_ sont les plus strictes et leur violation
a généralement des conséquences indésirables. Ces contraintes sont typiques dans
les systèmes critiques.]

Le _WCET_ (_Worst-Case Execution Time_) désigne le temps d'exécution maximal
d'un programme informatique sur une plateforme matérielle donnée.

= Notions générales <general_notions>

Cette section contient des notions générales autour des systèmes
d'exploitation et des interfaces matérielles pertinentes pour ce rapport. Ces
notions ne sont qu'effleurées étant donné d'une part la complexité des
architectures et des OS actuels, et d'autre part le foisonnement des solutions
existantes. Le lecteur intéressé par plus détails pourra lire les sources citées
au fil de la section.

== Partitionnement des ressources

Le partitionnement des ressources est un mécanisme fondamental des systèmes
d'exploitation modernes. Il vise à permettre l'exécution simultanée de
plusieurs tâche sur une même machine physique. On parle alors de système
#definition[multi-tâche].
En effet, les ressources matérielles étant le plus souvent insuffisantes pour exécuter
chaque tâche sur sa propre machine, il est nécessaire de partager ces ressources
entre les programmes.
Dans ce contexte, l'isolation des tâches en cours d'exécution devient nécessaire
afin de s'assurer qu'un programme malveillant ou défectueux ne puisse compromettre
l'ensemble du système. Ce partage peut être opéré à plusieurs niveaux, notamment:
- Au niveau des #definition[processus] s'exécutant sur un système d'exploitation.
- Au niveau des OS invités s'exécutant sur un hyperviseur.

Dans cette section, nous examinons ce partionnement pour deux ressources:
la mémoire principale et le processeur.

=== Partitionnement en mémoire

Le partitionnement en mémoire vise à partager la mémoire principale entre
plusieurs tâches en cours d'exécution. Ce partage est crucial car il permet de
conserver en mémoire tout ou une partie des données de plusieurs processus,
améliorant les performances du système.

Dans le cas des processus, la méthode la plus courante pour gérer ce partage
s'appuie sur la #definition[mémoire virtuelle]. Au lieu de faire référence à
des adresses physiques directement, les instructions utilisent des
adresses virtuelles qui sont traduites à la volée vers des adresses physiques
par une puce dédiée: le _MMU_ (_Memory Management Unit_). Ainsi, chaque
processus a l'illusion de disposer de la totalité de la mémoire principale.

Lorsqu'une instruction tente d'accéder à une adresse virtuelle qui ne figure pas
dans le table du processus en cours d'exécution, un _page fault_ est émis sous
la forme d'une interruption matérielle et permet au système d'exploitation de réagir
en conséquence.

Un autre aspect important est la #definition[pagination]. L'espace d'adressage est
subdivisée en des pages de tailles fixes. Cela permet de n'avoir qu'une portion
des données d'un processus en mémoire et de charger les pages manquantes à la
demande.

=== Partitionnement en temps

Les systèmes d'exploitation moderne permettent l'exécution de programmes dans un
contexte multi-tâches. Cette exécution peut être #definition[concurrentielle]
ou #definition[parallèle]. Dans cette section, une tâche peut aussi bien désigner
un programme, un _thread_ ou même un OS invité.

L'#definition[ordonnanceur de tâche] (_scheduler_) est un des composants
principales d'un système d'exploitation. Son rôle est de décider quelle tâche doit
être exécuté à un instant donné sur le CPU. Un _scheduler_ peut poursuivre des
objectifs différents et parfois incompatibles. Il peut notamment chercher à:
- #box[Maximiser la quantité de travail accomplie par unité de temps. En anglais,
on parle souvent du _throughtput_.]
- #box[Minimiser la #definition[latence] (_latency_), c'est-à-dire ]
- #box[Être #definition[équitable] (_fairness_) en donnant des tranches de temps
en proportion de la priorité et de la charge de travail d'une tâche.]

L'ordonnanceur de tâches d'un _RTOS_ cherche à maximiser le nombre de tâches
pouvant respecter leurs _deadlines_ simultanément. À cette fin, la
#definition[latence].

L'ordonnanceur de tâches d'un _GPOS_ cherche le plus souvent à maximiser
la quantité de travail accomplie par unité de temps#footnote[Cette quantité
est souvent désigner par _throughput_ en anglais.]

Un _cœur_ est un ensemble de circuits intégrés capable d'exécuter des instructions
de façon autonome. Un microprocesseur embarquant plusieurs cœurs est qualifié
de _processeur multi-cœur_.

De nos jours, certains fabricants comme Intel ou ARM proposent des processeurs où les
cœurs ne sont plus identiques. L'intérêt principal de ces architectures hybrides est
de faire un compromis entre la puissance de calcul et l'efficacité énergétique. Ainsi
on y trouve généralement deux types de cœurs:
- #box[Les cœurs performances: ces unités sont dédiées aux tâches lourdes mais
  sont gourmandes en énergie. On peut citer les cœurs _P-cores_ chez Intel et
  _big_ chez ARM.]
- #box[Les cœurs économes: moins performantes que les cœurs de la
  première catégorie mais consomment nettement moins d'énergie et dissipent moins
  de chaleur. On peut citer les cœurs _E-cores_ chez Intel et _LITTLE_ chez ARM).]

== Gestion des interruptions

La gestion des interruptions est l'une des tâches primordiales d'un système d'exploitation.
Une #definition[interruption] est un événement matériel qui altère le flot d'exécution normal
d'un programme. Au niveau matériel, elles se manifestent par des signaux
électriques pouvant être émis à tout moment par:
- Un périphérique (clavier, disque, carte PCI, ...).
- Le CPU lui-même.
- #box[Dans une architecture multi-cœur, des signaux sont émis entre les cœurs.]
Lorsqu'une interruption est déclenchée, l'exécution courante est suspendue. Dans ce cas,
un gestionnaire d'interruption prend le relais. Il est important de noter qu'une
interruption peut subvenir à n'importe quel moment, y compris pendant l'exécution
d'un gestionnaire d'interruption. Cela pose plusieurs difficultés:
- #box[Il n'est pas toujours possible d'interrompre l'exécution d'une routine, notamment
dans une section critique. C'est un scénario courant dans un noyau.]
- #box[Dans un programme temps réel et suivant le niveau d'exigence, la latence induite par
ces interruptions doit ou non être prise en compte dans les contraintes temporelles.]

=== Interruptions programmables

Les architectures modernes permettent généralement la programmation des interruptions
grâce à des puces dédiées réparties entre la carte mère et le CPU:
- #box[Sur les architectures Intel et AMD, cette tâche est répartie entre la puce
_I/O APIC_#footnote[_APIC_ est un abréviation pour _Advanced Programmable Interrupt Controller_]
qui gère les interruptions émises par les périphériques et des circuits intégrés dans chaque
cœur appelés _Local APIC_ qui gèrent les interruptions entre les cœurs.]
- #box[Sur les architectures ARM, cette tâche est dévolue au _GIC_
(_Generic Interrupt Controller_).]
L'émetteur de l'interruption envoie une requête d'interruption
(_IRQ_ pour _Interrupt ReQuest_) à l'une de ces puces qui décide ensuite d'envoyer ou non
l'interruption au destinataire (TODO: vérifier).

=== Masquage des interruptions

Une solution pour gérer les interruptions est de _masquer_, c'est-à-dire bloquer,
temporairement certaines d'entre elles.

Les architecture moderne embarque généralement plusieurs puces dédiées à la gestion des
requêtes d'interruption (_IRQ_ pour _Interrupt ReQuest_). Par exemple, sur les architectures
Intel et AMD, cette tâche est accomplie par le sous-système _APIC_
(_Advanced Programmable Interruption Controller_). Sur les architectures ARM,
elle est dévolue au _GIC_ (_Generic Interrupt Controller_).

Les processeurs multi-cœur disposent aussi de puce _APIC_ par cœur, permettant
la gestion des interruptions entre cœurs (_Inter-Processor Interrupt_ IPI).

Les contrôleurs d'interruption permettent également de mettre des niveaux de priorité
sur les interruptions.

== Corruption de la mémoire

Dans cette section, on s'intéresse à la corruption de la mémoire et plus
précisément à la détection et la correction de ces erreurs.
Une méthode communément utilisée pour détecter et corriger les erreurs consiste
à recourir à un code correcteur d'erreurs (en anglais _Error Correcting Code_, abrégé _ECC_).
Cette méthode permet de corriger la majorité des _soft errors_.

=== Mémoire ECC <ecc_memory>

De nos jours, les mémoires de type _DRAM_ (_Dynamic Random Access Memory_) sont
massivement utilisées comme mémoire principale aussi bien sur les serveurs que
les ordinateurs personnels. Certaines barrettes sont dotées d'une puce
mémoire supplémentaire permettant l'utilisation d'un code correcteur.
Ce type de mémoire nécessite une prise en charge par le contrôleur mémoire, le
CPU et le BIOS. Si cette prise en charge est rare sur le matériel grand public,
elle est en revanche commune sur celui dédié aux serveurs.

=== Scrubbing <scrubbing>

Les mémoires _ECC_ décrites en @ecc_memory permettent de corriger automatiquement
les erreurs à la lecture. Toutefois certaines données peuvent restées en
mémoire longtemps sans être accédées. On peut par exemple penser aux
enregistrements d'une base de donnée que l'on souhaite maintenir dans la
mémoire principale pour en accélérer l'accès. Les _soft errors_ peuvent
alors s'y accumuler au point que le code correcteur ne permette plus leur correction.
Pour pallier ce problème, on a recours au _scrubbing_. Il en existe de deux types:
- #box[Le _demand scrubbing_ permet à l'utilisateur de déclencher manuellement le
nettoyage d'une plage mémoire.]
- #box[Le _patrol scrubbing_ qui consiste à scanner périodiquement la mémoire
pour détecter et corriger les erreurs régulièrement.]

=== Interfaces matérielles

Bien qu'aucun pilote spécifique ne soit requis pour les mémoires _ECC_, certains
systèmes d'exploitation permettent de les piloter via des interfaces matérielles
spécifiques. Ces interfaces permettent notamment de:
- #box[Désactiver le _scrubbing_ lorsque cela pose des soucis de performance,]
- #box[Changer le taux de balayage du _patrol scrubbing_,]
- #box[Notifier et journaliser les _soft errors_ et les _hard errors_,
permettant ainsi aux logiciels de réagir,]
- #box[Spécifier une plage d'adresses pour le _demand scrubbing_.]
Il existent de nombreuses interfaces matérielles. Le tableau comparatif suivant liste
quelques unes d'entre elles ainsi que leurs caractéristiques clés.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, left, left, left),
    [Nom], [Demand scrubbing],[Plage d'adresses],  [Patrol scrubbing], [Taux de balayage],
    [ACPI ARS], [Oui], [Oui], [Non], [Non],
    [ACPI RAS2], [Oui], [Oui], [Oui], [Oui],
    [CXL Patrol Scrub], [Non], [Non], [Oui], [Oui],
    [CXL ECS], [Non], [Non], [Oui], [Non],
  ),
  caption: [Interfaces de pilotage pour le _scrubbing_],
) <scrubbing_interfaces>

== Profilage <profiling>

Le profilage est une technique utilisée pour mesurer et analyser les performances
d'un programme. Elle est souvent employée à des fins d'optimisation en
permettant de localiser des points chauds, c'est-à-dire des sections de code
particulièrement gourmandes en ressources (temps CPU, mémoire, ...). Toute mesure
ayant un impact sur les caractéristiques de l'objet mesuré, il est crucial que
cette instrumentation soit faite de la façon la moins intrusive possible.
Autrement, on risque de mesurer les performances de son outil de profilage
plutôt que ceux du programme étudié.

À cette fin, certains outils utilie une approche statistique. Au lieu
d'enregistrer tous les événements possibles lors de l'exécution du programme,
on n'effectue un échantillonnage de ces mesures en espérant que les échantillons
collectés seront représentatifs des caractéristiques de performances du programme
étudié.




#glossary(
  title: "Glossaire",
  sort: true,
  ignore-case: false,
)

#bibliography("references.bib")
