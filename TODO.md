# TODO - Punch In / Announcement Management Full-Stack App

## Plan (high level)
1. Create repo structure:
   - `mobile/` (Flutter app) OR align with user decision if needed
   - `server/` (Node.js + Express)
2. Backend setup:
   - Initialize Express app
   - Add MongoDB/Mongoose connection using `MONGODB_URI`
   - JWT auth (Admin + User RBAC)
   - Implement MVC structure (models/controllers/routes)
   - Add error handling + request validation
   - Add Socket.io for realtime updates
   - Notifications + announcement distribution + punch in/out APIs
3. Frontend setup:
   - Flutter app initialization
   - Implement auth flow, theming, provider state management
   - Build screens: login, dashboard, punch history, profile, notifications, announcements (user + admin)
   - Integrate HTTP API client with token storage
   - Add loading states, toasts, search/filter
4. MongoDB schemas:
   - users, punchHistory, announcements, notifications, announcementReplies, adminLogs
5. Add `.env.example` files for server + mobile.
6. Testing / run instructions:
   - `npm run dev` for server
   - `npm start` for mobile
7. Produce final summary + commands.

