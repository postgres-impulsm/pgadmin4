{#
# CREATE DATABSE does not allow us to run any
# other sql statments along with it, so we wrote
# seprate sql for rest alter sql statments here
#}
{% import 'macros/security.macros' as SECLABLE %}
{% import 'macros/variable.macros' as VARIABLE %}
{% import 'macros/privilege.macros' as PRIVILEGE %}
{% import 'macros/default_privilege.macros' as DEFAULT_PRIVILEGE %}
{% if data.comments %}
COMMENT ON DATABASE {{ conn|qtIdent(data.name) }}
  IS {{ data.comments|qtLiteral }};
{% endif %}

{# We will generate Security Label SQL's using macro #}
{% if data.securities %}
{% for r in data.securities %}
{{ SECLABLE.APPLY(conn, 'DATABASE', data.name, r.provider, r.securitylabel) }}
{% endfor %}
{% endif %}
{# We will generate Variable SQL's using macro #}
{% if data.variables %}
{% for var in data.variables %}
{% if var.value == True %}
{{ VARIABLE.APPLY(conn, data.name, var.role, var.name, 'on') }}
{% elif  var.value == False %}
{{ VARIABLE.APPLY(conn, data.name, var.role, var.name, 'off') }}
{% else %}
{{ VARIABLE.APPLY(conn, data.name, var.role, var.name, var.value) }}
{% endif %}
{% endfor %}
{% endif %}
{% if data.datacl %}
{% for priv in data.datacl %}
{{ PRIVILEGE.APPLY(conn, 'DATABASE', priv.grantee, data.name, priv.without_grant, priv.with_grant) }}
{% endfor %}
{% endif %}
{% if data.deftblacl %}
{% for priv in data.deftblacl %}
{{ DEFAULT_PRIVILEGE.APPLY(conn, 'TABLES', priv.grantee, priv.without_grant, priv.with_grant) }}
{% endfor %}
{% endif %}
{% if data.defseqacl %}
{% for priv in data.defseqacl %}
{{ DEFAULT_PRIVILEGE.APPLY(conn, 'SEQUENCES', priv.grantee, priv.without_grant, priv.with_grant) }}
{% endfor %}
{% endif %}
{% if data.deffuncacl %}
{% for priv in data.deffuncacl %}
{{ DEFAULT_PRIVILEGE.APPLY(conn, 'FUNCTIONS', priv.grantee, priv.without_grant, priv.with_grant) }}
{% endfor %}
{% endif %}
{% if data.deftypeacl %}
{% for priv in data.deftypeacl %}
{{ DEFAULT_PRIVILEGE.APPLY(conn, 'TYPES', priv.grantee, priv.without_grant, priv.with_grant) }}
{% endfor %}
{% endif %}