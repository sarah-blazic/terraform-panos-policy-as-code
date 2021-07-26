# Terraform Modules for Palo Alto Networks Panorama Policy as Code

## Overview

A set of modules for using **Palo Alto Networks Panorama Policy as Code** to configure your Palo Alto Networks Next Generation Firewalls with code instead of interacting with the GUI. It configures aspects such as Tags, Address Objects/Groups, Security/NAT policies, Security Profiles, and more.

## Structure

This repository has the following directory structure:

* [modules](./modules): This directory contains several standalone, reusable, production-grade Terraform modules. Each module is individually documented.
* [examples](./examples): This directory shows examples of different ways to combine the modules contained in the
  `modules` directory.

## Compatibility

This module is meant for use with PAN-OS >= 8.0 and Terraform >= 0.13

## Versioning

These modules follow the principles of [Semantic Versioning](http://semver.org/). You can find each new release,
along with the changelog, on the GitHub [Releases](../../releases) page.

## Getting Help

If you have found a bug, please report it. The preferred way is to create a new issue on the [GitHub issue page](../../issues).
