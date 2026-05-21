---
name: swift-code-organizer
description: Use this skill when the user wants to organize Swift code using idiomatic Swift best practices. Triggers include "organize this Swift file", "make this more organized", or any request to improve Swift code quality. Applies seven rules — var→let, private(set), didSet refactor, class→struct, private funcs, private-helpers extension, public-APIs extension — one at a time, always asking before each change.
---

## When To Use
- User asks to clean, refactor, or modernize a Swift file
- User asks to apply Swift best practices
- User asks to find unused `var`s, redundant classes, or refactor opportunities
- Any Swift code-quality pass — always ask before applying changes

## Important
- Analyze full file or selection before suggesting changes
- Group by rule, present one rule at a time
- Always show before/after diff and ask before applying
- Never apply multiple rules without confirmation
- Show summary after all changes

---

# Swift Cleaner Skill

## Purpose
Analyze and clean Swift code by applying idiomatic Swift best practices. Always ask the user before applying each change.

---

## Rules

### Rule 1 — `var` → `let`
Detect any `var` declaration that is never reassigned after initialization.
- Replace `var` with `let`
- Ask: "X vars can be converted to `let`. Apply?"

### Rule 2 — `private(set)`
Detect any `var` that:
- Is never assigned from outside its own file
- But is read from outside its file

Mark it as `private(set)`.
- Ask: "X vars are only set internally but read externally. Add `private(set)`?"

### Rule 3 — `didSet` refactor
Detect any function that:
- Updates a single variable AND
- That update triggers conditional logic based on the variable's new value

Refactor:
- Move the conditional logic into a `didSet` block on the variable
- Remove that logic from the function
- If the function has no remaining logic, delete the function entirely
- Ask: "Function `funcName` only updates `varName` and reacts to it. Move to `didSet` and remove function?"

### Rule 4 — singleton refactor
Detect any singleton by:
- If the class has a static variable that is the instance of the class

Action:
- make the init function private if it is public

### Rule 5 — `class` → `struct`
Detect any `class` that:
- Has no variables that are ever mutated after initialization
- Has only an initializer (no other methods, or only computed properties)
- Does not inherit from another class

Convert it to a `struct`.
- Ask: "Class `ClassName` behaves like a value type. Convert to `struct`?"

### Rule 6 — `func` → `private func`
Detect any function that:
- Is never called from outside its own class/struct/file
- Is not part of a protocol conformance
- Is not an `@objc`, `@IBAction`, or framework-required entry point

Mark it `private`.
- Ask: "Function `funcName` is only used internally. Add `private`?"

### Rule 7 — extract private helpers into `// MARK: private helpers` extension
For each class/struct, collect all `private` functions that are **not already inside another extension**.
Move them into a single new extension:

```swift
// MARK: private helpers
private extension ClassName {
    // moved private funcs
}
```

Constraints:
- MUST verify each function is currently in the main type body, not under any existing `extension ClassName { ... }`
- Skip functions already nested in another extension (do not move them)
- Preserve original order
- Ask: "Move X private funcs from `ClassName` body into `// MARK: private helpers` extension?"

### Rule 8 — extract public APIs into `// MARK: public APIs` extension
For each class/struct, collect all `public`/`open`/default-internal functions intended as the type's public surface (non-private, non-fileprivate) that are **not already inside another extension**.
Move them into a single new extension:

```swift
// MARK: public APIs
extension ClassName {
    // moved public funcs
}
```

Constraints:
- MUST verify each function is currently in the main type body, not under any existing `extension ClassName { ... }`
- Skip functions already nested in another extension (do not move them)
- Skip protocol-conformance methods (leave in their conformance extension)
- Preserve original order
- Ask: "Move X public funcs from `ClassName` body into `// MARK: public APIs` extension?"

---

## Behavior
- Analyze the full file or selection before suggesting changes
- Analyze files that contains targetted variable, if it is being changed anywhere
- Group changes by rule and present them one rule at a time
- Always ask before applying: show a before/after diff for each change
- After all changes, show a summary of what was applied
- Never apply multiple rules simultaneously without confirmation

---

## Output Format

For each suggestion, show:

1. **Rule applied** — e.g. `Rule 1 — var → let`
2. **Location** — `file.swift:line`
3. **Before / After diff** — fenced Swift code blocks

   ```swift
   // before
   var count = 0
   ```

   ```swift
   // after
   let count = 0
   ```
4. **Reason** — one-line why the change is safe
5. **Prompt** — "Apply? (y/n/skip rule)"

After all rules processed, show summary:

```
Summary
- Rule 1: 3 applied, 1 skipped
- Rule 2: 2 applied
- Rule 3: 0 matches
- Rule 4: 1 applied
- Rule 5: 4 applied
- Rule 6: 1 applied (3 funcs moved)
- Rule 7: 1 applied (2 funcs moved)
```
