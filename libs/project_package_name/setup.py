#!/usr/bin/env python
# encoding: utf-8

from setuptools import find_packages, setup

setup(
    name="project_package_name",
    version="0.1",
    description="project description",
    author="...",
    packages=find_packages(exclude=("tests",)),
)
