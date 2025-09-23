---
layout: post
title: Getting Thread Message History in Azure AI Foundry with Python
comments: true
tags: Azure AI Foundry message history thread Python SDK
---

When building an agent with Azure AI Foundry, you’ll often need to look back at the conversation so far. Whether you’re debugging, showing it for reference, or implementing agent “memory” fetching thread message history is essential.


## Install dependencies

You’ll need these packages:
- azure-ai-projects
- azure-ai-agents
- azure-identity

Install them with pip:

```bash
pip install azure-ai-projects azure-ai-agents azure-identity
```

## Initialize the client
```python
from azure.ai.projects.aio import AIProjectClient
from azure.identity.aio import DefaultAzureCredential

client = AIProjectClient(
              endpoint="Endpoint of your Azure Ai Foundry project",
              credential=DefaultAzureCredential()
          )
```

## Get thread ID
To fetch history, you need a thread ID. You can either persist it when creating threads in code or find it in the Azure AI Foundry portal:

<p align="center">
    <img src="{{ site.baseurl }}/images/azure-foundry/image.png"/>
</p>

## List all messages in a thread
The simplest way is to iterate over all messages with the async list method:

```python
agents_client = client.agents
msgs = agents_client.messages.list(thread_id=thread_id)
async for msg in msgs:
  ...
```

## Limiting Results (API Calls)
The `limit` parameter is confusing. It does **not** cap the total number of messages returned—it only controls how many items are retrieved per API call. For example, `limit=3` still fetches the entire history, just in smaller batches.

To truly process a limited number of messages, use paging and break early:

```py
messages = agents_client.messages.list(thread_id=thread_id, limit=3)

for i, page in enumerate(messages.by_page()):
    print(f"Items on page {i}")
    for message in page:
        print(message.id)
    # break after first page if only X items are needed

```

this will produce something like this:
```
Items on page 0
msg_1
msg_2
msg_3
Items on page 1
msg_4
msg_5
msg_6
Items on page 2
msg_7
```

If you only want the first N messages, you can exit the loop after processing the desired count.


### Sources
- [Microsoft Docs](https://learn.microsoft.com/en-us/python/api/azure-ai-agents/azure.ai.agents.operations.messagesoperations?view=azure-python-preview#azure-ai-agents-operations-messagesoperations-list)
- [Github Issue](https://github.com/Azure/azure-sdk-for-python/issues/42916)