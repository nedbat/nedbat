<!--

Process this file with cog:

    $ python -m pip install -r requirements.pip
    $ python -m cogapp -r README.md

-->

## Hi, I'm Ned

I'm a Python software developer and community organizer.

- My personal site is **[nedbatchelder.com][nedbat]**.
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
- **[Computing a GitHub Action matrix with cog](https://nedbatchelder.com/blog/202111/github_action_matrix_with_cog.html)** (7 Nov 2021): Here’s how I used embedded Python code to generate a complex GitHub Action matrix. *([read..](https://nedbatchelder.com/blog/202111/github_action_matrix_with_cog.html))*
- **[Coverage goals](https://nedbatchelder.com/blog/202111/coverage_goals.html)** (1 Nov 2021): There’s a feature request to add a per-file threshold to coverage.py. I didn’t add the feature, I wrote a proof-of-concept: goals.py. *([read..](https://nedbatchelder.com/blog/202111/coverage_goals.html))*
- **[Django Chat podcast](https://nedbatchelder.com/blog/202110/django_chat_podcast.html)** (13 Oct 2021): I had a fun conversation on the Django Chat podcast with Will Vincent and Carlton Gibson. It was a great discussion. *([read..](https://nedbatchelder.com/blog/202110/django_chat_podcast.html))*
- and [many more][blog]..
<!-- [[[end]]] -->

[nedbat]: https://nedbatchelder.com
[blog]: https://nedbatchelder.com/blog
[twitter]: https://twitter.com/nedbat
[discord]: https://pythondiscord.com
[libera]: https://libera.chat
[bp]: https://bostonpython.com
