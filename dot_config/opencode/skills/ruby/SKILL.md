---
name: ruby
description: Ruby and Ruby on Rails coding guidelines and best practices
---

## Ruby Style

### String Literals
- Use frozen string literals: `# frozen_string_literal: true` at the top of files
- Prefer single quotes for strings unless interpolation is needed

### Modern Ruby Features
- Use pattern matching with `case/in` when appropriate for complex conditionals
- Use endless methods (`def foo = bar`) for simple single-line method definitions
- Use safe navigation operator (`&.`) for nil safety instead of explicit nil checks

### Methods
- Early return when possible
- Always declare method visibility explicitly with `private` or `protected`
- Group private methods together at the bottom of the class

## Ruby Syntax Preferences

### Hash Syntax
- Always use the modern hash syntax: `{ key: value }` instead of `{ :key => value }`
- Use hash abbreviation when the key and variable name match: `{ key: }` instead of `{ key: key }`

### Method Parameters
- Use named parameters (keyword arguments) instead of positional arguments for methods with multiple parameters
- This makes the code self-documenting and avoids parameter order confusion

### Safe Navigation
- Use the safe navigation operator (`&.`) liberally for nil safety
- Prefer `user&.name` over `user && user.name`
- Prefer `users&.first` over `users && users.first`

## Rails Architecture

### Controllers
- Keep controllers skinny - they should only handle HTTP concerns
- Delegate business logic to models or service objects

### Models
- Models can be "fat" with domain logic and business rules
- Extract complex business logic to service objects when appropriate
- Use scopes for common query patterns instead of class methods

### Service Objects
- Extract complex business logic to service objects
- Keep them focused on a single responsibility

### ActiveRecord
- Always eager load associations with `includes` to avoid N+1 queries
- Only use raw SQL when ActiveRecord cannot express the query
- Use database-level constraints (not null, unique, foreign keys) in migrations

## Testing

### RSpec Style
- Use RSpec one-liners for simple expectations: `it { is_expected.to be_valid }`
- Keep test descriptions clear and concise
- Prefer implicit subject when testing the described class


