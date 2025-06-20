group "default" {
  targets = [
    "authentication",
    "shinyproxy",
    "monitoring",
    "services",
  ]
}

group "authentication" {
  targets = [ "ldap_server", "ldap_admin" ]
}

group "shinyproxy" {
  targets = [ "proxy", "app" ]
}

group "monitoring" {
  targets = [ "grafana", "database" ]
}

group "services" {
  targets = [ "api_dispatcher", "fastapi", "oxygen", "plumber", "gin", "express" ]
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

target "proxy" {
  dockerfile = "Dockerfile"
  context = "./shinyproxy/proxy"
  platforms = [ "linux/amd64" ]
  args = {
    OPENJDK_VERSION = "17"
    SHINYPROXY_VERSION = "3.1.1"
  }
  tags = ["shiny-system-design/shinyproxy:latest"]
}

target "app" {
  # Make sure to use non-arm arch to install binary packages from P3M
  dockerfile = "Dockerfile"
  context = "./shinyproxy/app"
  platforms = ["linux/amd64"]
  tags = ["shiny-system-design/shinyapp:latest"]
  args = {
    R_VERSION = "4.5.0"
  }
}

target "database" {
  context = "./monitoring/database/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = ["shiny-system-design/database:latest"]
}

target "grafana" {
  context = "./monitoring/grafana/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = ["shiny-system-design/grafana:latest"]
}

target "api_dispatcher" {
  context = "./services/api_dispatcher/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/api_dispatcher:latest" ]
}

target "fastapi" {
  context = "./services/fastapi_api/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/fastapi:latest" ]
}

target "oxygen" {
  context = "./services/oxygen_api/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/oxygen:latest" ]
}

target "plumber" {
  context = "./services/plumber_api/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/plumber:latest" ]
}

target "gin" {
  context = "./services/gin_api/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/gin:latest" ]
}

target "express" {
  context = "./services/express_api/"
  dockerfile = "Dockerfile"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/express:latest" ]
}
