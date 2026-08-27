---
layout: post
title: Using an Agent Engine AI Agent from dotnet c#
date: 2026-02-05
tags: code google ai vertex agent engine dotnet c#
image: /images/vertex-ai/vertexailogo.png
at-image: /images/vertex-ai/vertexailogo.png
atUri: "at://did:plc:be2rwmqqn7ek4o4mdnvb7hnb/site.standard.document/3mu2e6ug5fu2g"
---

<p align="center">
    <img src="{{ site.baseurl }}/images/vertex-ai/vertexailogo.png"/>
</p>

Because there is currently no .NET (dotnet) example on how to use the Google Vertex AI Agent Engine agent in a project, I decided to write one as there are misleading parts without any documentation.

## First things first

You will need to install the NuGet package [Google.Cloud.AIPlatform.V1](https://www.nuget.org/packages/Google.Cloud.AIPlatform.V1/) and [Google.Apis.Auth](https://www.nuget.org/packages/Google.Apis.Auth) for the authentication part.

To check whether there are any issues with the dotnet libraries, you can visit the [official GitHub repository](https://github.com/googleapis/google-api-dotnet-client).

## Authentication

For authentication, you can choose to authenticate the machine running the service, but in my case, it was easier to just export the service account credentials from Google as a JSON file. I used the documentation from [here](https://docs.cloud.google.com/agent-builder/agent-engine/set-up#default-service-agent) to get the JSON.

Google recently updated its credential creation process, so `GoogleCredential.FromJson()` method is deprecated, and a new way must be used with `CredentialFactory`.

```c#
var credentialsPath = "service-account-credentials.json";
var googleCredential =
    CredentialFactory.FromFile<ServiceAccountCredential>(mappedPath).ToGoogleCredential();
```

## Vertex AI Reasoning Engine Client

To be able to use the AI Agent, you will first need to create a `ReasoningEngineExecutionServiceClient` that can then be called for different operations. For this, use the `ReasoningEngineExecutionServiceClientBuilder` class, specifying the endpoint and using the credentials from the previous step.

**Endpoint example:** `us-central1-aiplatform.googleapis.com`, the us-central1 is where the Vertex AI models are also deployed.

```c#
var clientBuilder = new ReasoningEngineExecutionServiceClientBuilder
{
    Endpoint = _endpoint, 
    GoogleCredential = googleCredential
};

_client = clientBuilder.Build();
```

I usually put the auth and the client in the constructor of the class I will use.

## Calling the Agent

The Reasoning Engine client provides two (three if we consider the async too) methods that can be called to interact with the agent **QueryReasoningEngine** and **StreamQueryReasoningEngineRequest**.

### The misleading QueryReasoningEngine

Nothing in the documentation suggests that QueryReasoningEngine cannot be used to query the agent. The class is really misleading.

When querying the agent's operation schema, you even get back 2 operations (stream_query and async_stream_query) that, in theory, would be called from QueryReasoningEngine.

```json
...
    {
        "description": "Deprecated. Use async_stream_query instead.\n\n        Streams responses from the ADK application in response to a message.\n\n        Args:\n            message (Union[str, Dict[str, Any]]):\n                Required. The message to stream responses for.\n            user_id (str):\n                Required. The ID of the user.\n            session_id (str):\n                Optional. The ID of the session. If not provided, a new\n                session will be created for the user.\n            run_config (Optional[Dict[str, Any]]):\n                Optional. The run config to use for the query. If you want to\n            \r\n    pass in a `run_config` pydantic object, you can pass in a dict\n                representing it as `run_config.model_dump(mode=\"json\")`.\n            **kwargs (dict[str, Any]):\n                Optional. Additional keyword arguments to pass to the\n                runner.\n\n        Yields:\n            The output of querying the ADK application.\n        ",
        "parameters": {
            "type": "object",
            "properties": {
                "message": {
                    "anyOf": [
                        {
                            "type": "string"
                        },
                        {
                            "additionalProperties": true,
                            "type": "object"
                        }
                    ]
                },
                "user_id": {
                    "type": "string"
                },
                "session_id": {
                    "type": "string",
                    "nullable": true
                },
                "run_config": {
                    "type": "object",
                    "nullable": true
                }
            },
            "required": [
                "message",
                "user_id"
            ]
        },
        "api_mode": "stream",
        "name": "stream_query"
    },
    {
        "description": "Streams responses asynchronously from the ADK application.\n\n        Args:\n            message (str):\n                Required. The message to stream responses for.\n            user_id (str):\n                Required. The ID of the user.\n            session_id (str):\n                Optional. The ID of the session. If not provided, a new\n              \r\n  session will be created for the user.\n            run_config (Optional[Dict[str, Any]]):\n                Optional. The run config to use for the query. If you want to\n                pass in a `run_config` pydantic object, you can pass in a dict\n                representing it as `run_config.model_dump(mode=\"json\")`.\n            **kwargs (dict[str, Any]):\n                Optional. Additional keyword arguments to pass to the\n                runner.\n\n        Yields:\n            Event dictionaries asynchronously.\n        ",
        "parameters": {
            "type": "object",
            "properties": {
                "message": {
                    "anyOf": [
                        {
                            "type": "string"
                        },
                        {
                            "additionalProperties": true,
                            "type": "object"
                        }
                    ]
                },
                "user_id": {
                    "type": "string"
                },
                "session_id": {
                    "type": "string",
                    "nullable": true
                },
                "run_config": {
                    "type": "object",
                    "nullable": true
                }
            },
            "required": [
                "message",
                "user_id"
            ]
        },
        "api_mode": "async_stream",
        "name": "async_stream_query"
    },
    {
        "description": "Streams responses asynchronously from the ADK application.\n\n        In general, you should use `async_stream_query` instead, as it has a\n        more structured API and works with the respective ADK services that\n        you have defined for the AdkApp. This method is primarily meant for\n        invocation from AgentSpace.\n\n        Args:\n            request_json (str):\n                Required. The request to stream responses for.\n        ",
        "parameters": {
            "type": "object",
            "properties": {
                "request_json": {
                    "type": "string"
                }
            },
            "required": [
                "request_json"
            ]
        },
        "api_mode": "async_stream",
        "name": "streaming_agent_run_with_events"
    }
...
```

But when you call it that way, you get an error that the operation is not found, and it enumerates the available operations.

```json
{"detail":"Agent Engine Error: Default method `async_stream_query` not found. Available methods are: ['get_session', 'async_create_session', 'async_add_session_to_memory', 'async_get_session', 'async_delete_session', 'list_sessions', 'delete_session', 'async_list_sessions', 'async_search_memory', 'create_session']."}")
```

### Using StreamQueryReasoningEngineRequest

So the correct way to call the agent with a prompt and get a response is via StreamQueryReasoningEngine.

```c#
    var query = "...";
    var input = new Struct();
    input.Fields.Add("user_id", Value.ForString("test_user"));
    input.Fields.Add("message", Value.ForString(query));
    input.Fields.Add("session_id", Value.ForString("12345")); // Optional; only interesting when adding follow up to the conversation.

    var stream = _client.StreamQueryReasoningEngine(new StreamQueryReasoningEngineRequest
    {
        ReasoningEngineName = ReasoningEngineName.Parse(AgentName), 
        Input = input,
    });

    var finalResponse = "";

    await foreach (var response in stream.GetResponseStream())
    {
        var chunk = response.Data.ToStringUtf8();
        // Deserialize the JSON response into the StreamQueryReasoningEngineResponse model
        var agentResponse = JsonSerializer.Deserialize<StreamQueryReasoningEngineResponse>(chunk);
        // Extract the text content from the response
        if (agentResponse?.Content?.Parts is { Count: > 0 })
        {
            var text = agentResponse.Content.Parts[0].Text;
            finalResponse += text;
        }
    }

    return finalResponse;
}
```

**AgentName example:** `projects/{project-id}/locations/{location}/reasoningEngines/{agent-id}` that in the end should look similar to this `projects/123456789012/locations/us-central1/reasoningEngines/1234567890123456789`

**Note:** The class `StreamQueryReasoningEngineResponse` that is used for deserialization is a custom one I created based on the response. You can ask the AI to generate it based on the response. The response may differ based on the tools/model/agent you use.