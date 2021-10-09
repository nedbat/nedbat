<!--

Process this file with cog:

    $ python -m pip install -r requirements.pip
    $ python -m cogapp -r README.md

-->

## Hi, I'm Ned

I'm a Python software developer and community organizer.

- My personal site is https://nedbatchelder.com.
- I work at [edX](https://edx.org) on [Open edX](https://openedx.org).
- I'm an organizer of [Boston Python][bp].

You can find me at:

- I'm [@nedbat on Twitter][twitter].
- On [Libera IRC][libera], I'm nedbat in #python.
- I'm sometimes in the [Python Discord][discord].

Recent [blog posts][blog]:

<!-- [[[cog
    import datetime
    import cog
    import requests

    data = requests.get("https://nedbatchelder.com/summary.json").json()
    for entry in data["entries"][:3]:
        when = datetime.datetime.strptime(entry['when_iso'], "%Y%m%d")
        cog.out(f"- **[{entry['title']}]({entry['url']})** ({when:%-d %b %Y}): ")
        cog.out(f"{entry['description_text']} *([read..]({entry['url']}))*")
        cog.outl()
    # Have to print this from in here to get the spacing right.
    cog.outl("- and [many more][blog]..")
]]] -->
- **[Coverage 6.0](https://nedbatchelder.com/blog/202110/coverage_60.html)** (4 Oct 2021): Coverage.py 6.0 is now available. It’s a major version bump for two reasons: *([read..](https://nedbatchelder.com/blog/202110/coverage_60.html))*
- **[300 walks](https://nedbatchelder.com/blog/202109/300_walks.html)** (27 Sep 2021): I’ve been continuing the walking I described in Pandemic walks, and have now completed 300 such walks, 1648 miles. Walking new streets every day, but from the same point, actually means walking a lot of the same streets every day. *([read..](https://nedbatchelder.com/blog/202109/300_walks.html))*
- **[Real Django site](https://nedbatchelder.com/blog/202109/real_django_site.html)** (13 Sep 2021): Big changes behind the scenes here at nedbatchelder.com, but only a small change for you. *([read..](https://nedbatchelder.com/blog/202109/real_django_site.html))*
- **[Me on Bug Hunters Café](https://nedbatchelder.com/blog/202108/me_on_bug_hunters_caf.html)** (23 Aug 2021): I was a guest on the Bug Hunters Café podcast: episode #12, The Café Within. *([read..](https://nedbatchelder.com/blog/202108/me_on_bug_hunters_caf.html))*
- and [many more][blog]..
<!-- [[[end]]] -->

[twitter]: https://twitter.com/nedbat
[discord]: https://pythondiscord.com
[blog]: https://nedbatchelder.com/blog
[libera]: https://libera.chat
[bp]: https://bostonpython.com
