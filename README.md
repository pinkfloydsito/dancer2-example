[![Perl Test](https://github.com/pinkfloydsito/dancer2-example/actions/workflows/perl-test.yml/badge.svg)](https://github.com/pinkfloydsito/dancer2-example/actions/workflows/perl-test.yml)

# VaultSingleton

The `VaultSingleton` is a Perl module that provides a singleton implementation for interacting with HashiCorp Vault, a popular tool for securely managing secrets and sensitive data.

## Overview

HashiCorp Vault is a tool designed to secure, store, and tightly control access to tokens, passwords, certificates, encryption keys, and other secrets in modern computing. The `VaultSingleton` module simplifies the process of connecting to Vault and ensures that only one instance of the connection is created throughout the program's lifecycle.

## Installation

To use the `VaultSingleton` module, you'll need to have Perl installed on your system. Additionally, make sure you have the `WebService::HashiCorp::Vault` module installed. You can install it using `cpan` or `cpanm`:

```bash
cpanm WebService::HashiCorp::Vault
```

Alternatively, you can add the module to your project's `cpanfile` and use a dependency manager like `cpanm` to install it.

## Usage

### Importing the Module

To use the `VaultSingleton`, you need to import it into your Perl script or module:

```perl
use VaultSingleton;
```

### Creating and Using the Singleton

The `VaultSingleton` provides a singleton pattern, meaning only one instance of the connection to HashiCorp Vault will be created and shared across the program. To create the singleton instance, use the `new` method:

```perl
my $vault_singleton = VaultSingleton->new();
```

The `new` method will create a new instance if one does not already exist. If an instance has been created earlier, the same instance will be returned.

### Logging in to HashiCorp Vault

Before you can interact with HashiCorp Vault, you need to log in with a valid token. To do that, use the `login` method of the `VaultSingleton`:

```perl
my $vault_url = 'https://your-vault-url.com';
my $token = 'your_vault_access_token';

$vault_singleton->login($vault_url, $token);
```

The `login` method will establish a connection to the specified Vault URL using the provided access token.

### Interacting with HashiCorp Vault

Once you have successfully logged in, you can access the `WebService::HashiCorp::Vault` instance using the `vault_api` attribute:

```perl
my $vault_api = $vault_singleton->{vault_api};
```

With the `$vault_api` object, you can now make various calls to HashiCorp Vault using the methods provided by the `WebService::HashiCorp::Vault` module.

Remember, the singleton pattern ensures that the same `$vault_api` object is reused throughout your application, preventing unnecessary multiple connections and ensuring efficient resource usage.

## Example

Here's a basic example of how you might use the `VaultSingleton` module to interact with HashiCorp Vault:

```perl
use VaultSingleton;
use WebService::HashiCorp::Vault;

# Create the VaultSingleton instance
my $vault_singleton = VaultSingleton->new();

# Log in to HashiCorp Vault
my $vault_url = 'https://your-vault-url.com';
my $token = 'your_vault_access_token';
$vault_singleton->login($vault_url, $token);

# Now you can use the $vault_api to interact with HashiCorp Vault
# For example, read a secret from the Vault
my $secret_path = 'secret/data/myapp/config';
my $secret_response = $vault_singleton->read($secret_path);

if ($secret_response->{data}) {
    my $config = $secret_response->{data}{data};
    # Do something with the retrieved secret data
    # ...
}
```

## Conclusion

The `VaultSingleton` module simplifies and optimizes the process of connecting to HashiCorp Vault by providing a singleton instance. This ensures efficient resource usage and better control over interactions with the Vault throughout your Perl application. Feel free to use this module as a foundation for securely managing your application's secrets and sensitive data with HashiCorp Vault.
