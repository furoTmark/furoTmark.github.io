---
layout: post
title: Firestore Credential Initialization With AppSettings
comments: true
tags: c# firestore firebase dotnet net google credential authentication
---

Using Firestore to store data for a C# project is a great way to have a free cloud-based database for your project.

Their limits are pretty generous for a POC or a small project. But beware that their C#/.NET documentation is limited to simple cases.

This is why I created this post to explain how to initialize a Firestore credential using _appsettings.json_.

The google way can be found [here](https://cloud.google.com/firestore/docs/quickstart-servers#c). Here the recommendation is to download the credentials JSON file and set it as the path in an environment variable. As it is a JSON with credential information, I found it better to use these keys from appsettings.json and set them during my build. This way, I do not need to store this sensitive information as a file somewhere, then inject it into my container and set the environment variable.

The first step is to get the credential information. For this, I followed the steps from the [official guide](https://cloud.google.com/firestore/docs/quickstart-servers#set_up_authentication). After getting the credential information, I extended my appsettings.json with the following:

```json
{
  "Firebase": {
    "type": "<type>",
    "project_id": "<project_id>",
    "private_key_id": "<private_key_id>",
    "private_key": "<private_key>",
    "client_email": "<client_email>",
    "client_id": "client_id",
    "auth_uri": "<auth_uri>",
    "token_uri": "<token_uri>",
    "auth_provider_x509_cert_url": "<auth_provider_x509_cert_url>",
    "client_x509_cert_url": "<client_x509_cert_url>"
  },
    ...
}
```

These values are set from my build process. For development, I am using the _appsettings.Development.json_ file, I insert the values. This file should not be checked into source control (git, svn, etc).

Next, I created a new helper class that reads these values from the appsettings.json file and can make the necessary JSON string for initializing the Firestore client.

```csharp
public class FirestoreCredentialInitializer
    {
        [JsonPropertyName("type")]
        public string Type { get; set; }
        [JsonPropertyName("project_id")]
        public string ProjectId { get; set; }
        [JsonPropertyName("private_key_id")]
        public string PrivateKeyId { get; set; }
        [JsonPropertyName("private_key")]
        public string PrivateKey { get; set; }
        [JsonPropertyName("client_email")]
        public string ClientEmail { get; set; }
        [JsonPropertyName("client_id")]
        public string ClientId { get; set; }
        [JsonPropertyName("auth_uri")]
        public string AuthUri { get; set; }
        [JsonPropertyName("token_uri")]
        public string TokenUri { get; set; }
        [JsonPropertyName("auth_provider_x509_cert_url")]
        public string AuthProviderX509CertUrl { get; set; }
        [JsonPropertyName("client_x509_cert_url")]
        public string ClientX509CertUrl { get; set; }

        public FirestoreCredentialInitializer(IConfiguration configuration)
        {
            Type = configuration["Firebase:type"];
            ProjectId = configuration["Firebase:project_Id"];
            PrivateKeyId = configuration["Firebase:private_key_id"];
            PrivateKey = configuration["Firebase:private_key"];
            ClientEmail = configuration["Firebase:client_email"];
            ClientId = configuration["Firebase:client_id"];
            AuthUri = configuration["Firebase:auth_uri"];
            TokenUri = configuration["Firebase:token_uri"];
            AuthProviderX509CertUrl = configuration["Firebase:auth_provider_x509_cert_url"];
            ClientX509CertUrl = configuration["Firebase:client_x509_cert_url"];
        }

        public FirestoreCredentialInitializer(string type, string projectId, string privateKeyId, string privateKey,
                string clientEmail, string clientId, string authUri, string tokenUri,
                string authProviderX509CertUrl, string clientX509CertUrl)
        {
            Type = type;
            ProjectId = projectId;
            PrivateKeyId = privateKeyId;
            PrivateKey = privateKey;
            ClientEmail = clientEmail;
            ClientId = clientId;
            AuthUri = authUri;
            TokenUri = tokenUri;
            AuthProviderX509CertUrl = authProviderX509CertUrl;
            ClientX509CertUrl = clientX509CertUrl;
        }

        public string Serialize()
        {
            return JsonSerializer.Serialize(this);
        }
    }
```

Notice there are two ways to initialize this class. The first way is to use the injected IConfiguration service and get the values from the appsettings.json. The second way is to use the constructor with the parameters; this is useful if we want a special initialization for a specific part of the application, maybe unit testing.

After this class, I used it as an injected service in my implementation. That way, I can inject it into the class's constructor that needs it.

The following code block is an example of how the Firestore be initialized using just the credential information without setting the path to a file.

```csharp
        public FirestoreRepository(FirestoreCredentialInitializer firestoreCredential)
        {
            var projectId = firestoreCredential.ProjectId;
            var client = new FirestoreClientBuilder
            {
                JsonCredentials = firestoreCredential.Serialize()
            }.Build();

            _db = FirestoreDb.Create(projectId, client);
        }
```

Finally an example of a get request from the database.

```csharp
                Query query = _db.Collection(CollectionName);
                QuerySnapshot querySnapshot = await query.GetSnapshotAsync();
                
                return querySnapshot.Documents;
```