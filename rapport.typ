#import "@preview/hydra:0.6.2": hydra
#set text(lang: "fr")
#set par(justify: true)

#page(margin: (left: 2in))[
  #align(horizon + left)[
    #line(start: (0%, 5%), end: (8.5in, 5%), stroke: (thickness: 2pt))
    #text(
      size: 20pt,
      [Étude comparative de systèmes d'exploitations dans un
      contexte critique ou temps-réel]
    )

  ]

  #align(bottom + left)[#datetime.today().display()]
]

#set page(paper: "a4", margin: (y: 4em), numbering: "1", header: context {
  if calc.odd(here().page()) {
    align(right, emph(hydra(1)))
  } else {
    align(left, emph(hydra(2)))
  }
  line(length: 100%)
})

#set heading(numbering: "1.1", supplement: [])

#let definition(t) = {
  text(style: "oblique", weight: "semibold")[#t]
}

#show raw.where(block: true): code => {
  show raw.line: line => {
    text(fill: gray)[#line.number]
    h(1em)
    line.body
  }
  code
}

#let snippet(file, lang:none) = {
  box(
    stroke: 1pt + black,
    fill: luma(250),
    radius: 4pt,
    pad(
      left: 10pt,
      right: 16pt,
      top: 10pt,
      bottom: 10pt,
      raw(read(file), block:true, lang:lang),
    )
  )
}

#outline(depth: 1)


= Introduction <introduction>

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
instructions. A contrario, les logiciels applicatifs s'exécutent en mode
utilisateur (_user mode_) et interagissent avec l'OS lorsqu'ils ont besoin
d'accéder au matériel.

Ce document est une étude comparative de plusieurs systèmes d'exploitation dans
le contexte de systèmes critiques ou temps réels. Afin de mieux cerner le sujet,
commençons par préciser ces deux termes.

Un système est dit #definition[critique] si sa défaillance peut entraîner des
conséquences indésirables. Cela peut aller de la simple perte de données à la
destruction matérielle, voire, dans les cas les plus graves, à la perte de
vies humaines. La criticité d'un système est généralement évalué lors de sa
conception et le choix d'une solutions informatique adaptée en est une
étape importante, étant donné leur omniprésence dans les appareils modernes.

Un système informatique est dit #definition[temps-réel] lorsque celui-ci est
capable de piloter un procédé physique à une vitesse adaptée à l'évolution de ce
dernier. Un tel système doit donc respecter des limites et contraintes temporelles.
Ils sont souvent présents dans des systèmes critiques.

== Systèmes d'exploitation étudiés
Dans ce document, nous classons les systèmes d'exploitation étudiés en quatre
grandes catégories:
- #box[Les #definition[systèmes d'exploitation généralistes]
(_GPOS_ pour _General-Purpose Operating System_) constituent la
classe la plus connue du grand public. Ils sont le plus souvent directement
exécutés au-dessus de la couche matérielle et offrent un large éventail de
services. Leur domaine d'application est particulièrement vaste puisqu'on les
retrouve aussi bien sur les ordinateurs personnels, les smartphones que les
serveurs et les systèmes embarqués. Parmi les systèmes les plus connus, on
peut citer _Linux_, _Windows_ et _macOS_. Vous trouverez davantage de détails
sur les _GPOS_ dans la section @type_gpos.]
- #box[Les #definition[hyperviseurs] sont des systèmes d'exploitation dédiés à
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

Il est important de noter que certains systèmes d'exploitations rentrent dans
plusieurs catégories. Dans ce document nous examinons les systèmes
d'exploitation suivants:
- Linux 6.15.2 (_GPOS_, _hyperviseur_ et _RTOS_)
- MirageOS 4.9.0 (_LibOS_)
- PikeOS 5.1.3 (_hyperviseur_, _RTOS_)
- ProvenVisor
- RTEMS 6.1 (_RTOS_)
- seL4 13.0.0
- Xen 4.20 (_hyperviseur_)
- XtratuM

Nous nous sommes efforcés de fournir des informations valables pour les
versions spécifiées ci-dessus. Les entreprises développant ProvenVisor et
XtratuM ne communiquent pas de numéros de version pour leurs systèmes
d'exploitation.

== Critères de comparaison

== Organisation de l'étude

L'étude est organisée suivant le plan suivant:
- #box[Le chapitre @general_notions contient des généralités sur les systèmes
d'exploitations et les interfaces matérielles. Les notions abordées sont ensuite
librement utilisée dans les chapitres ultérieurs.]
- #box[Les chapitres @linux, @mirageos, @pikeos, @provenvisor, @rtems, @sel4,
@xen, @xtratum exposent chacun des OS étudiés.]
- #box[Le chapitre @comp contient des tableaux comparatifs.]

= Notions générales <general_notions>

Cette section contient des notions générales autour des systèmes
d'exploitation et des interfaces matérielles pertinentes pour ce rapport. Ces
notions ne sont qu'effleurées étant donné d'une part la complexité des
architectures et des OS actuels, et d'autre part le foisonnement des solutions
existantes. Le lecteur intéressé par plus détails pourra lire les sources citées
au fil de la section.

== Partionnement des ressources

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
précisément à la détection et la correction de ces erreurs. On distingue
deux types d'erreurs:
- #box[Les _soft errors_ sont dues à un événement exceptionnel et transitoire qui
corrompt des données. Par exemple le rayonnement de fond peut produire un basculement
de bits (_bit flips_). Ces erreurs peuvent être souvent corrigées à condition
de mettre en places des mesures préventives.]
- #box[Les _hard errors_ sont dues à un dysfonctionnement matériel au niveau de la
puce mémoire. Ces erreurs ne peuvent pas être corrigées et nécessitent un remplaçant
de la puce ou, à défaut, une isolation de celle-ci.]

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
Pour pallier ce problème, on a recourt au _scrubbing_. Il en existe de deux types:
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

== Watchdog <watchdog>

Un chien de garde (_watchdog_) est un dispositif matériel ou logiciel conçu
pour détecter le blocage d'un système informatique, et de réagir
de manière autonome pour ramener ce système dans un état normal. Qu'il s'agisse
d'un dispositif matériel ou logiciel, le principe du watchdog consiste le plus
souvent à demander au système surveillé d'envoyer régulièrement un signal à
un système surveillant. Le système surveillé dispose d'une fenêtre de temps
pour cette action. S'il n'effectue pas la tâche dans le temps imparti, il est
présumé dysfonctionnel. Le système surveillant peut alors tenter de remédier
à la situation. Le plus souvent cela consiste à redémarrer la machine.

Les appareils embarqués et les serveurs à haute disponibilité ont souvent
recours aux _watchdogs_ pour améliorer leur fiabilité.

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

== Type de système d'exploitation

=== GPOS <type_gpos>

Les _GPOS_ peuvent d'être divisé en trois grandes catégories:
- Les noyaux monolithique.
- #box[Les micronoyaux: au contraire du noyau monolithique, le micronoyau se
concentre sur les opérations fondamentales qui ne peuvent être effectuée que
dans le _kernel space_. Il s'agit généralement de la gestion de la mémoire
et des processus. Toutes les autres tâches sont déléguées à des services s'exécutant
dans le _user space_. Un exemple notable de tel système est le micronoyau _L4_
développé au sein de l'université Karlsruhe. Ce projet visait à réduire les
écarts de performances entre les micronoyaux et les architectures monolithiques
de l'époque. Ce projet a servi de base à deux systèmes d'exploitations étudiés
dans ce rapport: _seL4_ et _PikeOS_.]
- #box[Les noyaux modulaires: ils constituent un intermédiaire entre les deux
designs précédents. Le noyau a la possibilité de charger ou décharger certaines
sous-systèmes de façon dynamique. C'est notamment le cas des pilotes.]

=== Hyperviseur <type_hypervisor>

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

=== RTOS <type_rtos>

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


= Linux <linux>

Le noyau _Linux_ est un système d'exploitation généraliste de type UNIX développé par une
communauté décentralisée de développeurs. Le projet est initié par Linus Torvalds
en 1991. De nos jours, il est utilisé sur une large gamme de matériels comme des
serveurs, des supercalculateurs, des systèmes embarqués et des ordinateurs personnels.
Originellement conçu comme un noyau monolithique, _Linux_ est devenu un noyau
modulaire à partir de la version `1.1.85` publiée en 1995. En plus d'être un
_GPOS_, _Linux_ intègre un hyperviseur et est depuis 2024 un _RTOS_.
Plus précisément:
- #box[Depuis la version `2.6.20` publiée 2007, _Linux_ intègre un hyperviseur
baptisé _KVM_ (_Kernel-based Virtual Machine_)  @linux_kvm_website. Il s'agit
d'un hyperviseur de type 1 assisté par le matériel. Il offre également un support
pour la paravirtualisation. Plus de détails sont donnés dans la section @linux_kvm.]
- #box[Depuis la version `6.12`, le noyau intègre les patchs _PREEMPT_RT_ qui lui confère
des fonctionnalités temps réel. Plus d'informations sont données dans la section
@linux_prempt_rt.]

De nombreuses entreprises contribuent également au noyau, notamment aux pilotes
(Intel, Google, Samsung, AMD, ...).

== KVM <linux_kvm>

== PREEMPT_RT <linux_prempt_rt>

Au tournant du #smallcaps[XXI]#super[e] siècle, des initiatives ont visées à doter
_Linux_ de capacités temps réel. Le noyau de l'époque ayant été
développé pour être le cœur d'un _GPOS_, les changements requis dans le
code source étaient considérés comme trop complexes, et des approches
alternatives ont émergées. L'une de ces approches consiste à contourner le
noyau _Linux_ en exécutant les tâches temps réel et le noyau _Linux_
directement au-dessus d'un micronoyau temps réel. On parle alors de
_cokernel_. Les projets open-sources _RTLinux_ et _RTAI_#footnote[Le projet est toujours
activement développé.] adoptèrent cette approche avec succès. L'avantage de celle-ci est
de donner d'excellentes garanties quant aux respects
des _deadlines_ et une latence faible. En contrepartie, le développeur d'applications
temps réel ne peut pas utiliser l'écosystème et les bibliothèques UNIX, rendant
le développement plus ardu et coûteux. Ce défaut majeur a motivé le développement
du projet _PREEMPT_RT_ par Ingo Molnár et d'autres développeurs du noyau _Linux_.
Contrairement aux _cokernels_, l'approche de _PREEMPT_RT_ consiste à modifier en
profondeur le noyau afin de le rendre préemptible. Le projet a débuté en 2005 et
s'est étalé sur une vingtaine d'années sous la forme d'une succession de patchs
qui ont progressivement été intégrés à la branche principale de _Linux_. Les dernières
intégrations ont été terminées en septembre 2024, faisant de _Linux_ un _RTOS_
complet.

La documentation de _PREEMPT_RT_: @preempt_rt_doc.

== Architectures supportées

Le noyau _Linux_ était dans un premier temps développé pour l'architecture _x86_.
Il a depuis été porté sur de très nombreuses architectures
@linux_arch. Il fonctionne notamment sur les architectures suivantes:
_x86-32_, _x86-64_, _ARM v7_, _ARM v8_, _PowerPC_, _MIPS_, _RISC-V_ et _SPARC_.

Quant à l'hyperviseur _KVM_, il nécessite un support matériel pour
l'hypervirtualisation. Sur architecture _x86_, il supporte _Intel VT-x_ et
_AMD-V_. Sur architecture _ARM_, il supporte l'architecture _ARM v7_ à partir
de _Cortex-A15_ et _ARMv8-A_. Enfin il supporte certaines architectures
_PowerPC_ comme _BookE_ et _Book3S_.

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
```sh
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
```sh
gcc -O0 limited.c -o limited
./limited
```
et dans une autre console, on ajoute le processus au cgroup `bar`:
```sh
pgrep limited | sudo tee /sys/fs/cgroup/foo/bar/cgroup.procs
```
Finalement, on demande plus de mémoire que la limite autorisée et le processus
est tué:
```console
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
l'utilisation des _namespaces_. Il consistue une alternative à `chroot` plus sûre.
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
```
░ Spawning container foo on /foo.
░ Press Ctrl-] three times within 1s to kill container.
My pid: 1
1
Container foo exited successfully.
```
révélant que `alone` est le seul processus visible dans le conteneur `foo` et
qu'il a le PID 1.

== Corruption de la mémoire <linux_memory_corruption>

Le noyau _Linux_ intègre un sous-système nommé _EDAC_ (_Error Detection and Correction_)
@linux_edac qui permet la journalisation des erreurs mémoires. La journalisation s'effectue
grâce au démon _rasdaemon_.

Certains processeurs AMD nécessitent l'utilisation d'un pilote pour que _EDAC_
fonctionne.

Le noyau fournit également une interface logicielle commune @linux_scrub via _sysfs_#footnote[
Le système de fichiers _sysfs_ est un pseudo système de fichiers disponible sous Linux. Il permet
aux logiciels tournant dans le _user space_ de lire et de modifier des paramètres des pilotes et
des périphériques via des fichiers. Il est généralement monté dans le dossier _/sys_.]
pour les interfaces de pilotage du scrubbing décrites dans le @scrubbing_interfaces,
à l'exception de l'interface _ARS_ qui utilise son propre pilote.

== Perte du flux d'exécution

== Monitoring <linux_monitoring>

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

=== _perf_ <linux_perf>
Depuis sa version 2.6.31, _Linux_ intègre un outil puissant de profilage
dénommé _perf_ @perf_wiki. À l'origine _perf_ permettait de tracer l'activité
du _CPU_ via des compteurs _PMU_
#footnote[Les compteurs _PMU_ pour _Performance Monitoring Unit_
sont des registres matériels intégrés dans les microprocesseurs modernes. Ils
permettent de compter des événements bas niveau.].
Depuis, ses fonctionnalités ont été considérablement
étendues et il permet maintenant d'instrumenter aussi bien le noyau que
les programmes exécutés dans l'espace utilisateur. Dans cette section, nous
allons voir trois méthodes d'instrumentation: les _tracepoints_,
les _kprobes_ et les _uprobes_.

==== PMU <linux_perf_pmu>

Examinons les performances de notre programme @miss_source à l'aide de la
sous-commande `perf stat`. Cette dernière retourne des statistiques issues
des registres _PMU_ du processeur. En lançant `perf stat ./miss`, on obtient
la sortie:
```
Performance counter stats for './miss':

       116.46 msec task-clock:u                     #    0.991 CPUs utilized
            0      context-switches:u               #    0.000 /sec
            0      cpu-migrations:u                 #    0.000 /sec
        1,028      page-faults:u                    #    8.827 K/sec
  270,371,076      cycles:u                         #    2.322 GHz
1,100,144,340      instructions:u                   #    4.07  insn per cycle
  100,029,819      branches:u                       #  858.891 M/sec
        2,352      branch-misses:u                  #    0.00% of all branches
                   TopdownL1                 #     25.1 %  tma_backend_bound
                                             #      1.2 %  tma_bad_speculation
                                             #      0.2 %  tma_frontend_bound
                                             #     73.6 %  tma_retiring

  0.117552543 seconds time elapsed

  0.113162000 seconds user
  0.003969000 seconds sys
```
Tandis que parcourir le tableau `arr` dans un ordre aléatoire conduit à un
résultat très différent en terme de performance. En effet la commande
`perf stat ./miss random` donne la sortie:
```
Performance counter stats for './miss random':

     1,974.28 msec task-clock:u                     #    0.999 CPUs utilized
            0      context-switches:u               #    0.000 /sec
            0      cpu-migrations:u                 #    0.000 /sec
        2,003      page-faults:u                    #    1.015 K/sec
5,945,316,708      cycles:u                         #    3.011 GHz
7,896,922,743      instructions:u                   #    1.33  insn per cycle
1,600,032,861      branches:u                       #  810.440 M/sec
    3,229,770      branch-misses:u                  #    0.20% of all branches
                   TopdownL1                 #     60.4 %  tma_backend_bound
                                             #      2.7 %  tma_bad_speculation
                                             #      2.8 %  tma_frontend_bound
                                             #     34.1 %  tma_retiring

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

=== _oprofile_ <linux_oprofile>

Le logiciel _oprofile_ est un profileur de performance à l'échelle du système
_Linux_ entier. Il utilise les compteurs _PMU_ du processeur pour collecter
les événements.

```console
sudo opcontrol --start --event=CPU_CYCLES
```

```console
sudo opcontrol --reset
```

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

== Licences & brevets

Le noyau `Linux` est un logiciel libre distribué sous licence `GPL-2.0` avec
l'exception _syscall_ qui stipule qu'un logiciel utilisant le noyau `Linux` au
travers des appels systèmes n'est pas considéré comme une œuvre dérivée et
peut être distribué sous une licence qui n'est pas compatible avec la GPL,
y compris une licence propriétaire. Plus d'informations sont disponibles dans
le dossier `LICENSES` des sources du noyau `Linux`.

= MirageOS <mirageos>

_MirageOS_ est un _unikernel_ open-source conçu pour les applications réseaux.
Il est utilisé aussi bien sur des machines embarquées que dans le _cloud computing_.
Le projet, lancé en 2009, est activement développé par la _MirageOS Core Team_.
Cette équipe est composée d'employés du secteur privé et d'universitaires.

En tant qu'_unikernel_, _MirageOS_ cherche à produire des exécutables de petite
taille et avec une empreinte mémoire minimale. Il offre également des temps de
démarrage réduit.

== Environnement <mirageos_environnement>

Les _unikernels_ produits par _MirageOS_ peuvent aussi bien tourner sur un
hyperviseur, un _UNIX_ ou même dans un environnement _bare-metal_.

=== Hyperviseurs supportés <mirageos_hypervisors>

_Xen_, _KVM_, _bhyve_, _VMM_.

=== UNIX <mirageos_unix>

=== Bare-metal <mirageos_bare_metal>

== Architectures supportées <mirageos_architectures>

=== Support multi-cœur
Le support multi-cœur de _MirageOS_ dépend de la version d'OCaml utilisée:
- #box[En OCaml 4, il n'est pas possible de tirer parti nativement du parallélisme
offert par un processeur multi-cœur du fait de limitations du runtime OCaml.
Lorsqu'on souhaite uniquement entrelacer des files d'exécution, on peut utiliser
des threads coopératifs notamment avec la bibliothèque OCaml Lwt. Si le
parallèlisme est nécessaire, une solution est d'exécuter plusieurs unikernels
sur des cœurs différents. C'est notamment possible sur l'hyperviseur _Xen_ grâce
à des canaux de communication entre machines virtuelles appelés _Xen vchan_
@vchan_low_latency.]
- #box[En OCaml 5, Le projet _multi-core_ @retrofitting_parallelism a introduit le
concept de _domain_ dans le langage OCaml et permet exécution de code OCaml
sur plusieurs cœurs en parallèle.]

== Watchdog <mirageos_watchdog>

== Licences & brevets <mirageos_licenses>

Le code de MirageOS est publié sous la licence `ISC` avec certaines parties
sous licence `LGPLv2`. L'utilisation d'une licence open-source permissive comme
`ISC` est nécessaire car en tant qu'_unikernel_, les bibliothèques de _MirageOS_
doivent être liés statiquement avec le logiciel applicatif pour former l'image
qui sera mise en production.

= PikeOS <pikeos>

_PikeOS_ est un _RTOS_ et un hyperviseur de type 1 développé par l'entreprise
_SYSGO_ depuis 2005. En 2012, l'entreprise _SYSGO_ est rachetée par _Thalès_.
À l'origine _PikeOS_ était basé sur le micronoyau _L4_#footnote[Voir la section
@type_gpos pour plus d'informations sur le micronoyau _L4_.].

Dès sa conception, _PikeOS_ a été pensé pour faciliter la certification de
logiciels. Les différents kit de certifications disponibles sont exposés dans la
section @pikeos_licenses.

== Architectures supportées <pikeos_architectures>

_PikeOS_ supporte les architectures suivantes: _x86-64_, _ARM v7_, _ARM v8_,
_PowerPC_, _RISC-V_ et _SPARC_.

Le support matériel se fait via des _BSP_ (_Board Support Package_). Il est
également possible de financer le développement de nouveaux _BSP_.

== Partitionnement

Son hyperviseur permet à la fois la paravirtualisation et la virtualisation
de type _HVM_.

== Licenses & brevets <pikeos_licenses>

La société SYSGO propose deux types de licences propriétaires:
- #box[Une licence de développement permettant de concevoir des systèmes basés
sur _PikeOS_.]
- Une licence de déploiement.

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

= ProvenVisor <provenvisor>

== Licences & brevets <provenvisor_licenses>

- Permet la certification critères communs EAL5


= RTEMS <rtems>

== Architectures supportées <rtems_architectures>

_RTEMS_ supporte les architectures suivantes @rtems_licenses_website:
_x86-32_, _x86-64_, _ARM v7_, _ARM v8_, _PowerPC_, _MIPS_, _RISC-V_ et _SPARC_.

== Watchdog <rtems_watchdog>

_RTEMS_ ne fournit pas d'API unifié pour gérer les _watchdogs_ matériels.
Le support est implémenté au niveau du _BSP_ (_Board Support Package_).

Il est possible d'implémenter un _watchdog_ logiciel via le _Timer Manager_.
Plus précisément, on peut mettre en place un timer avec la fonction
`rtems_timer_fire_after`.

== Licences & brevets <rtems_licenses>

`RTEMS` est un logiciel libre distribué sous une multitude de licences libres
et open-sources. Le noyau peut utiliser ou être lié avec des programmes sous
n'importe quelle licence @rtems_licenses_website.

= seL4 <sel4>

== Licences & brevets <sel4_licenses>

Le noyau de `seL4` est un logiciel libre distribué principalement sous licence
`GNU General Public License version 2 only (GPL-2.0)`. Le code utilisateur et
les pilotes peuvent être distribués sous n'importe quelle licence @sel4_licensing.

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
#link("https://xenproject.org")[Xen Project]. Il offre à la fois des fonctionnalités
de _paravirtualisation_ et de _HVM_.

== Architectures supportées

L'hyperviseur _Xen_ supporte les architectures suivantes: _x86-32_, _x86-64_,
_ARM v7_ et _ARM v8_.

Il existe également un projet pour supporter _Xen_ sur _PowerPC_ mais il n'est plus
activement maintenu.

Il existe un projet pour le support de _RISC-V_.

=== Support multi-cœur
_Xen_ supporte les architectures multi-cœur. L'hyperviseur offre la possibilité
d'allouer les cœurs à certains systèmes invités grâce au concept de _virtual CPU_.

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

== Partitionnement

=== Domaines

_Xen_ utilise le terme de _domaine_ pour qualifier les conteneurs des machines
virtuelles en cours d'exécution. Il existe deux types de domaines:
- #box[Le domaine 0 (abrégé _dom0_) désigne un domaine privilégié qui est automatiquement
lancé au démarrage de l'hyperviseur. Le système d'exploitation hôte est généralement
une distribution _Linux_ modifiée (voir la section @xen_os).]
- #box[Les domaines utilisateurs (abrégé _domU_) sont les domaines qui contiennent les
OS invités. Il existe deux types de tels domaines. Les domaines de paravirtualisation
et les domaines _HVM_.]

=== Driver domain <xen_driver_domain>

Un _driver domain_ est un domaine utilisateur de _Xen_ qui a pour responsabilité de
gérer un périphérique. Il exécute un noyau minimal avec uniquement le pilote pour
ce périphérique. Ainsi, si le pilote plante, les autres domaines et en particulier
_dom0_ continuent de fonctionner tandis que le _driver domain_ peut être relancé.

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

== Watchdog <xen_watchdog>

_Xen_ permet la mise en place d'un _watchdog_ dans _dom0_ ou dans des domaines
utilisateurs. L'exemple ci-dessous met en place un _watchdog_ qui doit être
réinitialisé d'en un laps de temps de 30 secondes:
#figure(
  snippet("./xen/watchdog.c", lang:"c"),
  caption: [Exemple d'interaction avec un _watchdog_ sous _Xen_.]
)

Pour compiler et lancer le programme dans le domaine utilisateur, tapez:
```console
gcc watchdog.c -o watchdog $(pkg-config --cflags --libs xencontrol)
./watchdog
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

_Linux_ dispose d'un pilote _xen_wdt_ pour le _watchdog_ virtuel de _Xen_ qui
implèmente l'API décrit dans la section @linux_watchdog_api.

== Licences & brevets <xen_licenses>

L'hyperviseur `Xen` est un logiciel libre distribué principalement sous licence
`GPL-2.0`. Certaines parties du projet sont distribués sous des licences libres
plus permissives afin de pas contraindre les licences des logiciels
utilisateurs @xen_licensing.

= Xtratum <xtratum>

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
  align: left + horizon,
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
Dans cette étude nous nous focalisons sur les architectures de processeur utilisées
dans l'embarqué critique. Nous avons retenus les architectures suivantes:
- L'architecture 32bits `ARMv7`.
- L'architecture 64bits `ARMv8` qui propose deux modes d'exécution:
  - `Aarch32` permettant l'exécution de programme compilé vers le jeu d'instructions de l'architecture `ARMv7`.
  - `Aarch64` le mode d'exécution 64bits.
- L'architecture 32bits `x86-32`.
- L'architecture 64bits `x86-64`.
- `PowerPC`
- `MIPS`
- `RISC-V`
- `SPARC`

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

= Temps de démarrage

= Mécanisme de détection ou de tolérance aux pannes

== Partionnement temps et/ou mémoire

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

L'unikernel est capable de contrôler les interruptions matérielles via le méchanisme
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
un méchanisme abstrait appelé _Event channel_. Il est alors possible de masquer certains
événements via un champ _evtchn_mask_ @xen_event_channel_internals.

== Monitoring & profiling

#bibliography("references.bib")
