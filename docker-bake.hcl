group "default" {
  targets = [
    "ldap_server",
    "ldap_admin",
    "shinyproxy",
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
