# MCP Server Guidelines


## File Structure
mcp-server/
├── src/
│   ├── index.ts
│   ├── tools/
│   ├── resources/
│   └── util/
└── dist/


## Development Standards
- Zod schemas for all tool inputs
- TypeScript types for all returns
- Log errors to stderr only


## Security
- Validate all agent inputs
- Store keys in env vars, not code
- Limit FS access to templates/output dirs


## Testing
- Unit test tools with valid/invalid inputs
- Integration test inside Claude MCP
- Simulate network failures and malformed templates