User Session / Registration
- Session Plug
-- Check if user has access / refresh token cookies
-- If access token cookie, validate if authorized, set user as actor, pass conn
-- If refresh token cookie, validate if authorized, renew access token, set user as actor, pass conn
--