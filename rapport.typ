#import "@preview/hydra:0.6.2": hydra
#set text(lang: "fr")
#set par(justify: true)

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
  text(weight: "bold")[#t]
}

= Introduction

Un #definition[système d'exploitation]#footnote[On parle d'_Operating System_
en anglais, abrégé _OS_. On utilisera cette abréviation à notre convenance.]
est un ensemble de routines et de bibliothèques gérant les ressources
matérielles d'un système informatique (ordinateurs de bureau, serveurs,
systèmes embarqués, ...). Son objectif est de fournir une couche d'abstraction
logicielle entre les interfaces matérielles et les logiciels applicatifs.
Les systèmes d'exploitation se distinguent aussi bien par les mécanismes d'abstraction
qu'ils offrent, que leur organisation ou leur modularité. Ainsi, certaines tâches
gérées par un OS peuvent être, dans une autre configuration, déléguées à une autre
couche logicielle, voire au matériel. Il est donc difficile de caractériser
rigoureusement ce qu'est un système d'exploitation autrement que par le fait qu'il
s'exécute en #definition[mode noyau]#footnote[Le mode noyau (_kernel mode_ en anglais) est
un mode d'exécution privilégié donnant accès à l'ensemble de la mémoire et à l'exécution d'instructions habituellement interdites aux logiciels applicatifs. A contrario, les logiciels applicatifs s'exécute en mode utilisateur (_user mode_ en anglais).].
Dans ce document, nous étudions trois grandes classes de systèmes d'exploitation:
- #box[Les #definition[systèmes d'exploitation généralistes]#footnote[On parle parfois
de _GPOS_ en anglais pour _General-Purpose Operating System_] constituent la
classe la plus connue du grand public. Ils sont le plus souvent directement
exécutés au-dessus de la couche matérielle et offrent un large éventail de
services. Leur domaine d'application est vaste et on les retrouve aussi bien sur
les ordinateurs personnels, les smartphones que les serveurs et les systèmes embarqués.
Parmi les plus connus, on peut citer _Linux_, _Windows_ et _macOS_.]
- #box[Les #definition[hyperviseurs] sont des systèmes d'exploitation dédiés à la
virtualisation, c'est-à-dire à l'exécution d'OS invités au-dessus d'une couche
logicielle. Ils sont souvent utilisés pour exécuter simultanément plusieurs OS invités,
notamment sur des serveurs. Parmi les plus utilisés, on peut citer
_VMware vSphere_, _Hyper-V_, _KVM_, VirtualBox, QEMU, ...]
- #box[Les #definition[unikernel] sont des OS se présentent sous la forme d'une
collection de bibliothèques. Le développeur sélectionne les modules indispensables
à l'exécution de son logiciel applicatif, puis crée une image en liant son
programme à l'unikernel. Cette image peut ensuite être exécutée sur un hyperviseur
ou en #definition[bare-metal]#footnote[C'est-à-dire directement
sur la couche matérielle sans l'intermédiaire d'un système d'exploitation.].]

== Systèmes d'exploitation étudiés
Dans ce document nous examinons les systèmes d'exploitation suivants:
- KVM (intégré dans Linux)
- Linux 6.15.2
- MirageOS 4.9.0
- PikeOS 5.1.3
- ProvenVisor (version non communiqué)
- RTEMS 6.1
- seL4 13.0.0
- Xen 4.20
- XtratuM (version non communiqué)

Nous nous sommes efforcés de fournir des informations valables pour les
versions spécifiées ci-dessus. Les entreprises développant `ProvenVisor` et
`XtratuM` ne communiquent pas de numéros de version pour leurs systèmes
d'exploitation.

== Organisation de l'étude

Les systèmes étudiés étant très différents, ils nous a semblait pertinent de
diviser certaines sections de l'étude suivant le type de système d'exploitation.

= Notions générales

Cette section contient des notions générales autour des systèmes
d'exploitation et des interfaces matérielles pertinentes pour ce rapport. Ces
notions ne sont qu'effleurées étant donné d'une part la complexité des
architectures et des OS actuels, et d'autre part le foisonnement des solutions
existantes. Le lecteur intéressé par plus détails pourra lire les sources citées
au fil de la section.

== Type de système d'exploitation

=== GPOS

Les _GPOS_ peuvent d'être divisé en trois grandes catégories:
- Les noyaux monolithique.
- #box[Les micro-noyaux: au contraire du noyau monolithique, le micro-noyau se
concentre sur les opérations fondamentales qui ne peuvent être effectuée que
dans le _kernel space_. Il s'agit généralement de la gestion de la mémoire
et des processus. Toutes les autres tâches sont déléguées à des services s'exécutant
dans le _user space_.]
- #box[Les noyaux modulaires: ils constituent un intermédiaire entre les deux designs
précédents. Le noyau a la possibilité de charger ou décharger certaines sous-systèmes de
façon dynamique. C'est notamment le cas des pilotes.]

=== Hyperviseur

Les _hyperviseurs_ se divisent généralement en deux catégories:
- #box[Les _hyperviseurs de type 1_ s'installent directement sur la couche
matérielle.]
- #box[Les _hyperviseurs de type 2_ nécessitent une couche logicielle
intermédiaire entre eux et la couche matérielle. Nous n'étudions pas de tels
OS dans ce document.]

La _virtualisation totale_ (_full virtualization_ en anglais) consiste à émuler
le comportement de la couche matérielle en exposant la même interface aux systèmes
invités. Cette méthode permet d'exécuter n'importe quel logiciel qui aurait pu être
lancé sur cette couche matérielle. On distingue deux sous-types de virtualisation totale:
- la translation binaire (_binary translation_ en anglais)
- la virtualisation assistée par le matériel (_hardware-assisted virtualization_)

La _paravirtualisation_ est une technique de virtualisation qui consiste à
présenter une interface logicielle similaire au matériel mais optimisée pour
la virtualisation. Cette technique nécessite à la fois un support de l'hyperviseur
et du système d'exploitation invité. En contre partie, la paravirtualisation
permet généralement d'obtenir de meilleures performances.

=== Temps réel

Un système temps réel est un système informatique offrant des garanties
sur le temps d'exécution de tâches critiques. Les contraintes temporelles sont
d'autant plus difficile à garantir que le système est multi-tâche. Un système
d'exploitation offrant de telles garanties est appelé un RTOS
(_Real Time Operating System_).

== Partionnement des ressources

Le partitionnement des ressources est un mécanisme fondamental
des systèmes d'exploitation modernes. Il vise à permettre l'exécution simultanée
de plusieurs tâche sur une même machine physique. On parle alors de système
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

Le partitionnement en mémoire vise à partager la mémoire principale entre plusieurs
tâches en cours d'exécution. Ce partage est crucial car il permet de conserver en mémoire
tout ou une partie des données de plusieurs processus, améliorant les performances
du système.

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

Les systèmes d'exploitation permettent l'exécution de programmes dans un contexte
multi-tâches. Cette exécution peut être #definition[concurrentielle] ou
#definition[parallèle]. Afin que cett

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
_I/O APIC_#footnote[_APIC_ est un abbréviation pour _Advanced Programmable Interrupt Controller_]
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
(_Advanced Programmable Interruption Controller_). Sur les architectures ARM, elle
est dévolue au _GIC_ (_Generic Interrupt Controller_).

Les processeurs multi-cœur disposent aussi de puce _APIC_ par cœur, permettant la gestion
des interruptions entre cœurs (_Inter-Processor Interrupt_ IPI).

Les contrôleurs d'interruption permettent également de mettre des niveaux de priorité
sur les interruptions.

== Corruption de la mémoire

Dans cette section, on s'intéresse à la corruption de la mémoire et plus
précisément à la détection et la correction de ces erreurs. On distingue
de type d'erreurs:
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
Ce type de mémoire nécessite une prise en charge par le contrôleur mémoire, le CPU
et le BIOS. Si cette prise en charge est rare sur le matériel
grand public, elle est en revanche commune sur celui dédié aux serveurs.

=== Scrubbing

Les mémoires _ECC_ décrites en @ecc_memory permettent de corriger automatiquement
les erreurs à la lecture. Toutefois certaines données
peuvent restées en mémoire longtemps sans être accédées. On peut par exemple
penser aux enregistrements d'une base de donnée que l'on souhaite maintenir
dans la mémoire principale pour en accélérer l'accès. Les _soft errors_ peuvent
alors s'y accumuler au point que le code correcteur ne permette plus leur correction.
Pour pallier ce problème, on a recourt au _scrubbing_. Il en existe de deux types:
- #box[Le _demand scrubbing_ permet à l'utilisateur de déclencher manuellement le
nettoyage d'une plage mémoire.]
- #box[Le _patrol scrubbing_ qui consiste à scanner périodiquement la mémoire
pour détecter et corriger les erreurs régulièrement.]

=== Interfaces matérielles

Bien qu'aucun pilote spécifique ne soit requis pour les mémoires _ECC_, certains
systèmes d'exploitation permettent de les piloter via des interfaces matérielles spécifiques.
Ces interfaces permettent notamment de:
- #box[Désactiver le _scrubbing_ lorsque cela pose des soucis de performance,]
- #box[Changer le taux de balayage du _patrol scrubbing_,]
- #box[Notifier et journaliser les _soft errors_ et les _hard errors_, permettant ainsi
aux logiciels de réagir,]
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

== Watchdog

Un chien de garde, en anglais _watchdog_, est un dispositif matériel ou logiciel
permettant de détecter qu'un système informatique est bloqué de façon
anormale et de réagir en conséquence (désactivation du système, redémarrage, ...).
Qu'il s'agisse d'un dispositif matériel ou logiciel, le principe du watchdog consiste
le plus souvent à demander au système surveillé de mettre à jour régulièrement un compteur.
Le système surveillé dispose d'une fenêtre de temps pour cette action et s'il n'effectue
pas la tâche dans le temps imparti, il est présumé dysfonctionnel. Le système peut alors
tenter de remédier à la situation.

= Linux

Le noyau _Linux_ est un système d'exploitation généraliste de type UNIX développé par une
communauté décentralisée de développeurs. Le projet est initié par Linus Torvalds
en 1991. De nos jours, il est utilisé sur une large gamme de matériels comme des
serveurs, des supercalculateurs, des systèmes embarqués et des ordinateurs personnels.
Originellement conçu comme un noyau monolithique, _Linux_ est devenu un noyau
modulaire à partir de la version `1.1.85` publiée en 1995.

En plus d'être un _GPOS_, _Linux_ intègre un hyperviseur et est depuis récemment
un _RTOS_. Plus précisément:
- #box[Depuis la version `2.6.20` publiée 2007, _Linux_ intègre un hyperviseur baptisé
_KVM_ (_Kernel-based Virtual Machine_)  @linux_kvm. Il s'agit d'un hyperviseur de type 1
assisté par le matériel. Il offre également un support pour la paravirtualisation.]
- #box[Depuis la version `v6.12`, le noyau intègre les patchs _PREEMPT_RT_ qui lui confère
des fonctionnalités temps réel.]

Ces deux aspects importants seront abordés respectivement dans les sections @kvm et @prempt_rt.

== Architectures supportées

Le noyau _Linux_ était dans un premier temps développé uniquement pour l'architecture _x86_.
Il a depuis été porté sur de très nombreuses architectures @linux_arch. Il fonctionne notamment
sur les architectures suivantes: _x86-32_, _x86-64_, _ARM v7_, _ARM v8_, _PowerPC_, _MIPS_,
_RISC-V_ et _SPARC_.

Quant à l'hyperviseur _KVM_, il nécessite un support matériel pour l'hypervirtualisation.
Sur architecture _x86_, il supporte _Intel VT-x_ et _AMD-V_. Sur architecture _ARM_,
il supporte l'architecture _ARM v7_ à partir de _Cortex-A15_ et _ARMv8-A_. Enfin
il supporte certaines architectures _PowerPC_ comme _BookE_ et _Book3S_.

== Partitionnement <linux_partitioning>

=== Les _control croups_

Les _control groups_ (abrégé _cgroups_) sont un mécanisme permettant d'organiser
les processus de manière hiérarchique et de répartir les ressources du système de façon
contrôlée et configurable suivant cette hiérarchie. Notez qu'il existe deux versions
de ce mécanisme dans le noyau actuel:
- #box[La version `v1` qui a été introduite en 2008 dans le noyau _Linux 2.6.24_,]
- #box[La version `v2` est une refonte complète de la première version introduite dans le noyau
_Linux 4.5_ publié en 2016. C'est aujourd'hui la version recommandée.]
Dans cette section, nous ne décrivons que le fonctionnement de la version `v2`. Le lecteur
intéressé par la première version de l'API pourra se référer à documentation @linux_cgroups_v1.

Les _cgroups_ forment une structure arborescente et chaque processus appartient à exactement
un _cgroup_. Les _threads systèmes_ appartiennent toujours au _cgroup_ de leur processus.
À leur création, les processus héritent du _cgroup_ de leur parent mais ils peuvent migrer
vers un autre _cgroup_ s'ils ont les privilèges adéquates. Cette migration n'affecte pas leurs
enfants mais seulement ceux qui seront créés après celle-ci.

Les principaux contrôleurs de _cgroups_ sont:
- `cpu`: gère l'accès au temps de traitement du processeur.
- `memory`: contrôle l'utilisation de la mémoire vive et de la mémoire d'échange.
- `io`: gère les opérations d'entrée/sortie sur les périphériques de stockage.
- `pids`: limite le nombre de processus et de threads.
- `cpuset`: affecte un groupe de processus à des cœurs CPU spécifiques.
- `hugetlb`: contrôle l'utilisation des "huge pages".

Plus d'informations sur les _cgroups_ sont disponibles dans la documentation officielle @linux_cgroups_v2.

=== Les namespaces <linux_namespaces>

== Corruption de la mémoire <linux_memory_corrupt>

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

== KVM <kvm>

== PREMPT_RT <prempt_rt>

== Licences & brevets

Le noyau `Linux` est un logiciel libre distribué sous licence `GPL-2.0` avec
l'exception _syscall_ qui stipule qu'un logiciel utilisant le noyau `Linux` au
travers des appels systèmes n'est pas considéré comme une œuvre dérivée et
peut être distribué sous une licence qui n'est pas compatible avec la GPL,
y compris une licence propriétaire. Plus d'informations sont disponibles dans
le dossier `LICENSES` des sources du noyau `Linux`.

= Xen

_Xen_ est un hyperviseur de type 1 développé par le consortium d'entreprises
#link("https://xenproject.org")[Xen Project]. Il s'agit à la fois d'un paravirtualisateur
et d'un hyperviseur assisté par le matériel.

== Architectures supportées

L'hyperviseur _Xen_ supporte les architectures suivantes: _x86-32_, _x86-64_,
_ARM v7_ et _ARM v8_.

Il existe également un projet pour supporter _Xen_ sur _PowerPC_ mais il n'est plus
activement maintenu.

Il existe un projet pour le support de _RISC-V_.

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

== OS supportés <xen_os>

_Xen_ étant un paravirtualisateur, il nécessite un support
spécifique des OS invités, que ce soit pour les _VM_ s'exécutant dans le domaine privilégié _dom0_
ou les _VM_ s'exécutant dans les domaines _domU_. Pour le domaine _dom0_, il offre un support pour
de nombreuses distributions _GNU/Linux_ (voir @xen_gnu_linux_supported) ainsi que quelques autres
noyaux de type _UNIX_ (voir @xen_unix_supported). Plus d'informations sont disponibles @xen_os_supported. Pour le domaine _domU_, _Xen_ offre aussi un large support pour les OS invités
@domU_support_for_xen.

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

== Corruption de la mémoire

L'hyperviseur _Xen_ ne dispose pas d'un système de journalisation des erreurs mémoires.
En revanche, il transmet ces erreurs au système d'exploitation exécuté dans le domaine
privilégié _Dom0_. Il est alors possible d'utiliser les outils livrés avec ce système pour
journaliser ces erreurs. Il est par exemple possible d'exécuter un noyau _Linux_
dans le domaine _Dom0_ et d'utiliser ces fonctionnalités de pilotage de la mémoire _ECC_
décrites en section @linux_memory_corrupt.

== Licences & brevets

L'hyperviseur `Xen` est un logiciel libre distribué principalement sous licence
`GPL-2.0`. Certaines parties du projet sont distribués sous des licences libres
plus permissives afin de pas contraindre les licences des logiciels
utilisateurs @xen_licensing.

= OS généralistes

Leurs noyaux se répartissent en deux catégories:
- #box[Les _noyaux monolithiques_ qui se caractérisent pas le fait que la majorité
de leurs services s'exécutent en _mode noyau_.]
- #box[Les _micro-noyaux_ qui n'exécutent que le strict nécessaire en espace
noyau, à savoir l'ordonnancement des processus, la communication
inter-processus et la gestion de la mémoire.]

= Hyperviseurs
= Unikernels

= Types de système d'exploitation

Les systèmes d'exploitation se distinguent par les mécanismes d'abstraction
qu'ils offrent, leur organisation et leur modularité.
Certaines tâches gérées par un noyau peuvent être dans une configuration
différente déléguées à une autre couche logicielle, voire au matériel. Nous
proposons dans cette section une classification en trois catégories: les
_unikernels_, les _hyperviseurs_ et les _OS classiques_.

== Les unikernels

Les _unikernel_ sont des systèmes d'exploitation qui se présentent sous la
forme d'une collection de bibliothèques. Le développeur sélectionne les modules
indispensables à l'exécution de son application, puis crée une _image_ en
compilant son application avec les modules choisis. Cette image est ensuite
exécutée sur un _hyperviseur_ ou en _bare-metal_#footnote[C'est-à-dire directement
sur la couche matérielle sans l'intermédiaire d'un système d'exploitation.]

== Les OS classiques

== Tableau récapitulatif

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
- Classique: _Linux_ (monolithique modulaire), _seL4_ (micro-noyau), _RTEMS_

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

== Support multi-cœur

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

=== Linux & KVM

=== MirageOS

Le support multi-cœur de _MirageOS_ dépend de la version d'OCaml utilisée:
- #box[En OCaml 4, il n'est pas possible de tirer parti nativement du parrallélisme
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

=== PikeOS

=== ProvenVisor

=== RTEMS

=== seL4

=== Xen

_Xen_ supporte les architectures multi-cœur. L'hyperviseur offre la possibilité
d'allouer les cœurs à certains systèmes invités grâce au concept de _virtual CPU_.

=== XtratuM

= Activité

== Linux & KVM

Le projet Linux a été initié en 1991 par Linus Torvalds. Il est depuis activement
développé au travers d'une communauté décentralisée.

De nombreuses entreprises contribuent également au noyau, notamment aux pilotes
(Intel, Google, Samsung, AMD, ...).

== MirageOS

Le projet MirageOS a commencé en 2009. Il est depuis activement développé et maintenu.
La _Core Team_ et les contributeurs sont employés dans des laboratoires publics (notamment l'université de Cambridge) ou de R&D (notamment l'entreprise _Tarides_).

= Licences, brevets & certifications

== Linux & KVM

Le noyau `Linux` est un logiciel libre distribué sous licence
`GNU General Public License version 2 only (GPL-2.0)` avec l'exceptions
_syscall_ qui stipule qu'un logiciel utilisant le noyau `Linux` au travers des
appels systèmes n'est pas considéré comme une œuvre dérivée de celui-ci et
peut être distribué sous une licence qui n'est pas compatible avec la GPL,
y compris une licence propriétaire. Plus d'informations sont disponibles dans
le dossier `LICENSES` des sources du noyau `Linux`.

== MirageOS

Licence `ISC`

== PikeOS

La société SYSGO propose deux types de licences propriétaires:
- Une licence de développement permettant de concevoir des systèmes basés sur `PikeOS`.
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

== ProvenVisor

- Permet la certification critères communs EAL5

== RTEMS

`RTEMS` est un logiciel libre distribué sous une multitude de licences libres
et open-sources. Le noyau peut utiliser ou être lié avec des programmes sous
n'importe quelle licence @rtems_licenses.

== seL4

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

== Xen

== XtratuM

- La version originelle de l'hyperviseur `XtratuM` est distribuée sous licence `GPL v2` @xtratum_github
- Une nouvelle version `XtratuM New Generation` est développée et distribuée par l'entreprise fentISS. Il s'agit d'un logiciel propriétaire.

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

==== XtratuM

=== Watchdog

==== Linux

_Linux_ dispose d'un système de watchdog @linux_watchdog

== Monitoring & profiling

#bibliography("references.bib")
