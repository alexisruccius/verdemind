# Changelog


## v0.2.1 (2025-06-16)

### Bug fixes

- Integrate `notes()` system prompt from `Plant` into `InstructorQuery`

### Enhancements

- Improve test coverage
- Refactor OpenAI system prompt handling in `Plant` module
- Refactor `FormComponent` and `Router` for clarity


## v0.2.0 (2025-06-14)

### Features

- Provide a form after plant generation for editing and saving.

### Enhancements

- Add OpenAI system prompt to `InstructorQuery` and `Plant` for more precise feedback.


## v0.1.2 (2025-06-08)

### Bug fixes

- Show errors in the generate plant LiveView.
- Improve error handling in `InstructorQuery.ask/2`.

### Enhancements

- Rename `plant` to `plant_async` to clarify it represents an `%AsyncResult{}` struct.


