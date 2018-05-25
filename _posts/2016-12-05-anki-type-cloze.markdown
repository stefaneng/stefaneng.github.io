---
layout: post
title:  "Anki - Type Answer in Cloze Deletion"
date:   2016-12-05 20:00:00 -0800
categories: other
tags: [anki, cloze]
---

![cloze-typing]({{ site.url }}/assets/cloze_card_typing.jpg)
![cloze-typing-answer]({{ site.url }}/assets/cloze_card_typing2.jpg)

To enable typing on a cloze card in anki add

{% highlight text %}
{% raw %}
{{cloze:FieldName}}
{{type:cloze:FieldName}}
{% endraw %}
{% endhighlight %}

To the front and back of the card, like this

![cloze-card-creation]({{ site.url }}/assets/cloze_card_creation.jpg)

For more information see the [Anki Documentation](http://ankisrs.net/docs/manual.html#typinganswers)
