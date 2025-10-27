---
layout: post
title: How to Set a Retry Policy in Azure API Management (APIM)
comments: true
tags: azure apim api-gateway retry-policy azure-api-management
---

Sometimes requests are denied due to many reasons (like 429 Too Many Request) and it is wise to just retry. The retry can be set on multiple levels, in code (with polly), in service level or in api gateway with a simple policy. In this post I will focus on setting the retry on the Azure Api Gateway.

The following policy retries backend calls up to three times if they fail with certain status codes, waiting 10 seconds between attempts.

```xml
<backend>
  <retry condition="@(context.Response != null && new List<int>() { 403, 404, 500 }.Contains(context.Response.StatusCode))" count="3" interval="10">
    <forward-request buffer-request-body="true" />
  </retry>
</backend>
```

### Breakdown:
- The `retry` block sets the conditions on witch it retries and also how many times and the interval
- the `forward-request` is the important part with the `buffer-request-body` set to **true**, as this ensures that when we retry the request, the same body will be sent again. (This was a head-scratcher until we figured it out that is needed)

## Adding logging to the retry

To better understand when and why retries happen, you can log each attempt using trace and custom variables. Here’s a more complete example that tracks retry counts and logs the retried operation.

```xml
<policies>
    <inbound>
        <base />

        <set-variable name="someVariableFromRequest" value="@(context.Variables.GetValueOrDefault<JObject>("requestBody")?["someVariableFromRequest"]?.ToString())" />

        <set-variable name="retryCount" value="0" />
        ...
    </inbound>
    <backend>
        <retry condition="@(context.Response != null && new List<int>() { 403, 404, 500 }.Contains(context.Response.StatusCode))" count="3" interval="10">
            <choose>
                  <when condition="@(context.Response != null && new [] { 403, 404, 500 }.Contains(context.Response.StatusCode))">
                    <set-variable name="retryCount" value="@((Convert.ToInt32(context.Variables.GetValueOrDefault<string>("retryCount", "0")) + 1).ToString())" />
                    <trace source="RetryPolicy" severity="information">@( "Retrying {Operation Name} request with parameter " + context.Variables.GetValueOrDefault<string>("someVariableFromRequest") + ". Attempt " + context.Variables.GetValueOrDefault<string>("retryCount") )
                    </trace>
                </when>
            </choose>
          <forward-request buffer-request-body="true" />
        </retry>
    </backend>
    ...
</policies>
```

This approach makes it easier to see retry attempts in APIM’s trace logs, including which operation retried and what parameter values were used.

### Sources

- [Retry Policy](https://learn.microsoft.com/en-us/azure/api-management/retry-policy)
- [Forward Request Policy](https://learn.microsoft.com/en-us/azure/api-management/forward-request-policy)