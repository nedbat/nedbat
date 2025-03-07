<!--

You can manually process this file with cog:

    $ python -m pip install -r requirements.pip
    $ python -m cogapp -rP README.md

On GitHub, it's generated by an action:

    https://github.com/nedbat/nedbat/blob/main/.github/workflows/build.yml

-->

<!-- [[[cog

    import base64
    import datetime
    import os
    import sys
    import time
    from urllib.parse import quote, urlencode

    import requests

    def requests_get_json(url):
        """Get JSON data from a URL, with retries."""
        headers = {}
        token = None
        if "github.com" in url:
            token = os.environ.get("GITHUB_TOKEN", "")
        if token:
            headers["Authorization"] = f"Bearer {token}"

        for _ in range(3):
            sys.stderr.write(f"Fetching {url}\n")
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
    ):
        """Flexible building of a shields.io URL with optional components."""
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
        return url + "?" + urlencode(params)

    def md_image(image_url, text, link, title=None, attrs=None):
        """Build the Markdown for an image.

        image_url: the URL for the image.
        text: used for the alt text and the title if title is missing.
        link: the URL destination when clicking on the image.
        title: the title text to use.
        attrs: HTML attributes (switches to HTML syntax)
        """
        if title is None:
            title = text
        assert "]" not in text
        assert '"' not in title
        if attrs:
            img_attrs = " ".join(f'{k}="{v}"' for k, v in attrs.items())
            return f'[<img src="{image_url}" title="{title}" {img_attrs}/>]({link})'
        else:
            return f'[![{text}]({image_url} "{title}")]({link})'

    def badge(text=None, link=None, title=None, **kwargs):
        """Build the Markdown for a shields.io badge."""
        return md_image(image_url=shields_url(**kwargs), text=text, link=link, title=title)

    def badge_mastodon(server, handle):
        """A badge for a Mastodon account."""
        # https://github.com/badges/shields/issues/4492
        # https://docs.joinmastodon.org/methods/accounts/#lookup
        url = f"https://{server}/api/v1/accounts/lookup?acct={handle}"
        followers = requests_get_json(url)["followers_count"]
        return badge(
            label=f"@{handle}", message=rounded_nice(followers),
            logo="mastodon", color="96a3b0", label_color="450657", logo_color="white",
            text=f"Follow @{handle} on Mastodon", link=f"https://{server}/@{handle}",
        )

    def badge_bluesky(handle):
        """A badge for a Bluesky account."""
        url = f"https://public.api.bsky.app/xrpc/app.bsky.actor.getProfile?actor={handle}"
        followers = requests_get_json(url)["followersCount"]
        return badge(
            label=f"Bluesky", message=rounded_nice(followers),
            logo="icloud", label_color="3686f7", color="96a3b0", logo_color="white",
            text=f"Follow {handle} on Bluesky", link=f"https://bsky.app/profile/{handle}",
        )

    def badge_stackoverflow(userid):
        """A badge for a Stackoverflow account."""
        data = requests_get_json(f"https://api.stackexchange.com/2.3/users/{userid}?order=desc&sort=reputation&site=stackoverflow")["items"][0]
        rep_points = rounded_nice(data["reputation"])
        gold = rounded_nice(data["badge_counts"]["gold"])
        silver = rounded_nice(data["badge_counts"]["silver"])
        bronze = rounded_nice(data["badge_counts"]["bronze"])
        sp = "\N{THIN SPACE}"
        return badge(
            logo="stackoverflow", logo_color=None, label_color="333333", color="e6873e",
            message=(
                f"{rep_points} "
                + f"\N{LARGE YELLOW CIRCLE}{sp}{gold} "
                + f"\N{MEDIUM WHITE CIRCLE}{sp}{silver} "
                + f"\N{LARGE BROWN CIRCLE}{sp}{bronze}"
            ),
            text="Stack Overflow reputation", link=data["link"],
        )

    def data_url(image_file):
        """Read an image file and return a self-contained data URL."""
        assert image_file.endswith((".png", ".jpg"))
        with open(image_file, "rb") as imgf:
            b64 = base64.b64encode(imgf.read()).decode("ascii")
        return f"data:image/png;base64,{b64}"

]]] -->
<!-- [[[end]]] -->

<!--
  ##
  ## BADGES
  ##
  -->

<!-- [[[cog
print(badge(
    logo=data_url("pencil.png"), logo_color="white", label_color="eeeeee", message="Blog etc", color="888888",
    text="Read my blog", link="https://nedbatchelder.com",
))
print(badge_bluesky("nedbat.com"))
print(badge_mastodon("hachyderm.io", "nedbat"))
print(badge(
    logo="meetup", logo_color="red", label_color="eeeeee", message="Boston Python", color="4d7954",
    text="Join us at Boston Python", link="https://about.bostonpython.com",
))
print(badge(
    logo="discord", logo_color="white", label_color="7289da", message="Discord", color="ffe97c",
    text="Python Discord", link="https://discord.gg/python",
))
print(badge(
    logo="GitHub", label="\N{HEAVY BLACK HEART}", message="Sponsor me", color="brightgreen",
    text="Sponsor me on GitHub", link="https://github.com/sponsors/nedbat",
))
print(badge_stackoverflow(userid=14343))
print(badge(
    logo="python", logo_color="FFE873", label_color="306998", message="PyPI", color="4B8BBE",
    text="My PyPI packages", link="https://pypi.org/user/nedbatchelder",
))
]]] -->
[![Read my blog](https://img.shields.io/badge/-Blog%20etc-888888?style=flat&labelColor=eeeeee&logo=data%3Aimage%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAADgAAAA4CAMAAACfWMssAAABpFBMVEX%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8AAAAAAACwsLABAQEBAQEBAQGlpaUCAgICAgIXFxdycnKAgIBVVVSZmZgDAwMQEBANDQ0JCQgCAgIAAAAWFhYAAAAYGBgXFxcVFRUEBAQ5OTkZGRlTU1NqampmZmaAgHxfX198fHyKioqQkJCurqoMDAwFBQQAAAAgIB0QEBARERAjIyMaGhoXFxcVFRUAAAAVFRUXFxcVFRUBAQEnJyc9PT0uLi4tLS0lJSUzMzMtLS1ISEhFRUVERERhYV5XV1cPDw9GRkZWVlY%2FPz5aWlpjY19hYWFaWlojIyNjY2NLS0srKytnZ2c2NjZzc3IKCgqFhYUrKyuNjYDa2toFBQUaGhoXFxcKCgoUFBQcHBwKCgoKCgoAAAAICAEWFhYnJyMAAAAKCgoMDAwAAAAAAAAjIyM2NjYAAAARERExMSkKCgpRUU4bGxtHR0cAAAA%2BPj4oKCdOTkhZWVkFBQVPT086OjpNTUk5OTkBAQFLS0teXlZKSkpQUFBvb241NTUAAABvb294eHgAAACBIqjAAAAAi3RSTlMBBgMHCAACBQT9%2Bw%2F18eoT7efLNCQeF%2Fny8u%2Fk29nW08%2B3eHZYOi8rKCMgGxkH%2BvXz7Ofk4t%2Fc1cfFwLy2spiUjoqFd2VjXVlTUVBMR0ZCPz8%2BOzs3NjEtLB0aCwr%2B9Orq6OXi09LMxr%2B%2Fu7qro5qSj46HhIOAf317dXBtamlhVVBHRDYxKSckHhcWCkdRuAAAArhJREFUSMeV1mdX2zAUBuDrCNlJWIEQ9ipQNi0tpYWyZwuljEILBbr33nvv8f7pxkoT2fg6TvRFOdf3OTrOa9kiYVphU0hBycmQBWSEQgapyaICKcywRcKe7KbdticzCZFqIocT5HSGxxXuA1DVUkCWfdXhpL%2BzUk6NZ8pRXq6pYqEaeKGacnYjSdcjxUYtMJPspRxd6XGgOenIWi8GWskgH0deV96b6l3tR2Q%2BRBlnOZ003G446SrTmX0tQskO6b%2FV4cjtKm8BGNxWzr76BljKyZWrGBq20%2Ff0GWijAEcZB1z%2Fk3LfY4hsZuJwupDT9TYjPW6W2u5HGTBNlHYy2AFDpWR01QGTZBCzXsjheprgHHcKE%2FXAo2QTcU7Hf%2F4Y3ONuIzCudgcTP%2Bv0GDdVUzbX3cC4iVQT5esm073%2BruIo46bSvZSfe5rpJV83yLjnupfUtvA%2Bbp1HGPdSuzC5nczmXjuz5h%2FvjgEvi7S67olYdzi7U1PIuy3aGXfhrdtJYtwVZr13e5wgz3aKX2LcB09mnm0RP8S4WW%2FWtKf0jXHROS5rt9tfy7h5LmsKdAdOsFmTy9X4OCYzcrhVxlWd5J0gXVqp5h3%2F6tTrLV%2F0uqJT3BdeuOJYOsg7%2FhWo41jn3GnfV5mOY8zriv2djiMR9bplf6fjeIXivW7F3%2Bk4%2BgaqOxtdLnYmi9NxLOKh7K53uJKsTscxii1hdl3T7mzgyUCVfkeH7N%2B%2FrmoX%2BIVXcUxjTpW2LitXFg92Ko7duthOqnQuZrv27E7HsYDH%2F0uJMaBuUzvu8dZxyFF8TK33IIr694XsAVY7HcfPCIrWhFwcAYY%2FJUtZ19NxSGMKQE1LI6L3N4TM%2BcBMRl8J7NE%2F0UXaBcUfNslsUwm0%2FLXMQOeO4zZwY7ZPlfJwkjoi974IM28naC3uKOXh%2FgEMt7c2Kju6aAAAAABJRU5ErkJggg%3D%3D&logoColor=white "Read my blog")](https://nedbatchelder.com)
[![Follow nedbat.com on Bluesky](https://img.shields.io/badge/Bluesky-4.0k-96a3b0?style=flat&labelColor=3686f7&logo=icloud&logoColor=white "Follow nedbat.com on Bluesky")](https://bsky.app/profile/nedbat.com)
[![Follow @nedbat on Mastodon](https://img.shields.io/badge/%40nedbat-3.7k-96a3b0?style=flat&labelColor=450657&logo=mastodon&logoColor=white "Follow @nedbat on Mastodon")](https://hachyderm.io/@nedbat)
[![Join us at Boston Python](https://img.shields.io/badge/-Boston%20Python-4d7954?style=flat&labelColor=eeeeee&logo=meetup&logoColor=red "Join us at Boston Python")](https://about.bostonpython.com)
[![Python Discord](https://img.shields.io/badge/-Discord-ffe97c?style=flat&labelColor=7289da&logo=discord&logoColor=white "Python Discord")](https://discord.gg/python)
[![Sponsor me on GitHub](https://img.shields.io/badge/%E2%9D%A4-Sponsor%20me-brightgreen?style=flat&logo=GitHub "Sponsor me on GitHub")](https://github.com/sponsors/nedbat)
[![Stack Overflow reputation](https://img.shields.io/badge/-376k%20%F0%9F%9F%A1%E2%80%8977%20%E2%9A%AA%E2%80%89581%20%F0%9F%9F%A4%E2%80%89673-e6873e?style=flat&labelColor=333333&logo=stackoverflow "Stack Overflow reputation")](https://stackoverflow.com/users/14343/ned-batchelder)
[![My PyPI packages](https://img.shields.io/badge/-PyPI-4B8BBE?style=flat&labelColor=306998&logo=python&logoColor=FFE873 "My PyPI packages")](https://pypi.org/user/nedbatchelder)
<!-- [[[end]]] -->

<!--
  ##
  ## CAUSES
  ##
  -->

<!-- [[[cog
attrs = {"height": 75, "style": "border: 1px solid #888"}
print(md_image("https://nedbatchelder.com/pix/blm.jpg", "Black lives matter", "https://nedbatchelder.com/blog/202006/black_lives_matter.html", attrs=attrs))
print("&#xa0;" * 4)
print(md_image("https://nedbatchelder.com/pix/ukraine.png", "Support Ukraine", "https://stand-with-ukraine.pp.ua/#support-ukraine", attrs=attrs))
print("&#xa0;" * 4)
print(md_image("https://nedbatchelder.com/pix/progressprideflag.png", "Pride", "https://nedbatchelder.com/blog/201207/my_mom_got_married.html", attrs=attrs))
print("&#xa0;" * 4)
print(md_image("https://nedbatchelder.com/pix/us-flag.png", "Optimistic despite current events", "https://nedbatchelder.com/blog/202411/my_politics.html", attrs=attrs))
]]] -->
[<img src="https://nedbatchelder.com/pix/blm.jpg" title="Black lives matter" height="75" style="border: 1px solid #888"/>](https://nedbatchelder.com/blog/202006/black_lives_matter.html)
&#xa0;&#xa0;&#xa0;&#xa0;
[<img src="https://nedbatchelder.com/pix/ukraine.png" title="Support Ukraine" height="75" style="border: 1px solid #888"/>](https://stand-with-ukraine.pp.ua/#support-ukraine)
&#xa0;&#xa0;&#xa0;&#xa0;
[<img src="https://nedbatchelder.com/pix/progressprideflag.png" title="Pride" height="75" style="border: 1px solid #888"/>](https://nedbatchelder.com/blog/201207/my_mom_got_married.html)
&#xa0;&#xa0;&#xa0;&#xa0;
[<img src="https://nedbatchelder.com/pix/us-flag.png" title="Optimistic despite current events" height="75" style="border: 1px solid #888"/>](https://nedbatchelder.com/blog/202411/my_politics.html)
<!-- [[[end]]] -->


<!--
  ##
  ## ME
  ##
  -->

I'm **Ned Batchelder**, a Python software developer and community organizer.

- My personal site is [nedbatchelder.com][nedbat].
- I'm an organizer of [Boston Python][bp].
- I'm a member of the [Python Docs Editorial Board][pdeb].
- I work for an AI company, but [have concerns about AI][antblog].

You can **find me** at:

- Bluesky: [nedbat.com](https://bsky.app/profile/nedbat.com).
- Mastodon: [@nedbat@nedbat.com][mastodon].
- Libera IRC: nedbat in [#python][libera].
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
            print(f"<br/>\n{entry['description_text']} *([read..]({entry['url']}))*")
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
- **[Intricate interleaved iteration](https://nedbatchelder.com/blog/202501/intricate_interleaved_iteration.html)**, 30 Jan<br/>
Someone asked recently, “is there any reason to use a generator if I need to store all the values anyway?” As it happens, I did just that in the code for this blog’s sidebar because I found it the most readable way to do it. Maybe it was a good idea, maybe not. *([read..](https://nedbatchelder.com/blog/202501/intricate_interleaved_iteration.html))*
- **[Nat running](https://nedbatchelder.com/blog/202501/nat_running.html)**, 14 Jan<br/>
I took this picture nine years ago, but it’s still one of my favorites *([read..](https://nedbatchelder.com/blog/202501/nat_running.html))*
- **[Testing some tidbits](https://nedbatchelder.com/blog/202412/testing_some_tidbits.html)**, 4 Dec<br/>
A custom test harness for some esoteric Python expressions *([read..](https://nedbatchelder.com/blog/202412/testing_some_tidbits.html))*
- **[Dinner](https://nedbatchelder.com/blog/202412/dinner.html)**, 1 Dec<br/>
My son Nat has autism, and one way it affects him is he can be very quiet and passive, even when he wants something very much. This played out on our drive home from Thanks­giving this week. *([read..](https://nedbatchelder.com/blog/202412/dinner.html))*
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
        ("scriv", "Scriv", "nedbat/scriv"),
        ("dinghy", "Dinghy", "nedbat/dinghy"),
        ("watchgha", "WatchGHA", "nedbat/watchgha"),
        ("aptus", "Aptus", "nedbat/aptus"),
    ]

    def write_package(pkg, human, repo, mastinfo=None):
        description = requests_get_json(f"https://api.github.com/repos/{repo}")["description"]
        main_line = f"[**{human}**](https://github.com/{repo}): {description}"
        pypi_badge = badge(
            url=f"/pypi/v/{pkg}?style=flat",
            text="PyPI",
            link=f"https://pypi.org/project/{pkg}",
            title=f"The {pkg} PyPI page",
        )
        github_badge = badge(
            url=f"/github/last-commit/{repo}?logo=github&style=flat",
            text="GitHub last commit",
            link=f"https://github.com/{repo}/commits",
            title=f"Recent {human.lower()} commits",
        )
        pypi_downloads_badge = badge(
            url=f"/pypi/dm/{pkg}?style=flat",
            text="PyPI - Downloads",
            link=f"https://pypistats.org/packages/{pkg}",
            title=f"Download stats for {pkg}",
        )
        print(f"- {main_line}<br/>")
        print(f"  {pypi_badge} {github_badge} {pypi_downloads_badge}")
        if mastinfo is not None:
            print(f"  {badge_mastodon(*mastinfo)}")
]]] -->
<!-- [[[end]]] -->

I maintain a few [**Python packages**][ned_pypi], including:

<!-- [[[cog
    for args in pkgs:
        write_package(*args)
]]] -->
- [**Coverage.py**](https://github.com/nedbat/coveragepy): The code coverage tool for Python<br/>
  [![PyPI](https://img.shields.io/pypi/v/coverage?style=flat?style=flat "The coverage PyPI page")](https://pypi.org/project/coverage) [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/coveragepy?logo=github&style=flat?style=flat "Recent coverage.py commits")](https://github.com/nedbat/coveragepy/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/coverage?style=flat?style=flat "Download stats for coverage")](https://pypistats.org/packages/coverage)
  [![Follow @coveragepy on Mastodon](https://img.shields.io/badge/%40coveragepy-276-96a3b0?style=flat&labelColor=450657&logo=mastodon&logoColor=white "Follow @coveragepy on Mastodon")](https://hachyderm.io/@coveragepy)
- [**Cog**](https://github.com/nedbat/cog): Small bits of Python computation for static files<br/>
  [![PyPI](https://img.shields.io/pypi/v/cogapp?style=flat?style=flat "The cogapp PyPI page")](https://pypi.org/project/cogapp) [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/cog?logo=github&style=flat?style=flat "Recent cog commits")](https://github.com/nedbat/cog/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/cogapp?style=flat?style=flat "Download stats for cogapp")](https://pypistats.org/packages/cogapp)
- [**Scriv**](https://github.com/nedbat/scriv): Changelog management tool<br/>
  [![PyPI](https://img.shields.io/pypi/v/scriv?style=flat?style=flat "The scriv PyPI page")](https://pypi.org/project/scriv) [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/scriv?logo=github&style=flat?style=flat "Recent scriv commits")](https://github.com/nedbat/scriv/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/scriv?style=flat?style=flat "Download stats for scriv")](https://pypistats.org/packages/scriv)
- [**Dinghy**](https://github.com/nedbat/dinghy): A GitHub activity digest tool<br/>
  [![PyPI](https://img.shields.io/pypi/v/dinghy?style=flat?style=flat "The dinghy PyPI page")](https://pypi.org/project/dinghy) [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/dinghy?logo=github&style=flat?style=flat "Recent dinghy commits")](https://github.com/nedbat/dinghy/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/dinghy?style=flat?style=flat "Download stats for dinghy")](https://pypistats.org/packages/dinghy)
- [**WatchGHA**](https://github.com/nedbat/watchgha): Live display of current GitHub action runs<br/>
  [![PyPI](https://img.shields.io/pypi/v/watchgha?style=flat?style=flat "The watchgha PyPI page")](https://pypi.org/project/watchgha) [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/watchgha?logo=github&style=flat?style=flat "Recent watchgha commits")](https://github.com/nedbat/watchgha/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/watchgha?style=flat?style=flat "Download stats for watchgha")](https://pypistats.org/packages/watchgha)
- [**Aptus**](https://github.com/nedbat/aptus): Mandelbrot fractal viewer<br/>
  [![PyPI](https://img.shields.io/pypi/v/aptus?style=flat?style=flat "The aptus PyPI page")](https://pypi.org/project/aptus) [![GitHub last commit](https://img.shields.io/github/last-commit/nedbat/aptus?logo=github&style=flat?style=flat "Recent aptus commits")](https://github.com/nedbat/aptus/commits) [![PyPI - Downloads](https://img.shields.io/pypi/dm/aptus?style=flat?style=flat "Download stats for aptus")](https://pypistats.org/packages/aptus)
<!-- [[[end]]] -->

<!--
  ##
  ## OTHER PROJECTS
  ##
  -->

I've also made a few informal projects, some mathy art, and some small utilities:

- [pkgsample](https://github.com/nedbat/pkgsample), an simple example of how to package a Python project.
- [Truchet images](https://github.com/nedbat/truchet) explores Truchet tiles, and rendering images with them.
  [Blog post](https://nedbatchelder.com/blog/202208/truchet_images.html).
- [Flourish](https://github.com/nedbat/flourish) is a harmonograph explorer.
  [Blog post](https://nedbatchelder.com/blog/202101/flourish.html) and [live site](https://flourish.nedbat.com/).
- [Stilted](https://github.com/nedbat/stilted) is a toy PostScript implementation.
  [Blog post](https://nedbatchelder.com/blog/202208/stilted.html).
- [Gefilte Fish](https://github.com/nedbat/gefilte) is a Python-based DSL for writing Gmail filters.
  [Blog post](https://nedbatchelder.com/blog/202103/gefilte_fish_gmail_filter_creation.html).
- [Pydoctor](https://github.com/nedbat/pydoctor) shows details of your Python environment, for troubleshooting.

<!--
  ##
  ## FOOTER
  ##
  -->

<br/>
<br/>

This is a [Markdown page with embedded Python code][readme.md] rendered with [cog][cog].
See my blog post **[Cogged GitHub profile][blog_post]** for details.

<!-- [[[cog
    print(f"*Updated at {datetime.datetime.now():%Y-%m-%d %H:%M} UTC*")
]]] -->
*Updated at 2025-03-07 02:48 UTC*
<!-- [[[end]]] -->

[nedbat]: https://nedbatchelder.com "My site with blog, talks, etc"
[blog]: https://nedbatchelder.com/blog "My blog"
[mastodon]: https://hachyderm.io/@nedbat
[discord]: https://pythondiscord.com
[libera]: https://libera.chat
[bp]: https://bostonpython.com "The Boston Python home page"
[antblog]: https://nedbatchelder.com/blog/202407/anthropic.html "My blog post about working at Anthropic"
[pdeb]: https://python.github.io/editorial-board/
[ned_pypi]: https://pypi.org/user/nedbatchelder "The list of all my packages on PyPI"
[cog]: https://github.com/nedbat/cog "The cog repo on GitHub"
[readme.md]: https://github.com/nedbat/nedbat/blob/main/README.md?plain=1 "The raw source for this GitHub profile"
[blog_post]: https://nedbatchelder.com/blog/202409/cogged_github_profile.html "Discussion of how this page is constructed"
