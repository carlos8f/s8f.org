---
layout: default
title: Carlos Rodriguez
---

music
-----

<ul class="posts">
{% for post in site.categories.music %}
<li>{{ post.date || date_to_string}} &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title}}</a></li>
{% endfor %}
</ul>

code
----

<ul class="posts">
{% for post in site.categories.code %}
<li>{{ post.date || date_to_string}} &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title}}</a></li>
{% endfor %}
</ul>

photos
------

<ul class="posts">
{% for post in site.categories.photos %}
<li>{{ post.date || date_to_string}} &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title}}</a></li>
{% endfor %}
</ul>

misc
----

<ul class="posts">
{% for post in site.categories.photos %}
<li>{{ post.date || date_to_string}} &mdash; <a href="{{ site.root }}{{ post.url }}">{{ post.title}}</a></li>
{% endfor %}
</ul>

meta
----

<ul class="posts">
<li><a href="{{ site.baseurl }}README.html">About {{ site.title }}</a></li>
</ul>
