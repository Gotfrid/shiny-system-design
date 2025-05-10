ARG LDAP_ADMIN_VERSION=v1.11
ARG PLATFORM=amd64

FROM --platform=${PLATFORM} wheelybird/ldap-user-manager:${LDAP_ADMIN_VERSION}

ENV NO_HTTPS=true
ENV LDAP_URI="ldap://ldap_server"
ENV LDAP_BASE_DN="dc=ldapusermanager,dc=org"
ENV LDAP_REQUIRE_STARTTLS=false
ENV LDAP_ADMIN_BIND_DN="cn=admin,dc=ldapusermanager,dc=org"
ENV LDAP_ADMIN_BIND_PWD="admin"
ENV LDAP_IGNORE_CERT_ERRORS=true
ENV LDAP_USER_OU="accounts"
ENV LDAP_GROUP_OU="groups"
ENV LDAP_ADMINS_GROUP="admins"
ENV DEFAULT_USER_GROUP="users"
ENV ACCEPT_WEAK_PASSWORDS=true
