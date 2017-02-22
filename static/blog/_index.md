---
title: "spf13-vim 3.0 release and new website"
description: "spf13-vim is a cross platform distribution of vim plugins and resources for Vim."
tags: [ ".vimrc", "plugins", "spf13-vim", "vim" ]
lastmod: 2015-12-23
date: "2012-04-06"
categories:
  - "Development"
  - "VIM"
slug: "spf13-vim-3-0-release-and-new-website"
---

Content of the file goes Here


Front Matter with weighted tags and categories

<main class="blog index">
  <section class="content with-extras">
    <section class="posts col-md-9 col-sm-12">
      {{ range .Data.Pages }}
        <li><span><a href="{{ .RelPermalink }}">{{ .Title }}</a><time class="pull-right post-list">{{ .Date.Format "Mon, Jan 2, 2006" }}</h4></time></span></span></li>

      <hr class="col-xs-11 row" class="post-separator">
      {{ end }}

      <div class="blog-author col-xs-12 col-md-12">
        <a href="/blog/rss.xml"><img src="/assets/images/static/rss-icon.png"></a>
      </div>
    </section>

    <div class="col-md-3">
      {% include blog-extras.html %}
    </div>
  </section>
</main>
