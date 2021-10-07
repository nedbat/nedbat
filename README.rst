.. Process this file with cog:

    $ python -m pip install -r requirements.pip
    $ python -m cogapp -r README.rst

Hi, I'm Ned
===========

I'm a Python software developer and community organizer.  My personal site is
https://nedbatchelder.com.  I'm an organizer of `Boston Python`_.

You can find me at:

- On `Libera IRC`_, I'm nedbat in #python.
- I'm `@nedbat on Twitter <twitter>`_.
- I'm sometimes in the `Python Discord`_.

Recent `blog posts <blog>`_:

.. [[[cog
    import cog, requests
    data = requests.get("https://nedbatchelder.com/summary.json").json()
    for entry in data["entries"][:4]:
        cog.outl(f"- `{entry['title']} <{entry['url']}>`_ ({entry['when_human']}): {entry['description_text']}")
    cog.outl("")
.. ]]]
- `Coverage 6.0 <https://nedbatchelder.com/blog/202110/coverage_60.html>`_ (04 Oct): Coverage.py 6.0 is now available. It’s a major version bump for two reasons:
- `300 walks <https://nedbatchelder.com/blog/202109/300_walks.html>`_ (27 Sep): I’ve been continuing the walking I described in Pandemic walks, and have now completed 300 such walks, 1648 miles. Walking new streets every day, but from the same point, actually means walking a lot of the same streets every day.
- `Real Django site <https://nedbatchelder.com/blog/202109/real_django_site.html>`_ (13 Sep): Big changes behind the scenes here at nedbatchelder.com, but only a small change for you.
- `Me on Bug Hunters Café <https://nedbatchelder.com/blog/202108/me_on_bug_hunters_caf.html>`_ (23 Aug): I was a guest on the Bug Hunters Café podcast: episode #12, The Café Within.

.. [[[end]]]

.. _twitter: https://twitter.com/nedbat
.. _Python Discord: https://pythondiscord.com
.. _blog: https://nedbatchelder.com/blog
.. _Boston Python: https://bostonpython.com
.. _Libera IRC: https://libera.chat
