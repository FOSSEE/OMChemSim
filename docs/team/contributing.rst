.. _contributing:

Contribute to the Project
=========================

We welcome all sorts of contribution to the project!

Get Started
-----------

However you decide to contribute to our project, please follow the following instructions:

- Create a `GitHub Account <www.github.com>`_.
- Browse our `Issues`_ base.
- Fork the repository to your account by using the Fork button of the GitHub repository site.
- Clone the forked repository to your computer.
- Create a new topic branch and give it a meaningful name, like, e.g., "issue22-fix-formula".
- Do your code changes and commit them, one change per commit. Single commits can be copied to other branches. Multiple commits can be squashed into one, but splitting is difficult.
- Once you are done, push your topic branch to your forked repository.
- Go to the `upstream <https://github.com/FOSSEE/OMChemSim.git>`_ repository and submit aPull Request (PR). If the PR is related to a certain issue, reference it by its number like this: #22. Once a pull request is opened, you can discuss and review the potential changes with collaborators and add follow-up commits before the changes are merged into the repository.
- Update your branch with the requested changes. If necessary, merge the latest "master" branch into your topic branch and solve all merge conflicts in your topic branch.


Improve our Documentation
-------------------------

The documentation of the OMChemSim is hosted on `Read the Docs <https://readthedocs.org/>`_ and is developed using the **reStructuredText** markup language.

The sources for compiling the documentations are placed in the ``./docs/`` folder of the repository.

The main goal of the documentation is to provide information on the development conventions adopted for this project, and provide a guide to the contributors of the project.


Useful Links
^^^^^^^^^^^^

Here is a collection of resources to learn about the reStructuredText markup language:

- `Get Started with Read the Docs <https://docs.readthedocs.io/en/latest/getting_started.html>`_
- `Some infos about reStructuredText <http://build-me-the-docs-please.readthedocs.io/en/latest/Using_Sphinx/OnReStructuredText.html>`_
- `Some more infos about reStructuredText <http://www.sphinx-doc.org/en/stable/rest.html#>`_

Improve the Library
-------------------

The library has been in development for a couple years now, and comprises many models for chemical process simulation.
We are, however, always interested in adding new models to the library, or improve the existing models.

Please always document your contribution in an issue in our `Issues`_  Tracker, feel free to create a new issue if none of the existing one fit your contribution.
This will allow the team managing the repository to review the suggested changes, and discuss the motivation behind them.

.. note::
   Structural changes to the library should be discussed with the team prior to any submission

As a recommendation, a valid bug fix may contain one or more of the following changes.

- Correcting an equation.
- Correcting attributes quantity/unit/defaultUnit in a declaration.
- Improving/fixing the documentation.
- Introducing a new name in the public section of a class (model, package, ...) or in any section of a partial class is not allowed. 
  Since otherwise, a user might use this new name and when storing its model and loading it with an older build-version, an error would occur.
- Introducing a new name in the protected section of a non-partial class should only be done if absolutely necessary to fix a bug. The problem is that this might be non-backward compatible, because a user might already extend from this class and already using the same name.


.. _Issues : https://github.com/FOSSEE/OMChemSim/issues



