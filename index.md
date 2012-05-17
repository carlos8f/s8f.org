---
layout: default
title: Carlos Rodriguez
---

music
-----

{% for post in site.categories.music %}
* {{ post.date || date_to_string}} -- <a href="{{ site.root }}{{ post.url }}">{{ post.title }}</a>
{% endfor %}

code
----

<ul>
  {% for post in site.categories.code %}
  <li><span>{{ post.date || date_to_string}}</span> &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

photos
------

<ul>
  {% for post in site.categories.photos %}
  <li><span>{{ post.date || date_to_string}}</span> &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

misc
----

<ul>
  {% for post in site.categories.photos %}
  <li><span>{{ post.date || date_to_string}}</span> &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

meta
----

* [about {{ site.title }}]({{ site.baseurl }}README.html)
