group "default" {
  targets = [
    "authentication",
    "shinyproxy",
    "monitoring",
    "services",
    "cache",
  ]
}

group "authentication" {
  targets = [ "ldap_server", "ldap_admin" ]
}

group "shinyproxy" {
  targets = [ "proxy", "app" ]
}

group "monitoring" {
  targets = [ "grafana", "monitoring_db" ]
}

group "services" {
  targets = [ "api_dispatcher", "fastapi", "oxygen", "plumber", "gin", "express", "spring" ]
}

group "cache" {
  targets = [ "kv_database" ]
}

target "ldap_server" {
  context = "./authentication/ldap_server"
  platforms = ["linux/amd64"]
  args = {
    OPENLDAP_VERSION = "1.1.8"
  }
  tags = ["shiny-system-design/ldap_server:latest"]
}

target "ldap_admin" {
  context = "./authentication/ldap_admin"
  platforms = [ "linux/amd64" ]
  args = {
    LDAP_ADMIN_VERSION = "v1.11"
  }
  tags = ["shiny-system-design/ldap_admin:latest"]
}

target "proxy" {
  context = "./shinyproxy/proxy"
  platforms = [ "linux/amd64" ]
  args = {
    OPENJDK_VERSION = "17"
    SHINYPROXY_VERSION = "3.1.1"
  }
  tags = ["shiny-system-design/shinyproxy:latest"]
}

target "app" {
  context = "./shinyproxy/app"
  platforms = ["linux/amd64"]
  tags = ["shiny-system-design/shinyapp:latest"]
  args = {
    R_VERSION = "4.5.0"
  }
}

target "monitoring_db" {
  context = "./monitoring/monitoring_db/"
  platforms = [ "linux/amd64" ]
  tags = ["shiny-system-design/monitoring_db:latest"]
}

target "grafana" {
  context = "./monitoring/grafana/"
  platforms = [ "linux/amd64" ]
  tags = ["shiny-system-design/grafana:latest"]
}

target "api_dispatcher" {
  context = "./services/api_dispatcher/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/api_dispatcher:latest" ]
}

target "fastapi" {
  context = "./services/fastapi_api/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/fastapi:latest" ]
}

target "oxygen" {
  context = "./services/oxygen_api/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/oxygen:latest" ]
}

target "plumber" {
  context = "./services/plumber_api/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/plumber:latest" ]
}

target "gin" {
  context = "./services/gin_api/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/gin:latest" ]
}

target "express" {
  context = "./services/express_api/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/express:latest" ]
}

target "spring" {
  context = "./services/spring_api/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/spring:latest" ]
}

target "kv_database" {
  context = "./cache/kv_database/"
  platforms = [ "linux/amd64" ]
  tags = [ "shiny-system-design/kv_database:latest" ]
}
