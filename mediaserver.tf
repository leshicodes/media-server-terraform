# ----------------------------------------------------------------------------------------
#  Terraform Providers

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.13.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# ----------------------------------------------------------------------------------------
# --- Terraform Variable Definitions ---

# -- Locals --

# We need this to set the Containers to have pihole as the DNS Authority.
# https://stackoverflow.com/questions/63928641/terraform-specify-specific-docker-network-name-for-output
/* 
EXAMPLE
locals {
  container_networks = {
    for net in docker_container.pihole.network_data :
    net.network_name => net
  }
}
*/
locals {
  pihole_container_networks = {
    for net in docker_container.pihole.network_data :
    net.network_name => net
  }
}


# -- Common variables --
variable "uid" {
  type    = string
  default = "1000"
}

variable "gid" {
  type    = string
  default = "1000"
}

variable "timezone" {
  type    = string
  default = "America/Chicago"
}

# -- Container specific variables --
variable "pihole_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/pihole/conf"
}

variable "pihole_dnsmasq_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/pihole/dnsmasq.d"
}

variable "pihole_webpassword" {
  type    = string
  default = "mySuper$ecurePassw0rd!!3" # Obviously just a default password. Don't keep this.
}

# NZBGet is now deprecated ; 
# https://forum.nzbget.net/viewtopic.php?f=3&t=3690&p=22553
# https://info.linuxserver.io/issues/2022-11-27-nzbget/
# variable "nzbget_config_dir" {
#   type    = string
#   default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/ngzbget/conf"
# }

variable "sabnzbd_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/sabnzbd/conf"
}

variable "prowlarr_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/prowlarr/conf"
}

variable "sonarr_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/sonarr/conf"
}

variable "radarr_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/radarr/conf"
}

variable "homeassistant_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/homeassistant/conf"
}

variable "overseerr_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/overseerr/conf"
}

variable "doplarr_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/doplarr/conf"
}

variable "homer_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/homer/conf"
}

variable "calibre_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/calibre-web/conf"
}

variable "calibre_data_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/calibre-web/conf"
}

variable "calibre-web_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/calibre-web/books"
}

variable "plex_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/plex/config"
}

variable "bazarr_config_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/bazarr/config"
}

variable "pihole_container_vers" {
  type    = string
  default = "latest"
}

variable "sabnzbd_container_vers" {
  type    = string
  default = "latest"
}

variable "prowlarr_container_vers" {
  type    = string
  default = "latest"
}

variable "sonarr_container_vers" {
  type    = string
  default = "latest"
}

variable "radarr_container_vers" {
  type    = string
  default = "latest"
}

variable "homeassistant_container_vers" {
  type    = string
  default = "latest"
}

variable "overseerr_container_vers" {
  type    = string
  default = "latest"
}

variable "doplarr_container_vers" {
  type    = string
  default = "latest"
}

variable "homer_container_vers" {
  type    = string
  default = "latest"
}

variable "plex_container_vers" {
  type    = string
  default = "latest"
}

variable "calibre_container_vers" {
  type    = string
  default = "latest"
}

variable "calibre-web_container_vers" {
  type    = string
  default = "latest"
}

variable "bazarr_container_vers" {
  type    = string
  default = "latest"
}

variable "movie_dir" {
  type = string
}

variable "series_dir" {
  type = string
}

variable "anime_dir" {
  type = string
}

variable "documentaries_dir" {
  type = string
}

variable "docuseries_dir" {
  type = string
}

variable "audiobooks_dir" {
  type = string
}

variable "miscmedia_dir" {
  type = string
}

# Currently Unused ; Might use later on.
# variable "book_dir" {
#   type = string
# }

variable "downloads_dir" {
  type    = string
  default = "/c/Users/jjambrose1s/Documents/git-projects/media-server-stack/containers/ngzbget/downloads"
}

variable "doplarr_discord_token" {
  type    = string
  default = "abc123"
}

variable "doplarr_overseerr_token" {
  type    = string
  default = "abc123"
}

variable "pihole_external_ipaddress" {
  type    = string
  default = "8.8.8.8"
}

# ----------------------------------------------------------------------------------------
# --- Terraform Docker network resource definitions ---
resource "docker_network" "mediaserver_network" {
  name   = "mediaserver_network"
  driver = "bridge"
}

# ----------------------------------------------------------------------------------------
# --- Terraform Docker image resource definitions ---

resource "docker_image" "pihole" {
  name         = "pihole/pihole:${var.pihole_container_vers}"
  keep_locally = true
}

# resource "docker_image" "nzbget" {
#   name = "linuxserver/nzbget:${var.nzbget_container_vers}"
#   keep_locally = true
# }

resource "docker_image" "sabnzbd" {
  name         = "linuxserver/sabnzbd:${var.sabnzbd_container_vers}"
  keep_locally = true
}

resource "docker_image" "prowlarr" {
  name         = "ghcr.io/linuxserver/prowlarr:${var.prowlarr_container_vers}"
  keep_locally = true
}

resource "docker_image" "sonarr" {
  name         = "linuxserver/sonarr:${var.sonarr_container_vers}"
  keep_locally = true
}

resource "docker_image" "radarr" {
  name         = "linuxserver/radarr:${var.radarr_container_vers}"
  keep_locally = true
}

resource "docker_image" "homeassistant" {
  name         = "ghcr.io/home-assistant/home-assistant:${var.homeassistant_container_vers}"
  keep_locally = true
}

resource "docker_image" "overseerr" {
  name         = "linuxserver/overseerr:${var.overseerr_container_vers}"
  keep_locally = true
}

resource "docker_image" "doplarr" {
  name         = "ghcr.io/kiranshila/doplarr:${var.doplarr_container_vers}"
  keep_locally = true
}

resource "docker_image" "homer" {
  name         = "b4bz/homer:${var.homer_container_vers}"
  keep_locally = true
}

resource "docker_image" "calibre" {
  name         = "linuxserver/calibre:${var.calibre_container_vers}"
  keep_locally = true
}

resource "docker_image" "calibre-web" {
  name         = "linuxserver/calibre-web:${var.calibre-web_container_vers}"
  keep_locally = true
}

resource "docker_image" "plex" {
  name         = "linuxserver/plex:${var.plex_container_vers}"
  keep_locally = true
}

resource "docker_image" "bazarr" {
  name         = "linuxserver/bazarr:${var.bazarr_container_vers}"
  keep_locally = true
}

# ----------------------------------------------------------------------------------------
# Terraform Docker container resource definitions
# Docs : https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container


resource "docker_container" "pihole" {
  name         = "pihole"
  image        = docker_image.pihole.image_id
  hostname     = "pihole"
  restart      = "unless-stopped"
  must_run     = true
  domainname   = "pihole"
  network_mode = "bridge"
  ports {
    internal = 53
    external = 53
    protocol = "tcp"
  }
  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  ports {
    internal = 67
    external = 67
    protocol = "tcp"
  }
  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }
  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "WEBPASSWORD=${var.pihole_webpassword}"
  ]
  volumes {
    host_path      = var.pihole_config_dir
    container_path = "/etc/pihole"
  }
  volumes {
    host_path      = var.pihole_dnsmasq_dir
    container_path = "/etc/dnsmasq.d/"
  }
  capabilities {
    add = ["NET_ADMIN"]
  }
  depends_on = [docker_image.pihole]
}

resource "docker_container" "sabnzbd" {
  name       = "sabnzbd"
  image      = docker_image.sabnzbd.image_id
  hostname   = "sabnzbd"
  restart    = "on-failure"
  must_run   = true
  domainname = "sabnzbd"
  ports {
    internal = 8080
    external = 6789
  }
  env = [
    "TZ=${var.timezone}",
    "PUID=${var.uid}",
    "PGID=${var.gid}"
  ]
  volumes {
    host_path      = var.sabnzbd_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = var.downloads_dir
    container_path = "/downloads"
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://prowlarr:9696"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  depends_on = [docker_image.sabnzbd, docker_container.pihole]
}

resource "docker_container" "prowlarr" {
  name       = "prowlarr"
  image      = docker_image.prowlarr.image_id
  hostname   = "prowlarr"
  restart    = "on-failure"
  must_run   = true
  domainname = "prowlarr"
  ports {
    internal = 9696
    external = 9696
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "DOCKER_MODS=ghcr.io/gilbn/theme.park:prowlarr"
  ]
  volumes {
    host_path      = var.prowlarr_config_dir
    container_path = "/config"
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://prowlarr:9696"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  depends_on = [docker_image.prowlarr, docker_container.pihole, docker_container.sabnzbd]
}

resource "docker_container" "sonarr" {
  name       = "sonarr"
  image      = docker_image.sonarr.image_id
  hostname   = "sonarr"
  restart    = "on-failure"
  must_run   = true
  domainname = "sonarr"
  ports {
    internal = 8989
    external = 8989
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "UMASK_SET=022",
    "DOCKER_MODS=ghcr.io/gilbn/theme.park:sonarr"
  ]
  volumes {
    host_path      = var.sonarr_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = var.downloads_dir
    container_path = "/downloads"
  }
  volumes {
    host_path      = var.series_dir
    container_path = "/tv"
  }
  volumes {
    host_path      = var.anime_dir
    container_path = "/anime"
  }
  volumes {
    host_path      = var.docuseries_dir
    container_path = "/docuseries"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://prowlarr:9696"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }

  depends_on = [docker_image.sonarr, docker_container.pihole, docker_container.sabnzbd, docker_container.prowlarr]
}

resource "docker_container" "radarr" {
  name       = "radarr"
  image      = docker_image.radarr.image_id
  hostname   = "radarr"
  restart    = "on-failure"
  must_run   = true
  domainname = "radarr"
  ports {
    internal = 7878
    external = 7878
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "UMASK_SET=022",
    "DOCKER_MODS=ghcr.io/gilbn/theme.park:radarr"
  ]
  volumes {
    host_path      = var.radarr_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = var.downloads_dir
    container_path = "/downloads"
  }
  volumes {
    host_path      = var.movie_dir
    container_path = "/movies"
  }
  volumes {
    host_path      = var.documentaries_dir
    container_path = "/documentaries"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://prowlarr:9696"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }
  depends_on = [docker_image.radarr, docker_container.pihole, docker_container.sabnzbd, docker_container.prowlarr]
}

resource "docker_container" "homeassistant" {
  name       = "homeassistant"
  image      = docker_image.homeassistant.image_id
  hostname   = "homeassistant"
  restart    = "on-failure"
  must_run   = true
  domainname = "homeassistant"
  ports {
    internal = 8123
    external = 8123
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}"
  ]
  # dns = [local.pihole_container_networks["bridge"].ip_address]
  volumes {
    host_path      = var.homeassistant_config_dir
    container_path = "/config"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "https://google.com"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }
  depends_on = [docker_image.homeassistant]
}

resource "docker_container" "overseerr" {
  name       = "overseerr"
  image      = docker_image.overseerr.image_id
  hostname   = "overseerr"
  restart    = "on-failure"
  must_run   = true
  domainname = "overseerr"
  ports {
    internal = 5055
    external = 5055
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "LOG_LEVEL=info",
    "DOCKER_MODS=ghcr.io/gilbn/theme.park:overseerr"
  ]
  volumes {
    host_path      = var.overseerr_config_dir
    container_path = "/config"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://prowlarr:9696"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }
  depends_on = [docker_image.overseerr, docker_container.pihole, docker_container.sabnzbd, docker_container.prowlarr, docker_container.sonarr, docker_container.radarr]
}

resource "docker_container" "doplarr" {
  name       = "doplarr"
  image      = docker_image.doplarr.image_id
  hostname   = "doplarr"
  restart    = "on-failure"
  must_run   = true
  domainname = "doplarr"
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "UMASK_SET=022",
    "DISCORD__TOKEN=${var.doplarr_discord_token}",
    "OVERSEERR__URL=http://${docker_container.overseerr.name}:5055",
    "OVERSEERR__API=${var.doplarr_overseerr_token}",
    "DISCORD__MAX_RESULTS=25"
  ]
  volumes {
    host_path      = var.doplarr_config_dir
    container_path = "/config"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://prowlarr:9696"]
    retries  = "3"
    timeout  = "10s"
    interval = "10s"
  }
  depends_on = [docker_image.doplarr, docker_container.pihole, docker_container.sabnzbd, docker_container.prowlarr, docker_container.overseerr]
}

resource "docker_container" "homer" {
  name       = "homer"
  image      = docker_image.homer.image_id
  hostname   = "homer"
  restart    = "on-failure"
  must_run   = true
  domainname = "homer"
  ports {
    internal = 8080
    external = 8080
  }
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}"
  ]
  volumes {
    host_path      = var.homer_config_dir
    container_path = "/www/assets"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  depends_on = [docker_image.homer]
}

# Docs : https://docs.linuxserver.io/images/docker-plex
resource "docker_container" "plex" {
  name       = "plex"
  image      = docker_image.plex.image_id
  hostname   = "plex"
  restart    = "on-failure"
  must_run   = true
  domainname = "plex"
  /*
  ports {
    internal = 32400
    external = 32400
  }
  ports {
    internal = 1900
    external = 1900
    protocol = "udp"
  }
  ports {
    internal = 3005
    external = 3005
  }
  ports {
    internal = 5353
    external = 5353
    protocol = "udp"
  }
  ports {
    internal = 8324
    external = 8324
  }
  ports {
    internal = 32410
    external = 32410
    protocol = "udp"
  }
  ports {
    internal = 32412
    external = 32412
    protocol = "udp"
  }
  ports {
    internal = 32413
    external = 32413
    protocol = "udp"
  }
  ports {
    internal = 32414
    external = 32414
    protocol = "udp"
  }
  ports {
    internal = 32469
    external = 32469
  }
  */
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=${var.timezone}",
    "VERSION=docker"
  ]
  volumes {
    host_path      = var.plex_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = var.anime_dir
    container_path = "/anime"
  }
  volumes {
    host_path      = var.series_dir
    container_path = "/series"
  }
  volumes {
    host_path      = var.movie_dir
    container_path = "/movies"
  }
  volumes {
    host_path      = var.audiobooks_dir
    container_path = "/audiobooks"
  }
  volumes {
    host_path      = var.miscmedia_dir
    container_path = "/misc-media"
  }
  network_mode = "host"
  # networks_advanced {
  #   name = docker_network.mediaserver_network.name
  # }
  devices {
    host_path      = "/dev/dri"
    container_path = "/dev/dri"
  }
  depends_on = [docker_image.plex]
}

# Docs : https://github.com/linuxserver/docker-calibre
resource "docker_container" "calibre" {
  name       = "calibre"
  image      = docker_image.calibre.image_id
  hostname   = "calibre"
  restart    = "on-failure"
  must_run   = true
  domainname = "calibre"
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=America/Chicago"
  ]
  ports {
    internal = 8080
    external = 8181
  }
  ports {
    internal = 8081
    external = 8182
  }
  volumes {
    host_path      = var.calibre_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = var.calibre_data_dir
    container_path = "/data"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  depends_on = [docker_image.calibre]
}

resource "docker_container" "calibre-web" {
  name       = "calibre-web"
  image      = docker_image.calibre-web.image_id
  hostname   = "calibre-web"
  restart    = "on-failure"
  must_run   = true
  domainname = "calibre-web"
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=America/Chicago",
    "DOCKER_MODS=linuxserver/calibre-web:calibre",
    "DOCKER_MODS=linuxserver/mods:universal-calibre",
    "DOCKER_MODS=ghcr.io/gilbn/theme.park:calibre-web"
  ]
  ports {
    internal = 8083
    external = 8083
  }
  volumes {
    host_path      = var.calibre-web_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = "${var.calibre_data_dir}/Calibre"
    container_path = "/books"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  depends_on = [docker_image.calibre-web, docker_image.calibre, docker_container.calibre]
}

resource "docker_container" "bazarr" {
  name       = "bazarr"
  image      = docker_image.bazarr.image_id
  hostname   = "bazarr"
  restart    = "on-failure"
  must_run   = true
  domainname = "bazarr"
  env = [
    "PUID=${var.uid}",
    "PGID=${var.gid}",
    "TZ=America/Chicago"
  ]
  ports {
    internal = 6767
    external = 6767
  }
  volumes {
    host_path      = var.bazarr_config_dir
    container_path = "/config"
  }
  volumes {
    host_path      = var.series_dir
    container_path = "/tv"
  }
  volumes {
    host_path      = var.movie_dir
    container_path = "/movies"
  }
  volumes {
    host_path      = var.anime_dir
    container_path = "/anime"
  }
  networks_advanced {
    name = docker_network.mediaserver_network.name
  }
  depends_on = [docker_image.pihole, docker_image.bazarr, docker_container.pihole, docker_container.sonarr, docker_container.radarr]
}

# ----------------------------------------------------------------------------------------
# --- Terraform Output Definitions ---

output "pihole_container_ipaddress_output" {
  description = "IP Address that all containers are using for DNS Lookups"
  value       = local.pihole_container_networks["bridge"].ip_address
}
