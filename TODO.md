# TODO - Punch In / Task Management Full-Stack App

## Plan (high level)
1. Create repo structure:
   - `mobile/` (React Native codebase per original requirement) OR align with user decision if needed
   - `server/` (Node.js + Express)
2. Backend setup:
   - Initialize Express app
   - Add MongoDB/Mongoose connection using `MONGODB_URI`
   - JWT auth (Admin + User RBAC)
   - Implement MVC structure (models/controllers/routes)
   - Add error handling + request validation
   - Add Socket.io for realtime updates
   - Notifications + task assignment + punch in/out APIs
3. Frontend setup:
   - Create React Native app
   - Implement auth flow, theming (dark/light), context-based state (or RTK)
   - Build screens: login, dashboard, punch history, profile, notifications, task screen (user + admin)
   - Integrate Axios client with token storage
   - Add loading states, toasts, animations, pagination/search/filter
4. MongoDB schemas:
   - users, punchHistory, tasks, notifications, taskResponses, adminLogs
5. Add `.env.example` files for server + mobile.
6. Testing / run instructions:
   - `npm run dev` for server
   - `npm start` for mobile
7. Produce final summary + commands.

