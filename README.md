<!--

Process this file with cog:

    $ python -m pip install -r requirements.pip
    $ python -m cogapp -rP README.md

Helpful sites:
https://tinypng.com/
https://onlinepngtools.com/convert-png-to-data-uri

-->

<!-- [[[cog
    from urllib.parse import quote, urlencode

    def shields_url(
        label=None,
        message=None,
        color=None,
        label_color=None,
        logo=None,
        logo_color=None,
        link=None,
        **kwargs, # play fast and loose with arguments.
    ):
        url = "".join([
            "https://img.shields.io/badge/",
            quote(label or ""),
            "-",
            quote(message),
            "-",
            color,
            ])
        params = {"style": "flat"}
        if label_color:
            params["labelColor"] = label_color
        if logo:
            params["logo"] = logo
        if logo_color:
            params["logoColor"] = logo_color
        if link:
            params["link"] = link
        return url + "?" + urlencode(params)

    def md_image(src, text, link):
        return f'[![{text}]({src} "{text}")]({link})'

    def md_badge(**kwargs):
        return md_image(src=shields_url(**kwargs), text=kwargs["text"], link=kwargs["link"])

    pencil_icon = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX///////////////////8AAAD///////////8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY/Pz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA+Pj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9+w/18eoT7efLNCQeF/ny8u/k29nW08+3eHZYOi8rKCMgGxkH+vXz7Ofk4t/c1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8+Ozs3NjEtLB0aCwr+9Orq6OXi09LMxr+/u7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL+zUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q+RBlnOZ003G446SrTmX0tQskO6b/V4cjtKm8BGNxWzr76BljKyZWrGBq20/f0GWijAEcZB1z/k3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE/XAo2QTcU7Hf/4Y3ONuIzCudgcTP+v0GDdVUzbX3cC4iVQT5esm073+ruIo46bSvZSfe5rpJV83yLjnupfUtvA+bp1HGPdSuzC5nczmXjuz5h/vjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW/WtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3/6tTrLV/0uqJT3BdeuOJYOsg7/hWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3+k4+gaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N+/rmoX+IVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH/0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY/JUtZ19NxSGMKQE1LI6L3N4TM+cBMRl8J7NE/0UXaBcUfNslsUwm0/LXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh/gEMt7c2Kju6aAAAAABJRU5ErkJggg=="
]]] -->
<!-- [[[end]]] -->

I'm **Ned Batchelder**, a Python software developer and community organizer.

<!-- [[[cog
print(md_badge(
    logo="GitHub", label="\N{HEAVY BLACK HEART}", message="Sponsor me", color="brightgreen",
    text="Sponsor me on GitHub", link="https://github.com/sponsors/nedbat",
))
print(md_badge(
    logo="twitter", logo_color="white", label_color="1ca0f1", message="@nedbat", color="9ddcf7", 
    text="Follow me on Twitter", link="https://twitter.com/nedbat",
))
print(md_badge(
    logo=pencil_icon, logo_color="white", label_color="eeeeee", message="Blog etc", color="888888", 
    text="Read my blog", link="https://nedbatchelder.com",
))
print(md_badge(
    logo="meetup", logo_color="red", label_color="eeeeee", message="Boston Python", color="4d7954",
    text="Join us at Boston Python", link="https://about.bostonpython.com",
))
print(md_badge(
    logo="discord", logo_color="white", label_color="7289da", message="Discord", color="ffe97c",
    text="Python Discord", link="https://discord.gg/python",
))
print(md_badge(
    logo="python", logo_color="FFE873", label_color="306998", message="PyPI packages", color="4B8BBE",
    text="My PyPI packages", link="https://pypi.org/user/nedbatchelder",
))
]]] -->
[![Sponsor me on GitHub](https://img.shields.io/badge/%E2%9D%A4-Sponsor%20me-brightgreen?style=flat&logo=GitHub&link=https%3A%2F%2Fgithub.com%2Fsponsors%2Fnedbat "Sponsor me on GitHub")](https://github.com/sponsors/nedbat)
[![Follow me on Twitter](https://img.shields.io/badge/-%40nedbat-9ddcf7?style=flat&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https%3A%2F%2Ftwitter.com%2Fnedbat "Follow me on Twitter")](https://twitter.com/nedbat)
[![Read my blog](https://img.shields.io/badge/-Blog%20etc-888888?style=flat&labelColor=eeeeee&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY%2FPz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA%2BPj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9%2Bw%2F18eoT7efLNCQeF%2Fny8u%2Fk29nW08%2B3eHZYOi8rKCMgGxkH%2BvXz7Ofk4t%2Fc1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8%2BOzs3NjEtLB0aCwr%2B9Orq6OXi09LMxr%2B%2Fu7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL%2BzUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q%2BRBlnOZ003G446SrTmX0tQskO6b%2FV4cjtKm8BGNxWzr76BljKyZWrGBq20%2Ff0GWijAEcZB1z%2Fk3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE%2FXAo2QTcU7Hf%2F4Y3ONuIzCudgcTP%2Bv0GDdVUzbX3cC4iVQT5esm073%2BruIo46bSvZSfe5rpJV83yLjnupfUtvA%2Bbp1HGPdSuzC5nczmXjuz5h%2FvjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW%2FWtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3%2F6tTrLV%2F0uqJT3BdeuOJYOsg7%2FhWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3%2Bk4%2BgaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N%2B%2FrmoX%2BIVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH%2F0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY%2FJUtZ19NxSGMKQE1LI6L3N4TM%2BcBMRl8J7NE%2F0UXaBcUfNslsUwm0%2FLXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh%2FgEMt7c2Kju6aAAAAABJRU5ErkJggg%3D%3D&logoColor=white&link=https%3A%2F%2Fnedbatchelder.com "Read my blog")](https://nedbatchelder.com)
[![Join us at Boston Python](https://img.shields.io/badge/-Boston%20Python-4d7954?style=flat&labelColor=eeeeee&logo=meetup&logoColor=red&link=https%3A%2F%2Fabout.bostonpython.com "Join us at Boston Python")](https://about.bostonpython.com)
[![Python Discord](https://img.shields.io/badge/-Discord-ffe97c?style=flat&labelColor=7289da&logo=discord&logoColor=white&link=https%3A%2F%2Fdiscord.gg%2Fpython "Python Discord")](https://discord.gg/python)
[![My PyPI packages](https://img.shields.io/badge/-PyPI%20packages-4B8BBE?style=flat&labelColor=306998&logo=python&logoColor=FFE873&link=https%3A%2F%2Fpypi.org%2Fuser%2Fnedbatchelder "My PyPI packages")](https://pypi.org/user/nedbatchelder)
<!-- [[[end]]] -->

- My personal site is [https://nedbatchelder.com][nedbat].
- I work at [edX](https://edx.org) on [Open edX](https://openedx.org).
- I'm an organizer of [Boston Python][bp].

You can find me at:

- I'm [@nedbat on Twitter][twitter].
- On [Libera IRC][libera], I'm nedbat in #python.
- I'm sometimes in the [Python Discord][discord].

<details>
<summary><b>Blog posts</b></summary>

<br/>Recent [blog posts][blog]:

<!-- [[[cog
    import datetime
    import requests

    data = requests.get("https://nedbatchelder.com/summary.json").json()
    for entry in data["entries"][:4]:
        when = datetime.datetime.strptime(entry['when_iso'], "%Y%m%d")
        # Two trailing spaces make a line break in Markdown.
        print(f"- **[{entry['title']}]({entry['url']})**, {when:%-d %b %Y}  ")
        print(f"{entry['description_text']} *([read..]({entry['url']}))*")
    # Have to print this from in here to get the spacing right.
    print("- and [many more][blog]..")
]]] -->
- **[Load-balanced xdist](https://nedbatchelder.com/blog/202112/loadbalanced_xdist.html)**, 11 Dec 2021  
I wrote a pytest plugin to evenly balance tests across xdist workers. *([read..](https://nedbatchelder.com/blog/202112/loadbalanced_xdist.html))*
- **[Computing a GitHub Action matrix with cog](https://nedbatchelder.com/blog/202111/github_action_matrix_with_cog.html)**, 7 Nov 2021  
Here’s how I used embedded Python code to generate a complex GitHub Action matrix. *([read..](https://nedbatchelder.com/blog/202111/github_action_matrix_with_cog.html))*
- **[Coverage goals](https://nedbatchelder.com/blog/202111/coverage_goals.html)**, 1 Nov 2021  
There’s a feature request to add a per-file threshold to coverage.py. I didn’t add the feature, I wrote a proof-of-concept: goals.py. *([read..](https://nedbatchelder.com/blog/202111/coverage_goals.html))*
- **[Django Chat podcast](https://nedbatchelder.com/blog/202110/django_chat_podcast.html)**, 13 Oct 2021  
I had a fun conversation on the Django Chat podcast with Will Vincent and Carlton Gibson. It was a great discussion. *([read..](https://nedbatchelder.com/blog/202110/django_chat_podcast.html))*
- and [many more][blog]..
<!-- [[[end]]] -->

</details>

<details>
<summary><b>My Python packages</b></summary>

<br/>I maintain [a few Python packages][ned_pypi], including:

<!-- [[[cog
    pkgs = {
        # pypi name: (human name, github repo, description),
        "coverage": ("Coverage.py", "nedbat/coveragepy", "the code coverage tool for Python"),
        "scriv": ("Scriv", "nedbat/scriv", "changelog generator"),
        "cogapp": ("Cog", "nedbat/cog", "small bits of computation for static files"),
        "aptus": ("Aptus", "nedbat/aptus", "Mandelbrot fractal viewer"),
    }
    for pkg, (human, repo, description) in pkgs.items():
        print(f'- [**{human}**](https://github.com/{repo}): {description}  ')
        print(f'  [![PyPI](https://img.shields.io/pypi/v/{pkg}?style=flat "The {pkg} PyPI page")](https://pypi.org/project/{pkg})')
        print(f'  [![GitHub last commit](https://img.shields.io/github/last-commit/{repo}?logo=github&style=flat "Recent {human.lower()} commits")](https://github.com/{repo}/commits)')
        print(f'  [![PyPI - Downloads](https://img.shields.io/pypi/dm/{pkg}?style=flat "Download stats for {pkg}")](https://pypistats.org/packages/{pkg})')
]]] -->
- [**Coverage.py**](https://github.com/nedbat/coveragepy): the code coverage tool for Python  
  [![PyPI](https://img.shields.io/pypi/v/coverage?style=flat "The coverage PyPI page")](https://pypi.org/project/coverage)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/coveragepy?logo=github&style=flat "Recent coverage.py commits")](https://github.com/nedbat/coveragepy/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/coverage?style=flat "Download stats for coverage")](https://pypistats.org/packages/coverage)
- [**Scriv**](https://github.com/nedbat/scriv): changelog generator  
  [![PyPI](https://img.shields.io/pypi/v/scriv?style=flat "The scriv PyPI page")](https://pypi.org/project/scriv)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/scriv?logo=github&style=flat "Recent scriv commits")](https://github.com/nedbat/scriv/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/scriv?style=flat "Download stats for scriv")](https://pypistats.org/packages/scriv)
- [**Cog**](https://github.com/nedbat/cog): small bits of computation for static files  
  [![PyPI](https://img.shields.io/pypi/v/cogapp?style=flat "The cogapp PyPI page")](https://pypi.org/project/cogapp)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/cog?logo=github&style=flat "Recent cog commits")](https://github.com/nedbat/cog/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/cogapp?style=flat "Download stats for cogapp")](https://pypistats.org/packages/cogapp)
- [**Aptus**](https://github.com/nedbat/aptus): Mandelbrot fractal viewer  
  [![PyPI](https://img.shields.io/pypi/v/aptus?style=flat "The aptus PyPI page")](https://pypi.org/project/aptus)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/aptus?logo=github&style=flat "Recent aptus commits")](https://github.com/nedbat/aptus/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/aptus?style=flat "Download stats for aptus")](https://pypistats.org/packages/aptus)
<!-- [[[end]]] -->

</details>

[nedbat]: https://nedbatchelder.com
[blog]: https://nedbatchelder.com/blog
[twitter]: https://twitter.com/nedbat
[discord]: https://pythondiscord.com
[libera]: https://libera.chat
[bp]: https://bostonpython.com
[ned_pypi]: https://pypi.org/user/nedbatchelder
