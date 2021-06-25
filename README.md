# WP All Import Pro Stubs

This package provides stub declarations for [WP All Import Pro](https://www.wpallimport.com/).
These stubs can help plugin and theme developers leverage static analysis tools like [PHPStan](https://phpstan.org/).

Stubs are generated directly from the source using [giacocorsiglia/stubs-generator](https://github.com/GiacoCorsiglia/php-stubs-generator).

## Requirements

- PHP >=7.1

## Installation

Require this package as a development dependency with Composer.

```bash
composer require --dev wpsyntex/wp-all-import-pro-stubs
```

## Usage in PHPStan

Include the stubs in the PHPStan configuration file.

```yaml
parameters:
  bootstrapFiles:
    - vendor/wpsyntex/wp-all-import-pro-stubs/wp-all-import-pro-stubs.php
```
