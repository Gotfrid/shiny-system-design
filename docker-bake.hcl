group "default" {
  targets = [
    "ldap_server",
    "ldap_admin",
    "shinyproxy",
    "shinyapp",
    "telemetry_dash",
    "graphana",
    "class_service",
  ]
}

target "ldap_server" {
  dockerfile = "Dockerfile"
  context = "./authentication/ldap_server"
  platforms = ["linux/amd64"]
  args = {
    OPENLDAP_VERSION = "1.1.8"
  }
  tags = ["shiny-system-design/ldap_server:latest"]
}

target "ldap_admin" {
  dockerfile = "Dockerfile"
  context = "./authentication/ldap_admin"
  platforms = [ "linux/amd64" ]
  args = {
    LDAP_ADMIN_VERSION = "v1.11"
  }
  tags = ["shiny-system-design/ldap_admin:latest"]
}

target "shinyproxy" {
  dockerfile = "Dockerfile"
  context = "./shinyproxy/proxy"
  platforms = [ "linux/amd64" ]
  args = {
    OPENJDK_VERSION = "17"
    SHINYPROXY_VERSION = "3.1.1"
  }
  tags = ["shiny-system-design/shinyproxy:latest"]
}

target "shinyapp" {
  # Make sure to use non-arm arch to install binary packages from P3M
  dockerfile = "Dockerfile"
  context = "./shinyproxy/app"
  platforms = ["linux/amd64"]
  tags = ["shiny-system-design/shinyapp:latest"]
  args = {
    R_VERSION = "4.5.0"
  }
}

target "telemetry_dash" {
  # Make sure to use non-arm arch to install binary packages from P3M
  dockerfile = "Dockerfile"
  context = "./shinyproxy/analytics"
  platforms = [ "linux/amd64" ]
  tags = ["shiny-system-design/telemetry_dash:latest"]
  args = {
    R_VERSION = "4.5.0"
  }
}

target "graphana" {
  context = "./monitoring/grafana/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = ["shiny-system-design/grafana:latest"]
}

target "class_service" {
  context = "./services/classification/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/class_service:latest" ]
}
