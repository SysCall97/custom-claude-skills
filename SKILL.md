---
name: json_skill
description: Use this skill when the user wants to filter, query, search, or extract data from a JSON file. Triggers include filtering by a boolean field (e.g. isPremium, isActive, isEnabled), extracting specific keys or titles, searching nested JSON, or any task like "give me all X where Y is true". Always use jq via bash instead of reading the file manually into context.
---

## When To Use
- User asks to filter JSON by any field value
- User asks to extract titles, IDs, or keys from JSON
- User asks "give me all X where Y is true/false"
- Any JSON query task — always prefer jq over manual reading


## Important
- Never read the JSON file into context
- Always pass the file path directly to jq
- Avoid loading file contents into the conversation


# jq JSON Parsing Skill Guide

A practical guide to parsing simple and nested JSON structures using `jq`.

---

# What is jq?

`jq` is a command-line JSON processor.

It helps you:

* Read JSON
* Filter JSON
* Search JSON
* Transform JSON
* Extract data
* Sort data
* Pipe data

Install:

### Linux

Debian / Ubuntu:

```bash
sudo apt-get install jq
```

Fedora:

```bash
sudo dnf install jq
```

openSUSE:

```bash
sudo zypper install jq
```

Arch:

```bash
sudo pacman -S jq
```

Prebuilt binaries also available:

- jq 1.8.1 — AMD64, ARM64, i386
- jq 1.8.0 — AMD64, ARM64, i386
- jq 1.7.1 — AMD64, ARM64, i386
- jq 1.7 — AMD64, ARM64, i386
- jq 1.6 — AMD64, i386
- jq 1.5 — AMD64, i386
- jq 1.4 — AMD64, i386
- jq 1.3 — AMD64, i386

---

### macOS

Homebrew:

```bash
brew install jq
```

MacPorts:

```bash
port install jq
```

Fink:

```bash
fink install jq
```

Prebuilt binaries also available:

- jq 1.8.1 — Apple Silicon, Intel Mac
- jq 1.8.0 — Apple Silicon, Intel Mac
- jq 1.7.1 — Apple Silicon, Intel Mac
- jq 1.7 — Apple Silicon, Intel Mac
- jq 1.6 — AMD64
- jq 1.5 — AMD64
- jq 1.4 — AMD64, i386
- jq 1.3 — AMD64, i386

---

### FreeBSD

Prebuilt package (as root):

```bash
pkg install jq
```

From ports (as root):

```bash
make -C /usr/ports/textproc/jq install clean
```

---

### Solaris

OpenCSW (Solaris 10+, Sparc and x86):

```bash
pkgutil -i jq
```

jq 1.4 binaries available for Solaris 11 AMD64 or i386.

---

### Windows

winget:

```bash
winget install jqlang.jq
```

scoop:

```bash
scoop install jq
```

Chocolatey:

```bash
choco install jq
```

Prebuilt executables also available:

- jq 1.8.1 — AMD64, i386
- jq 1.8.0 — AMD64, i386
- jq 1.7.1 — AMD64, i386
- jq 1.7 — AMD64, i386
- jq 1.6 — AMD64, i386
- jq 1.5 — AMD64, i386
- jq 1.4 — AMD64, i386
- jq 1.3 — AMD64, i386

---

Check version:

```bash
jq --version
```

---

# Sample JSON Structures

## Simple JSON

```json
[
  {
    "uuid": "item_001",
    "badge": 1,
    "thumbImageUrl": "url/1.png"
  },
  {
    "uuid": "item_002",
    "badge": 2,
    "thumbImageUrl": "url/2.png"
  }
]
```

---

## Nested JSON

```json
[
  [
    {
      "uuid": "item_001",
      "badge": 1,
      "thumbImageUrl": "url/1.png",
      "nested": {
        "thumbImageUrl": "url/nested_1.png"
      }
    }
  ]
]
```

---

# Basic jq Syntax

| Syntax     | Meaning          |             |
| ---------- | ---------------- | ----------- |
| `.`        | Current object   |             |
| `.field`   | Access field     |             |
| `.[]`      | Iterate array    |             |
| `..`       | Recursive search |             |
| `          | `                | Pipe output |
| `select()` | Filter values    |             |
| `[]`       | Create array     |             |
| `?`        | Optional access  |             |
| `//`       | Default value    |             |

---

# 1. Get One Entry From JSON

## Simple Structure

JSON:

```json
{
  "uuid": "item_001",
  "badge": 1
}
```

Command:

```bash
jq '.uuid' file.json
```

Output:

```json
"item_001"
```

---

## Raw Output Without Quotes

```bash
jq -r '.uuid' file.json
```

Output:

```text
item_001
```

---

## Nested Structure

JSON:

```json
{
  "nested": {
    "thumbImageUrl": "url/image.png"
  }
}
```

Command:

```bash
jq -r '.nested.thumbImageUrl' file.json
```

Output:

```text
url/image.png
```

---

# 2. Get Multiple Entries From JSON

## Simple Array

JSON:

```json
[
  {
    "uuid": "item_001"
  },
  {
    "uuid": "item_002"
  }
]
```

Command:

```bash
jq -r '.[].uuid' file.json
```

Output:

```text
item_001
item_002
```

---

## Multiple Fields Side by Side

```bash
jq -r '.[] | [.uuid, .thumbImageUrl] | @tsv' file.json
```

Output:

```text
item_001    url/1.png
item_002    url/2.png
```

---

## Table Format

```bash
jq -r '.[] | [.uuid, .thumbImageUrl] | @tsv' file.json | column -t
```

Output:

```text
item_001  url/1.png
item_002  url/2.png
```

---

## Nested Structure

Command:

```bash
jq -r '.. | .thumbImageUrl? // empty' file.json
```

Output:

```text
url/1.png
url/nested_1.png
```

Explanation:

| Part              | Meaning               |
| ----------------- | --------------------- |
| `..`              | Search recursively    |
| `.thumbImageUrl?` | Optional field access |
| `// empty`        | Ignore null values    |

---

# 3. Pipelining

The pipe operator (`|`) sends output from the left side into the right side.

---

## Example 1

```bash
jq '.[] | .uuid' file.json
```

Flow:

```text
.[]       -> iterate objects
.uuid     -> get uuid from each object
```

---

## Example 2

```bash
jq '.[] | select(.badge > 1) | .uuid' file.json
```

Flow:

```text
.[]
  -> select(.badge > 1)
      -> .uuid
```

---

## Example 3

```bash
jq '.. | objects | select(.thumbImageUrl?) | .thumbImageUrl' file.json
```

Flow:

```text
recursive search
  -> keep objects only
      -> keep objects containing thumbImageUrl
          -> print thumbImageUrl
```

---

# 4. Filtering Data

Filtering is done using `select()`.

---

## Simple Filtering

JSON:

```json
[
  {
    "uuid": "item_001",
    "badge": 1
  },
  {
    "uuid": "item_002",
    "badge": 5
  }
]
```

Command:

```bash
jq '.[] | select(.badge > 1)' file.json
```

Output:

```json
{
  "uuid": "item_002",
  "badge": 5
}
```

---

## Filter And Extract Specific Field

```bash
jq -r '.[] | select(.badge > 1) | .uuid' file.json
```

Output:

```text
item_002
```

---

## Nested Filtering

```bash
jq '.. | objects | select(.thumbImageUrl?)' file.json
```

Explanation:

| Part          | Meaning                 |
| ------------- | ----------------------- |
| `..`          | Recursive traversal     |
| `objects`     | Keep objects only       |
| `select(...)` | Filter matching objects |

---

## Multiple Conditions

```bash
jq '.[] | select(.badge > 1 and .uuid == "item_002")' file.json
```

---

# 5. Searching

---

## Search By Exact Value

```bash
jq '.[] | select(.uuid == "item_001")' file.json
```

---

## Search Using contains()

```bash
jq '.[] | select(.uuid | contains("001"))' file.json
```

---

## Search Using startswith()

```bash
jq '.[] | select(.uuid | startswith("item"))'
```

---

## Search Using endswith()

```bash
jq '.[] | select(.thumbImageUrl | endswith(".png"))'
```

---

## Recursive Search In Nested JSON

```bash
jq '.. | objects | select(.thumbImageUrl?)'
```

---

# 6. Important jq Flags

| Flag | Meaning                | Example                      |
| ---- | ---------------------- | ---------------------------- |
| `-r` | Raw output             | `jq -r '.uuid' file.json`    |
| `-c` | Compact JSON           | `jq -c '.' file.json`        |
| `-s` | Slurp files into array | `jq -s '.' a.json b.json`    |
| `-R` | Read raw text          | `cat file.txt \| jq -R '.'`  |
| `-C` | Colored output         | `jq -C '.' file.json`        |
| `-M` | Disable colors         | `jq -M '.' file.json`        |
| `-S` | Sort keys              | `jq -S '.' file.json`        |
| `-e` | Exit status            | `jq -e '.success' file.json` |
| `-n` | No input mode          | `jq -n '{"a":1}'`            |

---

# Detailed Flag Examples

## -r (Raw Output)

Without `-r`:

```bash
jq '.uuid' file.json
```

Output:

```json
"item_001"
```

With `-r`:

```bash
jq -r '.uuid' file.json
```

Output:

```text
item_001
```

---

## -c (Compact Output)

```bash
jq -c '.' file.json
```

Output:

```json
{"uuid":"item_001","badge":1}
```

---

## -s (Slurp)

```bash
jq -s '.' a.json b.json
```

Output:

```json
[
  {...},
  {...}
]
```

---

## -S (Sort Keys)

Before:

```json
{
  "z": 1,
  "a": 2
}
```

Command:

```bash
jq -S '.' file.json
```

After:

```json
{
  "a": 2,
  "z": 1
}
```

---

# Useful Built-in Functions

| Function  | Example                     |
| --------- | --------------------------- |
| `length`  | `jq 'length' file.json`     |
| `keys`    | `jq 'keys' file.json`       |
| `sort`    | `jq 'sort' file.json`       |
| `reverse` | `jq 'reverse' file.json`    |
| `unique`  | `jq 'unique' file.json`     |
| `map()`   | `jq 'map(.uuid)' file.json` |

---

# Sorting Examples

## Ascending Sort

```bash
jq '[.[].thumbImageUrl] | sort | .[]' file.json
```

---

## Descending Sort

```bash
jq '[.[].thumbImageUrl] | sort | reverse | .[]' file.json
```

---

# Common Real-World Examples

## Extract All thumbImageUrl

```bash
jq -r '.. | .thumbImageUrl? // empty' file.json
```

---

## Get uuid + image side by side

```bash
jq -r '.[] | [.uuid, .thumbImageUrl] | @tsv' file.json | column -t
```

---

## Filter By Badge

```bash
jq '.[] | select(.badge > 0)'
```

---

## Get Only UUIDs

```bash
jq -r '.[] | .uuid'
```

---

## Count Entries

```bash
jq 'length' file.json
```

---

## Pretty Print JSON

```bash
jq '.' file.json
```

---

# Understanding Recursive Search (`..`)

`..` is one of the most powerful jq operators.

It traverses:

* objects
* arrays
* nested arrays
* nested objects
* all levels

Example:

```json
{
  "a": {
    "b": {
      "c": 1
    }
  }
}
```

Command:

```bash
jq '..' file.json
```

It visits:

```text
whole object
"a"
{"b":{...}}
"b"
{"c":1}
"c"
1
```

---

# Best Practices

## Use `-r` for shell scripting

```bash
jq -r '.uuid'
```

---

## Use `?` for optional fields

```bash
.thumbImageUrl?
```

---

## Use `// empty` to skip nulls

```bash
.thumbImageUrl? // empty
```

---

## Use `objects` when recursively traversing

```bash
.. | objects
```

Prevents errors when accessing fields on strings or arrays.

---

# Summary

This guide covered:

* Accessing JSON fields
* Parsing nested JSON
* Extracting multiple entries
* Pipelining
* Filtering
* Searching
* Recursive traversal
* Sorting
* jq flags
* Real-world jq patterns

jq becomes extremely powerful once you combine:

* `..`
* `select()`
* `|`
* `[]`
* `map()`
* `sort`
* `@tsv`

These are the core building blocks for most JSON parsing tasks.
