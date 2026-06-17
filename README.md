# PURE-GUIX Configuration Framework

A modular, reproducible GNU Guix configuration framework for managing multiple machines and users from a single repository.

If you're looking for a way to keep a fleet of Guix systems (and Guix Home configurations) organized without turning your repository into a giant pile of copy-pasted configuration files, this is the approach I settled on.

The idea is simple:

```text
Channels
    ↓
Features
    ↓
Profiles
    ↓
Machines / Homes
```

Everything builds from those layers.

Features describe capabilities.

Profiles combine features.

Machines provide hardware-specific details.

Homes provide user environments.

The result is a configuration repository that scales from a single laptop to a fleet of desktops, servers, VMs, and home environments.

---

## Goals

This framework is designed around a few principles:

* One source of truth
* Maximum reuse
* Minimal duplication
* Reproducible deployments
* Fleet-wide channel pinning
* User-agnostic features
* Portable Guix Home environments
* Long-term maintainability

---

## What It Supports

* GNU Guix System machines
* Foreign distributions using Guix Home
* Multiple users
* Multiple machine types
* Shared profiles
* Reproducible deployments
* Fleet-wide channel management

Whether you're managing one laptop or ten servers, the structure stays the same.

---

## Repository Layout

```text
guix-config/
│
├── channels.scm
├── manifest.scm
├── Makefile
│
├── modules/
│   ├── fleet/
│   ├── features/
│   ├── profiles/
│   ├── home/
│   └── services/
│
├── systems/
│
└── homes/
```

A rough breakdown:

### `modules/features/`

Features describe reusable capabilities.

Examples:

```text
desktop
development
server
containers
multimedia
```

A feature should never know anything about:

* usernames
* hostnames
* SSH keys
* filesystem labels

Features describe *what a machine can do*, not *who owns it*.

---

### `modules/profiles/`

Profiles are collections of features.

For example:

```text
Laptop
 ├─ Desktop
 └─ Development
```

```text
Workstation
 ├─ Desktop
 ├─ Development
 └─ Multimedia
```

```text
Server
 ├─ Server
 └─ Containers
```

Profiles are where most composition happens.

---

### `systems/`

Machine definitions live here.

A machine file should mostly contain:

* hostname
* users
* filesystems
* networking
* bootloader configuration
* machine-specific services

Everything reusable belongs elsewhere.

Example:

```text
systems/
├── t15.scm
├── p14s.scm
└── homelab01.scm
```

---

### `modules/home/`

Guix Home modules live here.

These modules are intentionally independent from Guix System and should work equally well on:

* Guix System
* Debian
* Fedora
* Arch Linux
* Other supported distributions

This keeps user environments portable.

---

### `homes/`

Home entrypoints stay intentionally small:

```scheme
(use-modules (home echjansen))

(echjansen-home)
```

Nothing complicated should live here.

---

## Channel Management

The entire fleet uses a single pinned channel definition.

```text
modules/fleet/channels.scm
        ↓
generated
        ↓
channels.scm
```

The root `channels.scm` remains self-contained so it can be used directly by:

```bash
guix time-machine -C channels.scm
```

without requiring custom module paths.

---

## Feature Design

Features are implemented as parameterless procedures.

Preferred:

```scheme
(define desktop-feature
  (lambda (config)
    ...))
```

Applied like:

```scheme
(list desktop-feature
      development-feature)
```

This keeps composition straightforward and avoids unnecessary complexity.

---

## How Configuration Flows

A machine starts with a minimal hardware configuration:

```text
Machine
    ↓
Base Operating System
```

A profile is applied:

```text
Laptop Profile
    ↓
Desktop Feature
    ↓
Development Feature
```

Result:

```text
Final Operating System
```

The same pattern applies everywhere.

---

## Example

A laptop might look like this:

```scheme
(define %t15-system
  (laptop-profile %t15-base))
```

The machine provides:

* hostname
* users
* filesystems
* bootloader

The profile provides:

* desktop environment
* development tools

The machine remains small because most behavior is inherited through composition.

---

## Guix Home

Home environments follow the same philosophy.

Reusable services go into shared modules:

```scheme
(common-home-services)
```

User-specific additions are layered on top:

```scheme
(append
 (common-home-services)
 user-services)
```

This scales much better than placing everything inside a single home definition.

---

## Deployment

I strongly recommend deploying everything through `guix time-machine`.

### System

```bash
sudo guix time-machine \
  -C channels.scm -- \
  system -L modules reconfigure systems/t15.scm
```

### Home

```bash
guix time-machine \
  -C channels.scm -- \
  home -L modules reconfigure homes/echjansen.scm
```

Benefits:

* Reproducible builds
* Consistent deployments
* CI-friendly
* Protected from local Guix version drift

---

## Validation

Build a system:

```bash
guix time-machine -C channels.scm -- \
  system -L modules build systems/t15.scm
```

Run a VM test:

```bash
guix time-machine -C channels.scm -- \
  system -L modules vm systems/t15.scm
```

Validate a home environment:

```bash
guix time-machine -C channels.scm -- \
  home -L modules build homes/echjansen.scm
```

I usually run these before committing changes.

---

## Development Environment

Enter the repository development environment:

```bash
guix shell -m manifest.scm
```

This provides a consistent set of tools for working on the configuration itself.

---

## REPL Usage

Instead of loading files directly:

```scheme
(load "systems/t15.scm")
```

start a Guix-aware REPL:

```bash
guix repl -L modules
```

Then import modules normally:

```scheme
,use (systems t15)

%t15-system
```

This gives access to exported bindings and matches how Guix evaluates modules.

---

## Future Improvements

A few things worth considering as the repository grows:

* Feature conflict detection
* Dedicated hardware profiles
* Shared fleet utility modules
* CI validation pipelines
* Shared package collections
* Shared user definitions

None of these are required to get started, but they become useful as the number of machines increases.

---

## Philosophy

The core idea is separation of concerns:

* Features describe capabilities
* Profiles describe roles
* Machines describe hardware
* Homes describe users
* Channels describe versions

Keeping those boundaries clean makes the repository easier to understand, easier to maintain, and much easier to scale.

If you stick to that rule, adding new machines, users, and services becomes surprisingly boring—which is exactly what infrastructure should be.
