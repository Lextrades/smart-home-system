import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { CallToolRequestSchema, ListToolsRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import Docker from "dockerode";
import fs from 'fs';

// --- Docker Setup ---
const docker = new Docker({ socketPath: '/var/run/docker.sock' });

// --- Secrets Management ---
let apiKey = "Not Set";
try {
    if (fs.existsSync('/run/secrets/mcp_api_key')) {
        apiKey = fs.readFileSync('/run/secrets/mcp_api_key', 'utf8').trim();
        // console.error to avoid polluting stdout (which is used for MCP protocol)
        console.error("Secure API Key loaded from Docker Secrets.");
    } else {
        console.error("No Docker Secret found at /run/secrets/mcp_api_key");
    }
} catch (err) {
    console.error("Error reading secret:", err);
}

// --- MCP Server Setup ---
const server = new Server(
    {
        name: "jetson-docker-mcp",
        version: "1.0.0",
    },
    {
        capabilities: {
            tools: {},
        },
    }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
        tools: [
            {
                name: "list_containers",
                description: "List all running Docker containers on the Jetson",
                inputSchema: { type: "object", properties: {} },
            },
            {
                name: "start_container",
                description: "Start a docker container by ID or Name",
                inputSchema: {
                    type: "object",
                    properties: {
                        containerId: { type: "string", description: "Container ID or Name" },
                    },
                    required: ["containerId"],
                },
            },
            {
                name: "stop_container",
                description: "Stop a docker container by ID or Name",
                inputSchema: {
                    type: "object",
                    properties: {
                        containerId: { type: "string", description: "Container ID or Name" },
                    },
                    required: ["containerId"],
                },
            },
        ],
    };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
    try {
        if (request.params.name === "list_containers") {
            const containers = await docker.listContainers();
            return {
                content: [{ type: "text", text: JSON.stringify(containers, null, 2) }],
            };
        }

        if (request.params.name === "start_container") {
            const container = docker.getContainer(request.params.arguments.containerId);
            await container.start();
            return {
                content: [{ type: "text", text: `Container ${request.params.arguments.containerId} started.` }],
            };
        }

        if (request.params.name === "stop_container") {
            const container = docker.getContainer(request.params.arguments.containerId);
            await container.stop();
            return {
                content: [{ type: "text", text: `Container ${request.params.arguments.containerId} stopped.` }],
            };
        }

        throw new Error("Tool not found");
    } catch (error) {
        return {
            content: [{ type: "text", text: `Error: ${error.message}` }],
            isError: true,
        };
    }
});

const transport = new StdioServerTransport();
await server.connect(transport);
