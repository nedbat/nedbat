<!--

Process this file with cog:

    $ python -m pip install -r requirements.pip
    $ python -m cogapp -rP README.md

Helpful sites:
https://tinypng.com/
https://onlinepngtools.com/convert-png-to-data-uri

-->

<!-- [[[cog
    import datetime
    import os
    import sys
    import time
    from urllib.parse import quote, urlencode

    import requests

    def requests_get_json(url):
        """Get JSON data from a URL, with retries."""
        headers = {}
        token = os.environ.get("GITHUB_TOKEN", "")
        if token:
            headers["Authorization"] = f"Bearer {token}"

        for _ in range(3):
            resp = requests.get(url, headers=headers)
            if resp.status_code == 200:
                break
            print(f"{resp.status_code} from {url}:", file=sys.stderr)
            print(resp.text, file=sys.stderr)
            time.sleep(1)
        else:
            raise Exception(f"Couldn't get data from {url}")
        return resp.json()

    def rounded_nice(n):
        """Make a good human-readable summary of a number: 1734 -> "1.7k"."""
        n = int(n)
        ndigits = len(str(n))
        if ndigits <= 3:
            return str(n)
        elif 3 < ndigits <= 4:
            return f"{round(n/1000, 1):.1f}k"
        elif 4 < ndigits <= 6:
            return f"{round(n/1000):d}k"
        elif 6 < ndigits <= 7:
            return f"{round(n/1_000_000, 1):.1f}M"
        elif 7 < ndigits <= 9:
            return f"{round(n/1_000_000):d}M"

    def shields_url(
        url=None,
        label=None,
        message=None,
        color=None,
        label_color=None,
        logo=None,
        logo_color=None,
        link=None,
        qargs=None,
        **kwargs, # play fast and loose with arguments.
    ):
        params = {"style": "flat"}
        if url is None:
            url = "".join([
                "/badge/",
                quote(label or ""),
                "-",
                quote(message),
                "-",
                color,
                ])
        else:
            if label:
                params["label"] = label
        url = "https://img.shields.io" + url
        if label_color:
            params["labelColor"] = label_color
        if logo:
            params["logo"] = logo
        if logo_color:
            params["logoColor"] = logo_color
        if link:
            params["link"] = link
        if qargs:
            params.update(qargs)
        return url + "?" + urlencode(params)

    def md_image(src, text, link):
        return f'[![{text}]({src} "{text}")]({link})'

    def md_badge(**kwargs):
        return md_image(src=shields_url(**kwargs), text=kwargs["text"], link=kwargs["link"])

    def md_dynamic_badge(url, query, **kwargs):
        qargs = {
            "url": url,
            "query": query,
            "label": kwargs.pop("label"),
        }
        return md_badge(url="/badge/dynamic/json", qargs=qargs, **kwargs)

    def md_badge_mastodon(server, handle):
        # from: https://github.com/badges/shields/issues/4492#issuecomment-1297165535
        url = f"https://{server}/users/{handle}/followers.json"
        followers = requests_get_json(url)["totalItems"]
        return md_badge(
            message=rounded_nice(followers),
            label=f"@{handle}", logo="mastodon", color="96a3b0", label_color="450657", logo_color="ffffff",
            text=f"Follow @{handle} on Mastodon", link=f"https://{server}/@{handle}",
        )

    pencil_icon = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX///////////////////8AAAD///////////8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY/Pz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA+Pj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9+w/18eoT7efLNCQeF/ny8u/k29nW08+3eHZYOi8rKCMgGxkH+vXz7Ofk4t/c1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8+Ozs3NjEtLB0aCwr+9Orq6OXi09LMxr+/u7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL+zUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q+RBlnOZ003G446SrTmX0tQskO6b/V4cjtKm8BGNxWzr76BljKyZWrGBq20/f0GWijAEcZB1z/k3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE/XAo2QTcU7Hf/4Y3ONuIzCudgcTP+v0GDdVUzbX3cC4iVQT5esm073+ruIo46bSvZSfe5rpJV83yLjnupfUtvA+bp1HGPdSuzC5nczmXjuz5h/vjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW/WtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3/6tTrLV/0uqJT3BdeuOJYOsg7/hWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3+k4+gaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N+/rmoX+IVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH/0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY/JUtZ19NxSGMKQE1LI6L3N4TM+cBMRl8J7NE/0UXaBcUfNslsUwm0/LXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh/gEMt7c2Kju6aAAAAABJRU5ErkJggg=="
    
    print("")   # force a rebuild
]]] -->

<!-- [[[end]]] -->

I'm **Ned Batchelder**, a Python software developer and community organizer.

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://vshymanskyy.github.io/StandWithUkraine)


<!-- [[[cog
print(md_badge(
    logo=pencil_icon, logo_color="white", label_color="eeeeee", message="Blog etc", color="888888", 
    text="Read my blog", link="https://nedbatchelder.com",
))
print(md_badge_mastodon("hachyderm.io", "nedbat"))
print(md_badge(
    logo="meetup", logo_color="red", label_color="eeeeee", message="Boston Python", color="4d7954",
    text="Join us at Boston Python", link="https://about.bostonpython.com",
))
print(md_badge(
    logo="discord", logo_color="white", label_color="7289da", message="Discord", color="ffe97c",
    text="Python Discord", link="https://discord.gg/python",
))
print(md_badge(
    logo="GitHub", label="\N{HEAVY BLACK HEART}", message="Sponsor me", color="brightgreen",
    text="Sponsor me on GitHub", link="https://github.com/sponsors/nedbat",
))
so_data = requests_get_json("https://api.stackexchange.com/2.3/users/14343?order=desc&sort=reputation&site=stackoverflow")["items"][0]
repk = rounded_nice(so_data["reputation"])
gold = rounded_nice(so_data["badge_counts"]["gold"])
silver = rounded_nice(so_data["badge_counts"]["silver"])
bronze = rounded_nice(so_data["badge_counts"]["bronze"])
print(md_badge(
    logo="stackoverflow", logo_color=None, label_color="333333", message=f"{repk} 🟡\u2009{gold} ⚪\u2009{silver} 🟤\u2009{bronze}", color="e6873e",
    text="Stack Overflow reputation", link=so_data["link"],
))
print(md_badge(
    logo="python", logo_color="FFE873", label_color="306998", message="PyPI packages", color="4B8BBE",
    text="My PyPI packages", link="https://pypi.org/user/nedbatchelder",
))
]]] -->
[![Read my blog](https://img.shields.io/badge/-Blog%20etc-888888?style=flat&labelColor=eeeeee&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY%2FPz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA%2BPj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9%2Bw%2F18eoT7efLNCQeF%2Fny8u%2Fk29nW08%2B3eHZYOi8rKCMgGxkH%2BvXz7Ofk4t%2Fc1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8%2BOzs3NjEtLB0aCwr%2B9Orq6OXi09LMxr%2B%2Fu7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL%2BzUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q%2BRBlnOZ003G446SrTmX0tQskO6b%2FV4cjtKm8BGNxWzr76BljKyZWrGBq20%2Ff0GWijAEcZB1z%2Fk3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE%2FXAo2QTcU7Hf%2F4Y3ONuIzCudgcTP%2Bv0GDdVUzbX3cC4iVQT5esm073%2BruIo46bSvZSfe5rpJV83yLjnupfUtvA%2Bbp1HGPdSuzC5nczmXjuz5h%2FvjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW%2FWtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3%2F6tTrLV%2F0uqJT3BdeuOJYOsg7%2FhWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3%2Bk4%2BgaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N%2B%2FrmoX%2BIVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH%2F0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY%2FJUtZ19NxSGMKQE1LI6L3N4TM%2BcBMRl8J7NE%2F0UXaBcUfNslsUwm0%2FLXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh%2FgEMt7c2Kju6aAAAAABJRU5ErkJggg%3D%3D&logoColor=white&link=https%3A%2F%2Fnedbatchelder.com "Read my blog")](https://nedbatchelder.com)
[![Follow @nedbat on Mastodon](https://img.shields.io/badge/%40nedbat-2.6k-96a3b0?style=flat&labelColor=450657&logo=mastodon&logoColor=ffffff&link=https%3A%2F%2Fhachyderm.io%2F%40nedbat "Follow @nedbat on Mastodon")](https://hachyderm.io/@nedbat)
[![Join us at Boston Python](https://img.shields.io/badge/-Boston%20Python-4d7954?style=flat&labelColor=eeeeee&logo=meetup&logoColor=red&link=https%3A%2F%2Fabout.bostonpython.com "Join us at Boston Python")](https://about.bostonpython.com)
[![Python Discord](https://img.shields.io/badge/-Discord-ffe97c?style=flat&labelColor=7289da&logo=discord&logoColor=white&link=https%3A%2F%2Fdiscord.gg%2Fpython "Python Discord")](https://discord.gg/python)
[![Sponsor me on GitHub](https://img.shields.io/badge/%E2%9D%A4-Sponsor%20me-brightgreen?style=flat&logo=GitHub&link=https%3A%2F%2Fgithub.com%2Fsponsors%2Fnedbat "Sponsor me on GitHub")](https://github.com/sponsors/nedbat)
[![Stack Overflow reputation](https://img.shields.io/badge/-366k%20%F0%9F%9F%A1%E2%80%8975%20%E2%9A%AA%E2%80%89565%20%F0%9F%9F%A4%E2%80%89663-e6873e?style=flat&labelColor=333333&logo=stackoverflow&link=https%3A%2F%2Fstackoverflow.com%2Fusers%2F14343%2Fned-batchelder "Stack Overflow reputation")](https://stackoverflow.com/users/14343/ned-batchelder)
[![My PyPI packages](https://img.shields.io/badge/-PyPI%20packages-4B8BBE?style=flat&labelColor=306998&logo=python&logoColor=FFE873&link=https%3A%2F%2Fpypi.org%2Fuser%2Fnedbatchelder "My PyPI packages")](https://pypi.org/user/nedbatchelder)
<!-- [[[end]]] -->


- My personal site is [https://nedbatchelder.com][nedbat].
- I work at [2U/edX](https://edx.org) on the [Open edX project](https://openedx.org).
- I'm an organizer of [Boston Python][bp].

You can **find me** at:

- Mastodon: [@nedbat@nedbat.com][mastodon].
- [Libera IRC][libera]: nedbat in #python.
- Discord: nedbat in the [Python Discord][discord].

<!--
  ##
  ## BLOG POSTS
  ##
  -->

<!-- [[[cog
    blogdata = requests_get_json("https://nedbatchelder.com/summary.json")

    def write_blog_post(entry, twoline=False):
        when = datetime.datetime.strptime(entry['when_iso'], "%Y%m%d")
        print(f"- **[{entry['title']}]({entry['url']})**, {when:%-d %b}", end="")
        if twoline:
            # Two trailing spaces make a line break in Markdown.
            print(f"  \n{entry['description_text']} *([read..]({entry['url']}))*")
        else:
            print()
]]] -->
<!-- [[[end]]] -->

My latest **[blog][blog]** posts:

<!-- [[[cog
    N_ENTRIES = 4
    entries = blogdata["entries"][:N_ENTRIES]
    for entry in entries:
        write_blog_post(entry, twoline=True)
    print("- and [many more][blog]..")
]]] -->
- **[Where did everyone go?](https://nedbatchelder.com/blog/202310/where_did_everyone_go.html)**, 21 Oct  
It’s been nearly a year since Elon Musk bought and started ruining Twitter. Since then, I’ve been on Mastodon and Bluesky, and I’ve started watching a bunch of RSS feeds I relied on in the days before Twitter. *([read..](https://nedbatchelder.com/blog/202310/where_did_everyone_go.html))*
- **[The myth of the myth of learning styles](https://nedbatchelder.com/blog/202309/the_myth_of_the_myth_of_learning_styles.html)**, 23 Sep  
“Four different learning styles” has been debunked, but learners still have to learn how they learn, and choose the paths and materials that are right for them. *([read..](https://nedbatchelder.com/blog/202309/the_myth_of_the_myth_of_learning_styles.html))*
- **[Advice to beginners](https://nedbatchelder.com/blog/202309/advice_to_beginners.html)**, 17 Sep  
I often see questions like, “I’m just starting to learn Python, any advice?” The expected answer is something like “watch this video,” or, “here’s an awesome tutorial,” but more important are some tips about how to learn technology in general. Here are mine: *([read..](https://nedbatchelder.com/blog/202309/advice_to_beginners.html))*
- **[Hammerspoon](https://nedbatchelder.com/blog/202308/hammerspoon.html)**, 27 Aug  
For a long time now I’ve displayed a small textual info box in the otherwise unused upper-left corner of my mac screen. It was originally based on GeekTool, but a new laptop got me to re-think it, and now it’s implemented with Hammerspoon. *([read..](https://nedbatchelder.com/blog/202308/hammerspoon.html))*
- and [many more][blog]..
<!-- [[[end]]] -->

<!--
  ##
  ## PYPI PACKAGES
  ##
  -->

<!-- [[[cog
    pkgs = [
        # (pypi name, human name, github repo, (mastserver, masthandle)),
        ("coverage", "Coverage.py", "nedbat/coveragepy", ("hachyderm.io", "coveragepy")),
        ("cogapp", "Cog", "nedbat/cog"),
        ("dinghy", "Dinghy", "nedbat/dinghy"),
        ("scriv", "Scriv", "nedbat/scriv"),
        ("watchgha", "WatchGHA", "nedbat/watchgha"),
        ("aptus", "Aptus", "nedbat/aptus"),
    ]

    def write_package(pkg, human, repo, mastinfo=None):
        description = requests_get_json(f"https://api.github.com/repos/{repo}")["description"]
        print(f'- [**{human}**](https://github.com/{repo}): {description}  ') # trailing spaces for Markdown line break...
        print(f'  [![PyPI](https://img.shields.io/pypi/v/{pkg}?style=flat "The {pkg} PyPI page")](https://pypi.org/project/{pkg})')
        print(f'  [![GitHub last commit](https://img.shields.io/github/last-commit/{repo}?logo=github&style=flat "Recent {human.lower()} commits")](https://github.com/{repo}/commits)')
        print(f'  [![PyPI - Downloads](https://img.shields.io/pypi/dm/{pkg}?style=flat "Download stats for {pkg}")](https://pypistats.org/packages/{pkg})')
        if mastinfo is not None:
            print('  ', md_badge_mastodon(*mastinfo), sep='')
]]] -->
<!-- [[[end]]] -->

I maintain a few [**Python packages**][ned_pypi], including:

<!-- [[[cog
    for args in pkgs:
        write_package(*args)
]]] -->
- [**Coverage.py**](https://github.com/nedbat/coveragepy): The code coverage tool for Python  
  [![PyPI](https://img.shields.io/pypi/v/coverage?style=flat "The coverage PyPI page")](https://pypi.org/project/coverage)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/coveragepy?logo=github&style=flat "Recent coverage.py commits")](https://github.com/nedbat/coveragepy/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/coverage?style=flat "Download stats for coverage")](https://pypistats.org/packages/coverage)
  [![Follow @coveragepy on Mastodon](https://img.shields.io/badge/%40coveragepy-126-96a3b0?style=flat&labelColor=450657&logo=mastodon&logoColor=ffffff&link=https%3A%2F%2Fhachyderm.io%2F%40coveragepy "Follow @coveragepy on Mastodon")](https://hachyderm.io/@coveragepy)
- [**Cog**](https://github.com/nedbat/cog): Small bits of Python computation for static files  
  [![PyPI](https://img.shields.io/pypi/v/cogapp?style=flat "The cogapp PyPI page")](https://pypi.org/project/cogapp)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/cog?logo=github&style=flat "Recent cog commits")](https://github.com/nedbat/cog/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/cogapp?style=flat "Download stats for cogapp")](https://pypistats.org/packages/cogapp)
- [**Dinghy**](https://github.com/nedbat/dinghy): A GitHub activity digest tool  
  [![PyPI](https://img.shields.io/pypi/v/dinghy?style=flat "The dinghy PyPI page")](https://pypi.org/project/dinghy)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/dinghy?logo=github&style=flat "Recent dinghy commits")](https://github.com/nedbat/dinghy/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/dinghy?style=flat "Download stats for dinghy")](https://pypistats.org/packages/dinghy)
- [**Scriv**](https://github.com/nedbat/scriv): Changelog management tool  
  [![PyPI](https://img.shields.io/pypi/v/scriv?style=flat "The scriv PyPI page")](https://pypi.org/project/scriv)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/scriv?logo=github&style=flat "Recent scriv commits")](https://github.com/nedbat/scriv/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/scriv?style=flat "Download stats for scriv")](https://pypistats.org/packages/scriv)
- [**WatchGHA**](https://github.com/nedbat/watchgha): Live display of current GitHub action runs  
  [![PyPI](https://img.shields.io/pypi/v/watchgha?style=flat "The watchgha PyPI page")](https://pypi.org/project/watchgha)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/watchgha?logo=github&style=flat "Recent watchgha commits")](https://github.com/nedbat/watchgha/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/watchgha?style=flat "Download stats for watchgha")](https://pypistats.org/packages/watchgha)
- [**Aptus**](https://github.com/nedbat/aptus): Mandelbrot fractal viewer  
  [![PyPI](https://img.shields.io/pypi/v/aptus?style=flat "The aptus PyPI page")](https://pypi.org/project/aptus)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/aptus?logo=github&style=flat "Recent aptus commits")](https://github.com/nedbat/aptus/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/aptus?style=flat "Download stats for aptus")](https://pypistats.org/packages/aptus)
<!-- [[[end]]] -->

<!--
  ##
  ## OTHER PROJECTS
  ##
  -->

I've also made a few informal projects, some mathy art, some small utilities:

- [Flourish](https://github.com/nedbat/flourish) is a harmonograph explorer.
  [Blog post](https://nedbatchelder.com/blog/202101/flourish.html) and [live site](https://flourish.nedbat.com/).
- [Stilted](https://github.com/nedbat/stilted) is a toy PostScript implementation.
  [Blog post](https://nedbatchelder.com/blog/202208/stilted.html).
- [Truchet images](https://github.com/nedbat/truchet) explores Truchet tiles, and rendering images with them.
  [Blog post](https://nedbatchelder.com/blog/202208/truchet_images.html).
- [Gefilte Fish](https://github.com/nedbat/gefilte) is a Python-based DSL for writing Gmail filters.
  [Blog post](https://nedbatchelder.com/blog/202103/gefilte_fish_gmail_filter_creation.html).
- [Pydoctor](https://github.com/nedbat/pydoctor) shows details of your Python environment, for troubleshooting.
- [pkgsample](https://github.com/nedbat/pkgsample), an simple example of how to package a Python project.

<!--
  ##
  ## FOOTER
  ##
  -->

<br/>
<br/>

<!-- [[[cog
    import datetime
    when = f"{datetime.datetime.now():%Y-%m-%d %H:%M}"
    print(f"*(made with [cog](https://github.com/nedbat/cog) at {when} UTC)*")
]]] -->
*(made with [cog](https://github.com/nedbat/cog) at 2023-10-22 13:26 UTC)*
<!-- [[[end]]] -->

[nedbat]: https://nedbatchelder.com
[blog]: https://nedbatchelder.com/blog
[mastodon]: https://hachyderm.io/@nedbat
[discord]: https://pythondiscord.com
[libera]: https://libera.chat
[bp]: https://bostonpython.com
[ned_pypi]: https://pypi.org/user/nedbatchelder
