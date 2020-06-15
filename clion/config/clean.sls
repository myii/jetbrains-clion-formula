# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import clion with context %}

   {%- if clion.pkg.use_upstream_macapp %}
       {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
   {%- else %}
       {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
   {%- endif %}

include:
  - {{ sls_package_clean }}

clion-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if clion.config_file and clion.config %}
      - {{ clion.config_file }}
               {%- endif %}
               {%- if clion.environ_file %}
      - {{ clion.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ clion.linux.desktop_file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ clion.dir.homes }}/{{ clion.identity.user }}/Desktop/{{ clion.pkg.name }}{{ '' if 'edition' not in clion else ' %sE'|format(clion.edition) }}  # noqa 204
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}