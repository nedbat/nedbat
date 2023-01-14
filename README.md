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
    import sys
    import time
    from urllib.parse import quote, urlencode

    import requests

    def requests_get_json(url):
        """Get JSON data from a URL, with retries."""
        for _ in range(3):
            resp = requests.get(url)
            if resp.status_code == 200:
                break
            print(f"{resp.status_code} from {url}:", file=sys.stderr)
            print(resp.text, file=sys.stderr)
            time.sleep(1)
        else:
            raise Exception(f"Couldn't get data from {url}")
        return resp.json()

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

    def md_badge_twitter(handle):
        return md_badge(
            url=f"/twitter/follow/{handle}.svg", label=f"@{handle}",
            logo="twitter", logo_color="white", label_color="1ca0f1",
            text=f"Follow @{handle} on Twitter", link=f"https://twitter.com/{handle}",
        )

    def md_dynamic_badge(url, query, **kwargs):
        qargs = {
            "url": url,
            "query": query,
            "label": kwargs.pop("label"),
        }
        return md_badge(url="/badge/dynamic/json", qargs=qargs, **kwargs)

    def md_badge_mastodon(server, handle):
        # from: https://github.com/badges/shields/issues/4492#issuecomment-1297165535
        return md_dynamic_badge(
            url=f"https://{server}/users/{handle}/followers.json", query="totalItems",
            label="Mastodon", logo="mastodon", color="b6c3d0", label_color="450657", logo_color="ffffff",
            text=f"Follow @{handle} on Mastodon", link=f"https://{server}/@{handle}",
        )

    pencil_icon = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX///////////////////8AAAD///////////8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY/Pz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA+Pj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9+w/18eoT7efLNCQeF/ny8u/k29nW08+3eHZYOi8rKCMgGxkH+vXz7Ofk4t/c1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8+Ozs3NjEtLB0aCwr+9Orq6OXi09LMxr+/u7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL+zUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q+RBlnOZ003G446SrTmX0tQskO6b/V4cjtKm8BGNxWzr76BljKyZWrGBq20/f0GWijAEcZB1z/k3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE/XAo2QTcU7Hf/4Y3ONuIzCudgcTP+v0GDdVUzbX3cC4iVQT5esm073+ruIo46bSvZSfe5rpJV83yLjnupfUtvA+bp1HGPdSuzC5nczmXjuz5h/vjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW/WtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3/6tTrLV/0uqJT3BdeuOJYOsg7/hWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3+k4+gaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N+/rmoX+IVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH/0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY/JUtZ19NxSGMKQE1LI6L3N4TM+cBMRl8J7NE/0UXaBcUfNslsUwm0/LXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh/gEMt7c2Kju6aAAAAABJRU5ErkJggg=="
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
print(md_badge_twitter("nedbat"))
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
repk = round(so_data["reputation"], -3) // 1000
gold = so_data["badge_counts"]["gold"]
silver = so_data["badge_counts"]["silver"]
bronze = so_data["badge_counts"]["bronze"]
print(md_badge(
    logo="stackoverflow", logo_color=None, label_color="333333", message=f"{repk}k 🟡\u2009{gold} ⚪\u2009{silver} 🟤\u2009{bronze}", color="e6873e",
    text="Stack Overflow reputation", link=so_data["link"],
))
print(md_badge(
    logo="python", logo_color="FFE873", label_color="306998", message="PyPI packages", color="4B8BBE",
    text="My PyPI packages", link="https://pypi.org/user/nedbatchelder",
))
]]] -->
[![Read my blog](https://img.shields.io/badge/-Blog%20etc-888888?style=flat&labelColor=eeeeee&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY%2FPz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA%2BPj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9%2Bw%2F18eoT7efLNCQeF%2Fny8u%2Fk29nW08%2B3eHZYOi8rKCMgGxkH%2BvXz7Ofk4t%2Fc1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8%2BOzs3NjEtLB0aCwr%2B9Orq6OXi09LMxr%2B%2Fu7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL%2BzUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q%2BRBlnOZ003G446SrTmX0tQskO6b%2FV4cjtKm8BGNxWzr76BljKyZWrGBq20%2Ff0GWijAEcZB1z%2Fk3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE%2FXAo2QTcU7Hf%2F4Y3ONuIzCudgcTP%2Bv0GDdVUzbX3cC4iVQT5esm073%2BruIo46bSvZSfe5rpJV83yLjnupfUtvA%2Bbp1HGPdSuzC5nczmXjuz5h%2FvjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW%2FWtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3%2F6tTrLV%2F0uqJT3BdeuOJYOsg7%2FhWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3%2Bk4%2BgaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N%2B%2FrmoX%2BIVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH%2F0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY%2FJUtZ19NxSGMKQE1LI6L3N4TM%2BcBMRl8J7NE%2F0UXaBcUfNslsUwm0%2FLXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh%2FgEMt7c2Kju6aAAAAABJRU5ErkJggg%3D%3D&logoColor=white&link=https%3A%2F%2Fnedbatchelder.com "Read my blog")](https://nedbatchelder.com)
[![Follow @nedbat on Mastodon](https://img.shields.io/badge/dynamic/json?style=flat&labelColor=450657&logo=mastodon&logoColor=ffffff&link=https%3A%2F%2Fhachyderm.io%2F%40nedbat&url=https%3A%2F%2Fhachyderm.io%2Fusers%2Fnedbat%2Ffollowers.json&query=totalItems&label=Mastodon "Follow @nedbat on Mastodon")](https://hachyderm.io/@nedbat)
[![Follow @nedbat on Twitter](https://img.shields.io/twitter/follow/nedbat.svg?style=flat&label=%40nedbat&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https%3A%2F%2Ftwitter.com%2Fnedbat "Follow @nedbat on Twitter")](https://twitter.com/nedbat)
[![Join us at Boston Python](https://img.shields.io/badge/-Boston%20Python-4d7954?style=flat&labelColor=eeeeee&logo=meetup&logoColor=red&link=https%3A%2F%2Fabout.bostonpython.com "Join us at Boston Python")](https://about.bostonpython.com)
[![Python Discord](https://img.shields.io/badge/-Discord-ffe97c?style=flat&labelColor=7289da&logo=discord&logoColor=white&link=https%3A%2F%2Fdiscord.gg%2Fpython "Python Discord")](https://discord.gg/python)
[![Sponsor me on GitHub](https://img.shields.io/badge/%E2%9D%A4-Sponsor%20me-brightgreen?style=flat&logo=GitHub&link=https%3A%2F%2Fgithub.com%2Fsponsors%2Fnedbat "Sponsor me on GitHub")](https://github.com/sponsors/nedbat)
[![Stack Overflow reputation](https://img.shields.io/badge/-356k%20%F0%9F%9F%A1%E2%80%8972%20%E2%9A%AA%E2%80%89558%20%F0%9F%9F%A4%E2%80%89653-e6873e?style=flat&labelColor=333333&logo=stackoverflow&link=https%3A%2F%2Fstackoverflow.com%2Fusers%2F14343%2Fned-batchelder "Stack Overflow reputation")](https://stackoverflow.com/users/14343/ned-batchelder)
[![My PyPI packages](https://img.shields.io/badge/-PyPI%20packages-4B8BBE?style=flat&labelColor=306998&logo=python&logoColor=FFE873&link=https%3A%2F%2Fpypi.org%2Fuser%2Fnedbatchelder "My PyPI packages")](https://pypi.org/user/nedbatchelder)
<!-- [[[end]]] -->


- My personal site is [https://nedbatchelder.com][nedbat].
- I work at [2U/edX](https://edx.org) on [Open edX](https://openedx.org).
- I'm an organizer of [Boston Python][bp].

You can **find me** at:

- Mastodon: [@nedbat@nedbat.com][mastodon].
- Twitter: [@nedbat][twitter].
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
    entries = blogdata["entries"][:6]
    for entry in entries:
        write_blog_post(entry, twoline=True)
    print("- and [many more][blog]..")
]]] -->
- **[Same words, different meanings](https://nedbatchelder.com/blog/202301/same_words_different_meanings.html)**, 10 Jan  
One of the difficulties when comparing programming languages is that they sometimes use the same words to describe similar things, but always with differences. Sometimes the differences are large enough that we want to use different words, but often they are not. *([read..](https://nedbatchelder.com/blog/202301/same_words_different_meanings.html))*
- **[Talk Python to Me: Tools for README](https://nedbatchelder.com/blog/202212/talk_python_to_me_tools_for_readme.html)**, 26 Dec  
Michael Kennedy invited me on his podcast to chat about a round-up of tools for README maintenance and other similar project automation: Talk Python to Me #395: Tools for README.md Creation and Maintenance. *([read..](https://nedbatchelder.com/blog/202212/talk_python_to_me_tools_for_readme.html))*
- **[Secure maintainer workflow, continued](https://nedbatchelder.com/blog/202212/secure_maintainer_workflow_continued.html)**, 22 Dec  
Picking up from Secure maintainer workflow, especially the comments there (thanks!), here are some more things I’m doing to keep my maintainer workflow safe. *([read..](https://nedbatchelder.com/blog/202212/secure_maintainer_workflow_continued.html))*
- **[Mastodon: servers, good and bad](https://nedbatchelder.com/blog/202211/mastodon_servers_good_and_bad.html)**, 27 Nov  
Like many people these days, I’m looking around at alternatives to Twitter, and Mastodon is a clear favorite. Comparing the two, the big differences, both good and bad, come down to servers. *([read..](https://nedbatchelder.com/blog/202211/mastodon_servers_good_and_bad.html))*
- **[Secure maintainer workflow](https://nedbatchelder.com/blog/202211/secure_maintainer_workflow.html)**, 21 Nov  
I’m trying to establish a more secure workflow for maintaining public packages. *([read..](https://nedbatchelder.com/blog/202211/secure_maintainer_workflow.html))*
- **[Ideal open source](https://nedbatchelder.com/blog/202210/ideal_open_source.html)**, 29 Oct  
DHH says we can choose our purpose in open source. I don’t feel all the freedom he describes. *([read..](https://nedbatchelder.com/blog/202210/ideal_open_source.html))*
- and [many more][blog]..
<!-- [[[end]]] -->

<!--
  ##
  ## PYPI PACKAGES
  ##
  -->

<!-- [[[cog
    pkgs = [
        # (pypi name, human name, github repo, twitter, description),
        ("coverage", "Coverage.py", "nedbat/coveragepy", "coveragepy"),
        ("cogapp", "Cog", "nedbat/cog"),
        ("dinghy", "Dinghy", "nedbat/dinghy"),
        ("scriv", "Scriv", "nedbat/scriv"),
        ("aptus", "Aptus", "nedbat/aptus"),
    ]

    def write_package(pkg, human, repo, twitter=None, description=None):
        if not description:
            description = requests_get_json(f"https://api.github.com/repos/{repo}")["description"]
        print(f'- [**{human}**](https://github.com/{repo}): {description}  ') # trailing spaces for Markdown line break...
        print(f'  [![PyPI](https://img.shields.io/pypi/v/{pkg}?style=flat "The {pkg} PyPI page")](https://pypi.org/project/{pkg})')
        print(f'  [![GitHub last commit](https://img.shields.io/github/last-commit/{repo}?logo=github&style=flat "Recent {human.lower()} commits")](https://github.com/{repo}/commits)')
        print(f'  [![PyPI - Downloads](https://img.shields.io/pypi/dm/{pkg}?style=flat "Download stats for {pkg}")](https://pypistats.org/packages/{pkg})')
        if twitter:
            print('  ', md_badge_twitter(twitter), sep='')
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
  [![Follow @coveragepy on Twitter](https://img.shields.io/twitter/follow/coveragepy.svg?style=flat&label=%40coveragepy&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https%3A%2F%2Ftwitter.com%2Fcoveragepy "Follow @coveragepy on Twitter")](https://twitter.com/coveragepy)
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
- [**Aptus**](https://github.com/nedbat/aptus): Mandelbrot fractal viewer  
  [![PyPI](https://img.shields.io/pypi/v/aptus?style=flat "The aptus PyPI page")](https://pypi.org/project/aptus)
  [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/aptus?logo=github&style=flat "Recent aptus commits")](https://github.com/nedbat/aptus/commits)
  [![PyPI - Downloads](https://img.shields.io/pypi/dm/aptus?style=flat "Download stats for aptus")](https://pypistats.org/packages/aptus)
<!-- [[[end]]] -->

<br/>
<br/>

<!-- [[[cog
    import datetime
    when = f"{datetime.datetime.now():%Y-%m-%d %H:%M}"
    print(f"*(made with [cog](https://github.com/nedbat/cog) at {when} UTC)*")
]]] -->
*(made with [cog](https://github.com/nedbat/cog) at 2023-01-14 11:13 UTC)*
<!-- [[[end]]] -->

[nedbat]: https://nedbatchelder.com
[blog]: https://nedbatchelder.com/blog
[twitter]: https://twitter.com/nedbat
[mastodon]: https://hachyderm.io/@nedbat
[discord]: https://pythondiscord.com
[libera]: https://libera.chat
[bp]: https://bostonpython.com
[ned_pypi]: https://pypi.org/user/nedbatchelder
