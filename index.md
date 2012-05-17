---
layout: default
title: Carlos Rodriguez
---

music
-----

{% for post in site.categories.music %}
* {{ post.date || date_to_string}} --- [{{ post.title}}]({{ site.root }}{{ post.url }})
{% endfor %}

code
----

{% for post in site.categories.code %}
* {{ post.date || date_to_string}} --- [{{ post.title}}]({{ site.root }}{{ post.url }})
{% endfor %}

photos
------

{% for post in site.categories.photos %}
* {{ post.date || date_to_string}} --- [{{ post.title}}]({{ site.root }}{{ post.url }})
{% endfor %}

misc
----

{% for post in site.categories.photos %}
* {{ post.date || date_to_string}} --- [{{ post.title}}]({{ site.root }}{{ post.url }})
{% endfor %}

meta
----

* [about {{ site.title }}]({{ site.baseurl }}README.html)
