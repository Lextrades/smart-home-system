# Web Platform & Login System Plan

## Goal Description
Implement the "Phase VII" Web Platform.
Target URL: `your.domain.com`
Final Step: Configure Nginx to proxy 80 -> 5000.

## Implementation Steps
1.  **Flask App**: Active on Port 5000.
2.  **System Integration**: Service Running.
3.  **Nginx**:
    -   Backup current: `/etc/nginx/sites-enabled/default.bak`
    -   Write new: `/etc/nginx/sites-enabled/default`
    -   `server_name`: `your.domain.com localhost`
    -   `proxy_pass`: `http://127.0.0.1:5000`

## Verification Plan
### Automated Tests
- `curl -I localhost` (Should see Flask/Gunicorn headers or 302 Redirect).
