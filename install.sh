#!/bin/bash
#Create By: Edmundo Cespedes A.
#Update System
echo "Actualizando Sistema";
sudo dnf upgrade -y;

#Configure DNF for Faster Downloads of Packages
echo "Insertando configuraciones en dnf";
sudo cp -rpfv /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bkp

#Metodo 1
#echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
#echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf;
#echo "defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf;

#Metodo 2
sudo tee -a /etc/dnf/dnf.conf <<EOF
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
EOF

echo "Actualizando Sistema";
sudo dnf upgrade -y;

#Non-Free and Fusion Repository
#Import RPM Fusion Free
echo "Instalando Repositorio Fusion Free";
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm;
#Import RPM Fusion Nonfree
echo "Instalando Repositorio Fusion NoFree";
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm;
#Enable the Free Repository
echo "Abilitando Repsoitorios Free";
sudo dnf config-manager --set-enabled rpmfusion-free-updates-testing;
#Enable the Non-Free Repository
echo "Abilitando Repsoitorios NoFree";
sudo dnf config-manager --set-enabled rpmfusion-nonfree-updates-testing;

echo "Actualozando OS";
sudo dnf upgrade --refresh -y;

echo "Revisando la Habilitacion de Repositorios";
dnf repolist | grep rpmfusion;

#Adding the Flathub Repository
echo "Instalando Flatpak";
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo;

#Install Snap
echo "Instalando Snap";
sudo dnf install -y snapd;
sudo ln -s /var/lib/snapd/snap /snap;

#Instalando herramientas de Desarrollo
echo "Instalando Herramistas de Desarrollo";
sudo dnf -y install @development-tools;

#Instalando NodeJS
echo "Instalando NodeJs";
sudo dnf install -y nodejs npm;

#Instalando Control de Energia (Laptop)
echo "Instalando TLP";
sudo dnf install -y tlp tlp-rdw;

#Install Multimedia Plugins
echo "Instalando VLC";
sudo dnf install -y vlc vlc-extras.x86_64;

#Install Plugins Multimedia
echo "Inslando Plugins";
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel;
sudo dnf install lame\* --exclude=lame-devel;
sudo dnf group upgrade --with-optional Multimedia;

#Install Terminal
echo "Instalando Terminal";
sudo dnf install -y zsh tilix yakuake bat zsh-autosuggestions zsh-syntax-highlighting fzf xclipboard ;

#Install Add
echo "Instalando Paquetes Adicionales";
sudo dnf install -y git wget curl latte-dock barrier;

#Install KVM
echo "Verificamos si el sistema permite Virtualizacion";
cat /proc/cpuinfo | egrep "vmx|svm";
echo "Instalando Virt-Manager";
sudo dnf -y install libvirt virt-install qemu-kvm virt-manager;
echo "Habilitamos el Servicio de Virtulizacion"
sudo systemctl start libvirtd;
sudo systemctl enable libvirtd;
echo  "Para que nuestro usuario pueda tenga acceso al administrador";
sudo usermod -aG libvirt $USER;

#Instalando VirtualBox
#Instando dependencias
echo "Instalando dependencias para VirtualBox";
sudo dnf -y install kernel-headers kernel-devel dkms elfutils-libelf-devel qt5-qtx11extras;
#Insertando Repositorio de VirtualBox
echo "Agregando repositorio de VirtualBox";
cat <<EOF | sudo tee /etc/yum.repos.d/virtualbox.repo
[virtualbox]
name=Fedora $releasever - $basearch - VirtualBox
baseurl=http://download.virtualbox.org/virtualbox/rpm/fedora/36/\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.virtualbox.org/download/oracle_vbox.asc
EOF

#Verificando los paquetes existentes de VirtualBox
sudo dnf search virtualbox;

#Instalando VirtualBox
echo "Instalando VirtualBox";
sudo dnf install VirtualBox-7.0;

#Agregando y creando usuarios para ejecutar VirtualBox
echo "Agregando el ususrioa VirtualBox";
sudo usermod -a -G vboxusers $USER;
echo "Agregando el grupo VirtualBox";
newgrp vboxusers;
echo "Verificando la adicion de ususario";
id $USER;

#Instalando Fuentes Microsoft
sudo dnf install -y mscore-fonts-all;

#Import GPG Key & Brave Repository and Install Brave
#Import Stable GPG KEY
echo "Insertando llave GPG de Brave"
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc;
#Import Stable Repository
echo "Instalando repositorio de Brave"
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/;
#Install Brave
echo "Instalando Brave"
sudo dnf install -y brave-browser;

#Import GPG Key & Google Chrome Repository and Install Google Chrome
#Import GPG Key
echo "Insertando llave GPG de Google Chrome"
sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub;
#Download Google Chrome Stable Repository
echo "Instalando repositorio de Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm;
#Install Google Chrome
echo "Instalando Google Chrome"
sudo dnf install -y google-chrome-stable_current_x86_64.rpm;

#Install Telegram
echo "Instalando Telegram"
sudo dnf install -y telegram;

#Install OBS-Studio
echo "Instalando Obs-Studio"
sudo dnf install -y obs-studio;

#Install DBeaver-CE
echo "Instalando DBeaver"
sudo dnf install -y https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm;

#Install MarkText
echo "Instalando MarkText"
sudo dnf install -y https://github.com/marktext/marktext/releases/download/v0.17.1/marktext-x86_64.rpm;

#Instalar FirewallDGUI
echo "Instalando FirewallD-GUI";
sudo firewall-cmd --version;
sudo dnf install firewalld -y;
systemctl status firewalld;
sudo dnf install firewall-config -y;
sudo dnf install plasma-firewall-firewalld -y;

#Instalar Filezilla
echo "Instalando Filezilla";
sudo dnf install filezilla -y;
