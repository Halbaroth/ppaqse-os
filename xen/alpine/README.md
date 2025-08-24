Ce dossier contient le nécessaire pour mettre en place une machine virtuelle
sous Xen en paravirtualisation.

# Mise en place du réseau
Afin de disposer du réseau dans la machine virtuelle, il faut mettre en place
un bridge et une redirection de type NAT. Notez que le fichier `alpine.cfg`
contient la ligne suivante:
```
vif = [ 'mac=00:16:3e:00:00:00,bridge=xenbr0' ]
```
Cette ligne stipule que la VM aura une interface réseau d'adresse MAC
`00:16:3e:00:00:00` et utilisera le bridge `xenbr0`.

## Dans le _dom0_
Commençons par créer ce bridge:
```console
sudo ip link add xenbr0 type bridge
sudo ip link set xenbr0 up
```
Puis ajoutons une adresse IP dans le bridge pour le réseau interne:
```console
sudo ip addr add 192.168.10.1/24 dev xenbr0
```
Finalement il faut rediriger le trafic réseau via des règles `iptables`:
```console
sudo iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o IFACE -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i xenbr0 -o IFACE -j ACCEPT
```
où `IFACE` désigne l'interface réseau de _dom0_.

# Dans le _domU_
Il reste à configurer le réseau dans la VM. Ajoutez un fichier `/etc/network/interfaces`
avec le contenu suivant:
```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
  address 192.168.10.10
  netmask 255.255.255.0
  gateway 192.168.10.1
```
et une configuration minimale pour le DNS:
```console
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```
Finalement vous pouvez relancer le service réseau:
```console
/etc/init.d/networking restart
```
La commande `ping 8.8.8.8` devrait réussir à ce point.

# Installation des outils Xen dans la VM
Il vous faut d'abord ajouter les dépôts officiels de Alpine:
```console
echo "http://dl-cdn.alpinelinux.org/alpine/v3.22/main" >> /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v3.22/community" >> /etc/apk/repositories
```
Puis mettre à jour la base de paquets:
```console
apk update
```
Finalement vous pouvez installer les outils _Xen_:
```console
apk add xen
```
