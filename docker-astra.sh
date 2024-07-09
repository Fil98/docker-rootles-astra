#!/bin/sh

# Обновление репозиториев и установка ключа архива Debian
sudo apt update
sudo apt install -y debian-archive-keyring  # добавлен флаг -y для автоматического подтверждения установки
echo "deb https://deb.debian.org/debian/ buster main contrib non-free" | sudo tee /etc/apt/sources.list.d/repos.list  # Использован sudo tee для добавления строки в файл
echo "deb https://security.debian.org/debian-security/ buster/updates main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/repos.list  # Использован sudo tee -a для добавления строки в файл
sudo apt update

# Установка пакетов
sudo apt-get install -y uidmap curl dbus-user-session fuse-overlayfs slirp4netns make wget libpcre2-32-0 neofetch git

# Установка Zsh и Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Установка Docker и Docker Compose
sudo apt update && sudo apt dist-upgrade -y  # Добавлен sudo и флаг -y для автоматического подтверждения
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2  # Добавлен флаг -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" | sudo tee /etc/apt/sources.list.d/docker.list  # Изменен путь файла и добавлен sudo tee
sudo apt update
sudo apt install -y docker-ce  # Добавлен флаг -y
sudo systemctl status docker
docker --version
sudo usermod -aG docker ${USER}
sudo su - ${USER}

# Установка Docker Compose
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Настройки безопасности
# запрет на прием и отправку ICMP пакетов перенаправления
sudo sysctl -w net.ipv4.conf.all.accept_redirects=0
sudo sysctl -w net.ipv4.conf.all.secure_redirects=0
sudo sysctl -w net.ipv4.conf.all.send_redirects=0

# отключение ответа на ICMP запросы
sudo sysctl -w net.ipv4.icmp_echo_ignore_all=1

# увеличение числа запоминаемых запросов на соединение
sudo sysctl -w net.ipv4.tcp_max_syn_backlog=4096

# уменьшение времени удержания «полуоткрытых» соединений
sudo sysctl -w net.ipv4.tcp_synack_retries=1

# увеличение максимального числа «осиротевших» TCP пакетов
sudo sysctl -w net.ipv4.tcp_max_orphans=65536

# уменьшение времени ожидания приема FIN до полного закрытия сокета
sudo sysctl -w net.ipv4.tcp_fin_timeout=10

# уменьшение времени проверки TCP-соединений
sudo sysctl -w net.ipv4.tcp_keepalive_time=60

# уменьшение количества проверок перед закрытием соединения
sudo sysctl -w net.ipv4.tcp_keepalive_probes=5 

# увеличение максимального числа открытых сокетов, ждущих соединения
sudo sysctl -w net.core.somaxconn=15000

# увеличение размера буфера приема данных по умолчанию
sudo sysctl -w net.core.rmem_default=65536
sudo sysctl -w net.core.wmem_default=65536

# увеличение максимального размера буфера приема данных
sudo sysctl -w net.core.rmem_max=16777216
sudo sysctl -w net.core.wmem_max=16777216

# использование протокола htcp для управления нагрузкой в сетях TCP
sudo sysctl -w net.ipv4.tcp_congestion_control=htcp

# запрет на сохранение результатов изменений TCP соединения в кеше
sudo sysctl -w net.ipv4.tcp_no_metrics_save=1

# защита от TIME_WAIT атак
sudo sysctl -w net.ipv4.tcp_rfc1337=1

# принудительное отклонение новых соединений при перегрузке
sudo sysctl -w net.ipv4.tcp_abort_on_overflow=1
