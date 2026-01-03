---
layout: blog-post
title: Can I Use That Code? Software licences as a user
summary: Software licences are fascinating, complicated and important.
excerpt: I gave a talk on software licences at PyCon Canada.  Software licences are fantastic complicated and important, enabling the whole open source community. Also, just because code is on the internet doesn't mean you can use it!
tags: software-licences open-source
---

<section id='intro' markdown='1'>
I did my first conference talk for PyCon Canada last weekend on software licences[^1] as a end user. I had given this [talk] before to a few meetups and it had gone well, which encouraged me to submit it to [PyCon Canada 2017][PyConCA] and [PyCascades 2018][PyCascades]. To my delight (and nervousness!) both conferences accepted it!

I really enjoyed the experience. While I was very nervous, and was finishing my slides and practicing fervently the night before I presented, the talk itself went fine. As a bonus, I've had several people tell me they enjoyed it, and I have an excuse to talk about software licences to everyone!

While most of the content can be found elsewhere on the internet, I know many people (myself included) prefer reading over watching a video so I've provided a summary/transcript.  [Slides](https://docs.google.com/presentation/d/1NGAzLPPOPS6v_q8mLxjJpJphoEAfV9Cs4FEVzM9JWKs/edit?usp=sharing) are also available.

[tl;dr](#conclusion)


[talk]: {{ "talks" | relative_url }}
[PyConCA]: https://2017.pycon.ca/en/schedule/18/
[PyCascades]: https://2018.pycascades.com/talks/can-i-use-that-code-software-licences-as-a-user/

</section>

<section id='talk' markdown='1'>

### Introduction

I'm going to try to answer the question "Can I use that code?".  I'll be talking about software licences as a user, focusing on looking at other people's code and checking if you can use it in your project

I'm Holly Becker. I'm a software developer at Sauce Labs, which does automated mobile and web testing as a service.  I'm also a PyLadies Vancouver co-organizer and a fan of open source.  Aside from programming, I enjoy books, board games and birdwatching. You can find me online as Hwesta.

Another important thing about me is I Am Not A Lawyer.  I did some research for this presentation, and while it was fascinating and informative it is definitely not legal advice.  You should consult a lawyer if you have any actual legal concerns.  My research isn't enough because software licences are complicated.  There are lots of interactions and complexities; some requirements conflict; there's unclear definitions of terms, or terms from legal precedent from another country.  Much of this has not been tested in court, so the final decision may be different than we think it is (or should be).  This is just a summary to get you thinking about software licences.

### What is a Licence?

First of all, what is a licence?

Specifically, what is a software licence? I'm only going to discuss software licences.  If you have other creative non-code work, I highly recommend the [Creative Commons][CC] set of licences.  Licences discuss what you can do, and what you must do to be able to use the code.  It allows uses that default copyright does not, and addresses how you can run, modify and redistribute the code (for example, using it in your project).

[CC]: https://creativecommons.org/licenses/

### Categories of Licences

There are lots of different software licences. Fortunately, they can be grouped into a few categories with similar rights and obligations, which I'll cover from most restrictive to least restrictive.

The first category is code that is not licensed. This is not actually a licence! By default everything is under copyright and not usable by anyone except the copyright holder, usually the author.  You can ask for permission to use it, but unless it has a licence you can't use it.  This includes the great looking code you found on someone's blog, or that useful website you found.

The next category is closed source or propriety licences.  Generally, you can't use this code, or you can only use it in a restricted sense like running but not modifying, or you have the compiled binary but not the source code.  A common example of this is a EULA, where you agree to the terms and conditions in order to run the program. Another interesting example is the Unity game engine; you can use it for free to make video games until your revenue passes a certain amount, then you have to pay to use it.

The first open source category is copyleft licences.  You can use this code! However you have some significant obligations.  You have to keep a copy of the licence with the code, and derivatives have to be licensed under a copyleft licence.  A derivative can be modifications to the original code, or a new program built with the code, but both of them have to be released under a copyleft licence.  Copyleft is concerned not just with *making* software free but with *keeping* software free and the licences in this category enforce that. The best known example of a copyleft licence is the GPL, and the related AGPL and LGPL.

The second open source category is permissive open source licences.  You can use this code! There are very few restrictions and generally just require distributing the licence with the code so others know the terms the code is available under.  Most licences also disclaim liability and may have additional restrictions such as granting patent licences or say that using this code isn't an endorsement.  Unlike copyleft, permissive licences are not concerned with derivatives' freedom and can be used in closed source applications with few issues.  This is a very popular category of license - more than half the projects on PyPI are licensed under one of the permissive open source licences.  There are several well know licences in this category, including the MIT, BSD and Apache licences.

Code can also be put in the public domain. You can use this code! There are no restrictions, no credit required, no licence to keep with the code.  Notably, there is no copyright. This is the biggest difference to the previous licences. In fact, it's not actually a licence, because no one has copyright.  Licences work by using copyright to control usage, even if the rights granted are broad and the conditions minimal.  If there's no copyright, then there's no one to set the terms, so no licence is possible.  There's also no disclaimer of liability, so you probably want a permissive open source licence instead of public domain for your code.  However it has been done: the [SQLite] database is public domain.  The "licences" in this category (CC0 and the Unlicense) offer public domain-like rights in jurisdictions with no concept of public domain.

The last category is joke licences.  This is not really a useful category. The intent is to be both permissive and funny, but it ends up being really legally problematic.  For example, "You can use my code if you buy me a beer!".  I buy you a beer? My company buys you a beer? Do all my coworkers have to buy you a beer? Do we buy you a beer before or after we start using your code? Do we have to hunt you down for the beer buying? This is problematic for lawyers and they have to buy themselves a beer to deal with it.  You should avoid libraries with these licences because it's a legal headache, and you should avoid licensing your code under a joke licence.

[SQLite]: https://www.sqlite.org/copyright.html


### Common Licences

Generally if you're using someone else's code it's available under one of the open source licences. We'll look at a couple permissive and copyleft licences to set the stage for discussing how they interact.

Starting with the shortest, the MIT Licence is a simple permissive open source licence.  It only requires keeping a copy of the licence (which includes the copyright holder's information) with the code. Like basically every licence, it disclaims liability. It's actually quite short, only about 170 words, and there's an excellent breakdown by (/dev/lawyer)[devlaywerMIT] explaining all the legalese.  Some Python packages licensed under MIT are SQLAlchemy, Twisted and six.

The BSD licence is very similar to the MIT licence: a simple, permissive open source licence.  It disclaims liability and says you must keep a copy of the licence with the source or binary. There's two major versions of the BSD licence: the 2-clause and 3-clause.  The 3-clause adds another clause saying that copyright holders don't endorse any derivatives.  This makes more sense in the context that BSD is short for Berkeley Software Distribution, and the University of California in Berkeley probably didn't want people saying Berkeley endorsed them just because they were using software written at Berkeley.  This as a popular license: it's used by scipy, numpy and pandas from data science/scientific computing, and Django and flask from web programming.

The Apache licence is the last of the permissive open source licences I'll discuss. It's longer and more explicit about things the previous licences are implicit about. Like the others, it includes a disclaimer of liability and you must keep a copy of the licence with the code.  It also explicitly addresses patents, and grants the patent rights necessary to run and distribute the code. Amusingly, these rights are revoked if there's a lawsuit over them.  Additionally, contributions to Apache licensed projects are by default licensed under Apache themselves, which is an interesting clause I didn't see elsewhere. The Python packages requests and selenium are licensed under Apache, as well as the Android operating system.

And last, but definitely not least, is the GPL or GNU Public License.  This is the best known of the copyleft licences. It includes the things you're probably coming to expect from a software licence: disclaimer of liability, keep a copy of the licence with the code. Like the Apache licence, version 3 includes a grant of patent licence.

On top of that, the GPL has all the things that make it a copyleft licence.  If you distribute code (or modify and distribute code) licensed under the GPL, you must make the source code available. Note that if you only use it for personal use or internal to your company you don't have to do anything special. It's the act of distributing it (either giving away or selling) that requires you to make the source code available.

Additionally, if you include GPL licensed code in your codebase and distribute it you must make the entire codebase available under the GPL.  Remember, copyleft licences are concerned with *keeping* software free; they don't want you to make something with their code and not contribute it back to the community.  The GPL is sometimes called 'viral' because including GPL'd code affects the licensing of the entire program.

However, the definition of 'one program' gets complicated. What's one program vs two programs that communicate?  Typically static and dynamic linking are considered one program, while HTTP calls and piping output are not. In between things get fuzzy. This is where the lawyers get involved if you want to use a GPL licensed dependency but don't want to release your codebase.

The best known example of a GPL licensed project is the Linux kernel, and the Python project Ansible is also licensed GPL.


[devlaywerMIT]: https://writing.kemitchell.com/2016/09/21/MIT-License-Line-by-Line.html

### Can I Use That Code?

This is the interesting part!  Now that we know a little about the licences, we can discuss if my code is licensed X can I include code licensed Y.  In the presentation, I asked people to guess the answer before I revealed it.

Closed Source + MIT: Yes! MIT has few restrictions, only requiring a copy of the licence be kept with the code so others know how it's licensed, and can easily be used in closed source projects.

Closed source + GPL: Probably not.  There are workarounds to ensure your project and the GPl'd project are considered separate projects, but you're probably going to want to talk to a lawyer to make sure you get it right.

GPL + MIT: Yes! For the same reasons MIT licensed code can be used in a closed source project: the MIT license is permissive and has few restrictions. Note that while the dependency is licensed MIT, the combined work of your project and the dependency is distributed under the GPL, because that's what the GPL requires.  (I did say licences were complicated.)

GPL + GPL: Yes! Two pieces of code with the same licence is rarely a problem because they have the same terms which are unlikely to conflict.

MIT + MIT: Double yes! They're the same licence, and the MIT licence is very permissive.

MIT + GPL: Probably not, for the same reasons it's difficult to include a GPL'd dependency in a closed source project. The GPL requires that derivatives be licensed under the GPL as well.  You could license your project GPL, but if you want to retain the MIT license it requires the same sorts of careful separation from the less-restrictive MIT license to prevent the GPL's viral nature from overriding it.  You're probably going to want to consult a lawyer.


### Common questions

There's a couple things that always come up when discussing licences.

Can you use code on Github?  By default, code on Github falls under unlicensed and you can't use it.  The copyright holder has given Github the rights to display the code and a few other things like forking, but that doesn't mean you can use it.  However, many repos have licences, and you can use that code under the terms of the licence.  In short: check!

What about Stack Overflow?  Stack Overflow is complicated. User contributions are licensed [CC-BY-SA], which is a copyleft licence for non-code works.  However, it's not clear that Creative Commons licences can apply to code.  Usually the text is licensed under CC and the code is separately licensed under a software license.  Stack Overflow [discussed] licensing code under the MIT license (or a modified MIT license), but it [failed to happen] because of community push back over the suitability of the license for tiny snippets, whole programs and code in questions. This is also complicated by the fact that not all snippets of code are big enough to be covered by copyright. To be covered by copyright, and therefore be licensable, it has to be creative. Since many small snippets of code are common ways of doing things and not creative, copyright may not apply.  Overall, it's a very awkward situation. I won't make a recommendation, but I will admit I use SO for inspiration and reference.

[CC-BY-SA]: https://creativecommons.org/licenses/by-sa/3.0/
[discussed]: https://meta.stackexchange.com/questions/271080/the-mit-license-clarity-on-using-code-on-stack-overflow-and-stack-exchange
[failed to happen]: https://meta.stackexchange.com/questions/272956/a-new-code-license-the-mit-this-time-with-attribution-required

### Conclusion

There's a few things I hope you remember from this.

* Software licences are fantastic! They allow you to use other people's code and allow others to use your code, enabling the whole open source community.
* Software licences are also complicated
* Permissive open source licences are simple, straightforward and easy to use
* Copyleft open source licences take a strong ethical stance.  It doesn't want code being used without contributing back to the community.

But most of all, **remember to check the licence!** Just because code is on the internet doesn't mean you can use it.

</section>

[^1]:
    When making this talk I got to learn the difference between licence (with a c) and license (with an s).  In American English, they only use license.  In non-American English, licence is the noun (think advi**c**e) and license is the verb (think advi**s**e).  [Grammarist](http://grammarist.com/spelling/licence-license/) has a good explanation.
