# Backend Development Rules

When writing or modifying backend code for this project, you MUST strictly adhere to the following rules:

- **Clean Architecture**: Always follow Clean Architecture principles to ensure the codebase remains maintainable and scalable.
- **Short & Clean Code**: Write concise, readable, and modular code. Avoid large, monolithic functions or files. Each function should have a single, clear responsibility.
- **Strict Layered Structure**: Organize all server-side logic into the following distinct layers:
  - **Routes**: Define HTTP or WebSocket endpoints. Keep these files extremely thin. They should only map endpoints to the appropriate controllers.
  - **Controllers**: Handle request extraction, basic validation, and HTTP responses. Controllers must NOT contain complex business logic; they must delegate work to services.
  - **Services**: This is where the core business logic lives. All complex data processing, algorithms, and orchestration between different models or external APIs should be done here.
  - **Models**: Define data schemas, database interaction logic, and data structures.
- **General Best Practices**: Use descriptive variable/function names, implement proper and consistent error handling, and add comments only where the logic is inherently complex.
- **User-Friendly Error Handling & Validation**: Every error and validation failure MUST return a clear, relevant, and easy-to-understand message so the end-user (or frontend developer) knows exactly what went wrong.
